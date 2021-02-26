---
title: Snake-casing JSON requests and responses with ASP.NET Core and System.Text.Json
author: Alastair Smith
category:
created: 1613302381
tags:
        - aspnetcore
        - system-text-json
        - dotnet
---

# Snake-casing JSON requests and responses with ASP.NET Core and System.Text.Json

I've been working with ASP.NET Core and .NET Core for about 5 years now, and
with the 3.0 release it really hit heights of maturity. I find it an enormously
productive and performant framework, and exceptionally well-designed.

The 3.0 release introduced a new, high-performance library for working with JSON
structures, superseding the community Newtonsoft.Json library for HTTP traffic.
Even amongst the fanfare of its release, and an [unusually-high first full
release version](https://www.nuget.org/packages/System.Text.Json/4.6.0),
developers quickly start finding holes in the release, many of which were not
resolved even in the .NET 5 release timeframe. Even today, there are [ten pages
of issues labelled for System.Text.Json on
GitHub](https://github.com/dotnet/runtime/labels/area-System.Text.Json), and an
[epic amount of work scheduled on the library for .NET
6](https://github.com/dotnet/runtime/issues/45190).

This isn't to say the library is buggy, just that there are still holes in it
compared with the mature Newtonsoft.Json package that has been serving ASP.NET
developers well for the better part of two decades. One of the bugs that I've
hit a couple of times in the last few months, along with many other developers
judging by my hunting round the internet, is [fully supporting snake
casing](https://github.com/dotnet/runtime/issues/782) in
JSON property names, `like_so`; out of the box, System.Text.Json supports only
`PascalCasing`. There has been a custom naming policy implementation
kicking around in the comments on that issue since August 2019, and updated in
April 2020, but was it was sadly dropped for the .NET 5.0 release which shipped
six months later, and so we're left waiting until November 2021 for its release.
This is a shame, as snake case formatting is so common in HTTP APIs across the
web.

Here is that implementation, courtesy of [Soheil
Alizadeh](https://github.com/xsoheilalizadeh) and
[jonathann92](https://github.com/jonathann92):

```csharp
using System;
using System.Text.Json;

namespace System.Text.Json
{
    public class SnakeCaseNamingPolicy : JsonNamingPolicy
    {
        // Implementation taken from
        // https://github.com/xsoheilalizadeh/SnakeCaseConversion/blob/master/SnakeCaseConversionBenchmark/SnakeCaseConventioneerBenchmark.cs#L49
        // with the modification proposed here:
        // https://github.com/dotnet/runtime/issues/782#issuecomment-613805803
        public override string ConvertName(string name)
        {
            int upperCaseLength = 0;

            for (int i = 1; i < name.Length; i++)
            {
                if (name[i] >= 'A' && name[i] <= 'Z')
                {
                    upperCaseLength++;
                }
            }

            int bufferSize = name.Length + upperCaseLength;

            Span<char> buffer = new char[bufferSize];

            int bufferPosition = 0;

            int namePosition = 0;

            while (bufferPosition < buffer.Length)
            {
                if (namePosition > 0 && name[namePosition] >= 'A' && name[namePosition] <= 'Z')
                {
                    buffer[bufferPosition] = '_';
                    buffer[bufferPosition + 1] = char.ToLowerInvariant(name[namePosition]);
                    bufferPosition += 2;
                    namePosition++;
                    continue;
                }

                buffer[bufferPosition] = char.ToLowerInvariant(name[namePosition]);

                bufferPosition++;

                namePosition++;
            }

            return buffer.ToString();
        }
    }
}
```

You then enable this by modifying your `Startup.cs` as follows:

```csharp
public void ConfigureService(IServiceCollection services)
{
    services
        .AddControllers() // or .AddControllersWithViews()
        .AddJsonOptions(options =>
        {
            options.JsonSerializerOptions.DictionaryKeyPolicy = new SnakeCaseNamingPolicy();
            options.JsonSerializerOptions.PropertyNamingPolicy = new SnakeCaseNamingPolicy();
        });
}
```

This gets you probably 90-95% of the way to supporting snake casing throughout
your ASP.NET Core application, but the one place I've found it doesn't support
is in the property keys in a `ModelStateDictionary` returned in a
`ValidationProblemDetails` object by ASP.NET Core's model binder, even with
the`DictionaryKeyPolicy` option set:

```json
{
	"title": "One or more validation errors occurred.",
	"status": 422,
	"errors": {
		"Email": ["The Email field is required."],
		"Mobile": ["The Mobile field is required."],
		"Address": ["The Address field is required."],
		"FirstName": ["The FirstName field is required."],
		"LastName": ["The LastName field is required."],
		"DateOfBirth": ["The DateOfBirth field is required."]
	}
}
```

Here, we would expect to see the property names with invalid values to have
their names `snake_cased` also. Unfortunately this a bug in ASP.NET Core 5.0: as
best I can tell, it should be applying the naming policy to the property name
before writing it, but [it
isn't](https://github.com/dotnet/aspnetcore/blob/main/src/Mvc/Mvc.Core/src/Infrastructure/ValidationProblemDetailsJsonConverter.cs#L63).
So here's how we solved the problem.

Following the documentation on [writing a custom
JsonConverter](https://docs.microsoft.com/en-us/dotnet/standard/serialization/system-text-json-converters-how-to) for .NET Core
3.1, I found the example on [supporting Dictionaries with non-string
keys](https://docs.microsoft.com/en-us/dotnet/standard/serialization/system-text-json-converters-how-to?pivots=dotnet-core-3-1#support-dictionary-with-non-string-key)
wholly enlightening. It turns out that the correct type to derive from isn't
`JsonConverter<T>` as I initially expected (and spiked), but
`JsonConverterFactory`: this provides a `CanConvert()` method which can be
overridden for our use case, as well as a `CreateConverter()` method to provide
an instance of our custom converter. We separately derive from
`JsonConverter<T>` (the docs suggest as a private nested class of our Factory
implementation) to provide the conversion logic itself. Here's the skeleton of
our custom `ValidationProblemDetails` converter:

```csharp
public class ValidationProblemDetailsJsonConverter : JsonConverterFactory
{
    // We can happily convert ValidationProblemDetailsObjects
    public override bool CanConvert(Type typeToConvert)
    {
        return typeToConvert == typeof(ValidationProblemDetails);
    }

    // And they're pretty easy to create, too
    public override JsonConverter CreateConverter(Type typeToConvert, JsonSerializerOptions options)
    {
        return new ValidationProblemDetailsConverter();
    }

    private class ValidationProblemDetailsConverter : JsonConverter<ValidationProblemDetails>
    {
        // The conversion implementation will go in here
    }
}
```

In the case of _reading_ a `ValidationProblemDetails` object, we can delegate to
the built-in converter, as we don't need or want to do anything special here. We
do that by instantiating a new `JsonSerializerOptions` and retrieving the
converter from there:

```csharp
public override ValidationProblemDetails Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
{
    // Use the built-in converter from the default
    // JsonSerializerOptions

    var converter = new JsonSerializerOptions()
            .GetConverter(typeof(ValidationProblemDetails))
        as JsonConverter<ValidationProblemDetails>;

    return converter.Read(ref reader, typeToConvert, options);
}
```

By passing no arguments or other initialization arguments to
`JsonSerializerOptions`, we get the default configuration of the serializer,
including the default `ValidationProblemDetails` converter. We can't simply
instantiate a `ValidationProblemDetailsJsonConverter`, as [it's marked
`internal`](https://github.com/dotnet/aspnetcore/blob/main/src/Mvc/Mvc.Core/src/Infrastructure/ValidationProblemDetailsJsonConverter.cs#L15).

The implementation of `Write()` is rather more involved. The System.Text.Json
API is deliberately forward-only, so we're unable to re-use the default
implementation and fix it up: we have to reimplement the logic from the default
implementation. Luckily it's relatively trivial: write a `{`, write the fields
[defined on the RFC](https://tools.ietf.org/html/rfc7807#page-5), write the
`errors` extension to the RFC with each error serialised properly this time,
close the `errors` extension with a `}`, and write the closing `}`.

```csharp
public override void Write(Utf8JsonWriter writer, ValidationProblemDetails problemDetails, JsonSerializerOptions options)
{
    writer.WriteStartObject();

    writer.Write(Type, problemDetails.Type);
    writer.Write(Title, problemDetails.Title);
    writer.Write(Status, problemDetails.Status);
    writer.Write(Detail, problemDetails.Detail);
    writer.Write(Instance, problemDetails.Instance);

    writer.WriteStartObject(Errors);

    foreach ((string key, string[] value) in problemDetails.Errors)
    {
        writer.WritePropertyName(options.PropertyNamingPolicy?.ConvertName(key) ?? key);
        JsonSerializer.Serialize(writer, value, options);
    }

    writer.WriteEndObject();

    writer.WriteEndObject();
}
```

(Note: the `writer.Write()` calls are a convenience extension method I wrote to
make the code a little more readable; it just checks the value is not null
before calling the writer's `WriteString()` method.)

The key bit for our requirement is line 15, where we call `ConvertName()` using
the supplied `PropertyNamingPolicy` on the dictionary key.

The full implementation then looks like this:

```csharp
using System;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Microsoft.AspNetCore.Mvc
{
    /// <summary>
    /// TODO: replace by built in implementation in dotnet 6.0
    /// https://github.com/dotnet/runtime/issues/782#issuecomment-673029718
    /// Implementation based on https://docs.microsoft.com/en-us/dotnet/standard/serialization/system-text-json-converters-how-to?pivots=dotnet-core-3-1#support-dictionary-with-non-string-key
    /// </summary>
    public class ValidationProblemDetailsJsonConverter : JsonConverterFactory
    {
        public override bool CanConvert(Type typeToConvert)
        {
            return typeToConvert == typeof(ValidationProblemDetails);
        }

        public override JsonConverter CreateConverter(Type typeToConvert, JsonSerializerOptions options)
        {
            return new ValidationProblemDetailsConverter();
        }

        private class ValidationProblemDetailsConverter : JsonConverter<ValidationProblemDetails>
        {
            private static readonly JsonEncodedText Type = JsonEncodedText.Encode("type");
            private static readonly JsonEncodedText Title = JsonEncodedText.Encode("title");
            private static readonly JsonEncodedText Status = JsonEncodedText.Encode("status");
            private static readonly JsonEncodedText Detail = JsonEncodedText.Encode("detail");
            private static readonly JsonEncodedText Instance = JsonEncodedText.Encode("instance");
            private static readonly JsonEncodedText Errors = JsonEncodedText.Encode("errors");

            public override ValidationProblemDetails Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
            {
                // Use the built-in converter from the default
                // JsonSerializerOptions

                var converter = new JsonSerializerOptions()
                        .GetConverter(typeof(ValidationProblemDetails))
                    as JsonConverter<ValidationProblemDetails>;

                return converter!.Read(ref reader, typeToConvert, options);
            }

            public override void Write(Utf8JsonWriter writer, ValidationProblemDetails problemDetails, JsonSerializerOptions options)
            {
                writer.WriteStartObject();

                writer.Write(Type, problemDetails.Type);
                writer.Write(Title, problemDetails.Title);
                writer.Write(Status, problemDetails.Status);
                writer.Write(Detail, problemDetails.Detail);
                writer.Write(Instance, problemDetails.Instance);

                writer.WriteStartObject(Errors);

                foreach ((string key, string[] value) in problemDetails.Errors)
                {
                    writer.WritePropertyName(options.PropertyNamingPolicy?.ConvertName(key) ?? key);
                    JsonSerializer.Serialize(writer, value, options);
                }

                writer.WriteEndObject();

                writer.WriteEndObject();
            }
        }
    }

    internal static class JsonWriterExtensions
    {
        internal static void Write(this Utf8JsonWriter writer, JsonEncodedText
propertyName, string? value)
        {
            if (value != null) writer.WriteString(propertyName, value);
        }

        internal static void Write(this Utf8JsonWriter writer, JsonEncodedText
propertyName, int? number)
        {
            if (number != null) writer.WriteNumber(propertyName, number.Value);
        }
    }
}
```

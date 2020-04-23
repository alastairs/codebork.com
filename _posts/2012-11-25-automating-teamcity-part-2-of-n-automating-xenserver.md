---
layout: post
title: 'Automating TeamCity (Part 2 of n): Automating XenServer'
author: alastairs
nid: 226
created: 1353850046
---
Recently at work I have been working on a project to build out a new TeamCity installation on a small farm of servers.  Having drawn some inspiration from [Paul Stack](http://www.twitter.com/stack72), I knew that leveraging a virtualised environment could buy us some big wins in automating many aspects of the new TeamCity environment.  This post continues a series of posts that will describe in some detail what I set out to achieve, why, and how I did so.  

Read previous posts in this series:

  * [Automating TeamCity, Part 1: Introduction and Motivation](http://codebork.com/2012/11/25/automating-teamcity-part-1-n.html)

<!--break-->

## The XenServer PowerShell SDK

First, a little bit of context.  Citrix XenServer is an Enterprise-class server virtualisation product, aimed at the corporate data centre.  I've been using it for about five years now, having been introduced to it at Citrix shortly after they acquired XenSource.  It's a direct competitor to VMware's ESXi, and, to a lesser extent, Microsoft's Hyper-V.  XenServer has the advantage of providing [a free version](http://www.citrix.com/products/xenserver/try.html) (account required for download), with a number of limitations, but those seem to be reduced with each successive release: it will support pooling servers to share resources, live migration of VMs across machines in a pool, and more. This is plenty sufficient for our needs, although some of the high-availability and dynamic workload balancing features in the paid-for editions may yet prove useful in future.  

All three of the main server virtualisation products provide a PowerShell SDK for administering and automating aspects of the environment.  [The XenServer PowerShell SDK](http://www.community.citrix.com/cdn/xs/sdks) is given away free (account required), and works with all editions of XenServer.  There are a couple of unfortunate design choices to this tool, sadly, and those are:

  * **It does not follow PowerShell conventions.** Although better than the older preview version of [the XenServer PowerShell cmdlets](http://codebork.com/2012/11/25/automating-teamcity-part-1-n.html), it uses an odd naming convention that does not fully comply with the PowerShell Verb-Noun naming convention, and subsequently breaks tab completion, an important discovery mechanism for any new set of cmdlets.  
  * **The cmdlets do not support the PowerShell pipeline.**  You can't simply take the output of a `Get-VM`-type operation and pipe it into another cmdlet; everything is done using `XenRef` objects, which in practice seems to mean strings. 
  * Both of the above are a direct result of the fact that **the cmdlets provided are a very thin abstraction over the XenServer API.**  Furthermore, the cmdlets are very fine-grained, which means there are no helpful high-level cmdlets for, e.g., creating a VM from a template, or deleting a VM.  Instead, everything is a multi-step operation.
  * **The documentation is terrible.** In most cases, the help on the cmdlets says little more than "refer to the API documentation", but the PowerShell SDK does not ship the API documentation!  Furthermore, the API documentation is exactly what you'd expect from something with that title: a brief summary of the method calls, types, enumerations, etc.
 
## Removing existing build agent VMs

We have a couple of templates for our build agents: one for .NET 4.0 (called dotnet40) and one for .NET 4.5 (called dotnet45).  I decided to use the convention [templatename]-[index] to name the virtual machines: the first .NET 4.0 build agent VM would be called dotnet40-1, the second would be dotnet40-2, etc.  I decided that as part of *adding* a build agent, it should have a tag associated with it so that the active build agents can be easily identified for deletion.  Furthermore, we should be careful not to delete the build agent running this job!  

The script to achieve this looks rather like the following.  We enumerate all the VMs on the XenServer pool, filter them by tag (to get the active build agents) and then by name (to remove the build agent running this job), then perform a clean shutdown on each of the VMs and delete it.  

[gist:4143207]

Note that I've imported a couple of scripts here, too. `credentials.ps1` contains a set of functions to provide credentials for various services, such as the XenServer pool; I'll talk more about this script later in this post.  `teamcity.ps1` is the TeamCity module from [psake-contrib](https://github.com/psake/psake-contrib), renamed to make it an executable script file rather than a PowerShell module.  This module provides a set of functions for writing out [TeamCity service messages](http://confluence.jetbrains.net/display/TCD7/Build+Script+Interaction+with+TeamCity#BuildScriptInteractionwithTeamCity-ServiceMessages), which I use here to output build progress information.  

## Spawning new build agent VMs

This script turned out to be rather more complicated to achieve, due to the fact that the cmdlets are so fine-grained.  

First, I clone the template.  This uses a fast-clone of the virtual disk, which uses the virtual hard drive (VHD) file in the template as a base-line for the new VM, and creates a new, linked, VHD file to store the changes to the disk.  This makes cloning a template super-fast (in my research for this blog post, I came across [this blog post](http://virtualfuture.info/2010/10/xenserver-fast-clone-a-vm-120-times-in-90-seconds/) in which the author claims that he was able to fast-clone a template 120 times in 90 seconds).  However, there are some issues with this approach, namely that [it can lead to an explosion of linked VHDs](http://www.danieletosatto.com/2012/05/04/creating-vms-from-templates-in-xenserver-creates-a-fast-clone/) if, as I was, you re-create your template over and over again from a clone each time.  This is easily resolved by doing a full copy of the template, however, which copies out all the delta VHD files as well as the base into a fresh VHD file ready for use by the new copy of the template.  Be warned that this can take a very long time!

Next, I set the tags on the VM.  This is slightly clunky: we get all the tags, add the desired new tag to that collection, and set them all back on the VM again.  It would be nice if this were to conform more to the PowerShell conventions: i.e., for the SDK to provide `Add-Tag` and `Remove-Tag` cmdlets.

So far, we have a clone of the desired template, with a tag added; we can't yet boot it, because it's still a template and not a runnable VM.  The third step, then, is to make the VM runnable.  Most of my research indicated that it was just a case of setting the `is_a_template` property of the VM to `false`, but this seemed a bit hacky.  Investigating the cmdlets available in the SDK, I found `Invoke-XenServer:VM.Provision` which has the same effect; whether or not it does anything beyond this I don't know, but it seemed better to use this cmdlet rather than fiddling the properties of the VM directly.  

We now have a VM we can boot up, so the final step is to do this.  I return the build agent's name from this helper function so that it can be used in future calls.  Note that in the body of the script, I obtain this value by using the `-1` array indexer on the result of the function call.  This is because the TeamCity module used to report build progress reports the service messages using `Write-Output`, which is equivalent to `return` in PowerShell.  As a result, this function returns multiple values, as an array.  The `-1` array indexer is simply a short-hand for saying "get the last item in the array".  

With the VM up and running, we now need to know when it's available for use, and more specifically, what its IP address is.  This took a bit of searching around the internet, but eventually I turned up [this handy cheatsheet for the XenServer API](http://blog.gigaspaces.com/wp-content/uploads/cloud/Xenserver_API_CheatSheet.pdf) (PDF), which provided an answer in C# using the .NET SDK that I could translate into the PowerShell SDK fairly easily.  Using the "Guest Metrics" of the VM, I can get the network information on the VM, and subsequently the IP address(es) of the VM.  

[gist:4143356]

## A note about storing credentials for use in PowerShell scripts

As I mentioned earlier, I have a couple of functions to retrieve stored credentials for various things, such as connecting to XenServer.  Initially, I used a technique I had picked up in some previous automation work: enter the credentials using `Get-Credential`, then use `ConvertFrom-SecureString` to get a string representation of the encrypted password that could be safely stored in the script file for later use.  This turned out to have a fairly major problem with it, however, namely that by default the encryption algorithm for `SecureString`s includes a machine-specific component *and* a user-specific component.  I discovered this when running the scripts on a build agent, after successfully trialling them on my development machine, and found that my calls to `ConvertTo-SecureString`, to turn the encrypted password string back into a secure string for use in a `PSCredential` object, kept returning the error "Key not valid for use in specified state."

What I had to do instead was generate an encryption key, which must be of a specific length (128, 192, or 256 bits, or 8, 12, or 16 Unicode characters), save this to a text file in Unicode encoding, **set appropriate read permissions on this file,** and read it in from the file as part of the script.  I then re-generated the encrypted password string using `Get-Credential` and `ConvertFrom-SecureString`, this time passing the `-Key` argument to the latter. Annoyingly, the Key can only be provided as a byte array or a SecureString (using the `-SecureKey` argument), so I had to convert the key to a byte array before using it.  My `credentials.ps1` script therefore looks a lot like the following:

[gist:4143393]

## Part 2 Wrap-Up

This part of the series has covered the approach that I took in automating the virtual machine aspects of our new TeamCity infrastructure, including some of the problems that I ran into both with the XenServer PowerShell SDK, and the practice of storing credentials such that the password is not written to the script *and* is usable across machines.  

I would like to see more time and effort invested by Citrix in the XenServer PowerShell SDK to make it less of a thin abstraction over the XenServer API and more of a discoverable set of PowerShell cmdlets, in line with the guiding design principles underpinning all of PowerShell itself.  Well-defined cmdlets that don't try to do too much, such as `New-VMFromTemplate` and `Get-VMIPAddress`, would have made this a much nicer SDK to work with, and implementing proper pipeline support would make the SDK immensely more powerful.  

Stay tuned for Part 3: running configuration scripts remotely!

---
layout: post
title: 'Code Complete: Working Classes (Part 3 - Design and Implementation Issues)'
author: alastairs
nid: 111
created: 1270308233
---
There are a number of design and implementation issues to consider when working with classes, not least dealing with inheritance.  This third post in the series of four on "Working Classes" covers my take on Steve McConnell's thoughts on containment, inheritance, member functions and data, and constructors.
<!--break-->
<h3>Containment</h3>

McConnell defines containment in terms of "has a" relationships; for example, a car "has a" steering wheel, an employee "has a" name and a phone number.  These can be primitive data elements or more complex object types.  These kinds of "has a" relationships should only be implemented through private inheritance as a last resort, i.e., if you can't achieve it via containment, or if containment creates tight coupling with the base classes.  A need to implement "has a" relationships through private inheritance tends to point to design problems, so if you find yourself in this situation, it's worth revisiting your high-level design before going ahead.

A further piece of advice for containment is to be critical of classes that contain more than seven or so members (based on the idea that <a href="http://en.wikipedia.org/wiki/The_Magical_Number_Seven,_Plus_or_Minus_Two">working memory is limited to seven plus or minus two items of information</a>).  If the members are mainly object types, then aim for the lower end of this range, as they are complex types, containing their own members; however, if the members are mostly, or entirely, primitive types, then the rule may be relaxed to the upper end of the range if needed.  
 
<h3>Inheritance</h3>

If containment is described in terms of A "has a" B, then inheritance is described in terms of A "is a" B; i.e., one class is a specialisation of another class.  Scott Meyers, author of <em>Effective C++</em> amongst other titles, regards this as <strong>the single most important rule in object-oriented programming</strong>.  

"Is a" relationships should be implemented via public inheritance such that the new class "is a" more specialised version of the base class.  The derived class must adhere completely to the interface contract defined by the class; if it cannot, inheritance is the wrong technique.  Inheritance adds complexity, however, so it is a dangerous technique; as such it must be designed for and documented, or otherwise prohibited.  If a class is not designed to be inherited from, be sure to mark it as such using <code language="java">final</code> or <code language="csharp">sealed</code>, or whatever mechanism your language makes available for this.  

When designing for inheritance, you should ensure you adhere to the <a href="http://www.codebork.com/2009/02/18/solid-principles-ood.html#LSP" title="SOLID Principles of OOD">Liskov Substitution Principle</a>.  In essence, this means that you shouldn't inherit from a base class unless the derived class really and truly "is a" more specific version of the base class.  The Pragmatic Programmers neatly summarise this as "The subclass must be usable through the base class interface without the need for the user to know the difference"; i.e., all routines defined in the base class should mean the same thing in the derived classes.  See the code listing below for an example:

<blockcode language="csharp">
public class Account {
    public void RecordTransaction(Transaction transaction) {
        // ...
    }
}

public class CurrentAccount : Account {
    // ...
}

public class SavingsAccount : Account {
    // ...
}

public class Program {
    public static void main(String[] args) {
        // ...

        Account currentAccount = new CurrentAccount();
        Account savingsAccount = new SavingsAccount();

        currentAccount.RecordTransaction(transaction);
    }
}
</blockcode>

Given the base class of <code>Account</code> and the derived classes of <code>CurrentAccount</code> and <code>SavingsAccount</code>, a programmer should be able to call Account.RecordTransaction() on either derived class without caring what subtype it is.  If this principle holds, much of the complexity introduced by inheritance is done away with: suddenly you need only deal with the generic attributes and not the implementation details.  Compare an <code>Account.InterestRate</code> getter implementation in a <code>SavingsAccount</code> with that of a <code>LoanAccount</code>: if you were worrying about the implementation details, you would likely need to remember to flip the sign.

When inheriting, be sure that you inherit only that which you want to inherit, i.e., look after your children!  You may want your kids to inherit the three-storey Kensington townhouse, but you probably don't want to saddle them with the mortgage too.  As mentioned above, class contracts apply to the inheritance relationship too, so don't pass on too much detail and baggage to the derived classes.  

The following table details variations on inherited routines.

<table style="text-align: center">
  <thead style="font-weight: bold; border-top: 2pt solid silver; border-bottom: 2pt solid silver">
    <td style="text-align: left; border-right: 1pt solid silver; padding: 2px;"></td>
    <td style="border-right: 1pt solid silver; padding: 2px;">Overridable</td>
    <td style="padding: 2px;">Not Overridable</td>
  </thead>
  <tbody>
    <tr style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver; padding: 2px;"><strong>Implementation: Default Provided</strong></td>
      <td style="border-right: 1pt solid silver; padding: 2px;">Overridable routine</td>
      <td style="padding: 2px;">Non-overridable routine</td>
    </tr>
    <tr  style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver; padding: 2px;"><strong>Implementation: No Default Provided</strong></td>
      <td style="border-right: 1pt solid silver; padding: 2px;">Abstract overridable routine</td>
      <td style="padding: 2px;">N/A - doesn't make sense</td>
    </tr>
  </tbody>
  <caption style="caption-side: bottom; margin-top: 3px; font-weight: bold">Variations on Inherited Routines</caption>
</table>

By way of explanation, "abstract overridable" indicates that a derived method should inherit the interface but not the implementation, such as with Java's <code language="java">AbstractMap.entrySet()</code> method.  This is indicated in Java and C# with the <code language="csharp">abstract</code> keyword.  "Overridable" indicates that the derived method should inherit the interface and the implementation, whilst still allowing the method to be overridden.  Examples include <code language="java">Object.getHashCode()</code> and <code language="java">Object.equals()</code>; this is the default behaviour for Java, but in C# overridable methods must be decorated with the <code language="csharp">virtual</code> keyword.  "Non-overridable" methods are those for which derived methods inherit the interface and the implementation, but where overriding of the implementation is disallowed.  There are no obvious examples in J2SE or .NET, but this is indicated by decorating your method with the <code language="java">final</code> (Java) or <code language="csharp">sealed</code> (C#) keywords.  Beware of inheriting a method's implementation just because you're inheriting the interface: there are strategies to avoid it.  If you want to use a method's implementation but not its interface, consider using containment instead to wrap the implementation.

To reduce complexity, you should avoid overriding a non-overridable member function.  This can cause confusion: methods look polymorphic when in fact they're not.  For example, if <code>A.print(String message)</code> is private, don't create <code>B.print(String message)</code> or <code>B.print(int i)</code> when <code>B</code> extends <code>A</code>.  Also, be sure to move common interfaces, data and behaviour to the highest possible level in the inheritance tree.  The abstraction should guide you here; if moving something up another level breaks the higher object's abstraction, leave it where it is.

McConnell goes on to describe some things to look out for and avoid when using inheritance.  First of these is to be suspicious of classes with only one instance.  This often indicates the design confuses objects with classes; i.e., a new derived class is created instead of instantiating an existing object.  The Singleton pattern is a notable exception to this rule.

You should also be suspicious of base classes with only one derived instance.  This can indicate pre-emptive design, i.e., trying to anticipate future needs, often without fully understanding what those future needs are.  This can be avoided by adhering strongly to <abbr title="You Ain't Gonna Need It">YAGNI</abbr>, and not creating any more inheritance structure than is necessary.

Furthermore, be suspicious of classes that override a routine and do nothing inside the derived routine.  This is usually an error in the design of the base class: e.g., class <code>Cat</code> has method <code>Scratch()</code>, but some cats are de-clawed so can't scratch.  One possible solution to this scenario is to create a new subclass <code>ScratchlessCat</code> that overrides <code>Scratch()</code> to do nothing.  This presents you with a number of problems, however.  First, it violates the abstraction presented by <code>Cat</code> by changing the semantics of its interface; second, what happens when you find a cat without a tail, or a de-clawed cat without a tail, or a cat that doesn't drink milk?  You'll end up with a horribly complex inheritance hierarchy.  Finally, the code becomes confusing to maintain because the interfaces and behaviour of the ancestor classes tell you nothing about the behaviour of their descendants.  The way to fix this scenario is to move the claws abstraction out of the <code>Cat</code> class and into its own class, and then use containment.

Try to avoid deep inheritance trees; inheritance brings much complexity with it, and this quickly mounts up when you introduce multiple levels of inheritance.  Perhaps unsurprisingly, deep inheritance trees are frequently associated with increased fault rates.  McConnell quotes Arthur Riel's 1996 book <em>Object-Oriented Design Heuristics</em> as suggesting six is a good maximum, but believes himself that this suggestion is "grossly optimistic", proposing instead that this is better applied to the total number of subclasses than the number of levels in the inheritance tree.  

Prefer polymorphism to extensive type-checking.  Polymorphism can effectively replace "is" or "instanceof" checks when possible; indeed an entire online campaign, the <a href="http://www.antiifcampaign.com/">Anti-If Campaign</a> has been spawned to address this very issue.  

Make all data private, not protected.  As Joshua Bloch describes in his 2001 book <em>Effective Java</em>, inheritance breaks encapsulation: when you inherit from an object, you obtain privileged access to that object's protected routines and data.  To preserve encapsulation, provide protected accessors instead of protected fields.

Finally, multiple inheritance should be <strong>very</strong> sparingly used.  Indeed, use it only after carefully considering the alternatives and weighing the impact on system complexity and comprehensibility.

In summary:
<ul>
  <li>If multiple classes share common data but not behaviour, create a common object those classes can contain.</li>
  <li>If multiple classes share common behaviour but not data, derive them from a common base class that defines the common routines.</li>
  <li>If multiple classes share common data and behaviour, inherit from a common base class that defines the common data and routines.</li>
  <li>Inherit when you want the base class to control your interface; contain when you want to control your interface.</li>
</ul>

<h3>Member Functions and Data</h3>
McConnell goes on to offer some advice on member functions and data.  First up is to keep the number of routines in a class as small as possible.  Research suggests that higher numbers of routines per class are associated with higher fault rates. Other factors can be more significant, though, such as deep inheritance trees, a large number of routines called within a class, and tight coupling between classes.  For best results, balance the number of routines against these other factors for best results.  

Try to disallow implicitly generated member functions and operators you don't want, such as private constructors, read-only properties, etc.  Also try to minimise the number of different routines called by a class; collectively known as "fan out" along with the number of classes used by a class, this positively correlates with fault rates.  Furthermore, try to minimise indirect routine calls to other classes, for example <code>account.ContactPerson.DayTimeContactInfo.PhoneNumber</code>.  The <a href="http://en.wikipedia.org/wiki/Law_of_Demeter">Law of Demeter</a>, also known as the principle of least knowledge or "the law of one dot", covers this quite neatly.  Simply put, there's no point in directing the wheels to turn when instead you want to drive forward.  

Finally, try to minimise collaboration with other classes.  This is related to the idea of coupling, but McConnell here enumerates some specific kinds of class interaction that should be minimised as much as possible: the number of kinds of objects instantiated, the number of different direct routine calls on instantiated objects, and the number of routine calls on objects returned by other instantiated objects.  

<h3>Constructing and Copying objects</h3>
As much as possible, all member data should be initialised in all the objects constructors.  This is an inexpensive defensive programming practice that can protect you from initialisation errors later on.  It is not clear, however, whether or not this means that initialising fields at declaration is wrong, as is supported by Java and C# for example.  The singleton pattern should be enforced through the use of a private constructor, so that member data is still initialised in the constructor, but only the class itself may create a new instance of the object.  

Finally, McConnell includes a note on deep copying vs. shallow copying of classes.  Deep copies (where a new object is instantiated and the member data of the source is copied into it) are simpler to code and maintain; shallow copies (where a new instance is created to reference the original instance) require code for reference counting and ensuring safe copies, comparisons and deletes.  <a href="http://en.wikipedia.org/wiki/Object_copy" title="Object Copy">Wikipedia has a good explanation of the differences.</a>  McConnell suggests that deep copies should be preferred to shallow copies until it's proven that shallow copies are needed (for performance gains).  It's worth noting, however, that modern languages with good garbage collection handle the reference counting issue capably for you, and in fact make shallow copying an easier and more natural operation than deep copies (which require implementations such as C#'s <code>MemberwiseClone()</code> method).

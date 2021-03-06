# Mirror

Mirror is a toy language I wrote in a couple hours to demonstrate a few tools and concepts in a presentation I gave in a local event in Brazil. It has a syntax inspired by [Smalltalk][1] and semantics inspired by [Self][2] and [IO][3] as seen in the example below:

    World mirrorInto: "Fib".

    Fib set: "of:" to: [ n |
      n < 3
        ifTrue: [ 1. ]
        ifFalse: [ (of: n - 1) + (of: n - 2). ].
    ].

    (Fib of: 10) transcribeAndBreak.
  
# A few more details

* It uses Treetop for parsing
* Classes and objects are represented by containers which contain slots. 
* Slots may be code or literal values. 
* Class and object creation is done by "mirrroring" another object.
* The ground object is called Universe and it contains a World object from which all other primary objects are "mirrored".
* It uses a **very naive** code generator and an **even more naive** interpreter

# Requirements

* Treetop
* Not really a requirement, but it runs better on Ruby 1.9
  
# Running

Usage is pretty simple:

    $ ruby mirror.rb test.mirror
    
Or:

    $ echo "[ 2 + 2. ] value transcribeAndBreak." | ruby mirror.rb
  
# Tests

There are a few tests and test scripts in the _test_ directory. 

# TO DO

* Arrays
* <strike>A more specific bytecode syntax</strike>
* <strike>A more coherent handling of contexts</strike>
* Inlining of common sends
	* <strike>ifTrue:</strike>
	* <strike>ifFalse:</strike>
	* <strike>ifTrue:ifFalse:</strike>
	* to:do:
	* downTo:do:
	* Binary primitives: +, -, *, /, etc
* <strike>Code cleanup</strike>
* LLVM
  
[1]: http://www.smalltalk.org/
[2]: http://selflanguage.org/
[3]: http://www.iolanguage.com/
This is how it works... On a command line you can use one of these
arguments:

D ........ Disable audio filter/LED

E ........ Enable audio filter/LED

S ........ simply Switch the current state of audio filter/LED

H or ? ... small help text 

And that's it. If no argument is used it will put a return code 5 if the
filter/LED is off and 0 if it's on. This way you can check the state of the
audio filter in a shell script using "If WARN".

AFSwitch was written and assembled with ASM-One (PhxAss should work too). It
was testet on an A1200, but should work on all Amiga platforms which support
filter switching since it uses plain 68k code. Big thanx to David Sjölin for
his nice AMW which gave me a clue how cli interaction actually works.

Source is included (with German comments only, sorry).

Changes since 1.0:

1.1
 * More optimizations to make it even smaller
 * Almost all data and address registers are now saved/restored (I'm not sure
   if this is necessary, but they are changed during the process)
 * The source code now contains an example script for return code handling

1.2
 * Added the ?-option (besides H) to call the help text to make it more
   AmigaDOS conform
 * Checks library version now to prevent crash with KickStarts older than 1.1

1.3
 * Minor bug fixed in text output routine

1.4
 * Library version is now checked by peeking directly into the exec base
   instead of using OpenLibrary (which would be pointless since this function
   did not exist before Kick 1.1)

1.5
 * Fixed stupid bug in register handling
 * Minor optimizations

1.6
 * Filter is now checked only if no argument is given making it optional to
   prevent trouble with altered return code

Hopefully the last update :) Note that the only library used by AFS is the
dos.library for text output. The remaining code (the actual filter handling)
should work with all KickStarts.

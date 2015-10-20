NOISE
=====

The Naive OS InStallEr, written in the simple language bash.

Gettext Invocation
------------------

This installer uses domain `aosc-inst` in `/usr/share/locales`. To get a 
fresh partial pot, use:

```Bash
for i in cliinst cliinst-*; do bash --dump-po-strings "$i"; done | msguniq -
```

You may want to do it from some other base directories so you get better 
reference annotations in POT files.

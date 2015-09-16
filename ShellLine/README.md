# LiveKit-CLI
LiveKit Installer, CLI version

## Gettext Invocation

This installer uses domain `aosc-inst` in `/usr/share/locales`. To get a 
fresh partial pot, use:

```Bash
for i in cliinst cliinst-*; do bash --dump-po-strings "$i"; done | msguniq -
```


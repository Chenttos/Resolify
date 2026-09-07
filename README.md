# ResolutionX

Rootless Theos tweak for iPhone 8 Plus / iOS 16.7.x.

## Features

- Resolution presets in Settings.
- iPhone X/XS, XR/11, 12/13/14, 14/15 and Pro Max logical layouts.
- Native iPhone 8 Plus restore option.
- Optional iPhone X-style floating dock.
- Respring button.

## Build

Install Theos and the iOS 16 SDK, then:

```sh
make clean package
```

For a rootless jailbreak, install the generated `.deb` with Sileo/Zebra/Filza.

## Important

This tweak changes SpringBoard's logical coordinate space. It does **not** reprogram the physical LCD framebuffer. Arbitrary framebuffer modes are not exposed as normal iPhone display modes.

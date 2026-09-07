# ResolutionX 1.0.2

For iPhone 8 Plus, iOS 16.7.16, rootless Theos.

## Important fix
This version includes the missing PreferenceLoader registration file:
`/Library/PreferenceLoader/Preferences/ResolutionXPrefs.plist`

Without that file, the preference bundle can install correctly but never appear in Settings.

Build:
`make clean package`

Install the generated deb and respring/reboot SpringBoard.

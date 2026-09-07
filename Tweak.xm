#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static NSString * const RXPrefsPath = @"/var/mobile/Library/Preferences/com.samuel.resolutionx.plist";

static NSDictionary *RXPrefs(void) {
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:RXPrefsPath];
    return d ?: @{};
}

static NSInteger RXPreset(void) {
    return [RXPrefs()[@"preset"] integerValue];
}

static BOOL RXGestureDock(void) {
    id v = RXPrefs()[@"gestureDock"];
    return v ? [v boolValue] : YES;
}

/*
 Presets are logical SpringBoard coordinate spaces.
 The iPhone 8 Plus panel itself remains the same physical panel; this changes
 the coordinate space SpringBoard uses, which is the safer approach than
 trying to reprogram the framebuffer.
*/
static CGSize RXSizeForPreset(NSInteger preset) {
    switch (preset) {
        case 1: return CGSizeMake(375, 812);  // iPhone X / XS
        case 2: return CGSizeMake(414, 896);  // iPhone XR / 11
        case 3: return CGSizeMake(390, 844);  // iPhone 12/13/14
        case 4: return CGSizeMake(393, 852);  // iPhone 14/15
        case 5: return CGSizeMake(430, 932);  // iPhone 12/13/14/15 Pro Max
        case 6: return CGSizeMake(414, 736);  // Native iPhone 8 Plus
        default: return CGSizeMake(414, 736);
    }
}

static BOOL RXEnabled(void) {
    return RXPreset() != 6;
}

%hook UIScreen

- (CGRect)bounds {
    CGRect original = %orig;

    if (!RXEnabled())
        return original;

    // Only alter the main SpringBoard display.
    if (self == [UIScreen mainScreen]) {
        CGSize target = RXSizeForPreset(RXPreset());

        // Preserve the current orientation.
        if (original.size.width > original.size.height)
            return CGRectMake(0, 0, target.height, target.width);

        return CGRectMake(0, 0, target.width, target.height);
    }

    return original;
}

%end

/*
 iOS has a useful quirk: giving UITraitCollection a non-zero display corner
 radius causes SpringBoard to use the modern/floating dock treatment.
 We only do this while the user has selected an X-style preset.
*/
%hook UITraitCollection

- (CGFloat)displayCornerRadius {
    if (RXEnabled() && RXGestureDock())
        return 6.0;

    return %orig;
}

%end

%hook SBDockIconListView

+ (NSUInteger)maxIcons {
    if (RXEnabled() && RXGestureDock())
        return 4;

    return %orig;
}

%end

%ctor {
    if (![[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"])
        return;
}

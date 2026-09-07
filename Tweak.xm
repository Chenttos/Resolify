#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static NSString * const RXDomain = @"com.samuel.resolutionx";
static NSString * const RXRespringNotification = @"com.samuel.resolutionx/respring";

static NSDictionary *RXPrefs(void) {
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:
        @"/var/mobile/Library/Preferences/com.samuel.resolutionx.plist"];
    return d ?: @{};
}

static NSInteger RXPreset(void) {
    return [RXPrefs()[@"preset"] integerValue];
}

static BOOL RXGestureDock(void) {
    id v = RXPrefs()[@"gestureDock"];
    return v ? [v boolValue] : YES;
}

static BOOL RXEnabled(void) {
    return RXPreset() != 6;
}

static CGSize RXTargetSize(void) {
    switch (RXPreset()) {
        case 1: return CGSizeMake(375, 812);
        case 2: return CGSizeMake(414, 896);
        case 3: return CGSizeMake(390, 844);
        case 4: return CGSizeMake(393, 852);
        case 5: return CGSizeMake(430, 932);
        default: return CGSizeMake(414, 736);
    }
}

%hook UIScreen

- (CGRect)bounds {
    CGRect r = %orig;
    if (self == [UIScreen mainScreen] && RXEnabled()) {
        CGSize s = RXTargetSize();
        if (r.size.width > r.size.height)
            return CGRectMake(0, 0, s.height, s.width);
        return CGRectMake(0, 0, s.width, s.height);
    }
    return r;
}

%end

// Keep the dock portion conservative: only alter icon count when X-style
// mode is selected. A later SpringBoard-specific implementation can replace
// the dock background/geometry without affecting Settings.
%hook SBDockIconListView

+ (NSUInteger)maxIcons {
    if (RXEnabled() && RXGestureDock())
        return 4;
    return %orig;
}

%end

%ctor {
    // SpringBoard only.
    if (![[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"])
        return;

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        [](CFNotificationCenterRef center, void *observer, CFStringRef name,
           const void *object, CFDictionaryRef userInfo) {
            if (!name) return;
            NSString *n = (__bridge NSString *)name;
            if ([n isEqualToString:RXRespringNotification]) {
                // Preferred on iOS 16: ask SpringBoard to quit cleanly.
                [[NSClassFromString(@"FBSystemService") performSelector:@selector(sharedInstance)] performSelector:@selector(exitAndRelaunchSpringBoard)];
            }
        },
        (__bridge CFStringRef)RXRespringNotification,
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );
}

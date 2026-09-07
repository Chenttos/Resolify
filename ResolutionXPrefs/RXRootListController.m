#import "RXRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

static NSString * const RXRespringNotification = @"com.samuel.resolutionx/respring";

@implementation RXRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)apply {
    CFPreferencesAppSynchronize(CFSTR("com.samuel.resolutionx"));

    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        (__bridge CFStringRef)RXRespringNotification,
        NULL,
        NULL,
        true
    );
}

@end

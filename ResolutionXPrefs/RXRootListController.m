#import "RXRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>
#import <notify.h>

static NSString * const RXPrefsDomain = @"com.samuel.resolutionx";

@implementation RXRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)apply {
    CFPreferencesAppSynchronize((CFStringRef)RXPrefsDomain);

    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"ResolutionX"
                                            message:@"SpringBoard will restart to apply the new layout."
                                     preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Respring"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *action) {
        notify_post("com.samuel.resolutionx.restart");
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

@end

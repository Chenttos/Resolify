#import "RXRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>

static NSString * const RXPrefsPath = @"/var/mobile/Library/Preferences/com.samuel.resolutionx.plist";

@implementation RXRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)apply {
    // Save through PreferencesLoader-compatible defaults.
    CFPreferencesAppSynchronize(CFSTR("com.samuel.resolutionx"));

    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"ResolutionX"
                                            message:@"Respring is required to apply the new display layout."
                                     preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Respring"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *a) {
        pid_t pid = 0;
        int (*SBRestart)(pid_t) = (int (*)(pid_t))dlsym(RTLD_DEFAULT, "SBRestart");
        if (SBRestart) {
            SBRestart(pid);
            return;
        }

        system("killall SpringBoard");
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

@end

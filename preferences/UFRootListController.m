#include "UFRootListController.h"

HBPreferences* preferences;

@implementation UFRootListController

-(id)init{
    self = [super init];

    if (self) {
	    preferences = [HBPreferences preferencesForIdentifier:UFBundleID];
    }

    return self;
}

+ (NSString *)hb_shareText {
    return [NSString stringWithFormat:TRANSLATE_TEXT(@"SHARE_TEXT"), @"@TapSharp", @"(⌐■_■)"];
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"http://repo.tapsharp.com/"];
}

+ (UIColor *)hb_tintColor {
	return UFTintColor;
}

+ (NSString *)hb_specifierPlist {
	return @"Root";
}


// - (id)readPreferenceValue:(PSSpecifier *)specifier {
//     return [preferences objectForKey:[specifier identifier]];
// }

// - (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
//     [preferences setObject:value forKey:[specifier identifier]];
//     [preferences synchronize];
//     [UFRootListController postPreferenceChangedNotification];
// }

#pragma mark - Preferences

+ (void)postPreferenceChangedNotification {
    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        (CFStringRef) UFBundleID_Notification, NULL, NULL, YES
    );
}

// + (void)postRespringRequiredNotification {
//     CFNotificationCenterPostNotification(
//         CFNotificationCenterGetDarwinNotifyCenter(),
//         (CFStringRef) ELPRespringRequiredNotification, NULL, NULL, YES
//     );
// }

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:UFBundle_PrefsFilePath];

    if ( ! prefs[[specifier propertyForKey:@"key"]]) {
        return [specifier propertyForKey:@"default"];
    }

    return prefs[[specifier propertyForKey:@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [preferences setObject:value forKey:[specifier properties][@"key"]];
    // [preferences synchronize];

    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:UFBundle_PrefsFilePath]];
    [defaults setObject:value forKey:[specifier properties][@"key"]];
    [defaults writeToFile:UFBundle_PrefsFilePath atomically:YES];

    [self.class postPreferenceChangedNotification];
}

- (void)restoreDefaultsUnicodeFaces {
    [preferences setObject:defaultUnifaces forKey:@"unifaces"];
    // [preferences synchronize];

    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:UFBundle_PrefsFilePath]];
    [defaults setObject:defaultUnifaces forKey:@"unifaces"];
    [defaults writeToFile:UFBundle_PrefsFilePath atomically:YES];

    [self.class postPreferenceChangedNotification];
}

# pragma mark - Others

- (void)supportConfirmation {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:TRANSLATE_TEXT(@"SUPPORT_DEVELOPER")
                                                                     message:TRANSLATE_TEXT(@"SUPPORT_DEVELOPER_TEXT")
                                                              preferredStyle:UIAlertControllerStyleAlert];


    UIAlertAction* supportButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"SUPPORT")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];

    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"CANCEL")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];

    [alert addAction:supportButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resetConfirmation {
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:TRANSLATE_TEXT(@"ARE_YOU_SURE")
                                                                     message:TRANSLATE_TEXT(@"ARE_YOU_SURE_RESET")
                                                              preferredStyle:UIAlertControllerStyleAlert];


    UIAlertAction* addButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"RESET")
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * action) {
                                                            [self restoreDefaultsUnicodeFaces];
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];

    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"CANCEL")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];

    [alert addAction:addButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setTitle:@""];
    self.view.tintColor = [UFRootListController hb_tintColor];
}

@end

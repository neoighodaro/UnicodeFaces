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

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    return [preferences objectForKey:[specifier identifier]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [preferences setObject:value forKey:[specifier identifier]];
    [preferences synchronize];
}

-(void) restoreDefaultsUnicodeFaces {
    [preferences setObject:defaultUnifaces forKey:@"unifaces"];
    [preferences synchronize];
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

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
	return @"Hey I'm using Unicode Faces by @TapSharp to type some really cool text smileys (⌐■_■) #iOS #iPhone #iPad";
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"http://repo.tapsharp.com/"];
}

+ (UIColor *)hb_tintColor {
	return [UIColor colorWithWhite:74.f/255.f alpha:1];
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

    HBLogDebug(@"Setting Value: %@ for ID: %@", value, [specifier identifier]);

    // NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:UFBundle_PrefsFilePath];
    // HBLogDebug(@"Plist: %@", plist);

    // CFStringRef PostNotification = (CFStringRef) CFBridgingRetain(specifier.properties[@"PostNotification"]);
    // if(PostNotification && ! [PostNotification isEqualTo:""]) {
    //     CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)PostNotification, nil, nil, YES);
    // }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setTitle:@""];
}

@end

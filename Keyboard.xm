#import "UnicodeFacesKeyboard.h"
#import <Cephei/HBPreferences.h>

NSString* activatorKey;
HBPreferences *preferences;

%hook UIKeyboardImpl

- (void)longPressAction {
	%log;

    UIKeyboardLayoutStar* keyboard = (UIKeyboardLayoutStar *) [self _layout];
    NSString* longPressedKey = [keyboard.activeKey name];

    consoleLog([@"Long Pressed: " stringByAppendingString:longPressedKey], nil);

    if ([longPressedKey isEqualToString:activatorKey]) {
        [self buildUnicodeKeyboard:keyboard];
        consoleLog(@"Completed longPressedAction.", nil);
    }

	return %orig;
}

- (NSArray *)subviews {
	%log;

	[self unifacesKeyboard:%orig withIntent:@"show"];
	return %orig;
}


%new
-(void) buildUnicodeKeyboard:(UIKeyboardLayoutStar *)keyboard {
    [self unifacesKeyboard:self.subviews withIntent:@"hide"];

    consoleLog(@"Create and register keyboard button press handler", nil);
    ButtonPressHandler* buttonPressHandler = [[ButtonPressHandler alloc] initWithKeyboard:self];
    UnicodeFacesKeyboard* view = [[UnicodeFacesKeyboard alloc] initWithFrame:self.frame
                                                     withButtonPressListener:buttonPressHandler];


    [[self superview] addSubview:view];
    [keyboard deactivateActiveKeys];

    [view release];
    [buttonPressHandler release];
}

%new
- (void)unifacesKeyboard:(NSArray *)subviews withIntent:(NSString *)intent {
    consoleLog(@"Attempting to %@ Unicodefaces Keyboard.", intent);

    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UnicodeFacesKeyboard class]]) {
            if ([intent isEqual:@"show"]) {
                [self bringSubviewToFront:view];
                consoleLog(@"Pushed UnicodeFacesKeyboard subview to front.", nil);
            }

            else if ([intent isEqual:@"hide"]) {
                [view removeFromSuperview];
                consoleLog(@"Removed UnicodeFacesKeyboard view from subviews.", nil);
            }

            else {
                consoleLog(@"No intent match for unifacesKeyboard.", nil);
            }

            break;
        }
    }
}
%end


void UFPreferencesChanged() {
    consoleLog(@"UFPreferencesChanged", nil);
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:[[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Preferences"] stringByAppendingPathComponent:@"com.tapsharp.unicodefaces"] stringByAppendingPathExtension:@"plist"]];

    if (plist[@"activator"]) {
        [preferences setObject:plist[@"activator"] forKey:@"activator"];
        consoleLog(@"UFPreferencesChanged updated", nil);
    }
}


%ctor {
    HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.tapsharp.unicodefaces"];

    [preferences registerObject:&activatorKey default:@"Space-Key" forKey:@"activator"];

    UFPreferencesChanged();
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        (CFNotificationCallback)UFPreferencesChanged,
        CFSTR("com.tapsharp.unicodefaces/ReloadPrefs"),
        NULL,
        kNilOptions
    );

    %init;
    consoleLog(@"Initialized! %@", activatorKey);
}

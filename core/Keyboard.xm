#import "UnicodeFacesKeyboard.h"

HBPreferences* preferences;


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - UIKeyboardImpl
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%hook UIKeyboardImpl

- (void)longPressAction {
    [self longPressAction:NULL];
}

- (void)longPressAction:(id)arg1 {
    %log;

    UIKeyboardLayoutStar* keyboard = (UIKeyboardLayoutStar *) [self _layout];
    NSString* longPressedKey = [keyboard.activeKey name];

    HBLogInfo(@"Long Pressed Key: %@", longPressedKey);


    if ([longPressedKey isEqualToString:[preferences objectForKey:@"activator"]]) {
        [self buildUnicodeKeyboard:keyboard];
    }


    %orig;
}

%new
-(void) buildUnicodeKeyboard:(UIKeyboardLayoutStar *)keyboard {
    %log;
    [self unifacesKeyboard:[self subviews] withIntent:@"hide"];

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
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UnicodeFacesKeyboard class]]) {
            if ([intent isEqual:@"hide"]) [view removeFromSuperview];
            if ([intent isEqual:@"show"]) [self bringSubviewToFront:view];
            break;
        }
    }
}
%end


void UFPreferencesChanged() {
    @try {
        HBLogDebug(@"UFPreferencesChanged");
        NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:UFBundle_PrefsFilePath];

        if (prefs[@"activator"]) {
            [preferences setObject:prefs[@"activator"] forKey:@"activator"];
        }

        if (prefs[@"unifaces"]) {
            [preferences setObject:prefs[@"unifaces"] forKey:@"unifaces"];
        }
    }
    @catch (NSException *exception) {
        HBLogDebug(@"Exception: %@", exception.reason);
    }
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constructor
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:UFBundleID];
    [preferences registerDefaults:@{ @"activator": @"Space-Key", @"unifaces": defaultUnifaces }];

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)UFPreferencesChanged,
        (CFStringRef)UFBundleID_Notification, NULL, kNilOptions);
    UFPreferencesChanged();

    %init;
}

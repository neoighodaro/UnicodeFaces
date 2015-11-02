#import "UnicodeFacesKeyboard.h"

HBPreferences* preferences;


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - UIKeyboardImpl
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%hook UIKeyboardImpl

- (void)longPressAction {
	%log;

    UIKeyboardLayoutStar* keyboard = (UIKeyboardLayoutStar *) [self _layout];
    NSString* longPressedKey = [keyboard.activeKey name];

    if ([longPressedKey isEqualToString:[preferences objectForKey:@"activator"]]) {
        [self buildUnicodeKeyboard:keyboard];
    }

	return %orig;
}


%new
-(void) buildUnicodeKeyboard:(UIKeyboardLayoutStar *)keyboard {
    [self unifacesKeyboard:self.subviews withIntent:@"hide"];

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
            if ([intent isEqual:@"show"]) {
                [self bringSubviewToFront:view];
            }

            else if ([intent isEqual:@"hide"]) {
                [view removeFromSuperview];
            }

            break;
        }
    }
}
%end



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constructor
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ctor {
    HBLogDebug(@"Initializing Bundle: %@", UFBundleID);

    preferences = [[HBPreferences alloc] initWithIdentifier:UFBundleID];
    [preferences registerDefaults:@{ @"activator": @"Space-Key", @"unifaces": defaultUnifaces }];

    %init;

    HBLogDebug(@"Initialized Bundle: %@", UFBundleID);
    HBLogDebug(@"Preferences: Activator: %@ Unifaces: %@", [preferences objectForKey:@"activator"], [preferences objectForKey:@"unifaces"]);
}

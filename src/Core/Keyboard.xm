#import <TapSharp/TSLog.h>
#import "Keyboard.h"
#import "UFKeyboard.h"

%hook UIKeyboardImpl
%property(nonatomic,retain) UFKeyboard *uf_keyboard;
-(void)longPressAction {
    [self uf_longPressAction:nil];
    %orig;
}

-(void)longPressAction:(id)arg1 {
    [self uf_longPressAction:arg1];
    %orig;
}

%new
- (void)uf_longPressAction:(id)arg1 {
    tslog("UIKeyboardImpl:uf_longPressAction: called: %@ %@", arg1, [self _layout].activeKey.name);
    if ([[self _layout].activeKey.name isEqualToString:@"International-Key"]) {
        [self uf_buildKeyboard];
    }
}

%new
-(void)uf_buildKeyboard {
    if (self.uf_keyboard == nil) {
        self.uf_keyboard = [UFKeyboard keyboard:self handler:[UFButtonPressHandler keyboard:self]];
        [[self superview] addSubview:self.uf_keyboard];
    }

    [self.uf_keyboard toggle];
    [[self _layout] deactivateActiveKeys];
}

// %new
// -(void)uf_toggleKeyboard:(NSArray *)subviews intent:(NSString *)intent {
//     for (UIView *view in subviews) {
//         if ([view isKindOfClass:UFKeyboard.class]) {
//             if ([intent isEqual:@"hide"]) [view removeFromSuperview];
//             if ([intent isEqual:@"show"]) [self bringSubviewToFront:view];
//             break;
//         }
//     }
// }
%end

%ctor {
    if (@available(iOS 13, *)) {
        NSBundle *bundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/TextInputUI.framework"];
        if (!bundle.loaded) {
            [bundle load];
        }
    }

    tslog("UIKeyboardImpl:Initialised");
    %init;
}

#import "Common.h"

@interface UIKBTree : NSObject
@property(retain, nonatomic) NSString *name;
@end

@interface UIKeyboardLayoutStar : UIView
@property(retain, nonatomic) UIKBTree* activeKey;
- (void)deactivateActiveKeys;
@end

@interface UIKeyboardImpl : UIView
- (void)insertText:(id)text;
- (CGRect)frame;
- (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg;
- (id)_layout;
- (NSArray *)subviews;
- (void)longPressAction;
- (void)longPressAction:(id)arg;
- (void)longPressActionLogic:(id)arg1;
- (void) buildUnicodeKeyboard:(UIKeyboardLayoutStar *)keyboard;
- (void)unifacesKeyboard:(NSArray *)subviews withIntent:(NSString *)intent;
@end

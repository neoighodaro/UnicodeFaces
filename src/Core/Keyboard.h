@interface UIKBTree : NSObject
@property(retain, nonatomic) NSString *name;
@end

@interface UIKeyboardLayoutStar : UIView
@property(retain, nonatomic) UIKBTree* activeKey;
- (void)deactivateActiveKeys;
@end

@interface UIKeyboardImpl : UIView
@property(nonatomic,retain) id uf_keyboard;
- (UIKeyboardLayoutStar *)_layout;
- (void)longPressAction;
- (void)longPressAction:(id)arg;
- (void)uf_longPressAction:(id)arg1;
- (void)uf_buildKeyboard;
- (void)uf_toggleKeyboard:(NSArray *)subviews intent:(NSString *)intent;

- (void)insertText:(id)text;
- (CGRect)frame;
- (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg;
- (NSArray *)subviews;
- (void)unifacesKeyboard:(NSArray *)subviews withIntent:(NSString *)intent;
@end

#import "Common.h"
#import "Keyboard.h"

@protocol ButtonPressListener
- (void)buttonPressReceived:(UIButton *)src;
@end

@interface ButtonPressHandler : NSObject<ButtonPressListener>
@property (strong, nonatomic) UIKeyboardImpl* keyboardImplRef;
- (id)initWithKeyboard:(UIKeyboardImpl*) keyboard;
@end

@interface UnicodeFacesKeyboard : UIView<ButtonPressListener>
- (id)initWithFrame:(CGRect)frame withButtonPressListener:(id<ButtonPressListener>)receiver;
@end

@interface UnicodeFacesKeyboard()
@property (strong, nonatomic) id<ButtonPressListener> receiver;
@property (strong, nonatomic) NSArray* prefs;
- (UIScrollView *)buildScrollView;
- (UIButton *)buildButtonAtIndex:(int)index;
- (UILabel *)buildTopLabel;
- (UIButton *)buildSettingsButton;
@end

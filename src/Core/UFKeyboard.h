#import "Keyboard.h"

@protocol UFKeyboardPressReceiver
-(void)buttonPressReceived:(UIButton *)src;
@end

@interface UFButtonPressHandler : NSObject<UFKeyboardPressReceiver>
@property (nonatomic, retain) UIKeyboardImpl* keyboard;
+(instancetype)keyboard:(UIKeyboardImpl *)keyboard;
@end

@interface UFKeyboard : UIView
@property (strong, nonatomic) id<UFKeyboardPressReceiver> receiver;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSArray<NSString *> *faces;
@property (nonatomic) BOOL showing;
@property (nonatomic, retain) UIKeyboardImpl *keyboard;
+(instancetype)keyboard:(UIKeyboardImpl *)keyboard handler:(id<UFKeyboardPressReceiver>)handler;
- (id)initWithKeyboard:(UIKeyboardImpl *)keyboard handler:(id<UFKeyboardPressReceiver>)receiver ;
- (void)orientationChanged:(NSNotification *)notification;
- (UIButton *)buildButtonWithFace:(NSString *)face index:(NSInteger)idx;
- (UILabel *)buildTopLabel;
-(void)toggle;
@end

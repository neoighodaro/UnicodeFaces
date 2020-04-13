#import "Keyboard.h"
#import "UFKeyboard.h"
#import "../Preferences/UFSettings.h"

@implementation UFButtonPressHandler
+(instancetype)keyboard:(UIKeyboardImpl *)keyboard {
	UFButtonPressHandler *instance = [[UFButtonPressHandler alloc] init];
	instance.keyboard = keyboard;
	return instance;
}

-(void)buttonPressReceived:(UIButton *)src {
	[_keyboard insertText:[src.currentTitle stringByAppendingString:@" "]];
}
@end


@implementation UFKeyboard : UIView
+(instancetype)keyboard:(UIKeyboardImpl *)keyboard handler:(id<UFKeyboardPressReceiver>)handler {
	UFKeyboard *instance = [[UFKeyboard alloc] initWithKeyboard:keyboard handler:handler];
	return instance;
}

- (id)initWithKeyboard:(UIKeyboardImpl *)keyboard handler:(id<UFKeyboardPressReceiver>)receiver {
	CGRect frameRect = keyboard.frame;
	frameRect.origin.y = CGRectGetHeight(frameRect)+100;

    UFKeyboard* superView = [super initWithFrame:frameRect];
    self = [self applyBlurToView:superView withEffectStyle:UIBlurEffectStyleDark andConstraints:YES];

	if (self) {
		_receiver = receiver;
		_keyboard = keyboard;
		_faces = [self faces];
		_scrollView = [self scrollView];

		[self addSubview:[self buildTopLabel]];
		[self addSubview:[self buildCloseButton]];

		NSInteger index = 0;
		for (NSString *face in _faces) {
			[_scrollView addSubview:[self buildButtonWithFace:face index:index]];
			index++;
		}

		[self addSubview:_scrollView];

		[[NSNotificationCenter defaultCenter] addObserver:self
                                        		 selector:@selector(orientationChanged:)
                                             		 name:@"UIDeviceOrientationDidChangeNotification"
                                           		   object:nil];
	}

	return self;
}

-(void)toggle {
	[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			CGRect frame = self.frame;
			frame.origin.y = frame.origin.y > 0 ? 0 : CGRectGetHeight(_keyboard.frame)+100;
			self.frame = frame;
		} completion:nil
	];
}

-(UIScrollView *)scrollView {
	if (_scrollView == nil) {
		CGRect frame = CGRectMake(0, 40, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 40);
		_scrollView = [[UIScrollView alloc] initWithFrame:frame];
		_scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), _faces.count * 40);
	}

	return _scrollView;
}

-(NSArray *)faces {
	if (_faces == nil) {
		_faces = [[UFSettings sharedInstance] faces];
	}
	return _faces;
}

- (void)orientationChanged:(NSNotification *)notification {
	CGRect frameRect = _keyboard.frame;
	frameRect.origin.y = CGRectGetHeight(frameRect)+100;
	self.frame = frameRect;
}

- (UILabel *)buildTopLabel {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
	label.text = [@"Unicode Faces" uppercaseString];
	label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor colorWithWhite:1 alpha:0.7];
	label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];

	return label;
}

- (UIButton *)buildCloseButton {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.titleLabel.font = [btn.titleLabel.font fontWithSize:12];
	btn.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, 8, 50, 20);
	[btn setTitle:@"Close" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

- (UIButton *)buildButtonWithFace:(NSString *)face index:(NSInteger)idx {
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = CGRectMake(0, idx*40, CGRectGetWidth(self.frame), 40);
	[btn setTitle:face forState:UIControlStateNormal];
	[btn addTarget:self.receiver action:@selector(buttonPressReceived:) forControlEvents:UIControlEventTouchUpInside];
	[btn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

- (UFKeyboard *)applyBlurToView:(UFKeyboard *)view withEffectStyle:(UIBlurEffectStyle)style andConstraints:(BOOL)addConstraints {
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
	UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	blurEffectView.frame = view.bounds;

	[view addSubview:blurEffectView];

	if(addConstraints)
	{
		//add auto layout constraints so that the blur fills the screen upon rotating device
		[blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];

		[view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
													   attribute:NSLayoutAttributeTop
													   relatedBy:NSLayoutRelationEqual
														  toItem:view
													   attribute:NSLayoutAttributeTop
													  multiplier:1
														constant:0]];

		[view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
													   attribute:NSLayoutAttributeBottom
													   relatedBy:NSLayoutRelationEqual
														  toItem:view
													   attribute:NSLayoutAttributeBottom
													  multiplier:1
														constant:0]];

		[view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
													   attribute:NSLayoutAttributeLeading
													   relatedBy:NSLayoutRelationEqual
														  toItem:view
													   attribute:NSLayoutAttributeLeading
													  multiplier:1
														constant:0]];

		[view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
													   attribute:NSLayoutAttributeTrailing
													   relatedBy:NSLayoutRelationEqual
														  toItem:view
													   attribute:NSLayoutAttributeTrailing
													  multiplier:1
														constant:0]];
	}

	return view;
}
@end

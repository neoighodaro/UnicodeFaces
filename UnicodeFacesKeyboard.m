#import "UnicodeFacesKeyboard.h"

HBPreferences* preferences;


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - ButtonPressHandler
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

@implementation ButtonPressHandler
- (id)initWithKeyboard:(UIKeyboardImpl*)keyboard {
	self = [super init];
	if(self) {
		self.keyboardImplRef = keyboard;
	}
	return self;
}

- (void)buttonPressReceived:(UIButton *)src {
	[self.keyboardImplRef insertText:[src.currentTitle stringByAppendingString:@" "]];
}
@end



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - UnicodeFacesKeyboard
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

@implementation UnicodeFacesKeyboard : UIView

- (id)initWithFrame:(CGRect)frame withButtonPressListener:(id<ButtonPressListener>)receiver {
	CGFloat oldYCord = frame.origin.y;

	CGRect frameRect = frame;
	frameRect.origin.y = CGRectGetHeight(frame);

    UnicodeFacesKeyboard* superView = [super initWithFrame:frameRect];
    self = [self applyBlurToView:superView withEffectStyle:UIBlurEffectStyleDark andConstraints:YES];

	if (self) {
		self.prefs = [preferences objectForKey:@"unifaces"];

		self.receiver = receiver;

		[self addSubview:[self buildTopLabel]];
		[self addSubview:[self buildCloseButton]];

		if ( ! IN_SPRINGBOARD) {
			[self addSubview:[self buildSettingsButton]];
		}

		UIScrollView *scrollView = [self buildScrollView];

		for(int i = 0; i < [self.prefs count]; i++) {
			UIButton *btn = [self buildButtonAtIndex:i];
			[scrollView addSubview:btn];
		}

		[self addSubview:scrollView];

		[UnicodeFacesKeyboard animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
				CGRect newRect = frame;
				newRect.origin.y = oldYCord;
        		self.frame = newRect;
			} completion:nil
		];

		[[NSNotificationCenter defaultCenter] addObserver:self
                                        		 selector:@selector(orientationChanged:)
                                             		 name:@"UIDeviceOrientationDidChangeNotification"
                                           		   object:nil];
	}

	return self;
}


#pragma mark - Build Views

- (void)orientationChanged:(NSNotification *)notification {
    [self buttonPressReceived:nil];
}

- (UILabel *)buildTopLabel {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
	label.text = [@"Unicode Faces" uppercaseString];
	label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor colorWithWhite:1 alpha:0.2];
	label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];

	return label;
}

- (UIButton *)buildSettingsButton {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

	btn.titleLabel.font = [btn.titleLabel.font fontWithSize:12];
	btn.frame = CGRectMake(10, 8, 50, 20);
	[btn setTitle:@"Settings" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(buttonPressReceivedForSettings:)
			  forControlEvents:UIControlEventTouchUpInside];

	return btn;
}

- (UIButton *)buildCloseButton {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

	btn.titleLabel.font = [btn.titleLabel.font fontWithSize:12];
	btn.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, 8, 50, 20);
	[btn setTitle:@"Close" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(buttonPressReceived:)
			  forControlEvents:UIControlEventTouchUpInside];

	return btn;
}

- (UIScrollView *)buildScrollView {
	CGRect frame = CGRectMake(0, 40, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 40);

	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
	scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), [self.prefs count] * 40);

	return scrollView;
}

- (UIButton *)buildButtonAtIndex:(int)index {
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];

	btn.frame = CGRectMake(0, index * 40, CGRectGetWidth(self.frame), 40);
	[btn setTitle:self.prefs[index] forState:UIControlStateNormal];
	[btn addTarget:self.receiver action:@selector(buttonPressReceived:) forControlEvents:UIControlEventTouchUpInside];
	[btn addTarget:self action:@selector(buttonPressReceived:) forControlEvents:UIControlEventTouchUpInside];

	return btn;
}


#pragma mark - Button Press Events

- (void)buttonPressReceivedForSettings:(UIButton *)src {
	[UnicodeFacesKeyboard animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
		animations:^{
			CGRect newRect = self.frame;
			newRect.origin.y = CGRectGetHeight(self.frame)+100;
    		self.frame = newRect;
		}
		completion:^(BOOL finished) {
			if (finished) {
				NSString *url = [NSString stringWithFormat:@"%@%@", UIApplicationOpenSettingsURLString, UFBundleID];
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
			}
		}
	];
}

- (void)buttonPressReceived:(UIButton *)src {
	[UnicodeFacesKeyboard animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
		animations:^{
			CGRect newRect = self.frame;
			newRect.origin.y = CGRectGetHeight(self.frame)+100;
    		self.frame = newRect;
		}
		completion:nil
	];
}


#pragma mark - Blur

- (UnicodeFacesKeyboard *)applyBlurToView:(UnicodeFacesKeyboard *)view withEffectStyle:(UIBlurEffectStyle)style andConstraints:(BOOL)addConstraints {
	UIBlurEffect *blurEffect = [NSClassFromString(@"UIBlurEffect") effectWithStyle:style];
	UIVisualEffectView *blurEffectView = [[NSClassFromString(@"UIVisualEffectView") alloc] initWithEffect:blurEffect];
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
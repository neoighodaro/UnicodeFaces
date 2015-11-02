#import "UFTapSharpCustomCells.h"

#pragma mark Header Cell

@implementation UFTapSharpHeaderCell

- (NSString *) tweakName {
	return @"Unicode Faces";
}

- (UIColor *) tweakNameColor {
	return [UIColor colorWithWhite:74.f / 255.f alpha:1];
}

- (NSString *) tweakDescription {
	return @"It's Like Emojis But With Plain Text!";
}

- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];

    if (self) {
        int width = [[UIScreen mainScreen] bounds].size.width;
        CGRect frame = CGRectMake(0, 0, width, 60);
        CGRect botFrame = CGRectMake(0, 53, width, 20);

        tweakNameLabel = [[UILabel alloc] initWithFrame:frame];
        [tweakNameLabel setNumberOfLines:1];
        tweakNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:45];
        [tweakNameLabel setText:[self tweakName]];
        [tweakNameLabel setBackgroundColor:[UIColor clearColor]];
        tweakNameLabel.textColor = [self tweakNameColor];
        tweakNameLabel.textAlignment = NSTextAlignmentCenter;

        tweakDescriptionLabel = [[UILabel alloc] initWithFrame:botFrame];
        [tweakDescriptionLabel setNumberOfLines:1];
        tweakDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        [tweakDescriptionLabel setText:[[self tweakDescription] uppercaseString]];
        [tweakDescriptionLabel setBackgroundColor:[UIColor clearColor]];
        tweakDescriptionLabel.textColor = [UIColor grayColor];
        tweakDescriptionLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:tweakNameLabel];
        [self addSubview:tweakDescriptionLabel];
    }

    return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
    return 100.f;
}

- (void) dealloc {
	[tweakNameLabel release];
	[tweakDescriptionLabel release];

	[super dealloc];
}

@end


#pragma mark - Footer Cell

@implementation UFTapSharpFooterCell

- (NSString *) copyrightText {
	return @"ALL RIGHTS RESERVED © %@";
}

- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];

    if (self) {
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;

        // Logo Image
		logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 29)];
		logoImageView.image = [UIImage imageNamed:@"tapsharp" inBundle:[NSBundle bundleForClass:self.class]];
		[logoImageView setCenter:CGPointMake(screenWidth/2, self.bounds.size.height/2)];

		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy"];
		NSString *yearString = [formatter stringFromDate:[NSDate date]];

		// Copyright text
        copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, screenWidth, 20)];
        [copyrightLabel setNumberOfLines:1];
        [copyrightLabel setBackgroundColor:[UIColor clearColor]];
        [copyrightLabel setText:[NSString stringWithFormat:[self copyrightText], yearString]];
        copyrightLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:8];
        copyrightLabel.textColor = [UIColor grayColor];
        copyrightLabel.textAlignment = NSTextAlignmentCenter;

        // Add subviews
        [self addSubview:copyrightLabel];
		[self addSubview:logoImageView];
    }

    return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
    return 80.0f;
}

-(void)dealloc {
	[copyrightLabel release];
	[logoImageView release];

	[super dealloc];
}

@end
#import <Preferences/PSTableCell.h>

@interface UIImage (TapSharp)
+ (UIImage *)imageNamed:(NSString *)named inBundle:(NSBundle *)bundle;
@end

@interface UFTapSharpHeaderCell : PSTableCell {
    UILabel *tweakNameLabel;
    UILabel *tweakDescriptionLabel;
}
- (NSString *) tweakName;
- (UIColor *) tweakNameColor;
- (NSString *) tweakDescription;
@end

@interface UFTapSharpFooterCell : PSTableCell {
	UILabel* copyrightLabel;
	UIImageView* logoImageView;
}
- (NSString *) copyrightText;
@end
#import "../Common.h"
#import <CepheiPrefs/HBRootListController.h>
#import <Preferences/PSTableCell.h>

@interface UFRootListController : HBRootListController
@end

@interface UFResetTableCell : PSTableCell
-(UILabel *)titleTextLabel;
-(UILabel *)titleLabel;
@end

@implementation UFResetTableCell
-(UILabel *)titleTextLabel {
	HBLogDebug(@"titleTextLabel");
	UILabel* title = [super titleTextLabel];
	title.textColor = [UFRootListController hb_tintColor];
	return title;
}

-(UILabel *)titleLabel {
	HBLogDebug(@"titleLabel");
	UILabel* title = [super titleLabel];
	title.textColor = [UFRootListController hb_tintColor];
	title.tintColor = [UFRootListController hb_tintColor];

	return title;
}
@end

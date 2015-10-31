#include "UFRootListController.h"

@implementation UFRootListController

+ (NSString *)hb_shareText {
	return @"Hey I'm using Unicode Faces by @TapSharp to type some really cool text smileys (⌐■_■) #iOS #iPhone #iPad";
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"http://repo.tapsharp.com/"];
}

+ (UIColor *)hb_tintColor {
	return [UIColor colorWithWhite:74.f / 255.f alpha:1];
}

+ (NSString *)hb_specifierPlist {
	return @"Root";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setTitle:@""];
}

@end

#import <TapSharp/TSLog.h>
#import "UFSettings.h"
#import "../macros.h"

@implementation UFSettings
+(instancetype)sharedInstance {
	static dispatch_once_t once = 0;
    __strong static id sharedInstance = nil;
	dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithAppID:CFSTR(kUFBundleID) defaults:nil];
    });
	return sharedInstance;
}

-(NSArray *)faces {
    return [self arrayForKey:@"faces" fallback:kUFDefaultFaces];
}
@end

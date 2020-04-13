#import <TapSharp/TSPrefsManager.h>

@interface UFSettings : TSPrefsManager
@property(nonatomic, readonly, getter=faces) NSArray *faces;
+(instancetype)sharedInstance;
@end

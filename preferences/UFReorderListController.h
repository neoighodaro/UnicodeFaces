#import <CepheiPrefs/HBListController.h>
#import <Preferences/PSSpecifier.h>

extern NSString* PSDeletionActionKey;

@interface PSEditableListController : HBListController
@end

@interface UFReorderListController : PSEditableListController {
	NSMutableArray* _unicodeFaces;
}
@property (retain, nonatomic) NSMutableArray* unicodeFaces;
@end
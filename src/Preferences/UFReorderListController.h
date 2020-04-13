#import "../core/Common.h"
#import <CepheiPrefs/HBListItemsController.h>
#import <Preferences/PSSpecifier.h>

extern NSString* PSDeletionActionKey;

@interface PSEditableListController : HBListItemsController
-(void)editDoneTapped;
-(void)reload;
-(void)reloadSpecifiers;
- (BOOL)performDeletionActionForSpecifier:(PSSpecifier*)specifier;
@end


@interface UFReorderListController : PSEditableListController {
	NSMutableArray* _unicodeFaces;
	BOOL _isEditingMode;
}

@property (retain, nonatomic) NSMutableArray* unicodeFaces;

- (id)init;
- (id)specifiers;
- (NSMutableArray *)unicodeFaces;
- (NSMutableArray *)unifacecodeSpecifiers;
- (PSSpecifier *)unifacecodeSpecifier:(NSString *)uniface;
- (id)readPreferenceValue:(PSSpecifier *)specifier;
- (void)removeUnicodeFace:(PSSpecifier *)specifier;
- (void)addUnicodeFace:(NSString *)unicodeFace;
- (void)updateUnicodeFace:(NSString *)unicodeFace atIndex:(NSIndexPath *)indexPath;
- (IBAction)addUnicodeFaceAlert:(id)sender;
- (void)editUnicodeFaceAlertForIndex:(NSIndexPath *)indexPath;
@end
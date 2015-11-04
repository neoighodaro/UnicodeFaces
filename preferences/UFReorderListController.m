#import "../Common.h"
#include "UFRootListController.h"
#include "UFReorderListController.h"

HBPreferences* preferences;

@implementation UFReorderListController

-(id)init{
    self = [super init];

    if (self) {
	    preferences = [HBPreferences preferencesForIdentifier:UFBundleID];
    }

    return self;
}

+ (UIColor *)hb_tintColor {
	return [UIColor colorWithWhite:74.f/255.f alpha:1];
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Specifiers
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-(id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [[self unifacecodeSpecifiers] copy];
	}

	return _specifiers;
}

-(NSMutableArray*) unicodeFaces {
	if ( ! _unicodeFaces) {
		_unicodeFaces = [[preferences objectForKey:@"unifaces"] mutableCopy];
	}

	return _unicodeFaces;
}


- (NSMutableArray*) unifacecodeSpecifiers {
	NSMutableArray* specifiers = [NSMutableArray array];

	for (NSString* unicodeFace in [self unicodeFaces]) {
		if ( ! [unicodeFace isEqual:@""]) {
			[specifiers addObject:[self unifacecodeSpecifier:unicodeFace]];
		}
	}

	return specifiers;
}

-(PSSpecifier *) unifacecodeSpecifier:(NSString *)uniface {
    PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:uniface
    														target:self
    														   set:nil
    														   get:nil
    														detail:nil
    														  cell:PSListItemCell
    														  edit:nil];

    [specifier setProperty:uniface forKey:@"id"];
    [specifier setProperty:NSStringFromSelector(@selector(removeUnicodeFace:)) forKey:PSDeletionActionKey];

    return specifier;
}



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Delete and Add
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-(void)removeUnicodeFace:(PSSpecifier*)specifier {
	[_unicodeFaces removeObjectAtIndex:[_unicodeFaces indexOfObject:[specifier identifier]]];
	[preferences setObject:_unicodeFaces forKey:@"unifaces"];
	[preferences synchronize];
	[self reloadSpecifiers];
    [UFRootListController postPreferenceChangedNotification];
}

-(void) addUnicodeFace:(NSString*)unicodeFace {
	[_unicodeFaces insertObject:unicodeFace atIndex:0];
	[preferences setObject:_unicodeFaces forKey:@"unifaces"];
	[preferences synchronize];
	[self reloadSpecifiers];
	[UFRootListController postPreferenceChangedNotification];
}

- (IBAction) addUnicodeFaceAlert:(id)sender {
	UIAlertController * alert=   [UIAlertController alertControllerWithTitle:TRANSLATE_TEXT(@"ADD_UNICODE")
																	 message:nil
															  preferredStyle:UIAlertControllerStyleAlert];


	UIAlertAction* addButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"ADD")
														style:UIAlertActionStyleDefault
													  handler:^(UIAlertAction * action) {
													  		NSString* newUnicodeFace = ((UITextField*)alert.textFields[0]).text;

													  		[self addUnicodeFace:newUnicodeFace];

															[alert dismissViewControllerAnimated:YES completion:nil];
															[self editDoneTapped];
													  }];

	UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"CANCEL")
														style:UIAlertActionStyleCancel
													  handler:^(UIAlertAction * action) {
															[alert dismissViewControllerAnimated:YES completion:nil];
													  }];

	[alert addAction:addButton];
	[alert addAction:cancelButton];
	[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = TRANSLATE_TEXT(@"ENTER_UNICODE");
		textField.keyboardType = UIKeyboardTypeDefault;
	}];

	[self presentViewController:alert animated:YES completion:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    if (editing) {
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
        																		target:self
        																		action:@selector(addUnicodeFaceAlert:)];
        self.navigationItem.leftBarButtonItem = addBtn;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Reordering Table Rows
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

- (BOOL)performDeletionActionForSpecifier:(PSSpecifier*)specifier {
	@try {
		[super performDeletionActionForSpecifier:specifier];
	}
	@catch (NSException* exception) {
		// @TODO: Implement yourself, throwing some exception
		HBLogDebug(@"Caught Exception: %@", exception.reason);

		NSMutableArray* specifiers = [_specifiers mutableCopy];
		[specifiers removeObjectAtIndex:[_specifiers indexOfObject:specifier]];
		_specifiers = specifiers;

		[specifiers release];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ! (indexPath.row == [_unicodeFaces count]);
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return ! (indexPath.row == [_unicodeFaces count]);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString* unicodeFace = [_unicodeFaces objectAtIndex:fromIndexPath.row];
    [_unicodeFaces removeObjectAtIndex:fromIndexPath.row];
    [_unicodeFaces insertObject:unicodeFace atIndex:toIndexPath.row];

	[preferences setObject:_unicodeFaces forKey:@"unifaces"];
	[preferences synchronize];
	[self reloadSpecifiers];
	[UFRootListController postPreferenceChangedNotification];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if ([proposedDestinationIndexPath row] < [_unicodeFaces count]) {
        return proposedDestinationIndexPath;
    }
    NSIndexPath *betterIndexPath = [NSIndexPath indexPathForRow:[_unicodeFaces count]-1 inSection:0];
    return betterIndexPath;
}



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Deallocate
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-(void)dealloc {
	[_unicodeFaces release];
	[super dealloc];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UFReorderListController hb_tintColor];
}

-(void)editDoneTapped {
	[super editDoneTapped];
	_isEditingMode = !_isEditingMode;
	[self setEditing:_isEditingMode animated:YES];
}
@end

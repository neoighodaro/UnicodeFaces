#import "../Common.h"
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
    [specifier setProperty:NSStringFromSelector(@selector(removedSpecifier:)) forKey:PSDeletionActionKey];

    return specifier;
}



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Delete and Add
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-(void)removedSpecifier:(PSSpecifier*)specifier{
	[_unicodeFaces removeObjectAtIndex:[_unicodeFaces indexOfObject:[specifier identifier]]];
	[preferences setObject:_unicodeFaces forKey:@"unifaces"];
	[preferences synchronize];
}

-(void) addSpecifier:(NSString*)uniface {
	HBLogDebug(@"Old Specifiers: %@", _specifiers);

	NSMutableArray* specifiers = [_specifiers mutableCopy];

	[specifiers addObject:[self unifacecodeSpecifier:uniface]];
	_specifiers = [specifiers copy];

	[specifiers release];

	// @TODO Reload?
	HBLogDebug(@"New Specifiers: %@", _specifiers);
}

-(void) restoreDefaultsUnicodeFaces {
	_unicodeFaces = [defaultUnifaces mutableCopy];
	[preferences setObject:_unicodeFaces forKey:@"unifaces"];
	[preferences synchronize];
}


// - (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//     [super setEditing:editing animated:animated];

//     HBLogDebug(@"Editing!");

//     if (editing) {
//         // Add the + button
//         UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//         																		target:self
//         																		action:@selector(addSpecifier:)];
//         self.navigationItem.leftBarButtonItem = addBtn;
//     } else {
//         // remove the + button
//         self.navigationItem.leftBarButtonItem = nil;
//     }
// }

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Reordering Table Rows
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_unicodeFaces count] ) {
        return NO;
    }
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_unicodeFaces count]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	HBLogDebug(@"Reorder Preferences");
    HBLogDebug(@"Old Prefs: %@", _unicodeFaces);

    PSSpecifier *specifier = [_unicodeFaces objectAtIndex:fromIndexPath.row];
    [_unicodeFaces removeObjectAtIndex:fromIndexPath.row];
    [_unicodeFaces insertObject:specifier atIndex:toIndexPath.row];

	[preferences setObject:_unicodeFaces forKey:@"unifaces"];
	[preferences synchronize];

    HBLogDebug(@"New Prefs: %@", _unicodeFaces);
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

@end

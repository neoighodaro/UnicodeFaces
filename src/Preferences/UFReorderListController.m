#include "UFRootListController.h"
#include "UFReorderListController.h"

HBPreferences* preferences;

@implementation UFReorderListController

- (id)init {
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

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [[self unifacecodeSpecifiers] copy];
	}

	return _specifiers;
}

- (NSMutableArray *)unicodeFaces {
	if ( ! _unicodeFaces) {
		_unicodeFaces = [[preferences objectForKey:@"unifaces"] mutableCopy];
	}

	return _unicodeFaces;
}


- (NSMutableArray *)unifacecodeSpecifiers {
	NSMutableArray* specifiers = [NSMutableArray array];

	for (NSString* face in self.unicodeFaces) {
		if ( ! [face isEqualToString:@""]) {
			[specifiers addObject:[self unifacecodeSpecifier:face]];
		}
	}

	return specifiers;
}

- (PSSpecifier *)unifacecodeSpecifier:(NSString *)uniface {
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

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:UFBundle_PrefsFilePath];

    if ( ! prefs[[specifier propertyForKey:@"key"]]) {
        return [specifier propertyForKey:@"default"];
    }

    return prefs[[specifier propertyForKey:@"key"]];
}

- (void)removeUnicodeFace:(PSSpecifier *)specifier {
	[_unicodeFaces removeObjectAtIndex:[_unicodeFaces indexOfObject:[specifier identifier]]];

	[preferences setObject:_unicodeFaces forKey:@"unifaces"];
	[preferences synchronize];

    // NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    // [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:UFBundle_PrefsFilePath]];
    // [defaults setObject:_unicodeFaces forKey:@"unifaces"];
    // [defaults writeToFile:UFBundle_PrefsFilePath atomically:YES];

    [UFRootListController postPreferenceChangedNotification];

	[self reloadSpecifiers];
}

- (void)addUnicodeFace:(NSString *)unicodeFace {
	[_unicodeFaces insertObject:unicodeFace atIndex:0];

	[preferences setObject:_unicodeFaces forKey:@"unifaces"];
	[preferences synchronize];

    // NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    // [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:UFBundle_PrefsFilePath]];
    // [defaults setObject:_unicodeFaces forKey:@"unifaces"];
    // [defaults writeToFile:UFBundle_PrefsFilePath atomically:YES];

    [UFRootListController postPreferenceChangedNotification];

	[self reloadSpecifiers];
}

- (void)updateUnicodeFace:(NSString *)unicodeFace atIndex:(NSIndexPath *)indexPath {
	[_unicodeFaces replaceObjectAtIndex:indexPath.row withObject:unicodeFace];

	[preferences setObject:_unicodeFaces forKey:@"unifaces"];
	[preferences synchronize];

    // NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    // [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:UFBundle_PrefsFilePath]];
    // [defaults setObject:_unicodeFaces forKey:@"unifaces"];
    // [defaults writeToFile:UFBundle_PrefsFilePath atomically:YES];

    [UFRootListController postPreferenceChangedNotification];

	[self reloadSpecifiers];
}

- (IBAction)addUnicodeFaceAlert:(id)sender {
	UIAlertController * alert = [UIAlertController alertControllerWithTitle:TRANSLATE_TEXT(@"ADD_UNICODE")
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


- (void)editUnicodeFaceAlertForIndex:(NSIndexPath *)indexPath {
	UIAlertController * alert = [UIAlertController alertControllerWithTitle:TRANSLATE_TEXT(@"EDIT_UNICODE")
																	 message:nil
															  preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction* addButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"EDIT")
														style:UIAlertActionStyleDefault
													  handler:^(UIAlertAction * action) {
													  		NSString* newUnicodeFace = ((UITextField*)alert.textFields[0]).text;

													  		[self updateUnicodeFace:newUnicodeFace atIndex:indexPath];
															[alert dismissViewControllerAnimated:YES completion:nil];
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
		textField.text = [_unicodeFaces objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self editUnicodeFaceAlertForIndex:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Reordering Table Rows
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

- (BOOL)performDeletionActionForSpecifier:(PSSpecifier*)specifier {
	@try {
		[super performDeletionActionForSpecifier:specifier];
	}
	@catch (NSException* exception) {
		NSMutableArray* specifiers = [_specifiers mutableCopy];
		[specifiers removeObjectAtIndex:[_specifiers indexOfObject:specifier]];
		_specifiers = specifiers;

		[specifiers release];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView.editing) {
		return UITableViewCellEditingStyleDelete;
	}

	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ! (indexPath.row == _unicodeFaces.count);
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

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)fromIndexPath toProposedIndexPath:(NSIndexPath *)toIndexPath {
    if (toIndexPath.row < _unicodeFaces.count) {
        return toIndexPath;
    }

    return [NSIndexPath indexPathForRow:(_unicodeFaces.count - 1) inSection:0];
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Misc
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

- (void)dealloc {
	[_unicodeFaces release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [self.class hb_tintColor];
}

- (void)editDoneTapped {
	[super editDoneTapped];

	_isEditingMode = !_isEditingMode;

	[self setEditing:_isEditingMode animated:YES];

	[preferences setObject:_unicodeFaces forKey:@"unifaces"];
	[preferences synchronize];
}
@end

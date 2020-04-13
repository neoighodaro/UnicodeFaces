#include "UFRootListController.h"

@implementation UFRootListController

# pragma mark - Others

- (void)supportConfirmation {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:TRANSLATE_TEXT(@"SUPPORT_DEVELOPER")
                                                                     message:TRANSLATE_TEXT(@"SUPPORT_DEVELOPER_TEXT")
                                                              preferredStyle:UIAlertControllerStyleAlert];


    UIAlertAction* supportButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"SUPPORT")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];

    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"CANCEL")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];

    [alert addAction:supportButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resetConfirmation {
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:TRANSLATE_TEXT(@"ARE_YOU_SURE")
                                                                     message:TRANSLATE_TEXT(@"ARE_YOU_SURE_RESET")
                                                              preferredStyle:UIAlertControllerStyleAlert];


    UIAlertAction* addButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"RESET")
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * action) {
                                                            [self restoreDefaultsUnicodeFaces];
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];

    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:TRANSLATE_TEXT(@"CANCEL")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];

    [alert addAction:addButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setTitle:@""];
    self.view.tintColor = [UFRootListController hb_tintColor];
}

@end

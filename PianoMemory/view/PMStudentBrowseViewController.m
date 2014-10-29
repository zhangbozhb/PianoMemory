//
//  PMStudentBrowseViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMStudentBrowseViewController.h"
#import "PMStudent+Wrapper.h"
#import "PMStudentBrowseTableViewCell.h"
#import "PMStudentEditViewController.h"
#import "PMServerWrapper.h"
#import <AddressBookUI/AddressBookUI.h>
#import <APAddressBook/APContact.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "PMDateUpdte.h"
#import "UIViewController+DataUpdate.h"
#import "UISearchBar+Extend.h"
#import "UIDevice+Extend.h"

static NSString *const studentBrowseTableViewCellReuseIdentifier = @"PMStudentBrowseTableViewCelReuseIdentifier";


@interface PMStudentBrowseViewController () <UITableViewDataSource, UITableViewDelegate,
                                            UISearchBarDelegate,
                                            ABPeoplePickerNavigationControllerDelegate,
                                            UIActionSheetDelegate,
                                            UIAlertViewDelegate>
@property (nonatomic) NSMutableArray *studentArray;
@property (nonatomic) BOOL shouldFetchData;

//search
@property (nonatomic) NSString *lastSearchText;
@property (nonatomic) BOOL waitingSearch;

@property (nonatomic) APContact *processingContact;
@property (nonatomic) PMStudent *toSaveStudent;

//xib reference
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UITableView *studentsTableView;
@property (weak, nonatomic) IBOutlet UIView *addContactViewContainer;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@end

@implementation PMStudentBrowseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForDataUpdate];
    self.shouldFetchData = YES;
    self.waitingSearch = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideAddContactView];
    [self loadCustomerData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self hideAddContactView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.studentArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMStudentBrowseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studentBrowseTableViewCellReuseIdentifier];
    PMStudent *student = [self.studentArray objectAtIndex:indexPath.row];
    [cell setStudent:student];
    [cell refreshUI];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        __weak PMStudentBrowseViewController *pSelf = self;
        [self deleteStudent:[self.studentArray objectAtIndex:indexPath.row] block:^{
            [pSelf.studentArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

#pragma add contact
- (IBAction)addContactFromContactsAction:(id)sender {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)hideAddContactView
{
    [self.addContactViewContainer setHidden:YES];
}

- (IBAction)performAddAction:(id)sender {
    if (self.addContactViewContainer.hidden) {
        self.addContactViewContainer.hidden = NO;
    } else {
        self.addContactViewContainer.hidden = YES;
    }
}

#pragma mark - Segue support
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"addStudentSegueIdentifier"]) {
        PMStudentEditViewController *addStudentVC = (PMStudentEditViewController*)[segue destinationViewController];
        [addStudentVC setStudent:nil];
        [self hideAddContactView];
    } else if([[segue identifier] isEqualToString:@"editStudentSegueIdentifier"]) {
        PMStudentEditViewController *addStudentVC = (PMStudentEditViewController*)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.studentsTableView indexPathForSelectedRow];
        if (selectedIndexPath && selectedIndexPath.row < [self.studentArray count]) {
            [addStudentVC setStudent:[self.studentArray objectAtIndex:selectedIndexPath.row]];
        } else {
            [addStudentVC setStudent:nil];
        }
        [self hideAddContactView];
    }
}


#pragma delegate ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//ios 7
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self handleABRecord:person];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
//ios8
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    [self handleABRecord:person];
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self handleABRecord:person];
}

- (void)handleABRecord:(ABRecordRef)person
{
    APContact *contact = [[APContact alloc] initWithRecordRef:person
                                                    fieldMask:APContactFieldDefault|APContactFieldEmails|APContactFieldCompositeName|APContactFieldCompany];

    NSArray *phones =  contact.phones;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"手机号码"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    for(NSString *pho in phones)
    {
        [sheet addButtonWithTitle:pho];
    }
    [sheet addButtonWithTitle:@"取消"];
    sheet.cancelButtonIndex = phones.count;

    if (0 < [contact.phones count]) {
        self.processingContact = contact;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    } else {
        self.processingContact = nil;
        [self showAlertViewForNoPhoneOfContact];
    }
}

#pragma delagte activesheet
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.toSaveStudent = nil;
    if (self.processingContact &&
        buttonIndex < [self.processingContact.phones count]) {
        PMStudent *student = [[PMStudent alloc] init];
        student.name = self.processingContact.compositeName;
        student.phone = [self.processingContact.phones objectAtIndex:buttonIndex];
        self.toSaveStudent = student;

        [self showSaveAlertViewForStudent:student];
    }
}

- (void)showSaveAlertViewForStudent:(PMStudent*)student
{
    NSString *message = [NSString stringWithFormat:@"%@\n%@",student.name, student.phone];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加联系人"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)showAlertViewForNoPhoneOfContact
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"失败"
                                                        message:@"该联系人没有电话号码，请选择其它联系人"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}
#pragma delegate alertview
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        if ([UIDevice zb_systemVersion8Latter]) {
            [self saveStudent:self.toSaveStudent];
        } else {
            __weak PMStudentBrowseViewController *pSelf = self;
            [self dismissViewControllerAnimated:YES completion:^{
                [pSelf saveStudent:pSelf.toSaveStudent];
            }];
        }
    }
}

- (void)saveStudent:(PMStudent*)student
{
    [student updateShortcut];
    __weak PMStudentBrowseViewController *pSelf = self;
    [[PMServerWrapper defaultServer] createStudent:student success:^(PMStudent *student) {
        MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"成功" message:@"已经成功添加学生"];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
        }];
    } failure:^(HCErrorMessage *error) {
        MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"失败" message:[error errorMessage]];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
        }];
    }];
}

- (void)deleteStudent:(PMStudent*)student block:(void (^)(void))block
{
    [student updateShortcut];
    __weak PMStudentBrowseViewController *pSelf = self;
    [[PMServerWrapper defaultServer] deleteStudent:student success:^(PMStudent *student) {
        MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"成功" message:@"已经成功删除学生"];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
            if (block) {
                block();
            }
        }];
    } failure:^(HCErrorMessage *error) {
        MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"失败" message:[error errorMessage]];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
            if (block) {
                block();
            }
        }];
    }];
}

#pragma convenience method
- (MBProgressHUD*)getSimpleToastWithTitle:(NSString*)title message:(NSString*)message
{
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:toast];
    toast.mode = MBProgressHUDModeText;
    toast.animationType = MBProgressHUDAnimationZoomOut;
    [toast setLabelText:title];
    [toast setDetailsLabelText:message];
    return toast;
}

#pragma data update
- (void)handleDataUpdated:(NSNotification *)notification
{
    [super handleDataUpdated:notification];
    if (PMLocalServer_DateUpateType_Student == [PMDateUpdte dateUpdateType:notification.object] ||
        PMLocalServer_DateUpateType_ALL == [PMDateUpdte dateUpdateType:notification.object]) {
        self.shouldFetchData = YES;
    }
}

#pragma search
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES];
    UIButton *cancelButton = [searchBar zb_getCancelButton];
    if (cancelButton) {
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.shouldFetchData = YES;
    [self loadCustomerData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchStudentWithNameOrPhoneWrapper];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self searchStudentWithNameOrPhone:[searchBar text]];
}

- (void)searchStudentWithNameOrPhone:(NSString *)searchText
{
    if (self.lastSearchText == searchText || [self.lastSearchText isEqualToString:searchText]) {
        return;
    }
    searchText = [searchText lowercaseString];
    self.lastSearchText = searchText;

    NSDictionary *params = nil;
    if (0 < [searchText length]) {
        params = @{@"name" : searchText,
                   @"phone" : searchText,
                   @"nameShortcut": searchText};
    }
    __weak PMStudentBrowseViewController *pSelf = self;
    [[PMServerWrapper defaultServer] queryStudents:params success:^(NSArray *array) {
        pSelf.studentArray = [NSMutableArray arrayWithArray:array];
        [pSelf refreshUI];
    } failure:^(HCErrorMessage *error) {
    }];
}

- (void)searchStudentWithNameOrPhoneWrapper
{
    if (!self.waitingSearch) {
        self.waitingSearch = YES;
        // dispatch_time使用的时间是纳秒，
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC);
        __weak PMStudentBrowseViewController *pSelf = self;
        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
            pSelf.waitingSearch = NO;
            [pSelf searchStudentWithNameOrPhone:pSelf.mySearchBar.text];
        });
    }
}

- (void)loadCustomerData
{
    if (self.shouldFetchData) {
        __weak PMStudentBrowseViewController *pSelf = self;
        [[PMServerWrapper defaultServer] queryStudents:nil success:^(NSArray *array) {
            pSelf.studentArray = [NSMutableArray arrayWithArray:array];
            [pSelf refreshUI];
            pSelf.shouldFetchData = NO;
        } failure:^(HCErrorMessage *error) {
        }];
    }
}

- (void)refreshUI
{
    [self.studentsTableView reloadData];
}
@end

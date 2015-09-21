//
//  ApplyInfoViewController.m
//  Joy
//
//  Created by gejw on 15/8/18.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

#import "ApplyInfoViewController.h"
#import "UserInfoViewController.h"
#import "EntryTableView.h"
#define curPageIndex 0

@interface ApplyInfoViewController() {
    EntryTableView *_tableView;
    NSMutableArray *_datas;
    NSArray *_costCenteDatas;
    NSArray *_composes;
    JSysData *_costCenter;
    JSysData *_compose;
}

@end

@implementation ApplyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"入职管理";
    UIBarButtonItem *stepItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"step1"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = stepItem;
    self.view.backgroundColor = [UIColor whiteColor];
    _costCenteDatas = @[];
    _composes = @[];
    _datas = [NSMutableArray array];

    
    _tableView = [[EntryTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 60)];
    [self.view addSubview:_tableView];
    [self loadSaveBar];
    
    [self getCostCenteDatas];
}

- (void)getCostCenteDatas {
    __weak ApplyInfoViewController *weakVC = self;
    // 获取部门
    [[JAFHTTPClient shared] getSysDataWithType:@"CostCenterno" parentId:-1 success:^(NSArray *sysDatas) {
        _costCenteDatas = sysDatas;
        
        [[JAFHTTPClient shared] getSysDataWithType:@"Compos" parentId:-1 success:^(NSArray *sysDatas) {
            _composes = sysDatas;
            [weakVC getPersonInfo];
        } failure:^(NSString *msg) {
        }];
    } failure:^(NSString *msg) {

    }];
}

- (NSString *)costCenternoName:(NSString *)sysValue {
    for (JSysData *data in _costCenteDatas) {
        if ([data.SysValue isEqualToString:sysValue]) {
            return data.SysKeyName;
        }
    }
    return @"请选择";
}

- (NSString *)composName:(NSString *)sysValue {
    for (JSysData *data in _composes) {
        if ([data.SysValue isEqualToString:sysValue]) {
            return data.SysKeyName;
        }
    }
    return @"请选择";
}


- (void)getPersonInfo {
    // 获取个人信息
    __weak ApplyInfoViewController *weakVC = self;
    [[JAFHTTPClient shared] getPersonInfo:^(JPersonInfo *personInfo) {
        [JPersonInfo setPerson:personInfo];
        [weakVC updateInfo];
        
        NSInteger pageIndex = [self pageIndex];
        if (pageIndex > curPageIndex) {
            // 跳转
            [weakVC nextPage:NO];
        }
    } failure:^(NSString *msg) {
        
    }];
}

- (void)updateInfo {
    
    [_datas removeAllObjects];
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"应聘部门 : " labelImage:[UIImage imageNamed:@"entry_department"] updateHandler:^(UIButton *button) {
            [button setTitle:[self costCenternoName:[JPersonInfo person].ComDep] forState:UIControlStateNormal];
        } clickHandler:^{
//            [ActionSheetStringPicker showPickerWithTitle:@"选择部门"
//                                                    rows:_costCenteDatas
//                                        initialSelection:0
//                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//                                                   _costCenter = [_costCenteDatas objectAtIndex:selectedIndex];
//                                                   _compose = nil;
//                                                   [JPersonInfo person].ComDep = _costCenter.SysValue;
//                                                   [JPersonInfo person].ComPos = nil;
//                                                   [_tableView reloadData];
//                                               }
//                                             cancelBlock:^(ActionSheetStringPicker *picker) {
//                                                 NSLog(@"Block Picker Canceled");
//                                             }
//                                                  origin:self.view];

        }];
        [_datas addObject:cell];
    }
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"应聘职位 : " labelImage:[UIImage imageNamed:@"entry_position"] updateHandler:^(UIButton *button) {
            [button setTitle:[self composName:[JPersonInfo person].ComPos] forState:UIControlStateNormal];
        } clickHandler:^{
//            if (_composes.count == 0) {
//                return;
//            }
//            [ActionSheetStringPicker showPickerWithTitle:@"选择职位"
//                                                    rows:_composes
//                                        initialSelection:0
//                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//                                                   if (selectedIndex >= _composes.count) {
//                                                       return;
//                                                   }
//                                                   _compose = [_composes objectAtIndex:selectedIndex];;
//                                                   [JPersonInfo person].ComPos = _compose.SysValue;
//                                                   [_tableView reloadData];
//                                               }
//                                             cancelBlock:^(ActionSheetStringPicker *picker) {
//                                                 NSLog(@"Block Picker Canceled");
//                                             }
//                                                  origin:self.view];

        }];
        [_datas addObject:cell];
    }
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"到岗日期 : " labelImage:[UIImage imageNamed:@"entry_date"] updateHandler:^(UIButton *button) {
            [button setTitle:[JPersonInfo person].ComEntryDate forState:UIControlStateNormal];
        } clickHandler:^{
            [ActionSheetDatePicker showPickerWithTitle:@"到岗日期" datePickerMode:UIDatePickerModeDate selectedDate:[[JPersonInfo person].ComEntryDate getCorrectDateDate] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                [JPersonInfo person].ComEntryDate = [selectedDate toDateString];
                [_tableView reloadData];
            } cancelBlock:^(ActionSheetDatePicker *picker) {
                NSLog(@"Block Picker Canceled");
            } origin:self.view];
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"现  居  地 : " labelImage:[UIImage imageNamed:@"entry_nowaddress"] updateHandler:^(UITextField *textFiled) {
            textFiled.placeholder = @"必填";
            textFiled.text = [JPersonInfo person].Address;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].Address = string;
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"联系电话 : " labelImage:[UIImage imageNamed:@"entry_contactway"] updateHandler:^(UITextField *textFiled) {
            textFiled.placeholder = @"必填";
            textFiled.text = [JPersonInfo person].Mobile;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].Mobile = string;
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"紧急联系人 : " labelImage:[UIImage imageNamed:@"entry_emergencyperson"] updateHandler:^(UITextField *textFiled) {
            textFiled.placeholder = @"必填";
            textFiled.text = [JPersonInfo person].UrgentContact;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].UrgentContact = string;
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"紧急联系方式 : " labelImage:[UIImage imageNamed:@"entry_emergencycontact"] updateHandler:^(UITextField *textFiled) {
            textFiled.placeholder = @"必填";
            textFiled.text = [JPersonInfo person].UrgentMobile;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].UrgentMobile = string;
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"户口所在地 : " labelImage:[UIImage imageNamed:@"entry_houschold"] updateHandler:^(UITextField *textFiled) {
            textFiled.placeholder = @"必填";
            textFiled.text = [JPersonInfo person].Residence;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].Residence = string;
        }];
        [_datas addObject:cell];
    }
    _tableView.datas = _datas;
}

- (void)save:(id)sender {
    if ([self check]) {
        [self savePageIndex:curPageIndex];
        [super save:self];
    }
}

- (void)next:(id)sender {
    if ([self check]) {
        [self nextPage:YES];
    }
}


- (BOOL)check {
    
    if (![JPersonInfo person].Address || [[JPersonInfo person].Address isEqualToString:@""]) {
        [self.view makeToast:@"请输入现居地"];
        return false;
    }
    if (![JPersonInfo person].Mobile || [[JPersonInfo person].Mobile isEqualToString:@""]) {
        [self.view makeToast:@"请输入联系电话"];
        return false;
    }
    if (![[JPersonInfo person].Mobile isValidPhoneNum]) {
        [self.view makeToast:@"联系电话格式错误！"];
        return false;
    }
    if (![JPersonInfo person].UrgentContact || [[JPersonInfo person].UrgentContact isEqualToString:@""]) {
        [self.view makeToast:@"请输入紧急联系人"];
        return false;
    }
    if (![JPersonInfo person].UrgentMobile || [[JPersonInfo person].UrgentMobile isEqualToString:@""]) {
        [self.view makeToast:@"请输入紧急联系方式"];
        return false;
    }
    if (![[JPersonInfo person].UrgentMobile isValidPhoneNum]) {
        [self.view makeToast:@"紧急联系方式格式错误！"];
        return false;
    }
    if (![JPersonInfo person].Residence || [[JPersonInfo person].Residence isEqualToString:@""]) {
        [self.view makeToast:@"请输入户口所在地"];
        return false;
    }
    return true;
}

- (void)nextPage:(BOOL)animated {
    UserInfoViewController *vc = [[UserInfoViewController alloc] init];
    vc.title = @"个人信息";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    UIBarButtonItem *stepItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"step2"] style:UIBarButtonItemStylePlain target:nil action:nil];
    vc.navigationItem.rightBarButtonItem = stepItem;
    [self.navigationController pushViewController:vc animated:animated];
}


@end

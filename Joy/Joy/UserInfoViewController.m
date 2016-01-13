//
//  UserInfoViewController.m
//  Joy
//
//  Created by gejw on 15/8/18.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

#import "UserInfoViewController.h"
#import "EntryTableView.h"
#import "CardInfoViewController.h"
#define curPageIndex 2

@interface UserInfoViewController () {
    EntryTableView *_tableView;
    NSMutableArray *_datas;
    
    NSMutableArray *_banks;
    NSMutableArray *_nations;
    NSMutableArray *_maritals;
    NSMutableArray *_politicals;
    NSMutableArray *_healths;
    NSMutableArray *_cultural;
    NSMutableArray *_provinces;
}

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _banks = [NSMutableArray array];
    _nations = [NSMutableArray array];
    _maritals = [NSMutableArray array];
    _politicals = [NSMutableArray array];
    _healths = [NSMutableArray array];
    _cultural = [NSMutableArray array];
    _provinces = [NSMutableArray array];
    
    [[JAFHTTPClient shared] getComGroupSysData:^(NSArray *banks, NSArray *nations, NSArray *maritals, NSArray *politicals, NSArray *healths, NSArray *cultural, NSArray *provinces, NSError *error) {
        if (error) {
            return;
        }
        _banks = [NSMutableArray arrayWithArray:banks];
        _nations = [NSMutableArray arrayWithArray:nations];
        _maritals = [NSMutableArray arrayWithArray:maritals];
        _politicals = [NSMutableArray arrayWithArray:politicals];
        _healths = [NSMutableArray arrayWithArray:healths];
        _cultural = [NSMutableArray arrayWithArray:cultural];
        _provinces = [NSMutableArray arrayWithArray:provinces];
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _datas = [NSMutableArray array];
    
    _tableView = [[EntryTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 60)];
    [self.view addSubview:_tableView];
    [self loadSaveBar];

    [self updateInfo];
    
    NSInteger pageIndex = [self pageIndex];
    if (pageIndex > curPageIndex) {
        // 跳转
        [self nextPage:NO];
    } else {
        if (pageIndex > 0)
            [JPersonInfo person].CurrentStep = [JPersonInfo person].CurrentStep - 1000;
    }
}

- (void)updateInfo {
    [_datas removeAllObjects];
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"中  文  名 : " labelImage:[UIImage imageNamed:@"entry_chinesename"] updateHandler:^(UITextField *textFiled) {
            textFiled.placeholder = @"必填";
            textFiled.text = [JPersonInfo person].PersonName;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].PersonName = string;
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"英  文  名 : " labelImage:[UIImage imageNamed:@"entry_englishname"] updateHandler:^(UITextField *textFiled) {
            textFiled.text = [JPersonInfo person].EnglishName;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].EnglishName = string;
        }];
        [_datas addObject:cell];
    }
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"性    别 : " labelImage:[UIImage imageNamed:@"entry_gender"] updateHandler:^(UIButton *button) {
            NSString *gender = [[JPersonInfo person].Gender isEqualToString:@"0"] ? @"男" : @"女";
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setTitle:gender forState:UIControlStateNormal];
        } clickHandler:^{
            [ActionSheetStringPicker showPickerWithTitle:@"选择职位"
                                                    rows:@[@"男", @"女"]
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   [JPersonInfo person].Gender = [NSString stringWithFormat:@"%i", @(selectedIndex).intValue];
                                                   [_tableView reloadData];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:self.view];
            
        }];
        [_datas addObject:cell];
    }
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"民族 : " labelImage:[UIImage imageNamed:@"entry_bankname"] updateHandler:^(UIButton *button) {
            [button setTitle:[JPersonInfo person].Nation forState:UIControlStateNormal];
        } clickHandler:^{
                        if (_nations.count == 0) {
                            return;
                        }
                        [ActionSheetStringPicker showPickerWithTitle:@"民族"
                                                                rows:_nations
                                                    initialSelection:0
                                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                               if (selectedIndex >= _nations.count) {
                                                                   return;
                                                               }
                                                               ComGroupSysData *compose = [_nations objectAtIndex:selectedIndex];
                                                               [JPersonInfo person].Nation = compose.SysKeyName;
                                                               [_tableView reloadData];
                                                           }
                                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                                             NSLog(@"Block Picker Canceled");
                                                         }
                                                              origin:self.view];
            
        }];
        [_datas addObject:cell];
    }
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"籍    贯 : " labelImage:[UIImage imageNamed:@"entry_birthplace"] updateHandler:^(UIButton *button) {
            [button setTitle:[JPersonInfo person].Regions forState:UIControlStateNormal];
        } clickHandler:^{
            if (_provinces.count == 0) {
                return;
            }
            [ActionSheetStringPicker showPickerWithTitle:@"籍贯"
                                                    rows:_provinces
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   if (selectedIndex >= _provinces.count) {
                                                       return;
                                                   }
                                                   ComGroupSysData *compose = [_provinces objectAtIndex:selectedIndex];
                                                   [JPersonInfo person].Regions = compose.SysKeyName;
                                                   [_tableView reloadData];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:self.view];
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"身份证号 : " labelImage:[UIImage imageNamed:@"entry_idno"] updateHandler:^(UITextField *textFiled) {
            textFiled.placeholder = @"必填";
            textFiled.text = [JPersonInfo person].IdNo;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].IdNo = string;
        }];
        [_datas addObject:cell];
    }
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"婚姻状况 : " labelImage:[UIImage imageNamed:@"entry_marital"] updateHandler:^(UIButton *button) {
            [button setTitle:[JPersonInfo person].MaritalStatus forState:UIControlStateNormal];
        } clickHandler:^{
            if (_maritals.count == 0) {
                return;
            }
            [ActionSheetStringPicker showPickerWithTitle:@"婚姻状况"
                                                    rows:_maritals
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   if (selectedIndex >= _maritals.count) {
                                                       return;
                                                   }
                                                   ComGroupSysData *compose = [_maritals objectAtIndex:selectedIndex];
                                                   [JPersonInfo person].MaritalStatus = compose.SysKeyName;
                                                   [_tableView reloadData];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:self.view];

            
        }];
        [_datas addObject:cell];
    }
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"政治面貌 : " labelImage:[UIImage imageNamed:@"entry_political"] updateHandler:^(UIButton *button) {
            [button setTitle:[JPersonInfo person].PoliticalStatus forState:UIControlStateNormal];
        } clickHandler:^{
            if (_politicals.count == 0) {
                return;
            }
            [ActionSheetStringPicker showPickerWithTitle:@"政治面貌"
                                                    rows:_politicals
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   if (selectedIndex >= _politicals.count) {
                                                       return;
                                                   }
                                                   ComGroupSysData *compose = [_politicals objectAtIndex:selectedIndex];
                                                   [JPersonInfo person].PoliticalStatus = compose.SysKeyName;
                                                   [_tableView reloadData];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:self.view];
            
        }];
        [_datas addObject:cell];
    }
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"健康状况 : " labelImage:[UIImage imageNamed:@"entry_health"] updateHandler:^(UIButton *button) {
            [button setTitle:[JPersonInfo person].HealthCondition forState:UIControlStateNormal];
        } clickHandler:^{
            if (_healths.count == 0) {
                return;
            }
            [ActionSheetStringPicker showPickerWithTitle:@"健康状况"
                                                    rows:_healths
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   if (selectedIndex >= _healths.count) {
                                                       return;
                                                   }
                                                   ComGroupSysData *compose = [_healths objectAtIndex:selectedIndex];
                                                   [JPersonInfo person].HealthCondition = compose.SysKeyName;
                                                   [_tableView reloadData];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:self.view];
            
        }];
        [_datas addObject:cell];
    }
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"文化程度 : " labelImage:[UIImage imageNamed:@"entry_culturaldegree"] updateHandler:^(UIButton *button) {
            [button setTitle:[JPersonInfo person].CulturalDegree forState:UIControlStateNormal];
        } clickHandler:^{
            if (_cultural.count == 0) {
                return;
            }
            [ActionSheetStringPicker showPickerWithTitle:@"文化程度"
                                                    rows:_cultural
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   if (selectedIndex >= _cultural.count) {
                                                       return;
                                                   }
                                                   ComGroupSysData *compose = [_cultural objectAtIndex:selectedIndex];
                                                   [JPersonInfo person].CulturalDegree = compose.SysKeyName;
                                                   [_tableView reloadData];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:self.view];
            
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"学历证号 : " labelImage:[UIImage imageNamed:@"entry_degreeno"] updateHandler:^(UITextField *textFiled) {
            textFiled.text = [JPersonInfo person].EducationNo;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].EducationNo = string;
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"专业 : " labelImage:[UIImage imageNamed:@"entry_major"] updateHandler:^(UITextField *textFiled) {
            textFiled.text = [JPersonInfo person].Major;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].Major = string;
        }];
        [_datas addObject:cell];
    }
//    {
//        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"开户银行 : " labelImage:[UIImage imageNamed:@"entry_bankname"] updateHandler:^(UITextField *textFiled) {
//            textFiled.placeholder = @"必填";
//            textFiled.text = [JPersonInfo person].DepositBank;
//        } changeHandler:^(NSString *string) {
//            [JPersonInfo person].DepositBank = string;
//        }];
//        [_datas addObject:cell];
//    }
    {
        ApplyPickerCell *cell = [[ApplyPickerCell alloc] initWithLabelString:@"开户银行 : " labelImage:[UIImage imageNamed:@"entry_bankname"] updateHandler:^(UIButton *button) {
            [button setTitle:[JPersonInfo person].DepositBank forState:UIControlStateNormal];
        } clickHandler:^{
            if (_banks.count == 0) {
                return;
            }
            [ActionSheetStringPicker showPickerWithTitle:@"开户银行"
                                                    rows:_banks
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   if (selectedIndex >= _banks.count) {
                                                       return;
                                                   }
                                                   ComGroupSysData *compose = [_banks objectAtIndex:selectedIndex];
                                                   [JPersonInfo person].DepositBank = compose.SysKeyName;
                                                   [_tableView reloadData];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:self.view];
            
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"银行账号 : " labelImage:[UIImage imageNamed:@"entry_bankno"] updateHandler:^(UITextField *textFiled) {
            textFiled.text = [JPersonInfo person].DepositCardNo;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].DepositCardNo = string;
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"公积金编号 : " labelImage:[UIImage imageNamed:@"entry_accumulationno"] updateHandler:^(UITextField *textFiled) {
            textFiled.text = [JPersonInfo person].AccumFund;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].AccumFund = string;
        }];
        [_datas addObject:cell];
    }
    {
        ApplyTextFiledCell *cell = [[ApplyTextFiledCell alloc] initWithLabelString:@"社保账户 : " labelImage:[UIImage imageNamed:@"entry_social"] updateHandler:^(UITextField *textFiled) {
            textFiled.text = [JPersonInfo person].SocialSecurityNo;
        } changeHandler:^(NSString *string) {
            [JPersonInfo person].SocialSecurityNo = string;
        }];
        [_datas addObject:cell];
    }
    _tableView.datas = _datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save:(id)sender {
    [self savePageIndex:curPageIndex];
    [super save:self];
}

- (void)next:(id)sender {
    if ([self check]) {
        [self nextPage:YES];

    }}

- (BOOL)check {
    if (![JPersonInfo person].PersonName || [[JPersonInfo person].PersonName isEqualToString:@""]) {
        [self.view makeToast:@"请输入中文名"];
        return false;
    }
    if (![JPersonInfo person].Regions || [[JPersonInfo person].Regions isEqualToString:@""]) {
        [self.view makeToast:@"请输入籍贯"];
        return false;
    }
    if (![JPersonInfo person].IdNo || [[JPersonInfo person].IdNo isEqualToString:@""]) {
        [self.view makeToast:@"请输入身份证号"];
        return false;
    }
    return true;
}

- (void)nextPage:(BOOL)animated {
    CardInfoViewController *vc = [[CardInfoViewController alloc] init];
    vc.title = @"证件信息";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    UIBarButtonItem *stepItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"step3"] style:UIBarButtonItemStylePlain target:nil action:nil];
    vc.navigationItem.rightBarButtonItem = stepItem;
    [self.navigationController pushViewController:vc animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

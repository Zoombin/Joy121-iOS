//
//  CompanyViewController.m
//  Joy
//
//  Created by 颜超 on 14-4-16.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "CompanyViewController.h"
#import "JoyViewController.h"
#import "ModuleViewController.h"
#import "SurveyViewController.h"
#import "Module.h"
#import "ModuleCollectionViewCell.h"
#import "LogoStoreViewController.h"
#import "UIColor+Hex.h"
#import "ContactsTableViewController.h"
#import "DepotTableViewController.h"
#import "PayRollViewController.h"
#import "PerformanceViewController.h"
#import "ApplyInfoViewController.h"

#define kReuseIdentifier @"Cell"

@interface CompanyViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (readwrite) NSMutableArray *colors;
@property (readwrite) NSArray *modules;
@property (readwrite) UIAlertView *contactsAlertView;

@end

@implementation CompanyViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.title = NSLocalizedString(@"公司门户", nil);
        UIImage *normalImage = [UIImage imageNamed:@"Company"];
        UIImage *selectedImage = [UIImage imageNamed:@"CompanyHighlighted"];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:normalImage selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ModuleCollectionViewCell class] forCellWithReuseIdentifier:kReuseIdentifier];
    
    _colors = [NSMutableArray array];
    [_colors addObject:[UIColor hexRGB:0x2e8aef]];
    [_colors addObject:[UIColor hexRGB:0x474cfd]];
    [_colors addObject:[UIColor hexRGB:0x5e3cba]];
    [_colors addObject:[UIColor hexRGB:0x7ab102]];
    [_colors addObject:[UIColor hexRGB:0x01a31c]];
    [_colors addObject:[UIColor hexRGB:0x13771c]];
    [_colors addObject:[UIColor hexRGB:0xdfb700]];
    [_colors addObject:[UIColor hexRGB:0xf7a211]];
    [_colors addObject:[UIColor hexRGB:0xfe8649]];
    
    [[JAFHTTPClient shared] getModulesByCompany:^(NSArray *multiAttributes, NSError *error) {
        if (!error) {
            _modules = [Module multiWithAttributesArray:multiAttributes];
            [self.collectionView reloadData];
        } else {
            [self displayHUDTitle:NSLocalizedString(@"错误", nil) message:error.description];
        }
    }];
    
    if ([[JAFHTTPClient shared] companyLogoURLString]) {
        self.navigationItem.titleView = [UIView companyTitleViewWithURLString:[[JAFHTTPClient shared] companyLogoURLString]];
    } else {
        self.title = [[JAFHTTPClient shared] companyTitle];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JPersonInfo setPerson:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
+ (UICollectionViewFlowLayout *)flowLayout;
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(30, 26, 20, 26);
    flowLayout.collectionView.backgroundColor = [UIColor blackColor];
    return flowLayout;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _modules.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModuleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    Module *module = _modules[indexPath.row];
    cell.module = module;
    cell.icon = [module icon];
    
    cell.backgroundColor = _colors[indexPath.row % _colors.count];
    cell.alpha=0.8; //设置模块透明度
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [ModuleCollectionViewCell size];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Module *module = _modules[indexPath.row];
    Class class = [module childViewControllerClass];
    BOOL hideBottomBar = YES;
    UIViewController *controller = [[UIViewController alloc] init];
    if (class == [ModuleViewController class]) {
        ModuleViewController *moduleViewController = [[ModuleViewController alloc] initWithStyle:UITableViewStyleGrouped];
        moduleViewController.module = _modules[indexPath.row];
        controller = moduleViewController;
    } else if (class == [SurveyViewController class]) {
        SurveyViewController *surveyViewController = [[SurveyViewController alloc] initWithStyle:UITableViewStylePlain];
        controller = surveyViewController;
    } else if (class == [JoyViewController class]) {
        JoyViewController *joyViewController = [[JoyViewController alloc] initWithStyle:UITableViewStyleGrouped];
        controller = joyViewController;
        hideBottomBar = NO;
    } else if (class == [LogoStoreViewController class]) {
        LogoStoreViewController *logoStore = [[LogoStoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
        controller = logoStore;
        hideBottomBar = NO;
    } else if (class == [ContactsTableViewController class]) {
        //self.contactsAlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入账户密码查看通讯录。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //self.contactsAlertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        //[self.contactsAlertView show];
        //controller = nil;
        ContactsTableViewController *contactsTableViewController = [[ContactsTableViewController alloc] init];
        controller = contactsTableViewController;
        hideBottomBar = YES;
    } else if (class == [DepotTableViewController class]) {
        DepotTableViewController *depotViewController = [[DepotTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        controller = depotViewController;
        hideBottomBar = YES;
    } else if(class == [PayRollViewController class]) {
        //UIAlertView *inputPassWord = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入账户密码查看工资单。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //inputPassWord.alertViewStyle = UIAlertViewStyleSecureTextInput;
        //[inputPassWord show];
        PayRollViewController *payRollViewController = [[PayRollViewController alloc] initWithStyle:UITableViewStyleGrouped];
		controller = payRollViewController;
        hideBottomBar = YES;
	} else if (class == [PerformanceViewController class]) {
		PerformanceViewController *performanceViewController = [[PerformanceViewController alloc] init];
		performanceViewController.isEncourage = [module moduleType] == CompanyModuleTypeEncourage;
		controller = performanceViewController;
    } else {
        controller = [[class alloc] initWithNibName:nil bundle:nil];
    }
    
    controller.hidesBottomBarWhenPushed = hideBottomBar;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *textValue = [alertView textFieldAtIndex:0];
    NSString *pwdValue = [[JAFHTTPClient shared]md5WithString:textValue.text];
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView == _contactsAlertView) {
            if ([pwdValue isEqualToString:[[JAFHTTPClient shared] passWord]]) {
                ContactsTableViewController *contactsTableViewController = [[ContactsTableViewController alloc] init];
                contactsTableViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:contactsTableViewController animated:YES];
            }
            else {
                [self displayHUDTitle:@"密码错误" message:nil duration:1.5];
            }
        } else {
            if ([pwdValue isEqualToString:[[JAFHTTPClient shared] passWord]]) {
                PayRollViewController *payrollViewController = [[PayRollViewController alloc] initWithStyle:UITableViewStyleGrouped];
                payrollViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:payrollViewController animated:YES];
            }
            else{
                [self displayHUDTitle:@"密码错误" message:nil duration:1.5];
            }
        }
    }
}

@end

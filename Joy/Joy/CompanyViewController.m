//
//  CompanyViewController.m
//  Joy
//
//  Created by 颜超 on 14-4-16.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "CompanyViewController.h"
#import "JoyViewController.h"

@interface CompanyViewController ()

@end

@implementation CompanyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"welfare_icon_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"welfare_icon"]];
         self.tabBarItem.title = @"公司门户";
    }
    return self;
}

- (IBAction)joyClick:(id)sender
{
    JoyViewController *viewController = [[JoyViewController alloc] initWithNibName:@"JoyViewController" bundle:nil];
    [viewController addBackBtn];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTitleIconWithTitle:@"公司门户"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
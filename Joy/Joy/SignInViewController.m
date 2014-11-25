//
//  SignInViewController.m
//  Joy
//
//  Created by 颜超 on 14-4-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"
#import "JUser.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)checkBoxButtonClick:(id)sender
{
    _checkBoxButton.selected = !_checkBoxButton.selected;
}

- (IBAction)signInButtonClick:(id)sender
{
	//TODO: for test
	_userNameTextField.text = @"320586198312312125";
	_passwordTextField.text = @"312125";
	
//	_userNameTextField.text = @"310225198112162465";
//	_passwordTextField.text = @"121";
	
//	_userNameTextField.text = @"310101199101281557";
//	_passwordTextField.text = @"281557";
	
//	_userNameTextField.text = @"31010319760607002X";
//	_passwordTextField.text = @"07002X";

    [self hidenAllKeyBoard];
    if ([_userNameTextField.text areAllCharactersSpace] || _userNameTextField.text == nil) {
        [self displayHUDTitle:nil message:@"请输入用户名!"];
        return;
    }
    if ([_passwordTextField.text areAllCharactersSpace] || _passwordTextField.text == nil) {
        [self displayHUDTitle:nil message:@"请输入密码!"];
        return;
    }

    [self displayHUD:@"登录中..."];
    [[JAFHTTPClient shared] signIn:_userNameTextField.text password:_passwordTextField.text withBlock:^(NSDictionary *result, NSError *error) {
        if (result[@"retobj"] && [result[@"retobj"] isKindOfClass:[NSDictionary class]]) {
			JUser *user = [[JUser alloc] initWithAttributes:result[@"retobj"]];
            [[JAFHTTPClient shared] saveUserName:user.userName];
            [[JAFHTTPClient shared] saveCompanyName:user.companyShort];
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate addTabBar];
            [self hideHUD:YES];
        } else {
			[self displayHUDTitle:@"出错了" message:error.localizedDescription];
        }
    }];
}


- (IBAction)registerButtonClick:(id)sender
{
    [self displayHUDTitle:nil message:@"本系统暂不开放注册功能!"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTextField) {
        [_passwordTextField becomeFirstResponder];
    } else {
        [self signInButtonClick:nil];
    }
    return YES;
}

- (void)hidenAllKeyBoard
{
    [_userNameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

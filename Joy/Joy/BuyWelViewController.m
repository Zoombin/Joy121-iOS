//
//  BuyWelViewController.m
//  Joy
//
//  Created by 颜超 on 14-4-10.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "BuyWelViewController.h"

@interface BuyWelViewController ()

@end

@implementation BuyWelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"收货信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyBoard)];
    [self.view addGestureRecognizer:tapGesture];
    
    [_scrollView setContentSize:CGSizeMake(320, 568)];
    [self loadUserInfo];
    _goodsLabel.text =  _info.welName;
    _describeLabel.text = _info.longDescribe;
    _timesLabel.text = [NSString stringWithFormat:@"X %@", @(_times)];
    _priceLabel.text = [NSString stringWithFormat:@"%@   %@", _info.welName,_info.score];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%@", @([_info.score integerValue] * _times)];
}

- (void)hidenKeyBoard
{
    [_bzTextView resignFirstResponder];
}

- (void)loadUserInfo
{
    [self displayHUD:@"加载中..."];
    [[JAFHTTPClient shared] userInfoWithBlock:^(NSDictionary *attributes, NSError *error) {
        [self hideHUD:YES];
		if (!error) {
			_user = [[JUser alloc] initWithAttributes:attributes];
            _receiverLabel.text = _user.realName;
            _addressLabel.text = _user.address;
            _phoneLabel.text = _user.telephone;
            _leftMoneyLabel.text = [NSString stringWithFormat:@"%@", _user.score];
		} else {
            [self displayHUDTitle:nil message:NETWORK_ERROR];
		}
    }];
}

- (IBAction)confirmBZButtonClick:(id)sender
{
    [_confirmButton setHidden:YES];
    [_bzTextView setEditable:NO];
}

- (IBAction)submitButtonClick:(id)sender
{
    if ([_user.score integerValue] < [_info.score integerValue]) {
        [self displayHUDTitle:nil message:@"余额不足!"];
        return;
    }
    [self displayHUD:@"提交订单中..."];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

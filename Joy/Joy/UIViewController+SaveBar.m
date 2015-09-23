//
//  UIViewController+SaveBar.m
//  Joy
//
//  Created by gejw on 15/9/8.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

#import "UIViewController+SaveBar.h"

@implementation UIViewController (SaveBar)

- (void)loadSaveBar {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
    [self.view addSubview:footerView];
    
    float emptyWidth = (footerView.width - 240) / 3;
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(emptyWidth, 10, 120, 40)];
    [saveButton setTitle:@"保    存" forState:UIControlStateNormal];
    [saveButton setTintColor:[UIColor whiteColor]];
    [saveButton setBackgroundImage:[[UIColor colorWithRed:0.54 green:0.6 blue:0.64 alpha:1] toImage] forState:UIControlStateNormal];
    saveButton.layer.borderColor = [UIColor colorWithRed:0.67 green:0.73 blue:0.76 alpha:1].CGColor;
    saveButton.layer.borderWidth = 4;
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:saveButton];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(emptyWidth * 2 + 120, 10, 120, 40)];
    [nextButton setTitle:@"下一步 >" forState:UIControlStateNormal];
    [nextButton setTintColor:[UIColor whiteColor]];
    [nextButton setBackgroundImage:[[UIColor colorWithRed:0.38 green:0.61 blue:0.35 alpha:1] toImage] forState:UIControlStateNormal];
    nextButton.layer.borderColor = [UIColor colorWithRed:0.51 green:0.71 blue:0.48 alpha:1].CGColor;
    nextButton.layer.borderWidth = 4;
    [nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextButton];
}

- (void)save:(id)sender {
    [[JAFHTTPClient shared] updatePersonInfo:[JPersonInfo person] success:^{
        [self.view makeToast:@"保存成功"];
    } failure:^(NSString *msg) {
        [self.view makeToast:msg];
    }];
}

- (void)submit:(id)sender {
    [JPersonInfo person].Submited = 1;
    [[JAFHTTPClient shared] updatePersonInfo:[JPersonInfo person] success:^{
        [self.view makeToast:@"提交成功"];
    } failure:^(NSString *msg) {
        [self.view makeToast:msg];
    }];
}

- (void)savePageIndex:(NSInteger)pageIndex {
    [JPersonInfo person].CurrentStep = pageIndex;
}

- (NSInteger)pageIndex {
    return [JPersonInfo person].CurrentStep;
}

@end

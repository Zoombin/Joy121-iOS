//
//  HobbyViewController.m
//  Joy
//
//  Created by gejw on 15/8/18.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

#import "HobbyViewController.h"
#define curPageIndex 6

@interface HobbyViewController () {
    NSMutableDictionary *_viewDict;
    NSMutableArray *_selectDatas;
    NSArray *allDatas;
}

@end

@implementation HobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    allDatas = @[@"打篮球", @"踢足球", @"打羽毛球",
                 @"打乒乓球", @"爬山", @"唱歌",
                 @"看书", @"烹饪", @"画画",
                 @"舞蹈", @"旅游", @"摄影", ];
    JPersonInfo *persinInfo = [JPersonInfo person];
    _viewDict = [NSMutableDictionary dictionary];
    if (![JPersonInfo person].Interesting) {
        [JPersonInfo person].Interesting = @"";
    }
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:[persinInfo.Interesting dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    _selectDatas = [NSMutableArray arrayWithArray:arr];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, winSize.width - 40, 20)];
    label.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"选择您的兴趣爱好并画上爱心:";
    [self.view addSubview:label];
    
    int width = (winSize.width - 15 * 4) / 3;
    int lastY = 0;
    for (int i = 0; i < allDatas.count; i++) {
        int x = i % 3;
        int y = i / 3;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 * (x + 1) + width * x, y * 40 + 15 * (y + 1) + label.bottom + 20, width, 40)];
        [button setTitle:[allDatas objectAtIndex:i] forState:UIControlStateNormal];
        [button setTintColor:[UIColor whiteColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"entry_uncheck"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"entry_checked"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [_viewDict setObject:button forKey:[allDatas objectAtIndex:i]];
        lastY = button.y + 40;
    }
    [self refreshState];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + 20, self.view.width, 60)];
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
    [nextButton setTitle:@"提    交" forState:UIControlStateNormal];
    [nextButton setTintColor:[UIColor whiteColor]];
    [nextButton setBackgroundImage:[[UIColor colorWithRed:0.97 green:0.51 blue:0.51 alpha:1] toImage] forState:UIControlStateNormal];
    nextButton.layer.borderColor = [UIColor colorWithRed:0.94 green:0.69 blue:0.69 alpha:1].CGColor;
    nextButton.layer.borderWidth = 4;
    [nextButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickButton:(UIButton *)button {
    NSString *title = button.titleLabel.text;
    if ([_selectDatas containsObject:title]) {
        [_selectDatas removeObject:title];
    } else {
        [_selectDatas addObject:title];
    }
    [self refreshState];
}

- (void)save:(id)sender {
    [self savePageIndex:curPageIndex];
    [super save:self];
}


- (void)refreshState {
    for (NSString *title in allDatas) {
        [[_viewDict objectForKey:title] setSelected:[_selectDatas containsObject:title]];
    }
    [JPersonInfo person].Interesting = [_selectDatas JSONString];
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

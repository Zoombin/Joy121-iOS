//
//  ExperienceViewController.m
//  Joy
//
//  Created by gejw on 15/8/18.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

#import "ExperienceViewController.h"
#import "EntryTableView.h"
#import "FamilyInfoViewController.h"
#define curPageIndex 3

@protocol JExperienceCellDelegate <NSObject>

- (void)textFieldDidChange:(id)data index:(int)index type:(int)type;

@end

@interface JExperienceCell : UITableViewCell {
    UITextField *sDateLabel;
    UITextField *eDateLabel;
    UITextField *birthdayLabel;
    UITextField *addressLabel;
    UITextField *shipLabel;
    NSArray *_labels;
}

@property (nonatomic, assign) id<JExperienceCellDelegate> delegate;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) id data;

@end

@implementation JExperienceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(50, 24, 4, 102)];
        colorView.tag = 9999;
        [self.contentView addSubview:colorView];
        _labels = @[@[@"开始时间：", @"结束时间：", @"学校：", @"专业：", @"收获："],
                    @[@"开始时间：", @"结束时间：", @"公司：", @"职位：", @"收获："]];
        
        sDateLabel = [[UITextField alloc] initWithFrame:CGRectMake(60, 20, winSize.width - 120, 20)];
        sDateLabel.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
        sDateLabel.font = [UIFont systemFontOfSize:13];
        sDateLabel.enabled = NO;
        sDateLabel.tag = 10000;
        [sDateLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:sDateLabel];
        [sDateLabel loadLine];
        UIButton *button = [[UIButton alloc] initWithFrame:sDateLabel.frame];
        [button addTarget:self action:@selector(selectSDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        eDateLabel = [[UITextField alloc] initWithFrame:CGRectMake(60, sDateLabel.bottom + 2, winSize.width - 120, 20)];
        eDateLabel.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
        eDateLabel.font = [UIFont systemFontOfSize:13];
        eDateLabel.enabled = NO;
        eDateLabel.tag = 10000;
        [eDateLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:eDateLabel];
        [eDateLabel loadLine];
        button = [[UIButton alloc] initWithFrame:eDateLabel.frame];
        [button addTarget:self action:@selector(selectEDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        birthdayLabel = [[UITextField alloc] initWithFrame:CGRectMake(60, eDateLabel.bottom + 2, winSize.width - 120, 20)];
        birthdayLabel.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
        birthdayLabel.font = [UIFont systemFontOfSize:13];
        birthdayLabel.tag = 10001;
        [birthdayLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:birthdayLabel];
        [birthdayLabel loadLine];
        
        
        addressLabel = [[UITextField alloc] initWithFrame:CGRectMake(60, birthdayLabel.bottom + 2, winSize.width - 120, 20)];
        addressLabel.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
        addressLabel.font = [UIFont systemFontOfSize:13];
        addressLabel.tag = 10002;
        [addressLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:addressLabel];
        [addressLabel loadLine];
        
        
        shipLabel = [[UITextField alloc] initWithFrame:CGRectMake(60, addressLabel.bottom + 2, winSize.width - 120, 20)];
        shipLabel.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
        shipLabel.font = [UIFont systemFontOfSize:13];
        shipLabel.tag = 10003;
        [shipLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:shipLabel];
        [shipLabel loadLine];
    }
    return self;
}

- (void)selectSDate:(id)sender {
    __weak JExperienceCell *cell = self;
    [ActionSheetDatePicker showPickerWithTitle:@"选择日期" datePickerMode:UIDatePickerModeDate selectedDate:[[sDateLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:0] withString:@""] toDate] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        sDateLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:0], [selectedDate toDateString]];
        [cell textFieldDidChange:sDateLabel];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:self];
}


- (void)selectEDate:(id)sender {
    __weak JExperienceCell *cell = self;
    [ActionSheetDatePicker showPickerWithTitle:@"选择日期" datePickerMode:UIDatePickerModeDate selectedDate:[[eDateLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:1] withString:@""] toDate] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        eDateLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:1], [selectedDate toDateString]];
        [cell textFieldDidChange:eDateLabel];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:self];
}

- (void)setData:(id)data {
    _data = data;
    if (_type == 0) {
        sDateLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:0], ((JLearning *)_data).SDate];
        eDateLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:1], ((JLearning *)_data).EDate];
        birthdayLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:2], ((JLearning *)_data).School];
        addressLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:3], ((JLearning *)_data).Profession];
        shipLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:4], ((JLearning *)_data).Achievement];
    } else {
        sDateLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:0], ((JJob *)_data).SDate];
        eDateLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:1], ((JLearning *)_data).EDate];
        birthdayLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:2], ((JJob *)_data).Company];
        addressLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:3], ((JJob *)_data).Position];
        shipLabel.text = [NSString stringWithFormat:@"%@%@", [[_labels objectAtIndex:_type] objectAtIndex:4], ((JJob *)_data).Achievement];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (_type == 0) {
        ((JLearning *)_data).SDate = [sDateLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:0] withString:@""];
        ((JLearning *)_data).EDate = [eDateLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:1] withString:@""];
        ((JLearning *)_data).School = [birthdayLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:2] withString:@""];
        ((JLearning *)_data).Profession = [addressLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:3] withString:@""];
        ((JLearning *)_data).Achievement = [shipLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:4] withString:@""];
    } else {
        ((JLearning *)_data).SDate = [sDateLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:0] withString:@""];
        ((JLearning *)_data).EDate = [eDateLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:1] withString:@""];
        ((JJob *)_data).Company = [birthdayLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:2] withString:@""];
        ((JJob *)_data).Position = [addressLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:3] withString:@""];
        ((JJob *)_data).Achievement = [shipLabel.text stringByReplacingOccurrencesOfString:[[_labels objectAtIndex:_type] objectAtIndex:4] withString:@""];
    }
    
    if (_delegate) {
        [_delegate textFieldDidChange:_data index:_index type:_type];
    }
}

@end



@interface ExperienceViewController () <UITableViewDelegate, UITableViewDataSource, JExperienceCellDelegate> {
    UITableView *_tableView;
    int _selectType;
    JExperiences *_experiences;
    NSMutableArray *_learns;
    NSMutableArray *_jobs;
    NSArray *_colors;
    UIImageView *_learnTriangleImageView;
    UIImageView *_jobTriangleImageView;
}

@end

@implementation ExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _experiences = [JExperiences objectWithKeyValues:[JPersonInfo person].Experiences];
    _learns = [NSMutableArray arrayWithArray:_experiences.Learning];
    _jobs = [NSMutableArray arrayWithArray:_experiences.Job];
    _selectType = 0;
    _colors = @[[UIColor colorWithRed:1 green:0.88 blue:0.53 alpha:1],
                [UIColor colorWithRed:0.53 green:0.72 blue:0.5 alpha:1],
                [UIColor colorWithRed:0.44 green:0.7 blue:0.88 alpha:1],
                [UIColor colorWithRed:0.32 green:0.32 blue:0.45 alpha:1]];
    
    UIImage *triangleImage = [UIImage imageNamed:@"triangle"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight(self), self.view.width, 40)];
    [self.view addSubview:headerView];
    UIButton *learnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerView.width / 2, headerView.height)];
    learnButton.backgroundColor = [UIColor colorWithRed:0.44 green:0.7 blue:0.88 alpha:1];
    [learnButton setTitle:@"学习经历" forState:UIControlStateNormal];
    [learnButton addTarget:self action:@selector(clickLearn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:learnButton];
    _learnTriangleImageView = [[UIImageView alloc] initWithImage:triangleImage];
    _learnTriangleImageView.frame = CGRectMake((learnButton.width - _learnTriangleImageView.width) / 2,
                                               learnButton.height - _learnTriangleImageView.height,
                                               _learnTriangleImageView.width,
                                               _learnTriangleImageView.height);
    _learnTriangleImageView.tag = 10000;
    [learnButton addSubview:_learnTriangleImageView];
    
    UIButton *jobButton = [[UIButton alloc] initWithFrame:CGRectMake(learnButton.right, 0, headerView.width / 2, headerView.height)];
    jobButton.backgroundColor = [UIColor colorWithRed:0.53 green:0.72 blue:0.5 alpha:1];
    [jobButton setTitle:@"工作经验" forState:UIControlStateNormal];
    [jobButton addTarget:self action:@selector(clickJob:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:jobButton];
    _jobTriangleImageView = [[UIImageView alloc] initWithImage:triangleImage];
    _jobTriangleImageView.frame = CGRectMake((jobButton.width - _jobTriangleImageView.width) / 2,
                                             jobButton.height - _jobTriangleImageView.height, _jobTriangleImageView.width, _jobTriangleImageView.height);
    _jobTriangleImageView.tag = 10000;
    _jobTriangleImageView.hidden = YES;
    [jobButton addSubview:_jobTriangleImageView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - 100 - navHeight(self) - tabHeight(self))];
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    _tableView.tableFooterView = tableFooterView;
    
    float emptyWidth = (tableFooterView.width - 120) / 2;
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(emptyWidth, 10, 120, 40)];
    [newButton setTitle:@"添    加" forState:UIControlStateNormal];
    [newButton setTintColor:[UIColor whiteColor]];
    [newButton setBackgroundImage:[[UIColor colorWithRed:1 green:0.72 blue:0.32 alpha:1] toImage] forState:UIControlStateNormal];
    newButton.layer.borderColor = [UIColor colorWithRed:0.98 green:0.84 blue:0.64 alpha:1].CGColor;
    newButton.layer.borderWidth = 4;
    [newButton addTarget:self action:@selector(addnew:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:newButton];
    
    [self loadSaveBar];
    
    NSInteger pageIndex = [self pageIndex];
    if (pageIndex > curPageIndex) {
        // 跳转
        [self nextPage:NO];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickLearn:(id)sender {
    _selectType = 0;
    _learnTriangleImageView.hidden = NO;
    _jobTriangleImageView.hidden = YES;
    [_tableView reloadData];
}

- (void)clickJob:(id)sender {
    _selectType = 1;
    _learnTriangleImageView.hidden = YES;
    _jobTriangleImageView.hidden = NO;
    [_tableView reloadData];
}

- (void)addnew:(id)sender {
    if (_selectType == 0) {
        [_learns addObject:[[JLearning alloc] init]];
    } else if (_selectType == 1) {
        [_jobs addObject:[[JJob alloc] init]];
    }
    [_tableView reloadData];
}

- (void)save:(id)sender {
    [self savePageIndex:curPageIndex];
    [super save:self];
}

- (void)next:(id)sender {
    [self nextPage:YES];
}

- (void)nextPage:(BOOL)animated {
    FamilyInfoViewController *vc = [[FamilyInfoViewController alloc] init];
    vc.title = @"家庭信息";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    UIBarButtonItem *stepItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"step5"] style:UIBarButtonItemStylePlain target:nil action:nil];
    vc.navigationItem.rightBarButtonItem = stepItem;
    [self.navigationController pushViewController:vc animated:animated];
}

#pragma uitableview

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectType == 0) {
        [_learns removeObjectAtIndex:indexPath.row];
        _experiences.Learning = _learns;
    } else if (_selectType == 1) {
        [_jobs removeObjectAtIndex:indexPath.row];
        _experiences.Job = _jobs;
    }
    [JPersonInfo person].Experiences = [_experiences JSONString];
    [tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_selectType == 0) {
        return _learns.count;
    } else {
        return _jobs.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[JExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.type = _selectType;
    cell.index = @(indexPath.row).intValue;
    [cell.contentView viewWithTag:9999].backgroundColor = [_colors objectAtIndex:indexPath.row % 4];
    cell.data = _selectType == 0 ? [_learns objectAtIndex:indexPath.row] : [_jobs objectAtIndex:indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 133;
}

- (void)textFieldDidChange:(id)data index:(int)index type:(int)type {
    if (type == 0) {
        [_learns replaceObjectAtIndex:index withObject:data];
        _experiences.Learning = _learns;
    } else if (type == 1) {
        [_jobs replaceObjectAtIndex:index withObject:data];
        _experiences.Job = _jobs;
    }
    [JPersonInfo person].Experiences = [_experiences JSONString];
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

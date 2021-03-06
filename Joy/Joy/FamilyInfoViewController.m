//
//  FamilyInfoViewController.m
//  Joy
//
//  Created by gejw on 15/8/18.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

#import "FamilyInfoViewController.h"
#import "EntryTableView.h"
#import "HobbyViewController.h"
#define curPageIndex 5

@protocol JFamilyCellDelegate <NSObject>

- (void)textFieldDidChange:(JFamily *)family index:(int)index;

@end

@interface JFamilyCell : UITableViewCell {
    UITextField *nameLabel;
    UITextField *birthdayLabel;
    UITextField *addressLabel;
    UITextField *shipLabel;
}

@property (nonatomic, assign) id<JFamilyCellDelegate> delegate;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) JFamily *family;

@end

@implementation JFamilyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        nameLabel = [[UITextField alloc] initWithFrame:CGRectMake(40, 20, winSize.width - 80, 20)];
        nameLabel.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.tag = 10000;
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
            nameLabel.leftView = label;
            nameLabel.leftViewMode = UITextFieldViewModeAlways;
            label.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
            label.font = [UIFont systemFontOfSize:13];
        }
        [nameLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:nameLabel];
        [nameLabel loadLine];
        
        
        birthdayLabel = [[UITextField alloc] initWithFrame:CGRectMake(40, nameLabel.bottom + 2, winSize.width - 80, 20)];
        birthdayLabel.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
        birthdayLabel.font = [UIFont systemFontOfSize:15];
        birthdayLabel.tag = 10001;
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
            birthdayLabel.leftView = label;
            birthdayLabel.leftViewMode = UITextFieldViewModeAlways;
            label.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
            label.font = [UIFont systemFontOfSize:13];
        }
        birthdayLabel.enabled = NO;
        [birthdayLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:birthdayLabel];
        [birthdayLabel loadLine];
        UIButton *button = [[UIButton alloc] initWithFrame:birthdayLabel.frame];
        [button addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        
        addressLabel = [[UITextField alloc] initWithFrame:CGRectMake(40, birthdayLabel.bottom + 2, winSize.width - 80, 20)];
        addressLabel.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
        addressLabel.font = [UIFont systemFontOfSize:15];
        addressLabel.tag = 10002;
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
            addressLabel.leftView = label;
            addressLabel.leftViewMode = UITextFieldViewModeAlways;
            label.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
            label.font = [UIFont systemFontOfSize:13];
        }
        [addressLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:addressLabel];
        [addressLabel loadLine];
        
        
        shipLabel = [[UITextField alloc] initWithFrame:CGRectMake(40, addressLabel.bottom + 2, winSize.width - 80, 20)];
        shipLabel.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
        shipLabel.font = [UIFont systemFontOfSize:15];
        shipLabel.tag = 10003;
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
            shipLabel.leftView = label;
            shipLabel.leftViewMode = UITextFieldViewModeAlways;
            label.textColor = [UIColor colorWithRed:0.35 green:0.47 blue:0.58 alpha:1];
            label.font = [UIFont systemFontOfSize:13];
        }
        [shipLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:shipLabel];
        [shipLabel loadLine];
    }
    return self;
}

- (void)setFamily:(JFamily *)family {
    _family = family;
    
    ((UILabel *)nameLabel.leftView).text = @"姓名：";
    ((UILabel *)birthdayLabel.leftView).text = @"生日";
    ((UILabel *)addressLabel.leftView).text = @"地址";
    ((UILabel *)shipLabel.leftView).text = @"关系";
    nameLabel.text = family.Name;
    birthdayLabel.text = family.Birthday;
    addressLabel.text = family.Address;
    shipLabel.text = family.RelationShip;
}

- (void)selectDate:(id)sender {
    [ActionSheetDatePicker showPickerWithTitle:@"选择日期" datePickerMode:UIDatePickerModeDate selectedDate:[birthdayLabel.text toDate] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        birthdayLabel.text = [selectedDate toDateString];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:self];
}

- (void)textFieldDidChange:(UITextField *)textField{
    _family.Name = nameLabel.text;
    _family.Birthday = birthdayLabel.text;
    _family.Address = addressLabel.text;
    _family.RelationShip = shipLabel.text;
    
    if (_delegate) {
        [_delegate textFieldDidChange:_family index:_index];
    }
}

@end

@interface FamilyInfoViewController () <UITableViewDataSource, UITableViewDelegate, JFamilyCellDelegate> {
    UITableView *_tableView;
    JFamilyBase *_family;
    NSArray *_datas;
    NSMutableArray *_familys;
}
@end

@implementation FamilyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _family = [JFamilyBase objectWithKeyValues:[JPersonInfo person].Family];
    if (_family == nil) {
        _family = [[JFamilyBase alloc] init];
    }
    _familys = [NSMutableArray arrayWithArray:_family.Relatives];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 60)];
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
    } else {
        if (pageIndex > 0)
            [JPersonInfo person].CurrentStep = [JPersonInfo person].CurrentStep - 1000;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addnew:(id)sender {
    [_familys addObject:[[JFamily alloc] init]];
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
    HobbyViewController *vc = [[HobbyViewController alloc] init];
    vc.title = @"兴趣爱好";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    UIBarButtonItem *stepItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"step6"] style:UIBarButtonItemStylePlain target:nil action:nil];
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
    [_familys removeObjectAtIndex:indexPath.row];
    _family.Relatives = _familys;
    [JPersonInfo person].Family = [_family JSONString];
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _familys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFamilyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[JFamilyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    JFamily *family = [_familys objectAtIndex:indexPath.row];
    cell.index = @(indexPath.row).intValue;
    [cell setFamily:family];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)textFieldDidChange:(JFamily *)family index:(int)index {
    [_familys replaceObjectAtIndex:index withObject:family];
    _family.Relatives = _familys;
    [JPersonInfo person].Family = [_family JSONString];
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

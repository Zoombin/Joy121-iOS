//
//  ContactsTableViewController.m
//  Joy
//
//  Created by zhangbin on 11/11/14.
//  Copyright (c) 2014 颜超. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "JAFHTTPClient.h"
#import "Contact.h"
#import "ContactDetailsTableViewController.h"
#define SelectColor [UIColor colorWithRed:0.93 green:0.56 blue:0.12 alpha:1]
#define NormalColor [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1]
@interface ContactsTableViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    UIView *_sengmentView;
    UIButton *_normalButton;
    UIButton *_importantButton;
    int _type;
}

@property (readwrite) NSArray *contacts;
@property (readwrite) UISearchBar *searchBar;
@property (readwrite) NSUInteger page;
@property (readwrite) BOOL noMore;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"公司通讯录", nil);
	_page = 1;
    _type = 0;

    _sengmentView = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight(self), winSize.width, 40)];
    [self.view addSubview:_sengmentView];
    
    _normalButton = [self sengmentButton:@"常用联系人" x:0];
    [_sengmentView addSubview:_normalButton];
    _importantButton = [self sengmentButton:@"重要联系人" x:winSize.width / 2];
    [_sengmentView addSubview:_importantButton];
    [self clickSengment:_normalButton];
    
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, _sengmentView.bottom, self.view.frame.size.width, 40)];
        _searchBar.placeholder = @"请搜索中文名，英文名，部门";
        _searchBar.delegate = self;
    }
    [self.view addSubview:_searchBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, winSize.width, winSize.height - _sengmentView.bottom - navHeight(self) - _searchBar.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[_searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIButton *)sengmentButton:(NSString *)name x:(int)x {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, winSize.width / 2, 40)];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:NormalColor forState:UIControlStateNormal];
    [button setTitleColor:SelectColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickSengment:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, button.bottom - 1, button.width, 1)];
    line.tag = 10000;
    [button addSubview:line];
    return button;
}

- (void)clickSengment:(id)sender {
    if (sender == _normalButton) {
        _normalButton.selected = YES;
        _importantButton.selected = NO;
        [_normalButton viewWithTag:10000].backgroundColor = SelectColor;
        [_importantButton viewWithTag:10000].backgroundColor = NormalColor;
        _type = 0;
        _noMore = NO;
        
        _searchBar.hidden = NO;
        _tableView.frame = CGRectMake(0, _searchBar.bottom, winSize.width, winSize.height - _sengmentView.bottom - navHeight(self) - _searchBar.height);
    } else if (sender == _importantButton) {
        _normalButton.selected = NO;
        _importantButton.selected = YES;
        [_normalButton viewWithTag:10000].backgroundColor = NormalColor;
        [_importantButton viewWithTag:10000].backgroundColor = SelectColor;
        _type = 1;
        _noMore = YES;
        
        _searchBar.hidden = YES;
        _tableView.frame = CGRectMake(0, _sengmentView.bottom, winSize.width, winSize.height - _sengmentView.bottom - navHeight(self));

    }
    _contacts = [NSArray array];
    _page = 1;
    [self loadContacts:nil page:_page];
}

- (void)loadContacts:(NSString *)queryString page:(NSUInteger)page
{
	[self displayHUD:@"加载中..."];
    if (_type == 0) {
        [[JAFHTTPClient shared] contacts:queryString page:page pagesize:@"20" withBlock:^(NSArray *multiAttributes, NSError *error) {
            [self hideHUD:YES];
            if (!error) {
                if (multiAttributes.count > 0) {
                    NSArray *tmp = [Contact multiWithAttributesArray:multiAttributes type:_Normal];
                    NSMutableArray *all = [NSMutableArray array];
                    if (tmp.count) {
                        [all addObjectsFromArray:tmp];
                    }
                    if (_contacts.count) {
                        [all addObjectsFromArray:_contacts];
                    }
                    _contacts = [NSArray arrayWithArray:all];
                    [_tableView reloadData];
                } else {
                    _noMore = YES;
                }
            }
        }];
    } else {
        [[JAFHTTPClient shared] getEntryRelation:^(NSArray *multiAttributes, NSError *error) {
            [self hideHUD:YES];
            if (!error) {
                if (multiAttributes) {
                    _contacts = [Contact multiWithAttributesArray:multiAttributes type:_Important];
                } else {
                    _contacts = [NSArray array];
                }
                [_tableView reloadData];
            }
        }];
    }

}

- (void)loadMore
{
	if (_noMore) {
		[self displayHUDTitle:NSLocalizedString(@"已经显示全部", nil) message:nil duration:0.3];
		return;
	}
	_page++;
	if (_searchBar.text.length > 0) {
		[self loadContacts:_searchBar.text page:_page];
	} else {
		[self loadContacts:nil page:_page];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contacts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	if (!_searchBar) {
//		_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//		_searchBar.placeholder = @"请搜索中文名，英文名，部门";
//		_searchBar.delegate = self;
//	}
//	return _searchBar;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}
	cell.imageView.image = [UIImage imageFromColor:[UIColor redColor]];
	Contact *contact = _contacts[indexPath.row];
	cell.imageView.image = [UIImage imageNamed:@"user_head"];
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.personName ?: @"", contact.englishName ?: @""];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", contact.companyPosition ?: @"", contact.companyDepartment ?: @""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ContactDetailsTableViewController *contactDetailsTableViewController = [[ContactDetailsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	contactDetailsTableViewController.contact = _contacts[indexPath.row];
	[self.navigationController pushViewController:contactDetailsTableViewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	if (searchBar.text.length) {
		_page = 1;
		_contacts = [NSArray array];
		[_tableView reloadData];
		[self loadContacts:searchBar.text page:_page];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
	if (endScrolling >= scrollView.contentSize.height - 10) {
		[self loadMore];
	}
}

@end

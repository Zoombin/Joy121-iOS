//
//  CardInfoViewController.m
//  Joy
//
//  Created by gejw on 15/8/18.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

#import "CardInfoViewController.h"
#import "EntryTableView.h"
#import "ExperienceViewController.h"
#define curPageIndex 3

NS_ENUM(NSInteger, FileType) {
    None,
    Certificates,
    Video,
    LearningCertificate,
    IDImagePositive,
    IDImageReverse,
    Retirement,
    Physical
};

@interface CardInfoViewController () <UIActionSheetDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    EntryTableView *_tableView;
    NSMutableArray *_datas;
    enum FileType _fileType;
    UIActionSheet *_actionSheet;
    JMaterials *_materials;
}

@end

@implementation CardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _datas = [NSMutableArray array];
    _fileType = None;
    // 检测判空
    if (![JPersonInfo person].Materials || [NSJSONSerialization isValidJSONObject:[JPersonInfo person].Materials]) {
        _materials = [[JMaterials alloc] init];
    } else {
        _materials = [JMaterials objectWithKeyValues:[JPersonInfo person].Materials];
    }
    
    
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
    
    __weak CardInfoViewController *weakSelf = self;
    {
        ApplyImageCell *cell = [[ApplyImageCell alloc] initWithLabelString:@"证  件  照：" labelImage:[UIImage imageNamed:@"entry_myself"] hintString:@"(只需要一张照片即可)" num:1 updateHandler:^(UIImageView *imageView, UIImageView *imageView2) {
            if (_materials.Certificates) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:_materials.Certificates]];
            }
        } clickHandler:^(UIImageView *imageView, int indexSelect) {
            _fileType = Certificates;
            [weakSelf openMenu];
        }];
        [_datas addObject:cell];
    }
    
//    {
//        ApplyImageCell *cell = [[ApplyImageCell alloc] initWithLabelString:@"我的视频" labelImage:[UIImage imageNamed:@"entry_myselfvideo"] hintString:@"" num:1 updateHandler:^(UIImageView *imageView, UIImageView *imageView2) {
//            
//        } clickHandler:^(UIImageView *imageView, int indexSelect) {
//            
//        }];
//        [_datas addObject:cell];
//    }
//    
    {
        ApplyImageCell *cell = [[ApplyImageCell alloc] initWithLabelString:@"学习证书：" labelImage:[UIImage imageNamed:@"entry_academicphoto"] hintString:@"(只需要一张照片即可)" num:1 updateHandler:^(UIImageView *imageView, UIImageView *imageView2) {
            
            if (_materials.LearningCertificate) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:_materials.LearningCertificate]];
            }
        } clickHandler:^(UIImageView *imageView, int indexSelect) {
            _fileType = LearningCertificate;
            [weakSelf openMenu];
        }];
        [_datas addObject:cell];
    }
    
    {
        ApplyImageCell *cell = [[ApplyImageCell alloc] initWithLabelString:@"身  份  证：" labelImage:[UIImage imageNamed:@"entry_idphoto"] hintString:@"(需要正反两面照片)" num:2 updateHandler:^(UIImageView *imageView, UIImageView *imageView2) {
            if (_materials.IDImage.Positive) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:_materials.IDImage.Positive]];
            }
            if (_materials.IDImage.Reverse) {
                [imageView2 sd_setImageWithURL:[NSURL URLWithString:_materials.IDImage.Reverse]];
            }
        } clickHandler:^(UIImageView *imageView, int indexSelect) {
            _fileType = indexSelect == 0 ? IDImagePositive : IDImageReverse;
            [weakSelf openMenu];
        }];
        [_datas addObject:cell];
    }
    
    {
        ApplyImageCell *cell = [[ApplyImageCell alloc] initWithLabelString:@"退  工  单：" labelImage:[UIImage imageNamed:@"entry_rapairorder"] hintString:@"(只需要一张照片即可)" num:1 updateHandler:^(UIImageView *imageView, UIImageView *imageView2) {
            if (_materials.Retirement) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:_materials.Retirement]];
            }
        } clickHandler:^(UIImageView *imageView, int indexSelect) {
            _fileType = Retirement;
            [weakSelf openMenu];
        }];
        [_datas addObject:cell];
    }
    
    {
        ApplyImageCell *cell = [[ApplyImageCell alloc] initWithLabelString:@"体检报告：" labelImage:[UIImage imageNamed:@"entry_checkreproting"] hintString:@"(只需要一张照片即可)" num:1 updateHandler:^(UIImageView *imageView, UIImageView *imageView2) {
            if (_materials.Physical) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:_materials.Physical]];
            }
        } clickHandler:^(UIImageView *imageView, int indexSelect) {
            _fileType = Physical;
            [weakSelf openMenu];
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
    }
}

- (BOOL)check {
    if (!_materials.Certificates || [_materials.Certificates isEqualToString:@""]) {
        [self.view makeToast:@"请上传证件照"];
        return false;
    }
    if (!_materials.LearningCertificate || [_materials.LearningCertificate isEqualToString:@""]) {
        [self.view makeToast:@"请上传学习证书"];
        return false;
    }
    if (!_materials.IDImage.Positive || [_materials.IDImage.Positive isEqualToString:@""]) {
        [self.view makeToast:@"请上传身份证正面"];
        return false;
    }
    if (!_materials.IDImage.Reverse || [_materials.IDImage.Reverse isEqualToString:@""]) {
        [self.view makeToast:@"请上传身份证反面"];
        return false;
    }
    if (!_materials.Retirement || [_materials.Retirement isEqualToString:@""]) {
        [self.view makeToast:@"请上传退工单"];
        return false;
    }
    if (!_materials.Physical || [_materials.Physical isEqualToString:@""]) {
        [self.view makeToast:@"请上传体检报告"];
        return false;
    }
    return true;
}

- (void)nextPage:(BOOL)animated {
    ExperienceViewController *vc = [[ExperienceViewController alloc] init];
    vc.title = @"个人经历";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    UIBarButtonItem *stepItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"step4"] style:UIBarButtonItemStylePlain target:nil action:nil];
    vc.navigationItem.rightBarButtonItem = stepItem;
    [self.navigationController pushViewController:vc animated:animated];
}


#pragma 选择照片

- (void)openMenu {
    //在这里呼出下方菜单按钮项
    _actionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [_actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == _actionSheet.cancelButtonIndex) {
        NSLog(@"取消");
        _fileType = None;
    }
    
    switch (buttonIndex) {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

//开始拍照
- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
- (void)LocalPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        [picker dismissViewControllerAnimated:YES completion:nil];
        [[JAFHTTPClient shared] uploadFile:data success:^(NSString *filePath) {
            // 上传成功之后  删除
            switch (_fileType) {
                case Certificates:
                    _materials.Certificates = filePath;
                    break;
                case LearningCertificate:
                    _materials.LearningCertificate = filePath;
                    break;
                case IDImagePositive:
                    if (!_materials.IDImage) {
                        _materials.IDImage = [[JIdimage alloc] init];
                    }
                    _materials.IDImage.Positive = filePath;
                    break;
                case IDImageReverse:
                    if (!_materials.IDImage) {
                        _materials.IDImage = [[JIdimage alloc] init];
                    }
                    _materials.IDImage.Reverse = filePath;
                    break;
                case Retirement:
                    _materials.Retirement = filePath;
                    break;
                case Physical:
                    _materials.Physical = filePath;
                    break;
                    
                default:
                    break;
            }
            [JPersonInfo person].Materials = [_materials JSONString];
            [_tableView reloadData];
            _fileType = None;
        } failure:^(NSString *msg) {
            [_tableView reloadData];
            _fileType = None;
        }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _fileType = None;
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

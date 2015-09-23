//
//  UIViewController+SaveBar.h
//  Joy
//
//  Created by gejw on 15/9/8.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SaveBar)

- (void)loadSaveBar;

- (void)save:(id)sender;

- (void)next:(id)sender;

- (void)savePageIndex:(NSInteger)pageIndex;

- (void)submit:(id)sender;

- (NSInteger)pageIndex;

@end

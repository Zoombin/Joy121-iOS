//
//  UIColor+Joy.h
//  Joy
//
//  Created by zhangbin on 7/5/14.
//  Copyright (c) 2014 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Joy)

+ (void)saveThemeColorWithHexString:(NSString *)hexString;
+ (void)saveSecondaryColorWithHexString:(NSString *)hexString;
+ (instancetype)themeColor;
+ (instancetype)secondaryColor;

@end

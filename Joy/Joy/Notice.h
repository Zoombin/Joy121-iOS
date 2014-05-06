//
//  Notice.h
//  Joy
//
//  Created by 颜超 on 14-5-6.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *postTime;

+ (Notice *)createNoticeWithDict:(NSDictionary *)dict;
+ (NSArray *)createNoticesWithArray:(NSArray *)array;
@end



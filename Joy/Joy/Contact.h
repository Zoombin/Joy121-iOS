//
//  Contact.h
//  Joy
//
//  Created by zhangbin on 11/11/14.
//  Copyright (c) 2014 颜超. All rights reserved.
//

#import "ZBModel.h"

typedef NS_ENUM(NSUInteger, ZBContactType) {
    _Normal,
    _Important
};

@interface Contact : ZBModel

@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *englishName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *companyPosition;
@property (nonatomic, strong) NSString *companyDepartment;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *companyName;

- (instancetype)initWithAttributes:(NSDictionary *)attributes type:(ZBContactType)type;

+ (NSArray *)multiWithAttributesArray:(NSArray *)array type:(ZBContactType)type;

@end

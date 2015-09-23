//
//  JPersonInfo.m
//  Joy
//
//  Created by gejw on 15/8/21.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

#import "JPersonInfo.h"

@implementation JPersonInfo

static JPersonInfo *personInfo = nil;
+ (JPersonInfo *)person {
    return personInfo;
}

+ (void)setPerson:(JPersonInfo *)person {
    personInfo = person;
}

@end

#pragma 个人经历

@implementation JExperiences

+ (NSDictionary *)objectClassInArray{
    return @{@"Job" : [JJob class], @"Learning" : [JLearning class]};
}

@end


@implementation JJob

- (instancetype)init
{
    self = [super init];
    if (self) {
        _Achievement = @"";
        _Position = @"";
        _SDate = @"";
        _EDate = @"";
        _Company = @"";
    }
    return self;
}

@end


@implementation JLearning

- (instancetype)init
{
    self = [super init];
    if (self) {
        _Achievement = @"";
        _Profession = @"";
        _SDate = @"";
        _EDate = @"";
        _School = @"";
    }
    return self;
}

@end

#pragma 家庭信息

@implementation JFamilyBase

+ (NSDictionary *)objectClassInArray{
    return @{@"Relatives" : [JFamily class]};
}

@end

@implementation JFamily

- (instancetype)init
{
    self = [super init];
    if (self) {
        _Name = @"";
        _Birthday = @"";
        _Address = @"";
        _RelationShip = @"";
    }
    return self;
}

@end

#pragma 附件信息

@implementation JMaterials

@end
@implementation JIdimage

@end
//
//  Contact.m
//  Joy
//
//  Created by zhangbin on 11/11/14.
//  Copyright (c) 2014 颜超. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (instancetype)initWithAttributes:(NSDictionary *)attributes type:(ZBContactType)type {
    self = [super init];
    if (self) {
        switch (type) {
            case _Normal:
                if (attributes[@"PersonName"] != [NSNull null]) _personName = attributes[@"PersonName"];
                if (attributes[@"EnglishName"] != [NSNull null]) _englishName = attributes[@"EnglishName"];
                if (attributes[@"Mobile"] != [NSNull null]) _mobile = attributes[@"Mobile"];
                if (attributes[@"ComPos"] != [NSNull null]) _companyPosition = attributes[@"ComPos"];
                if (attributes[@"ComDep"] != [NSNull null]) _companyDepartment = attributes[@"ComDep"];
                if (attributes[@"Email"] != [NSNull null]) _email = attributes[@"Email"];
                if (attributes[@"Phone"] != [NSNull null]) _phone = attributes[@"Phone"];
                if (attributes[@"CompanyName"] != [NSNull null]) _companyName = attributes[@"CompanyName"];
                break;
            case _Important:
                if (attributes[@"ReferUserName"] != [NSNull null]) _personName = attributes[@"ReferUserName"];
                if (attributes[@"ReferMobile"] != [NSNull null]) _mobile = attributes[@"ReferMobile"];
                if (attributes[@"ReferCostCenterNo"] != [NSNull null]) _companyPosition = attributes[@"ReferCostCenterNo"];
                if (attributes[@"ReferRelationTypeName"] != [NSNull null]) _companyDepartment = attributes[@"ReferRelationTypeName"];
                if (attributes[@"ReferEmail"] != [NSNull null]) _email = attributes[@"ReferEmail"];
            default:
                break;
        }
    }
    return self;
}

+ (NSArray *)multiWithAttributesArray:(NSArray *)array type:(ZBContactType)type
{
    NSMutableArray *multi = [NSMutableArray array];
    if ([array isKindOfClass:[NSNull class]]) {
        return multi;
    }
    for (NSDictionary *attributes in array) {
        [multi addObject:[[[Contact class] alloc] initWithAttributes:attributes type:type]];
    }
    return multi;
}
- (NSString *)description
{
	return [NSString stringWithFormat:@"< personName: %@, mobile: %@, department: %@, phone: %@ >", _personName, _mobile, _companyDepartment, _phone];
}

@end

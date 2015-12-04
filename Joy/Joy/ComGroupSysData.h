//
//  ComGroupSysData.h
//  Joy
//
//  Created by gejw on 15/12/4.
//  Copyright © 2015年 颜超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComGroupSysData : NSObject

@property (nonatomic, copy) NSString *SysKey;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *ComGroup;

@property (nonatomic, copy) NSString *SysKeyName;

@property (nonatomic, copy) NSString *SysValue;

@property (nonatomic, assign) NSInteger Flag;

@property (nonatomic, assign) NSInteger ParentId;


@end

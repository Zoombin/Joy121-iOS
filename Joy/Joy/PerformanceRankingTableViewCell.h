//
//  PerformanceRankingTableViewCell.h
//  Joy
//
//  Created by zhangbin on 2/17/15.
//  Copyright (c) 2015 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Performance.h"

@interface PerformanceRankingTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) Performance *performance;

@end

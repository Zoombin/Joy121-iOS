//
//  JAFHTTPClient.h
//  Joy
//
//  Created by 颜超 on 14-4-7.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "AFHTTPClient.h"

@interface JAFHTTPClient : AFHTTPClient

#define NETWORK_ERROR @"网络异常"

+ (instancetype)shared;
- (void)saveUserName:(NSString *)userName;
- (NSString *)userName;
- (void)saveCompanyName:(NSString *)companyName;
- (NSString *)companyName;
+ (void)signOut;
+ (BOOL)bLogin;
+ (NSString *)imageURLString;
- (NSArray *)pushTags;
- (NSString *)companyLogoURLString;
- (NSString *)companyTitle;
- (NSString *)companyLogoBasePath;

/**
 * @brief 用户登录
 *
 * @param username
 * @param password
 */
- (void)signIn:(NSString *)username
      password:(NSString *)password
     withBlock:(void(^)(NSDictionary *result, NSError *error))block;

/**
 * @brief 用户信息
 *
 */
- (void)userInfoWithBlock:(void(^)(NSDictionary *attributes, NSError *error))block;

/**
 * @brief 用户购买历史
 *
 */
- (void)userBuyHistory:(void(^)(NSDictionary *result, NSError *error))block;

/**
 * @brief 用户积分
 *
 */
- (void)userScore:(void(^)(NSDictionary *result, NSError *error))block;

/**
 * @brief 修改密码
 *
 */
- (void)changePwd:(NSString *)oldPwd
           newPwd:(NSString *)newPwd
        withBlock:(void(^)(NSDictionary *result, NSError *error))block;


- (void)myOrders:(void(^)(NSArray *multiAttributes, NSError *error))block;

- (void)frontPicWithBlock:(void(^)(NSDictionary *result, NSError *error))block;

/**
 * @brief 用户可订购套餐的列表
 *
 */
- (void)userPackageList:(void(^)(NSDictionary *result, NSError *error))block;
- (void)packageDetail:(NSString *)cid
          withBlock:(void(^)(NSDictionary *result, NSError *error))block;

- (void)noticesIsExpired:(BOOL)expired withBlock:(void(^)(NSArray *multiAttributes, NSError *error))block;
- (void)eventsIsExpired:(BOOL)bExpired isTraining:(BOOL)bTraining withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
- (void)joinEvent:(NSString *)eventId fee:(NSString *)fee withBlock:(void(^)(BOOL success, NSError *error))block;
- (void)quitEvent:(NSString *)eventId withBlock:(void (^)(BOOL success, NSError *error))block;
- (void)surveysIsExpired:(BOOL)expired withBlock:(void(^)(NSDictionary *result, NSError *error))block;

- (void)voteSubmit:(NSString *)surId
           answers:(NSString *)answers
         withBlock:(void(^)(NSDictionary *result, NSError *error))block;

- (void)companyModulesWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
- (void)storeCategoriesWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
- (void)goodsPropertiesWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
- (void)amountsOfGoods:(NSString *)goodsID withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
- (void)submitOrder:(NSString *)orderDescribe withBlock:(void (^)(NSError *error))block;
- (void)contacts:(NSString *)queryString page:(NSUInteger)page pagesize:(NSString *)pagesize withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
- (void)officeDepotWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
- (void)companyPayRoll:(void (^)(NSArray *multiAttributes, NSError *error))block;
- (void)submitDepotRent:(NSString *)depotID number:(NSNumber *)number withBlock:(void (^)(NSError *error))block;

- (void)storeGoodsOfCategoryID:(NSString *)categoryID categoryType:(NSString *)categoryType withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

@end

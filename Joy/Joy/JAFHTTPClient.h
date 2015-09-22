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
- (void)saveLoginPassWord:(NSString *)passWord;//存储密码
- (NSString *)passWord;//获取密码
- (NSString *)md5WithString:(NSString *)str;

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
- (void)detailOfPayroll:(NSString *)period withBlock:(void (^)(NSDictionary *attributes, NSError *error))block;
- (void)submitDepotRent:(NSString *)depotID number:(NSNumber *)number withBlock:(void (^)(NSError *error))block;

- (void)storeGoodsOfCategoryID:(NSString *)categoryID categoryType:(NSString *)categoryType withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

- (void)performanceIsEncourage:(BOOL)isEncourage WithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
- (void)encourageDetailsWithReportCaseID:(NSString *)reportCaseID withblock:(void (^)(NSArray *multiAttributes, NSError *error))block;


/**
 *  获取模块
 *
 *  @param block
 */
- (void)getModulesByCompany:(void (^)(NSArray *multiAttributes, NSError *error))block;

/**
 *  获取重要联系人
 *
 *  @param success
 *  @param failure
 */
- (void)getEntryRelation:(void (^)(NSArray *multiAttributes, NSError *error))block;

#pragma 入职离职
/**
 *  获取字典项
 *
 *  @param type      类型 WorkPlace工作地点,CostCenterno 部门,Compo职位,comgrade职位级别,SalaryGrade工资等级
 *  @param parentId  父id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)getSysDataWithType:(NSString *)type
                  parentId:(int)parentId
                   success:(void (^)(NSArray *sysDatas))success
                   failure:(void (^)(NSString *msg))failure;

/**
 *  获取用户信息
 *
 *  @param success
 *  @param failure 
 */
- (void)getPersonInfo:(void (^)(JPersonInfo *personInfo))success
              failure:(void (^)(NSString *msg))failure;

/**
 *  更新用户信息
 *
 *  @param personInfo
 *  @param success
 *  @param failure
 */
- (void)updatePersonInfo:(JPersonInfo *)personInfo
                 success:(void (^)())success
                 failure:(void (^)(NSString *msg))failure;

- (void)uploadFile:(NSData *)data
           success:(void (^)(NSString *filePath))success
           failure:(void (^)(NSString *msg))failure;



@end

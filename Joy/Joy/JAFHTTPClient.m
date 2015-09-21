//
//  JAFHTTPClient.m
//  Joy
//
//  Created by 颜超 on 14-4-7.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "JAFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "APService.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"

#define USER_NAME @"username"
#define PASS_WORD @"password"
#define COMPANY_NAME @"companyname"
#define KEY @"wang!@#$%"
#define kAPIInterface @"ajaxpage/app/msg.ashx"
#define kAPIKeyAction @"action"
#define BASE_URL_STRING @"http://cloud.joy121.com:99/"
//#warning TODO:test server
//#define BASE_URL_STRING @"http://www.joy121.com:8000/"
#define GOODS_PROPERTIES @"GOODS_PROPERTIES"
#define kReturnObj @"retobj"
#define APP_SETTINGS_TITLE @"APP_SETTINGS_TITLE"
#define APP_SETTINGS_LOGO @"APP_SETTINGS_LOGO"

static NSString * const COMPANY_GROUP = @"COMPANY_GROUP";
static NSString * const TOMMY = @"TOMMY";

@implementation JAFHTTPClient

+ (instancetype)shared
{
    static JAFHTTPClient *client;
    if (!client) {
        client = [[JAFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL_STRING]];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return client;
}

- (void)saveUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userName
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_NAME];
}

- (void)saveCompanyName:(NSString *)companyName
{
    [[NSUserDefaults standardUserDefaults] setObject:companyName forKey:COMPANY_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)companyName
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:COMPANY_NAME];
}

+ (void)signOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_NAME];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)bLogin
{
	NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:USER_NAME];
	return userName ? YES : NO;
}

+ (NSString *)imageURLString
{
	return [NSString stringWithFormat:@"%@%@", BASE_URL_STRING, @"files/img/"];
}

- (NSString *)companyLogoURLString {
	NSString *logo = [[NSUserDefaults standardUserDefaults] objectForKey:APP_SETTINGS_LOGO];
	if (logo) {
		return [NSString stringWithFormat:@"%@%@", [[self class] companyLogoBasePath], logo];
	}
	return nil;
}

- (NSString *)companyTitle {
	NSString *title = [[NSUserDefaults standardUserDefaults] objectForKey:APP_SETTINGS_TITLE];
	return title;
}

+ (NSString *)companyLogoBasePath {
	return [NSString stringWithFormat:@"%@%@", BASE_URL_STRING, @"Files/logo/"];
}

- (NSString *)md5WithString:(NSString *)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

- (void)saveLoginPassWord:(NSString *)passWord
{
    passWord = [self md5WithString:passWord];
    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:PASS_WORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)passWord
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:PASS_WORD];
}

- (void)signIn:(NSString *)username
      password:(NSString *)password
     withBlock:(void(^)(NSDictionary *result, NSError *error))block
{
    NSString *deviceToken = @"null";//服务器不需要这个参数了
    NSString *token = [NSString stringWithFormat:@"%@%@", username, KEY];
	
	NSDictionary *normalParameters = @{kAPIKeyAction : @"login", @"token" : [self md5WithString:token]};
	NSDictionary *jsonParameters = @{@"loginname": username, @"loginpwd" : password, @"imeino" : deviceToken};
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
		
    [self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
		NSError *error = nil;
		if (jsonValue[@"retobj"] == [NSNull null]) {
			NSString *errorMessage = @"帐户或者密码错误！";
			if (jsonValue[@"msg"]) {
				errorMessage = jsonValue[@"msg"];
			}
			error = [NSError errorWithDomain:@"joy" code:1 userInfo:@{@"errormessage" : errorMessage}];
		} else {
			NSDictionary *attributes = jsonValue[@"retobj"];
			NSString *accessCodes = attributes[@"AppAccessCodes"];
			NSArray *codes = [accessCodes componentsSeparatedByString:@","];
			[self savePushTags:codes];
			
			AppDelegate *delegate = [UIApplication sharedApplication].delegate;
			[delegate apserviceSetTags];
			
			NSDictionary *companyAttributes = attributes[@"CompanyInfo"];
			if (companyAttributes) {
				NSString *appSettings = companyAttributes[@"CompAppSetting"];
				
				if (appSettings.length) {
					NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:[appSettings dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error:nil];
					
					if (JSON[@"color1"]) {
						NSString *color1 = JSON[@"color1"];
						[UIColor saveThemeColorWithHexString:color1];
					}
					
					if (JSON[@"color2"]) {
						NSString *color2 = JSON[@"color2"];
						[UIColor saveSecondaryColorWithHexString:color2];
					}
					
					if (JSON[@"logo"]) {
						[[NSUserDefaults standardUserDefaults] setObject:JSON[@"logo"] forKey:APP_SETTINGS_LOGO];
					}
					
					if (JSON[@"title"]) {
						[[NSUserDefaults standardUserDefaults] setObject:JSON[@"title"] forKey:APP_SETTINGS_TITLE];
					}
					[[NSUserDefaults standardUserDefaults] synchronize];
				}
			}
			
			if (attributes[@"ComGroup"]) {
				[[NSUserDefaults standardUserDefaults] setObject:attributes[@"ComGroup"] forKey:COMPANY_GROUP];
				[[NSUserDefaults standardUserDefaults] synchronize];
			}
		}
        if (block) {
            block(jsonValue, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)savePushTags:(NSArray *)tags
{
	[[NSUserDefaults standardUserDefaults] setObject:tags forKey:@"push_tags"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)pushTags
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"push_tags"];
}

- (NSString *)getToken
{
    NSString *token = [NSString stringWithFormat:@"%@%@", [self userName], KEY];
    return [self md5WithString:token];
}

- (void)userInfoWithBlock:(void(^)(NSDictionary *attributes, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"user_info", @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
    [self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
		NSDictionary *attributes = jsonValue[@"retobj"];
        if (block) {
            block(attributes, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)userBuyHistory:(void(^)(NSDictionary *result, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"user_order", @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];

    [self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        if (block) {
            block(jsonValue, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)userScore:(void(^)(NSDictionary *result, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"point_his", @"token" : [self getToken]};
	NSDictionary *jsonParamters = [self addLoginName:@{}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParamters];

    [self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        if (block) {
            block(jsonValue, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)changePwd:(NSString *)oldPwd
           newPwd:(NSString *)newPwd
        withBlock:(void(^)(NSDictionary *result, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"user_cpwd", @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"ologinpwd" : oldPwd, @"nloginpwd" : newPwd}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
    [self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        if (block) {
            block(jsonValue, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)myOrders:(void(^)(NSArray *multiAttributes, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"user_order", @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];

    [self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        if (block) {
            block(jsonValue[@"retobj"], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}


- (void)frontPicWithBlock:(void (^)(NSDictionary *, NSError *))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"fp_pic" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
    [self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        if (block) {
            block(jsonValue, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)userPackageList:(void(^)(NSDictionary *result, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"fp_benefit" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
    [self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        if (block) {
            block(jsonValue, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)packageDetail:(NSString *)cid
          withBlock:(void(^)(NSDictionary *result, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"bf_single" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"commsetid" : cid}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
    [self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        if (block) {
            block(jsonValue, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)noticesIsExpired:(BOOL)expired withBlock:(void(^)(NSArray *multiAttributes, NSError *error))block;
{
	NSNumber *isExpired = expired ? @(2) : @(1);
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comp_post" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginNameAndCompanyName:@{@"isexpired": isExpired}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];

    [self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
        if (block) {
            block(multiAttributes, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)eventsIsExpired:(BOOL)bExpired isTraining:(BOOL)bTraining withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
{
	NSNumber *isExpired = bExpired ? @(2) : @(1);
	NSNumber *isTraining = bTraining ? @(2) : @(1);
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comp_activity" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginNameAndCompanyName:@{@"isexpired" : isExpired, @"acttype" : isTraining}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
    [self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
        if (block) {
            block(multiAttributes, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)joinEvent:(NSString *)eventId fee:(NSString *)fee withBlock:(void(^)(BOOL success, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comp_act_join" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"actid" : eventId, @"actfee" : fee}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];

    [self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
		
		NSString *flag;
		if (jsonValue[@"retobj"]) {
			flag = jsonValue[@"retobj"][@"result"];
		}
		BOOL success = NO;
		NSString *message;
		if (flag) {
			if ([flag isEqualToString:@"1"]) {
				success = YES;
			} else if ([flag isEqualToString:@"0"]) {
				message = NSLocalizedString(@"参与失败", nil);
			} else if ([flag isEqualToString:@"2"]) {
				message = NSLocalizedString(@"已经参加过此活动", nil);
			}
		}
		
		NSError *error = nil;
		if (!success) {
			error = [NSError errorWithDomain:DSH_ERROR_DOMAIN code:DSH_ERROR_CODE userInfo:@{DSH_ERROR_USERINFO_ERROR_MESSAGE : message ?: NSLocalizedString(@"未知错误", nil)}];
		}
		
        if (block) {
            block(success, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO, error);
        }
    }];
}

- (void)quitEvent:(NSString *)eventId withBlock:(void (^)(BOOL success, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comp_act_quit" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"actid" : eventId}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		
		NSString *flag;
		if (jsonValue[@"retobj"]) {
			flag = jsonValue[@"retobj"][@"result"];
		}
		BOOL success = NO;
		NSString *message;
		if (flag) {
			if ([flag isEqualToString:@"1"]) {
				success = YES;
			} else {
				message = jsonValue[@"msg"];
				if ([message isKindOfClass:[NSNull class]]) {
					message = nil;
				}
			}
		}
		
		NSError *error = nil;
		if (!success) {
			error = [NSError errorWithDomain:DSH_ERROR_DOMAIN code:DSH_ERROR_CODE userInfo:@{DSH_ERROR_USERINFO_ERROR_MESSAGE : message ?: NSLocalizedString(@"未知错误", nil)}];
		}
		
		if (block) {
			block(success, error);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(NO, error);
		}
	}];
}

- (void)surveysIsExpired:(BOOL)expired withBlock:(void(^)(NSDictionary *result, NSError *error))block;
{
	NSNumber *isExpired = expired ? @(2) : @(1);
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comp_survey" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginNameAndCompanyName:@{@"isexpired" : isExpired}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
    [self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        if (block) {
            block(jsonValue, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)voteSubmit:(NSString *)surId
           answers:(NSString *)answers
         withBlock:(void(^)(NSDictionary *result, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comp_survey_a" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"surveyid" : surId, @"answers" : answers}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];

    [self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        if (block) {
            block(jsonValue, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)companyModulesWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comp_modules" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginNameAndCompanyName:@{}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];

	[self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
        if (block) {
            block(multiAttributes, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)storeCategoriesWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comm_category" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginNameAndCompanyName:@{@"categorytype" : @"2"}];//TODO: logo stroe为2，在线商城为1
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
		if (block) {
			block(multiAttributes, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)storeGoodsOfCategoryID:(NSString *)categoryID categoryType:(NSString *)categoryType withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block {
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comm_list" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginNameAndCompanyName:@{@"categorytype" : categoryType, @"categoryid" : categoryID}];//categorytype==2代表logo商店
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
		if (block) {
			block(multiAttributes, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)goodsPropertiesWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block
{
	static NSArray *_multiAttributes;
	if (_multiAttributes) {
		if (block) {
			block(_multiAttributes, nil);
			return;
		}
		return;
	}
	NSDictionary *normalParameters = @{kAPIKeyAction : @"commproperty_list" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
		_multiAttributes = multiAttributes;
		if (block) {
			block(multiAttributes, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)amountsOfGoods:(NSString *)goodsID withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"commpropertystock" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"commodityid" : goodsID}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self postPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
		if (block) {
			block(multiAttributes, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)submitOrder:(NSString *)orderDescribe withBlock:(void (^)(NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"order_submit" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"receiver" : @"", @"recadd" : @"", @"recphone" : @"", @"cartlist" : orderDescribe}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		BOOL success = NO;
		NSString *message;
		if (jsonValue[kReturnObj]) {
			if (jsonValue[kReturnObj][@"StatusFlag"]) {
				success = [jsonValue[kReturnObj][@"StatusFlag"] isEqualToString:@"1"];
			}
			if (jsonValue[kReturnObj][@"StatusRemark"]) {
				message = [NSString stringWithFormat:@"%@", jsonValue[kReturnObj][@"StatusRemark"]];
			}
		}
		NSError *error = nil;
		if (!success) {
			error = [NSError errorWithDomain:DSH_ERROR_DOMAIN code:DSH_ERROR_CODE userInfo:@{DSH_ERROR_USERINFO_ERROR_MESSAGE : message ?: NSLocalizedString(@"未知错误", nil)}];
		}
		if (block) {
			block(error);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(error);
		}
	}];
}

- (void)contacts:(NSString *)queryString page:(NSUInteger)page pagesize:(NSString *)pagesize withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block
{
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comp_personinfos" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"qvalue" : queryString ?: @"", @"pagenum" : @(page), @"pagesize" : pagesize ?: @"20"}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
		if (block) {
			block(multiAttributes, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)officeDepotWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block {
	NSDictionary *normalParameters = @{kAPIKeyAction : @"getofficedepotlist" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
		if (block) {
			block(multiAttributes, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)detailOfPayroll:(NSString *)period withBlock:(void (^)(NSDictionary *attributes, NSError *error))block {
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comp_payroll_detail" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"period" : period}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		NSLog(@"jsonValue: %@", jsonValue);
		NSDictionary *attributes = jsonValue[@"retobj"];
		if (block) {
			block(attributes, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}


- (void)companyPayRoll:(void (^)(NSArray *multiAttributes, NSError *error))block {
    NSString *loginname = @"\"loginname\"";
    NSString *decompile = @"\"";
    NSString *loginadmin = [[JAFHTTPClient shared] userName];
    NSString *decompiles = @"\"";
    NSString *logincomplete = [NSString stringWithFormat:@"%@%@%@",decompile,loginadmin,decompiles];
    NSString *strUrl = [NSString stringWithFormat:@"http://cloud.joy121.com/AjaxPage/app/Msg.ashx?action=comp_payroll_list&json={%@:%@}" ,loginname,logincomplete];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getPath:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"this data:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id jsonValue = [self jsonValue:responseObject];
        NSArray *multiAttributes = jsonValue[@"retobj"];
        if (block) {
            block(multiAttributes, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

- (void)submitDepotRent:(NSString *)depotID number:(NSNumber *)number withBlock:(void (^)(NSError *error))block {
	NSDictionary *normalParameters = @{kAPIKeyAction : @"submitofficerent" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"depotid" : depotID, @"rentnum" : number}];
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (block) {
			block(nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(error);
		}
	}];
}

- (void)performanceIsEncourage:(BOOL)isEncourage WithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block {
	NSDictionary *normalParameters = @{kAPIKeyAction : @"get_person_performance_list" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"reporttype" : @"2"}];
	if (isEncourage) {
		jsonParameters = [self addLoginName:@{@"reporttype" : @"1"}];
	}
	
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
		if (block) {
			block(multiAttributes, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)encourageDetailsWithReportCaseID:(NSString *)reportCaseID withblock:(void (^)(NSArray *multiAttributes, NSError *error))block {
	NSDictionary *normalParameters = @{kAPIKeyAction : @"comp_performance_detail" , @"token" : [self getToken]};
	NSDictionary *jsonParameters = [self addLoginName:@{@"reportcaseid" : reportCaseID}];
	
	NSDictionary *parameters = [self normalParamters:normalParameters addJSONParameters:jsonParameters];
	
	[self getPath:kAPIInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id jsonValue = [self jsonValue:responseObject];
		NSArray *multiAttributes = jsonValue[@"retobj"];
		if (block) {
			block(multiAttributes, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

#pragma mark - utilities

- (NSString *)createJsonStringWithParam:(NSDictionary *)param
{
    NSArray *keys = [param allKeys];
    NSMutableString *json = [@"{" mutableCopy];
    for (int i = 0; i < keys.count; i ++) {
        NSString *keyValue = [NSString stringWithFormat:@"\"%@\":\"%@\"", keys[i], param[keys[i]]];
        [json appendString:keyValue];
        if ((i + 1) != keys.count) {
            [json appendString:@","];
        }
    }
    [json appendString:@"}"];
    return json;
}

- (id)jsonValue:(id)JSON
{
	if (![JSON isKindOfClass:[NSData class]] || !JSON) {
		return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingAllowFragments error:nil];
}

- (NSDictionary *)addLoginName:(NSDictionary *)parameters
{
	NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
	newParameters[@"loginname"] = [self userName];
	return newParameters;
}

- (NSDictionary *)addCompanyName:(NSDictionary *)parameters
{
	NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
	newParameters[@"company"] = [self companyName];
	return newParameters;
}

- (NSDictionary *)addLoginNameAndCompanyName:(NSDictionary *)parameters
{
	return [self addCompanyName:[self addLoginName:parameters]];
}

- (NSDictionary *)normalParamters:(NSDictionary *)parameters addJSONParameters:(NSDictionary *)JSONParamters
{
	NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
	newParameters[@"json"] = [self createJsonStringWithParam:JSONParamters];
	return newParameters;
}

#pragma 入职离职

+ (AFHTTPClient *)http {
    static AFHTTPClient *httpClient = nil;
    if (!httpClient) {
        httpClient = [[JAFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://cloud.joy121.com:999/"]];
        [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        httpClient.parameterEncoding = AFFormURLParameterEncoding;
    }
    return httpClient;
}

- (void)getModulesByCompany:(void (^)(NSArray *multiAttributes, NSError *error))block {
    NSDictionary *parameters = @{
                                 @"loginName": [self userName]};
    [[JAFHTTPClient http] getPath:@"api/SysData/GetModulesByCompany" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        NSArray *multiAttributes = jsonValue[@"retobj"];
        if (block) {
            block(multiAttributes, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)getSysDataWithType:(NSString *)type
                       parentId:(int)parentId
                        success:(void (^)(NSArray *sysDatas))success
                        failure:(void (^)(NSString *msg))failure {
    NSDictionary *parameters = @{
                                 @"loginName": [self userName],
                                 @"type": type,
                                 @"parentId": @(parentId)};
    [[JAFHTTPClient http] getPath:@"api/Entry/GetSysData" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"this data: -> \n%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id jsonValue = [self jsonValue:responseObject];
        NSLog(@"jsonValue --->\n%@", jsonValue);
        int retCode = [[jsonValue objectForKey:@"RetCode"] intValue];
        NSString *retMsg = [jsonValue objectForKey:@"retMsg"];
        NSArray *retObj = [jsonValue objectForKey:@"RetObj"];
        if (retCode == 1 && retObj) {
            success([JSysData objectArrayWithKeyValuesArray:retObj]);
        } else {
            failure(retMsg);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.description);
    }];
}

- (void)getPersonInfo:(void (^)(JPersonInfo *personInfo))success
              failure:(void (^)(NSString *msg))failure {
    NSDictionary *parameters = @{@"loginName": [self userName]};
    [[JAFHTTPClient http] getPath:@"api/Entry/GetPersonInfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"this data:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        id jsonValue = [self jsonValue:responseObject];
        NSLog(@"jsonValue --->\n%@", jsonValue);
        NSString *retMsg = [jsonValue objectForKey:@"RetMsg"];
        int retCode = [[jsonValue objectForKey:@"RetCode"] intValue];
        NSArray *retObj = [jsonValue objectForKey:@"RetObj"];
        if (retCode == 1 && retObj) {
            JPersonInfo *info = [JPersonInfo objectWithKeyValues:retObj];
            NSDictionary *dict = [info keyValues];
            for (id key in dict){
                id obj = [dict objectForKey:key];
                if ([obj isKindOfClass:[NSString class]]) {
                    if ([obj rangeOfString:@"/Date("].length > 0) {
                        [info setValue:[obj getCorrectDateWithoutTime] forKey:key];
                    }
                }
            }
            success(info);
        } else {
            failure(retMsg);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.description);
    }];
}

- (void)updatePersonInfo:(JPersonInfo *)personInfo
                 success:(void (^)())success
                 failure:(void (^)(NSString *))failure {
    NSString *personInfoJson = [personInfo JSONString];
    NSString *params = [NSString stringWithFormat:@"persioninfo=%@", personInfoJson];
    
    NSMutableURLRequest *request = [[JAFHTTPClient http] multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"api/Entry/PostUpdatePersonInfo?handleType=modify&loginName=%@", [self userName]] parameters:nil constructingBodyWithBlock:nil];
    NSLog(@"personInfoJson --->\n%@", personInfoJson);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        NSLog(@"jsonValue --->\n%@", jsonValue);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    [operation start];
    
}

- (void)uploadFile:(NSData *)data
           success:(void (^)(NSString *))success
           failure:(void (^)(NSString *))failure {
    NSMutableURLRequest *request = [[JAFHTTPClient http] multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"api/UpFile/PostFile?fileType=image&activityName=avatar&loginname=%@", [self userName]] parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonValue = [self jsonValue:responseObject];
        NSLog(@"jsonValue --->\n%@", jsonValue);
        
        NSString *retMsg = [jsonValue objectForKey:@"RetMsg"];
        int retCode = [[jsonValue objectForKey:@"RetCode"] intValue];
        NSString *retFilePath = [jsonValue objectForKey:@"RetFilePath"];
        if (retCode == 1 && retFilePath) {
            success(retFilePath);
        } else {
            failure(retMsg);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure(error.description);
    }];
    [[JAFHTTPClient http] enqueueHTTPRequestOperation:operation];
}

@end


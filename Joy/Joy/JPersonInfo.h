//
//  JPersonInfo.h
//  Joy
//
//  Created by gejw on 15/8/21.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JJob, JLearning, JExperiences, JFamily, JIdimage, JMaterials;

@interface JPersonInfo : NSObject

@property (nonatomic, copy) NSString *Company;

@property (nonatomic, copy) NSString *ComDep;

@property (nonatomic, copy) NSString *LoginName;

@property (nonatomic, copy) NSString *IsUser;

@property (nonatomic, copy) NSString *WorkPlace;

@property (nonatomic, assign) NSInteger CurrentStep;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *EmployeeId;

@property (nonatomic, copy) NSString *ComGrade;

@property (nonatomic, copy) NSString *Email;

@property (nonatomic, copy) NSString *IsEmployed;

@property (nonatomic, assign) NSInteger TotalStep;

@property (nonatomic, copy) NSString *CompanyName;

@property (nonatomic, copy) NSString *ComEntryDate;

@property (nonatomic, copy) NSString *DegreeNo;

@property (nonatomic, copy) NSString *ComPos;

@property (nonatomic, copy) NSString *QQ;

@property (nonatomic, copy) NSString *DepositBank;

@property (nonatomic, copy) NSString *IntroducedText;

@property (nonatomic, copy) NSString *UrgentContact;

@property (nonatomic, copy) NSString *ContactStartDate;

@property (nonatomic, copy) NSString *ContactEndDate;

@property (nonatomic, copy) NSString *EnglishName;

@property (nonatomic, copy) NSString *LifeInsureStartDate;

@property (nonatomic, assign) NSInteger LifeInsureFee;

@property (nonatomic, copy) NSString *Group;

@property (nonatomic, copy) NSString *ComReporter;

@property (nonatomic, copy) NSString *IntroducedVideo;

@property (nonatomic, copy) NSString *Mobile;

@property (nonatomic, copy) NSString *Interesting;

@property (nonatomic, copy) NSString *Gender;

@property (nonatomic, copy) NSString *UrgentMobile;

@property (nonatomic, copy) NSString *Residence;

@property (nonatomic, copy) NSString *IdNo;

@property (nonatomic, copy) NSString *EducationNo;

@property (nonatomic, copy) NSString *DepositCardNo;

@property (nonatomic, copy) NSString *CreateTime;

@property (nonatomic, copy) NSString *Regions;

@property (nonatomic, copy) NSString *Phone;

@property (nonatomic, copy) NSString *SalaryGrade;

@property (nonatomic, copy) NSString *PersonName;
// 个人经历
@property (nonatomic, copy) NSString *Experiences;
// 附件信息
@property (nonatomic, copy) NSString *Materials;
// 家庭
@property (nonatomic, copy) NSString *Family;

@property (nonatomic, copy) NSString *Flag;

@property (nonatomic, copy) NSString *AccumFund;

@property (nonatomic, copy) NSString *TrialDate;

@property (nonatomic, copy) NSString *BirthDay;

+ (JPersonInfo *)person;

+ (void)setPerson:(JPersonInfo *)person;

@end

#pragma 个人经历

@interface JExperiences : NSObject

@property (nonatomic, strong) NSArray *Job;

@property (nonatomic, strong) NSArray *Learning;

@end

@interface JJob : NSObject

@property (nonatomic, copy) NSString *Achievement;

@property (nonatomic, copy) NSString *Position;

@property (nonatomic, copy) NSString *SDate;

@property (nonatomic, copy) NSString *EDate;

@property (nonatomic, copy) NSString *Company;

@end

@interface JLearning : NSObject

@property (nonatomic, copy) NSString *Achievement;

@property (nonatomic, copy) NSString *Profession;

@property (nonatomic, copy) NSString *SDate;

@property (nonatomic, copy) NSString *EDate;

@property (nonatomic, copy) NSString *School;

@end

#pragma 家庭信息

@interface JFamily : NSObject

@property (nonatomic, copy) NSString *Birthday;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *RelationShip;

@end

#pragma 附件信息

@interface JMaterials : NSObject

@property (nonatomic, strong) JIdimage *IDImage;

@property (nonatomic, copy) NSString *Certificates;

@property (nonatomic, copy) NSString *LearningCertificate;

@property (nonatomic, copy) NSString *Retirement;

@property (nonatomic, copy) NSString *Physical;

@property (nonatomic, copy) NSString *Video;


@end

@interface JIdimage : NSObject

@property (nonatomic, copy) NSString *Positive;

@property (nonatomic, copy) NSString *Reverse;

@end

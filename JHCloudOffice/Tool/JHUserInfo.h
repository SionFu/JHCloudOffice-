//
//  JHUserInfo.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface JHUserInfo : NSObject
singleton_interface(JHUserInfo)
/**
 *  用户手机号
 */
@property (nonatomic, strong) NSString *mobile;
/**
 *  用户id
 */
@property (nonatomic, strong) NSString *objectId;
/**
 *  用户登录名
 */
@property (nonatomic, strong) NSString *code;
/**
 *  WeaverUser : {
	sessionKey : 2125B69C4AB2AB5DFCE13A735A4AAB1D,
	uid : 1280,
	loginid : hjq
 },
 */
@property (nonatomic, strong) NSString *sessionKey;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *loginid;
@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *traceMessage;
/**
 *  用户显示名称
 */
@property (nonatomic, strong) NSString *name;


@property (nonatomic, strong) NSString *companyObjectId;
/**
 *  公司信息
 */
@property (nonatomic, strong) NSString *company;

@end

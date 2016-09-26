//
//  JHUserDefault.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/28.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHUserDefault : NSObject
/**
 *  存入账号密码
 *
 *  @param userName 用户名
 *  @param userPwd  密码
 */
+(void)remberUserName:(NSString *)userName andUserPwd:(NSString *)userPwd;
/**
 *  返回是否自动登录
 *
 *  @return user 有值返回 YES
 */
+(BOOL)autoLogin;
/**
 *  清除名户名密码
 */
+(void)clearUser;
/**
 *  返回用户名
 */
+(NSString* )getUserName;
/**
 *  返回密码
 */
+(NSString *)getPwd;


@end

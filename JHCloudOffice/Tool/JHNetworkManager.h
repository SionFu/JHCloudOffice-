//
//  JHNetworkManager.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
/**
 *  登陆返回的情况
 */
@protocol JHLoginDelegate <NSObject>

/**
 *  登陆成功
 */
- (void) loginSuccess;
- (void) loginfaild;
- (void) loginNetError;
@end
@interface JHNetworkManager : NSObject
singleton_interface(JHNetworkManager)
@property (nonatomic, weak) id<JHLoginDelegate> loginDelegate;
/**
 *  用户名密码登陆
 */
+ (void) vaidataUserWithUserName:(NSString *)user andPassword:(NSString *)password;
/**
 *  获取流程列表
 */
+ (void) getModules;
@end

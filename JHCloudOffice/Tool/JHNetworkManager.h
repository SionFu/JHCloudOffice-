//
//  JHNetworkManager.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "JHModules.h"
/**
 *  获取人员组织返回情况
 */
@protocol JHOrguser <NSObject>
/**
 *  成功获取组织人员结构
 */
- (void) getOrguserSuccess;
@end
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
/**
 *  开始获取流程数据
 */
- (void) beginGetModules;
@end
/**
 *  返回获取page数据的情况
 */
@protocol JHPageDelegate <NSObject>

/**
 *  获取发起流程数据成功
 */
- (void) getPageSuccess;
- (void) getPageDatasSuccess;
- (void) getPagefaild;
- (void) getsetSingleParticipantFromServerSucceed;
- (void) getsetSingleParticipantFromServerfaild;

@end
@interface JHNetworkManager : NSObject
singleton_interface(JHNetworkManager)
@property (nonatomic, weak) id<JHLoginDelegate> loginDelegate;
@property (nonatomic, weak) id<JHPageDelegate> getPageDelegate;
@property (nonatomic, weak) id<JHOrguser> getOrguserDelegate;
/**
 *  用户名密码登陆
 */
+ (void) vaidataUserWithUserName:(NSString *)user andPassword:(NSString *)password;
/**
 *  获取流程列表
 */
- (void) getModules;
/**
 *  获取流程配置
 */
- (void)getPageSettingWithCurrentVC:(NSInteger)currentIndex andRow:(NSInteger)sectionRow;
/**
 *  获取流程选择菜单二级菜单内容save 内容
 */
-(void)getPageSaverSettingWith:(NSDictionary *)parameters;
/**
 *  储存当面流程的SheetCode 接口文件名 流程编码等模型
 */
@property (nonatomic, strong) JHModules *modulesModel;
/**
 *  获取流程数据
 */
- (void)getPageDatas;
/**
 *  获取用户组织
 */
- (void)getUsersWithDic:(NSDictionary *)dic;

/**
 *  上传数据!!!未实现
 */
- (void)uploadDatasWithData:(NSArray *)uploadData andInstanceName:(NSString *)pageName;
@end

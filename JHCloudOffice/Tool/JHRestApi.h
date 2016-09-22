//
//  JHRestApi.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/8.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
//Instances
/**
 *  获取 流程
 */
@protocol JHGetInstancesDelegate <NSObject>

- (void)getInstancesSuccess;
- (void)getInstancesFaild;

@end
/**
 *  获取待办 阅办
 */
@protocol JHGetTaskDelegate <NSObject>

- (void)getTaskSuccess;
- (void)getTaskFaild;

@end
/**
 *下载附件(巨化报)代理
 */
@protocol JHDownPFileDelegate <NSObject>

- (void)downFileSuccess;
- (void)downFileFaild;

@end
/**
 *  获取 Queue 公司推送通知内容
 */
@protocol JHQueueObjectsDelegate <NSObject>

- (void)getQueueObjectsSuccess;

@end
/**
 *  取消和获取订阅代理
 */
@protocol JHFollowAndCancelSubscribeDelegate <NSObject>

- (void)foolwSubcribeSuccess;
- (void)cancelSubscribeSuccess;

@end
/**
 *  获取订阅列表代理
 */
@protocol JHGetPoiListDelegate <NSObject>

//获取通知后返回通知结果
- (void)getPoiListSuccess;
@end
/**
 *  获取通知代理
 */
@protocol JHGetNotificationObjectDelegate <NSObject>

//获取通知后返回通知结果
- (void)getNoticationSuccess;
@end
@interface JHRestApi : NSObject

@property (nonatomic, weak) id<JHGetInstancesDelegate>getInstancesDelegate;
@property (nonatomic, weak) id<JHGetTaskDelegate>getTaskDelegate;
@property (nonatomic, weak) id<JHDownPFileDelegate>downFileDelegate;
@property (nonatomic ,weak) id<JHQueueObjectsDelegate>getQueueObjectsDelegate;
@property (nonatomic, weak) id<JHFollowAndCancelSubscribeDelegate>subscribeDelegate;
@property (nonatomic, weak) id<JHGetPoiListDelegate> getPoiListdDelegate;
@property (nonatomic, weak) id<JHGetNotificationObjectDelegate>getNotificationDelegate;
/**
 *  获取全部订阅消息
 */
- (void)subscribeObjectsGetSubscribeObjectsWithAction:(NSString *)action;
/**
 *  获取本公司订阅内容
 */
- (void)pushQueueObjectsGetPushQueueObjectsWithPublicGuid:(NSString *)publicGuid andPageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex;
/**
 *  删除通知 公司内部通知
 */
- (void)resultPojoDeletePushQueueObjectWithPqid:(NSString *)pqid;
/**
 *  传入subscribe[PUBLICCODE] 取消订阅此内容
 */
- (void)resultPojoCancelSubscribeWithSubscribe:(NSString *)subscribe;
/**
 *  传入subscribe[PUBLICCODE] 订阅此内容
 */
- (void)subscribeObjectFollowSubscribeWithSubscribe:(NSString *)subscribe;
/**
 *  获取主页通知数
 */
- (void)notificationObjectGetNotificationWithTime:(NSString *)lastTime;
/**
 *  检查是否订阅, 直接从所有列表中获取数据
 */
+ (NSDictionary *)getObjectFollowSubscribeInAllListWithPublicCode:(NSString *)publicCode;
/**
 *  downloadFile
 */
- (void)downloadFileWithPURL:(NSString *)pUrl AndFileName:(NSString *)fileName;
/**
 *  获取待办 
 */
- (void)moduleTaskItemsGetTasksWithSheet:(NSString *)sheet andCode:(NSString *)code andStates:(NSString *)states andKey:(NSString *)key andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andSort:(NSString *)sort  andDescOrAsc:(NSString *)descOrAsc andPageSize:(int)pageSize andPageIndex:(int)pageIndex;
/**
 *  我的流程
 */
- (void)moduleInstancesGetInstancesWithCode:(NSString *)code andVersion:(NSString *)version andStates:(NSString *)states andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andKey:(NSString *)key andSort:(NSString *)sort andisasc:(NSString *)isasc andPageSize:(int)pageSize andPageIndex:(int)pageIndex;
@end

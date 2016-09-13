//
//  JHRestApi.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/8.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
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
- (void)pushQueueObjectsGetPushQueueObjectsWithUserid:(NSString *)userid andPublicGuid:(NSString *)publicGuid andPageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex;
/**
 *  删除通知
 */
//- (void)resultPojoDeletePushQueueObjectWithUserid:(NSString *)userid andPqid:(NSString *)pqid;
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
@end

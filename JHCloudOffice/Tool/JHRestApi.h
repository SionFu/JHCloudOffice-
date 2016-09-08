//
//  JHRestApi.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/8.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  获取通知代理
 */
@protocol JHGetNotificationObjectDelegate <NSObject>
//获取通知后返回通知结果
- (void)getNoticationSuccess;
@end
@interface JHRestApi : NSObject
@property (nonatomic,weak) id<JHGetNotificationObjectDelegate>getNotificationDelegate;
- (void)notificationObjectGetNotificationWithTime:(NSString *)lastTime;
@end

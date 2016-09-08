//
//  JHRestApi.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/8.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHRestApi.h"
#import "JHNetworkManager.h"
#import "JHUserInfo.h"
@implementation JHRestApi
- (void)notificationObjectGetNotificationWithUserId:(NSString *)UserId andUserCode:(NSString *)userCode andUser:(NSString *)user andTime:(NSString *)time andToken:(NSString *)token andPassword:(NSString *)password {
    //userId,"", "", notifiTime, sessionKey,user.getToken(), new NotificationInfoPojoCallback
    //userId,userCode,user,time,token, password
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/Notification.ashx?appKey=%@&token=%@&action=get&userCode=%@&user=%@&userId=%@&time=%@&password=%@",SITEURL,APPKEY,[JHUserInfo sharedJHUserInfo].sSOKey,[JHUserInfo sharedJHUserInfo].code,[JHUserInfo sharedJHUserInfo].code,[JHUserInfo sharedJHUserInfo].objectId,time,[[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)notificationObjectGetNotificationWithTime:(NSString *)lastTime {
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/Notification.ashx?appKey=%@&token=%@&action=get&userCode=%@&user=%@&userId=%@&time=%@&password=%@",SITEURL,APPKEY,[JHUserInfo sharedJHUserInfo].sessionKey,[JHUserInfo sharedJHUserInfo].code,[JHUserInfo sharedJHUserInfo].code,[JHUserInfo sharedJHUserInfo].objectId,lastTime,[[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"%@",urlStr);
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [JHUserInfo sharedJHUserInfo].notificationDic = responseObject;
        [self.getNotificationDelegate getNoticationSuccess];
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end

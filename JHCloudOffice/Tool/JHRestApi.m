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
#import "JHPoiModel.h"
#import "JHTaskModel.h"
#import "JHInstancesModel.h"
@implementation JHRestApi
- (void)notificationObjectGetNotificationWithTime:(NSString *)lastTime {
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/Notification.ashx?appKey=%@&token=%@&action=get&userCode=%@&user=%@&userId=%@&time=%@&password=%@",SITEURL,APPKEY,[JHUserInfo sharedJHUserInfo].sessionKey,[JHUserInfo sharedJHUserInfo].code,[JHUserInfo sharedJHUserInfo].code,[JHUserInfo sharedJHUserInfo].objectId,lastTime,[[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [JHUserInfo sharedJHUserInfo].notificationDic = responseObject;
        [self.getNotificationDelegate getNoticationSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)subscribeObjectsGetSubscribeObjectsWithAction:(NSString *)action {
    NSString *urlStr = [NSString stringWithFormat:@"%@RestAPI/Subscribe.ashx?appKey=%@&action=%@&userid=%@&platform=ios",SITEURL,APPKEY,action,[JHUserInfo sharedJHUserInfo].objectId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
        if ([action isEqualToString:@"list"]) {
           [JHPoiModel sharedJHPoiModel].listData = responseObject;
        } else if ([action isEqualToString:@"alllist"]) {
           [JHPoiModel sharedJHPoiModel].allListData = responseObject;
        }
     
        [self.getPoiListdDelegate getPoiListSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)resultPojoCancelSubscribeWithSubscribe:(NSString *)subscribe {
        NSString *urlStr = [NSString stringWithFormat:@"%@RestAPI/Subscribe.ashx?appKey=%@&action=cancel&userid=%@&subscribe=%@",SITEURL,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,subscribe];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.subscribeDelegate cancelSubscribeSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)subscribeObjectFollowSubscribeWithSubscribe:(NSString *)subscribe {
        NSString *urlStr = [NSString stringWithFormat:@"%@RestAPI/Subscribe.ashx?appKey=%@&action=follow&userid=%@&subscribe=%@",SITEURL,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,subscribe];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.subscribeDelegate foolwSubcribeSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
+(NSDictionary *)getObjectFollowSubscribeInAllListWithPublicCode:(NSString *)publicCode {
    NSDictionary *poiDic;
    for (NSDictionary *allPoiDic in [JHPoiModel sharedJHPoiModel].allListArray) {
        if ([allPoiDic[@"PUBLICCODE"] isEqualToString:publicCode]) {
            poiDic = allPoiDic;
        }
    }
    return poiDic;
}
-(void)pushQueueObjectsGetPushQueueObjectsWithPublicGuid:(NSString *)publicGuid andPageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex {
    NSString *urlStr = [NSString stringWithFormat:@"%@RestAPI/Subscribe.ashx?appKey=%@&action=queue&userid=%@&publicGuid=%@&pageSize=%@&pageIndex=%@",SITEURL,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,publicGuid,pageSize,pageIndex];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [JHPoiModel sharedJHPoiModel].queueData = responseObject;
        [self.getQueueObjectsDelegate getQueueObjectsSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)resultPojoDeletePushQueueObjectWithPqid:(NSString *)pqid{
    NSString *urlStr = [NSString stringWithFormat:@"%@RestAPI/Subscribe.ashx?appKey=%@&action=deletepush&userid=%@&pqid=%@",SITEURL,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,pqid];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:nil failure:nil];
}
-(void)downloadFileWithPURL:(NSString *)pUrl AndFileName:(NSString *)fileName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    documentPath = [documentPath stringByAppendingPathComponent:[JHUserInfo sharedJHUserInfo].loginid];
    [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    //下载文件
    //    NSLog(@"%@",filePath);
    pUrl = [pUrl stringByReplacingOccurrencesOfString:@"h3.juhua.com.cn" withString:@"h3.juhua.com.cn/portal"];
    NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pUrl]];
    if ([[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil]){
        [self.downFileDelegate downFileSuccess];
    }else {
        [self.downFileDelegate downFileFaild];
    }

}
-(void)moduleTaskItemsGetTasksWithSheet:(NSString *)sheet andCode:(NSString *)code andStates:(NSString *)states andKey:(NSString *)key andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andSort:(NSString *)sort andDescOrAsc:(NSString *)descOrAsc andPageSize:(int)pageSize andPageIndex:(int)pageIndex {
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&token=%@&code=%@&action=task&userId=%@&states=%@&key=%@&sort=%@&isasc=%@&startTime=%@&endTime=%@&pageSize=%d&pageIndex=%d",SITEURL,sheet,APPKEY,[JHUserInfo sharedJHUserInfo].sessionKey,code,[JHUserInfo sharedJHUserInfo].objectId,states,key,sort,descOrAsc,startTime,endTime,pageSize,pageIndex];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\nTask:%@,url:%@",responseObject,urlStr);
        [JHTaskModel sharedJHTaskModel].taskDataDic = responseObject;
        [self.getTaskDelegate getTaskSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.getTaskDelegate getTaskFaild];
    }];
}
- (void)moduleInstancesGetInstancesWithCode:(NSString *)code andVersion:(NSString *)version andStates:(NSString *)states andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andKey:(NSString *)key andSort:(NSString *)sort andisasc:(NSString *)isasc andPageSize:(int)pageSize andPageIndex:(int)pageIndex {
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/DefaultSheet.ashx?appKey=%@&token=%@&action=instance&code=%@&version=%@&userId=%@&states=%@&key=%@&sort=%@&isasc=%@&startTime=%@&endTime=%@&pageSize=%d&pageIndex=%d",SITEURL,APPKEY,[JHUserInfo sharedJHUserInfo].sessionKey,code,version,[JHUserInfo sharedJHUserInfo].objectId,states,key,sort,isasc,startTime,endTime,pageSize,pageIndex];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [JHInstancesModel sharedJHInstancesModel].instancesDataDic = responseObject;
        [JHTaskModel sharedJHTaskModel].taskDataDic = responseObject;
        [self.getInstancesDelegate getInstancesSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.getInstancesDelegate getInstancesFaild];
    }];
}

@end

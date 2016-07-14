//
//  JHNetworkManager.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHNetworkManager.h"
#import "AFNetworking.h"
#import "JHUserInfo.h"
#import "JHModules.h"
#import "JHModulesData.h"
#import "JHPageDataManager.h"

#define SITEURL @"http://h3.juhua.com.cn/Portal/ForApp/"
//#define SITEURL @"http://188.1.100.165:8010/Portal/ForApp/"
#define APPKEY @"cloudoffice"

@implementation JHNetworkManager
singleton_implementation(JHNetworkManager)



+ (void)vaidataUserWithUserName:(NSString *)user andPassword:(NSString *)password{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/DefaultSheet.ashx?appKey=%@&action=validateuser&userCode=%@&password=%@",SITEURL,APPKEY,user,password];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
#warning 有打印
        NSLog(@"%@",responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *dic = responseObject;
            JHNetworkManager *loginManger = [JHNetworkManager sharedJHNetworkManager];
            [loginManger loginResults:dic];
           } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"登陆失败%@",error.userInfo);
            JHNetworkManager *loginManger = [JHNetworkManager sharedJHNetworkManager];
            [loginManger loginResults:error.userInfo];
    }];
}
- (void)loginResults:(NSDictionary *)dic{
    if ([dic[@"ErrorCode"] isEqualToString:@"30003"]) {
        [JHUserInfo sharedJHUserInfo].errorCode = dic[@"ErrorMessage"];
        [self.loginDelegate loginfaild];
        return;
    }
    if ([dic[@"ErrorCode"] isEqualToString:@"30001"]) {
        [JHUserInfo sharedJHUserInfo].errorCode = dic[@"ErrorMessage"];
        [self.loginDelegate loginfaild];
        return;
    }
    if (dic[@"ErrorCode"] == nil||[dic[@"_kCFStreamErrorCodeKey"]  isEqual: @"-2102"]){
        [self.loginDelegate loginNetError];
        return;
    }
    if (dic[@"Name"] != nil) {
    [self.loginDelegate loginSuccess];
    [JHUserInfo sharedJHUserInfo].objectId = dic[@"ObjectId"];
    [JHUserInfo sharedJHUserInfo].code = dic[@"Code"];
    [JHUserInfo sharedJHUserInfo].name = dic[@"Name"];
    [JHUserInfo sharedJHUserInfo].mobile = dic[@"Mobile"];
    [JHUserInfo sharedJHUserInfo].company = dic[@"Company"];
        [JHUserInfo sharedJHUserInfo].uid = dic[@"WeaverUser"][@"uid"];
        
    }
}

- (void)getModules {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/DefaultSheet.ashx?appKey=%@&token=%@&action=modules&create=1&userId=%@", SITEURL, APPKEY, [JHUserInfo sharedJHUserInfo].objectId, [JHUserInfo sharedJHUserInfo].uid];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
# warning 有打印
        NSLog(@"%@",responseObject);
        NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"Modules.plist"];
#warning 本地化数据
        [responseObject writeToFile:filepath atomically:YES];
        
        NSArray *array = responseObject[@"datas"];
        [JHModulesData sharedJHModulesData].count = responseObject[@"count"];
        [JHModulesData sharedJHModulesData].errorCode = responseObject[@"ErrorCode"];
        for (NSDictionary *dic in array) {
            JHModules *modu = [JHModules new];
            [modu setValuesForKeysWithDictionary:dic];
//            NSLog(@"%@",modu);
            [[JHModulesData sharedJHModulesData].modulesArray addObject:modu];
        }
        //将流程数组分类保存
        [JHModulesData getModulesArray];
        [self.loginDelegate beginGetModules];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self.loginDelegate loginNetError];
    }];
}


- (void)getPageSettingWithCurrentVC:(NSInteger)currentIndex andRow:(NSInteger)sectionRow{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    JHModules *module = [JHModulesData sharedJHModulesData].allModuleArray[currentIndex][sectionRow];
    self.modulesModel =  module;
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&token=%@&action=page&code=%@&version=%@&activity=%@&userId=%@&instance=nil&item=nil&viewmode=false", SITEURL,self.modulesModel.StartSheetCode,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,module.ModuleCode,module.ModuleVersion,module.StartActivityCode,[JHUserInfo sharedJHUserInfo].uid];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
#warning 本地化数据
    NSString *filepath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:responseObject[@"ModuleName"]]stringByAppendingPathExtension:@"plist"];
//        NSLog(@"%@",responseObject);
        [responseObject writeToFile:filepath atomically:YES];
        NSDictionary *dicAllPageData = [NSDictionary dictionaryWithContentsOfFile:filepath];
        
        //获取流程里的	StartActivityCode : Activity?
        int i = 0;
            for (NSDictionary *activitys in dicAllPageData[@"Activitys"]) {
                i ++;
                if ( [module.StartActivityCode isEqualToString:activitys[@"ActivityCode"]]) {
                   [JHPageDataManager sharedJHPageDataManager].pageVisibleItemArray = [NSArray arrayWithArray:dicAllPageData[@"Activitys"][i][@"DataItemPermissions"]];
                }
            }
        //值获取其中的一个流程
//        [JHPageDataManager sharedJHPageDataManager].pageVisibleItemArray = [NSArray arrayWithArray:dicAllPageData[@"Activitys"][2][@"DataItemPermissions"]];
        
        [JHPageDataManager sharedJHPageDataManager].pageDataItemsArray = [NSMutableArray arrayWithArray:dicAllPageData[@"DataItems"]];
        //反回获取流程菜单数据代理
        [self.getPageDelegate getPageSuccess];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.getPageDelegate getPagefaild];
    }];
}


-(void)getPageSaverSettingWith:(NSDictionary *)parameters{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSArray *datas = [NSArray arrayWithObject:parameters];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&action=source&code=%@&version=%@&instance=null&item=null&field=wldl&activity=%@&user=%@", SITEURL,self.modulesModel.StartSheetCode,APPKEY,self.modulesModel.ModuleCode,self.modulesModel.ModuleVersion,self.modulesModel.StartActivityCode,[JHUserInfo sharedJHUserInfo].objectId];
//    NSString *urlStr = @"http://h3.juhua.com.cn/Portal/ForApp/Sheets/ceshi.ashx?appKey=cloudoffice&action=source&code=ceshi&version=2&instance=null&item=null&field=wldl&key=&type=&activity=Activity2&user=f0bbd1cc-7727-449c-ba74-e63dca84f9f1";
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:datas options:kNilOptions error:nil];
    NSString *strJson = [[NSString alloc]initWithData:dataJson encoding:NSUTF8StringEncoding];
     NSDictionary *dicc = [NSDictionary dictionaryWithObject:strJson forKey:@"datas"];
    AFHTTPRequestOperationManager *mangerr = [AFHTTPRequestOperationManager manager];
    [mangerr POST:urlStr parameters:dicc constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"接收成功%@",responseObject);
        
        //给接收数组赋值
        [JHPageDataManager sharedJHPageDataManager].sourceFromServerArray = [NSMutableArray arrayWithArray:responseObject[@"datas"]];
        [self.getPageDelegate getsetSingleParticipantFromServerSucceed];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}
-(void)getPageDatas{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&token=%@&action=data&code=%@&version=%@&activity=%@&userId=%@&viewmode=false", SITEURL,self.modulesModel.StartSheetCode,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,self.modulesModel.ModuleCode,self.modulesModel.ModuleVersion,self.modulesModel.StartActivityCode,[JHUserInfo sharedJHUserInfo].objectId];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取详细信息成功:%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取详细信息失败%@",error);
    }];

}
-(void)getUsers{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&token=%@&action=orguser&code=%@&version=%@&activity=%@&userId=%@&viewmode=false", SITEURL,self.modulesModel.StartSheetCode,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,self.modulesModel.ModuleCode,self.modulesModel.ModuleVersion,self.modulesModel.StartActivityCode,[JHUserInfo sharedJHUserInfo].objectId];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}
@end

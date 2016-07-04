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
#define SITEURL @"http://188.1.100.165:8010/Portal/ForApp/"
#define APPKEY @"cloudoffice"

@implementation JHNetworkManager
singleton_implementation(JHNetworkManager)



+ (void)vaidataUserWithUserName:(NSString *)user andPassword:(NSString *)password{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/DefaultSheet.ashx?appKey=%@&action=validateuser&userCode=%@&password=%@",SITEURL,APPKEY,user,password];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
#warning 有打印
        NSLog(@"%@",responseObject);
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
            NSLog(@"%@",modu);
            [[JHModulesData sharedJHModulesData].modulesArray addObject:modu];
        }
        //将流程数组分类保存
        [JHModulesData getModulesArray];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)getPageSettingWithCurrentVC:(NSInteger)currentIndex andRow:(NSInteger)sectionRow{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    JHModules *module = [JHModulesData sharedJHModulesData].allModuleArray[currentIndex][sectionRow];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&token=%@&action=page&code=%@&version=%@&activity=%@&userId=%@item=nil&instance=nil&item=nil&viewmode=false", SITEURL, module.StartSheetCode,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,module.ModuleCode,module.ModuleVersion,module.StartActivityCode,[JHUserInfo sharedJHUserInfo].uid];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
#warning 本地化数据
    NSString *filepath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:responseObject[@"ModuleName"]]stringByAppendingPathExtension:@"plist"];
//        NSLog(@"%@",responseObject);
        [responseObject writeToFile:filepath atomically:YES];
        NSDictionary *dicAllPageData = [NSDictionary dictionaryWithContentsOfFile:filepath];
        [JHPageDataManager sharedJHPageDataManager].pageVisibleItemArray = [NSArray arrayWithArray:dicAllPageData[@"Activitys"][2][@"DataItemPermissions"]];
        [self.getPageDelegate getPageSuccess];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.getPageDelegate getPagefaild];
    }];
    NSLog(@"%@",urlStr);
}









@end

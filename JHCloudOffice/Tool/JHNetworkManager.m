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
#import "JHOrguserManger.h"
#import "NSDictionary+JHChangeDicToJson.h"
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
        [JHUserInfo sharedJHUserInfo].companyObjectId = dic[@"CompanyObjectId"];
        
    }
}

- (void)getModules {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/DefaultSheet.ashx?appKey=%@&token=%@&action=modules&create=1&userId=%@", SITEURL, APPKEY, [JHUserInfo sharedJHUserInfo].objectId, [JHUserInfo sharedJHUserInfo].uid];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
# warning 有打印
//        NSLog(@"%@",responseObject);
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
         [self.getPageDelegate getPageDatasSuccess];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.getPageDelegate getPagefaild];
    }];
}


-(void)getPageSaverSettingWith:(NSDictionary *)parameters{
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&action=source&code=%@&version=%@&instance=null&item=null&field=wldl&activity=%@&user=%@", SITEURL,self.modulesModel.StartSheetCode,APPKEY,self.modulesModel.ModuleCode,self.modulesModel.ModuleVersion,self.modulesModel.StartActivityCode,[JHUserInfo sharedJHUserInfo].objectId];
//    NSArray *datas = [NSArray arrayWithObject:parameters];
    [parameters changeDicToJsonWithDic:parameters];
//    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:datas options:kNilOptions error:nil];
//    NSString *strJson = [[NSString alloc]initWithData:dataJson encoding:NSUTF8StringEncoding];
     NSDictionary *dicc = [NSDictionary dictionaryWithObject:[parameters changeDicToJsonWithDic:parameters] forKey:@"datas"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger POST:urlStr parameters:dicc constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"接收成功%@",responseObject);
        NSArray *array = responseObject[@"datas"];
        if (array.count == 0) {
            [self.getPageDelegate getsetSingleParticipantFromServerfaild];
            return ;
        }
        //给接收数组赋值
        [JHPageDataManager sharedJHPageDataManager].sourceFromServerArray = [NSMutableArray arrayWithArray:responseObject[@"datas"]];
        [self.getPageDelegate getsetSingleParticipantFromServerSucceed];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
        [self.getPageDelegate getsetSingleParticipantFromServerfaild];
    }];
}
-(void)getPageDatas{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&token=%@&action=data&code=%@&version=%@&activity=%@&userId=%@&viewmode=false", SITEURL,self.modulesModel.StartSheetCode,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,self.modulesModel.ModuleCode,self.modulesModel.ModuleVersion,self.modulesModel.StartActivityCode,[JHUserInfo sharedJHUserInfo].objectId];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"从服务器上获取流程信息成功:%@\nURL:\n%@",responseObject,urlStr);
        //将从服务器上获取的流程数据存入数组中
        [JHPageDataManager sharedJHPageDataManager].datasFromServerArray = [responseObject[@"datas"]mutableCopy];
        [self.getPageDelegate getPageDatasSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"从服务器上获取流程信息失败%@",error);
    }];

}
-(void)getUsersWithDic:(NSDictionary *)dic{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSDictionary *dic = @{
//                          @"key":@"owercompany",
//                          @"value":@"539e82c4-3415-4fd8-9db1-7485899efb7b",
//                          @"displayValue":@"539e82c4-3415-4fd8-9db1-7485899efb7b",
//                          @"type":@"ShortString"
//                          };
   NSString *str = [dic changeDicToJsonWithDic:dic];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&token=%@&action=orguser&type=OrganizationUnit&canSelType=&instance=null&code=%@&userId=%@&field=tzr&parentid=%@", SITEURL,self.modulesModel.StartSheetCode,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,self.modulesModel.ModuleCode,[JHUserInfo sharedJHUserInfo].objectId,str];
     NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlStr, NULL, NULL,  kCFStringEncodingUTF8 ));
    [manager GET:encodedString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"RESPONSE:%@,\nJSON:%@\nURL:%@",responseObject,str,encodedString);
//        NSArray *array = responseObject[@"datas"];
//        if (array.count == 0) {
//            return;
//        }
        [JHOrguserManger sharedJHOrguserManger].parentidsArray = [responseObject[@"datas"] mutableCopy];
        [[JHOrguserManger sharedJHOrguserManger] addParentidsArray];
        [self.getOrguserDelegate getOrguserSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}
@end

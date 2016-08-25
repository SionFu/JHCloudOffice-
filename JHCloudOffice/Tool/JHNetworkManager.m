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
//#define SITEURL @"http://188.1.100.165:8010/Portal/ForApp/"http://127.0.0.1:8081/service/common/sendMail
#define APPKEY @"cloudoffice"

@implementation JHNetworkManager
singleton_implementation(JHNetworkManager)



+ (void)vaidataUserWithUserName:(NSString *)user andPassword:(NSString *)password{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/DefaultSheet.ashx?appKey=%@&action=validateuser&userCode=%@&password=%@",SITEURL,APPKEY,user,password];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
#warning 有打印
//        NSLog(@"%@",responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *dic = responseObject;
            JHNetworkManager *loginManger = [JHNetworkManager sharedJHNetworkManager];
            [loginManger loginResults:dic];
           } failure:^(NSURLSessionDataTask *task, NSError *error) {
            JHNetworkManager *loginManger = [JHNetworkManager sharedJHNetworkManager];
            [loginManger loginResults:error.userInfo];
               NSLog(@"%@",error);
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
        [JHUserInfo sharedJHUserInfo].loginid = dic[@"WeaverUser"][@"loginid"];
        [JHUserInfo sharedJHUserInfo].companyObjectId = dic[@"CompanyObjectId"];
        
    }
}

- (void)getModules {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/DefaultSheet.ashx?appKey=%@&token=%@&action=modules&create=1&userId=%@", SITEURL, APPKEY, [JHUserInfo sharedJHUserInfo].objectId, [JHUserInfo sharedJHUserInfo].uid];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"Modules.plist"];
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
//    [parameters changeDicToJsonWithDic:parameters];
//    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:datas options:kNilOptions error:nil];
//    NSString *strJson = [[NSString alloc]initWithData:dataJson encoding:NSUTF8StringEncoding];
     NSDictionary *dicc = [NSDictionary dictionaryWithObject:[parameters changeDicToJsonWithArrDic:parameters] forKey:@"datas"];
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
        [JHPageDataManager sharedJHPageDataManager].datasFromServerArray = responseObject[@"datas"];
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
   NSString *str = [dic changeDicToJsonWithArrDic:dic];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&token=%@&action=orguser&canSelType=&instance=null&code=%@&userId=%@&field=tzr&parentid=%@", SITEURL,self.modulesModel.StartSheetCode,APPKEY,[JHUserInfo sharedJHUserInfo].objectId,self.modulesModel.ModuleCode,[JHUserInfo sharedJHUserInfo].objectId,str];
     NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlStr, NULL, NULL,  kCFStringEncodingUTF8 ));
    [manager GET:encodedString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"RESPONSE:%@,\nJSON:%@\nURL:%@",responseObject,str,encodedString);
//        NSArray *array = responseObject[@"datas"];
//        if (array.count == 0) {
//            return;
//        }
        [JHOrguserManger sharedJHOrguserManger].parentidsArray = responseObject[@"datas"];
        [[JHOrguserManger sharedJHOrguserManger] addParentidsArray];
        [self.getOrguserDelegate getOrguserSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}
- (void)uploadDatasWithData:(NSArray *)uploadData andInstanceName:(NSString *)pageName {
    /*
     http://h3.juhua.com.cn/Portal/ForApp/Sheets/ceshi.ashx?appKey=cloudoffice&userid=f0bbd1cc-7727-449c-ba74-e63dca84f9f1&action=create&code=ceshi&instancename=%E6%B5%8B%E8%AF%95%E6%B5%81%E7%A8%8B
     */
    NSString *instancename = [pageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@Sheets/%@.ashx?appKey=%@&action=create&code=%@&userid=%@&instancename=%@", SITEURL,self.modulesModel.StartSheetCode,APPKEY,self.modulesModel.ModuleCode,[JHUserInfo sharedJHUserInfo].objectId,instancename];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *strJson = [NSString stringWithFormat:@"[%@]",[uploadData componentsJoinedByString:@","]];

    NSLog(@"url:%@\nJson:%@",urlStr,strJson);
//    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:strJson options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *strJson1 = [[NSString alloc]initWithData:dataJson encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",strJson1);
    [manager POST:urlStr parameters:uploadData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"接收成功%@",responseObject);
//        NSArray *array = responseObject[@"datas"];
//        if (array.count == 0) {
//            NSLog(@"上传失败");
//            return ;
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败:%@",error.userInfo);
    }];
    AFHTTPRequestOperationManager *mangert = [AFHTTPRequestOperationManager manager];
    mangert.responseSerializer = [AFJSONResponseSerializer serializer];
    mangert.requestSerializer = [AFJSONRequestSerializer serializer];
    mangert.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mangert POST:urlStr parameters:uploadData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
//                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody: [strJson dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    op.responseSerializer = [AFJSONResponseSerializer serializer];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"JSON responseObject: %@ ",responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", [error localizedDescription]);
//        
//    }];
//    [op start];
    
//    NSMutableArray *parameters = @[@"foo", @"bar"];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:uploadData
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    NSString *body = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [strJson dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        NSLog(@"%@",error.userInfo);
        
    }];
    [op start];
    
}
@end

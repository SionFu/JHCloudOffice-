//
//  JHWeaverNetManger.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHWeaverNetManger.h"
#import "JHNetworkManager.h"
#define WEAVURL @"http://188.1.10.5/service/common/"
@implementation JHWeaverNetManger
- (NSString *)proxyUrlWithUrl:(NSString *)url andisPost:(BOOL)isPost andisAttachment:(BOOL)isAttachment {
    NSString *isPostStr;
    NSString *isAttachmentStr;
    if (isPost) {
        isPostStr = @"ture";
    }else {
        isPostStr = @"false";
    }
    if (isAttachment) {
        isAttachmentStr = @"ture";
    }else {
        isAttachmentStr = @"false";
    }
    NSString *Realurl = [NSString stringWithFormat:@"%@Sheets/WeaverProxy.ashx?ispost=%@&isattachment=%@&rurl=%@",SITEURL,isPostStr,isAttachmentStr,url];
    return Realurl;
}
- (void)weaverCategoryObjectsgetDocContentWithMainid:(NSString *)mainid andSubid:(NSString *)subid andSeccategory:(NSString *)seccategory {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@getDocDir?sessionKey=%@&publishType=0&mainid=%@&subid=%@&seccategory=%@",WEAVURL,[JHUserInfo sharedJHUserInfo].sessionKey,mainid,subid,seccategory];
    urlStr = [self proxyUrlWithUrl:urlStr andisPost:false andisAttachment:false];
    NSLog(@"url:%@",urlStr);
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
- (void)docInfoObjectsgetNoticesWithMainid:(NSString *)mainid andSubid:(NSString *)subid andSeccategory:(NSString *)seccategory andnewOnly:(NSString *)newOnly andPage:(NSString *)page andPageSize:(NSString *)pageSize {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@getDocDir?sessionKey=%@&publishType=0&subid=%@&seccategory=%@&newOnly=%@&page=%@&pageSize=%@",WEAVURL,[JHUserInfo sharedJHUserInfo].sessionKey,subid,seccategory,newOnly,page,pageSize];
    urlStr = [self proxyUrlWithUrl:urlStr andisPost:false andisAttachment:false];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end

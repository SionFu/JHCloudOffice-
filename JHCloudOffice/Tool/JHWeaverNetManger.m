//
//  JHWeaverNetManger.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHWeaverNetManger.h"
#import "JHNetworkManager.h"
#import "JHDocModel.h"
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
    /**
     *  将泛微地址进行 url 编码
     */
    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)url, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    NSLog(@"%@",url);
    NSString *Realurl = [NSString stringWithFormat:@"%@Sheets/WeaverProxy.ashx?ispost=%@&isattachment=%@&rurl=%@",SITEURL,isPostStr,isAttachmentStr,encodedValue];
    return Realurl;
}

- (void)weaverCategoryObjectsgetDocContentWithMainid:(NSString *)mainid andSubid:(NSString *)subid andSeccategory:(NSString *)seccategory {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@getDocDir?sessionKey=%@&publishType=0&mainid=%@&subid=%@&seccategory=%@",WEAVURL,[JHUserInfo sharedJHUserInfo].sessionKey,mainid,subid,seccategory];
    urlStr = [self proxyUrlWithUrl:urlStr andisPost:false andisAttachment:false];
//    NSLog(@"%@",urlStr);
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[JHDocModel sharedJHDocModel].allDataArray addObject:responseObject];
        [self.getDocDelegate getDocSuccess];
//        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.getDocDelegate getDocFaild];
    }];

}
- (void)docInfoObjectsgetNoticesWithMainid:(NSString *)mainid andSubid:(NSString *)subid andSeccategory:(NSString *)seccategory andnewOnly:(NSString *)newOnly andPage:(NSString *)page andPageSize:(NSString *)pageSize {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@getDocDir?sessionKey=%@&publishType=0&subid=%@&seccategory=%@&newOnly=%@&page=%@&pageSize=%@",WEAVURL,[JHUserInfo sharedJHUserInfo].sessionKey,subid,seccategory,newOnly,page,pageSize];
    urlStr = [self proxyUrlWithUrl:urlStr andisPost:false andisAttachment:false];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"URL:%@%@",urlStr ,responseObject);
        [JHDocModel sharedJHDocModel].fileListData = responseObject;
        [self.getFileListDelegate getFileListSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.getFileListDelegate getFileListFaild];
    }];
}
-(void)docInfoContentObjectGetDocContentWithDocId:(NSString *)docId {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@viewGw?sessionKey=%@&docid=%@",WEAVURL,[JHUserInfo sharedJHUserInfo].sessionKey,docId];
    urlStr = [self proxyUrlWithUrl:urlStr andisPost:false andisAttachment:false];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)mailObjectsGetMailInBoxWithNewOnly:(BOOL *)iNewOnly andFolderId:(NSString *)folderId andKey:(NSString *)key andPage:(NSString *)page andPageSize:(NSString *)pageSize {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@getMailInBox?sessionKey=%@&index=%@&perpage=%@&folderid=%@&sortColumn=&sortType=DESC",WEAVURL,[JHUserInfo sharedJHUserInfo].sessionKey,page,pageSize,folderId];
    if (iNewOnly) {
       urlStr = [NSString stringWithFormat:@"%@getMailInBox?sessionKey=%@&index=%@&perpage=%@&folderid=%@&status=0&sortColumn=&sortType=DESC",WEAVURL,[JHUserInfo sharedJHUserInfo].sessionKey,page,pageSize,folderId]; 
    }
    urlStr = [self proxyUrlWithUrl:urlStr andisPost:false andisAttachment:false];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)mailContentObjectsGetMailContent:(NSString *)mailId {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@getDocDir?sessionKey=%@&mailid=%@",WEAVURL,[JHUserInfo sharedJHUserInfo].sessionKey,mailId];
    urlStr = [self proxyUrlWithUrl:urlStr andisPost:false andisAttachment:false];
    NSLog(@"GetMailContentURL:%@",urlStr);
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [JHDocModel sharedJHDocModel].docData = responseObject;
        [self.getDocDelegate getDocSuccess];
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.getDocDelegate getDocFaild];
    }];
}
- (void)mailResultSendMailWithPriority:(NSString *)priority andReceiver:(NSString *)receiver andSendToId:(NSString *)sendToId andMailSubject:(NSString *)mailSubject andMouldText:(NSString *)mouldText andFileURL:(NSURL *)fileURL andFileName:(NSString *)fileName {
//    NSURL *filePath = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"png"];
    NSString *urlStr = [NSString stringWithFormat:@"%@sendMail",WEAVURL];
    urlStr = [self proxyUrlWithUrl:urlStr andisPost:false andisAttachment:false];
    NSDictionary *priorityDic = @{@"priority":priority};
    NSDictionary *sendToIdDic = [NSDictionary dictionary];
    if ([receiver isEqualToString:@""]) {
        sendToIdDic = @{@"sendToId":sendToId};
    }else {
        sendToIdDic = @{@"receiver":receiver};
    }
    NSDictionary *mailSubjectDic = @{@"mailSubject":mailSubject};
    NSDictionary *mouldtextDic = @{@"mouldtext":mouldText};
    NSDictionary *sessionKeyDic = @{@"sessionKey":[JHUserInfo sharedJHUserInfo].sessionKey};
    NSArray *parametersArray = [NSArray arrayWithObjects:priorityDic,sendToId,sendToIdDic,mailSubjectDic,mouldtextDic,sessionKeyDic ,nil];
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    [requestManager POST:urlStr parameters:parametersArray constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        /**
         *  appendPartWithFileURL   //  指定上传的文件
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  指定上传文件的原始文件名
         *  mimeType                //  指定商家文件的MIME类型
         */
        [formData appendPartWithFileURL:fileURL name:@"file" fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:@"image/png" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        [[[UIAlertView alloc] initWithTitle:@"上传结果" message:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]  delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil] show];
        NSLog(@"%@",responseObject);
        [self.sendEamilDelegate sendEmailSuccess];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.sendEamilDelegate sendEmailFaild];
        NSLog(@"获取服务器响应出错");
        
    }];
}
@end

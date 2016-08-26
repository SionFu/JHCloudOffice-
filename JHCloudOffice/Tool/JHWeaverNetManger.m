//
//  JHWeaverNetManger.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHWeaverNetManger.h"

#define SITEURL @"http://h3.juhua.com.cn/Portal/ForApp/"
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
@end

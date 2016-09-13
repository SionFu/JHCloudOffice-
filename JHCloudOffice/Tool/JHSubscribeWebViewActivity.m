//
//  JHSubscribeWebViewActivity.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/13.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHSubscribeWebViewActivity.h"
#import "JHUserInfo.h"
@implementation JHSubscribeWebViewActivity
- (NSString *)getUserAndSsoUrlWithUrl:(NSString *)url {
    NSString *getNewUrl;
    if ([url rangeOfString:@"user_id"].location == NSNotFound) {
        if ([url rangeOfString:@"?"].location == NSNotFound) {
            getNewUrl = [NSString stringWithFormat:@"%@?user_id=%@&user_objectid=%@",url,[JHUserInfo sharedJHUserInfo].sSOKey,[JHUserInfo sharedJHUserInfo].objectId];
        } else {
            getNewUrl = [NSString stringWithFormat:@"%@&user_id=%@&user_objectid=%@",url,[JHUserInfo sharedJHUserInfo].sSOKey,[JHUserInfo sharedJHUserInfo].objectId];
        }
    } else {
            getNewUrl = [NSString stringWithFormat:@"%@&_user_id=%@&user_objectid=%@",url,[JHUserInfo sharedJHUserInfo].sSOKey,[JHUserInfo sharedJHUserInfo].objectId];
    }
    return getNewUrl;
}
@end

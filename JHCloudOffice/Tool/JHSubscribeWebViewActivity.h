//
//  JHSubscribeWebViewActivity.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/13.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHSubscribeWebViewActivity : NSObject
/**
 *  返回添加用户名和 sso 认证的 url 地址
 */
- (NSString *)getUserAndSsoUrlWithUrl:(NSString *)url;
@end

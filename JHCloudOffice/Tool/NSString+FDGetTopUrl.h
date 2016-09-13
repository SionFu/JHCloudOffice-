//
//  NSString+FDGetTopUrl.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/13.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FDGetTopUrl)
/**
 *  传入一个长地址 返回顶级 域名
 *
 *  @param url 传入需要修改的地址
 *
 *  @return 返回顶级地址
 */
+ (NSString *)getTopUrlWithAnyString:(NSString *)url;
@end

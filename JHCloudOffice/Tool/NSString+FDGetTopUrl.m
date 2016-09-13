//
//  NSString+FDGetTopUrl.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/13.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "NSString+FDGetTopUrl.h"

@implementation NSString (FDGetTopUrl)
+ (NSString *)getTopUrlWithAnyString:(NSString *)url {
    NSRange startRange = [url rangeOfString:@"//"];
    
    NSString *getUrl = [url substringFromIndex:startRange.location + startRange.length];
    NSRange endRange;
    if ([getUrl rangeOfString:@":"].location != NSNotFound) {
        endRange = [getUrl rangeOfString:@":"];
    }else {
        endRange = [getUrl rangeOfString:@"/"];
    }
    getUrl = [getUrl substringToIndex:endRange.location];
    getUrl = [NSString stringWithFormat:@"网页由 %@ 提供",getUrl];
    return getUrl;
}
@end

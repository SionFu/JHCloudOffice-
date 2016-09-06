//
//  NSString+JHChangeStringToBase.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/5.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "NSString+JHChangeStringToBase.h"

@implementation NSString (JHChangeStringToBase)
-(NSString *)changeStringToBaseWithString:(NSString *)str {
    NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *baseStr = [stringData base64EncodedStringWithOptions:0];
    return baseStr;
}
@end

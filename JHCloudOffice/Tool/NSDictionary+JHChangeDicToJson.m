//
//  NSDictionary+JHChangeDicToJson.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/19.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "NSDictionary+JHChangeDicToJson.h"

@implementation NSDictionary (JHChangeDicToJson)
-(NSString *)changeDicToJsonWithDic:(NSDictionary *)dic {
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:nil];
    NSString *strJson = [[NSString alloc]initWithData:dataJson encoding:NSUTF8StringEncoding];
    return strJson;
}
-(NSString *)changeDicToJsonWithArrDic:(NSDictionary *)dic {
    NSArray *datas = [NSArray arrayWithObject:dic];
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:datas options:kNilOptions error:nil];
    NSString *strJson = [[NSString alloc]initWithData:dataJson encoding:NSUTF8StringEncoding];
    return strJson;
}
@end

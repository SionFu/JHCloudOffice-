//
//  JHPageData.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/15.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPageData.h"

@implementation JHPageData
-(NSString *)description{
    return [NSString stringWithFormat:@"key:%@ value:%@ displayValue:%@ type:%@",self.key,self.value,self.displayValue,self.type];
}
@end

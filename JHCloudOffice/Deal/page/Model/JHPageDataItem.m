//
//  JHPageDataItem.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPageDataItem.h"

@implementation JHPageDataItem
-(NSString *)description{
    return [NSString stringWithFormat:@"ItemName:%@==Value:%@,Parents:%@",self.ItemName,self.ItemType[@"Value"],self.Parents];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

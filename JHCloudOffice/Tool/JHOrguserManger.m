//
//  JHOrguserManger.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/19.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHOrguserManger.h"

@implementation JHOrguserManger
singleton_implementation(JHOrguserManger)
-(NSMutableArray *)displaysArray{
    if (_displaysArray == nil) {
        _displaysArray = [NSMutableArray array];
    }return _displaysArray;
}
-(NSArray *)parentidsArray{
    if (_parentidsArray == nil) {
        _parentidsArray = [NSArray array];
    }return _parentidsArray;
}
-(void)getDisplaysValue {
    for (NSString *display in self.parentidsArray) {
        [self.displaysArray addObject:display];
    }
}
@end

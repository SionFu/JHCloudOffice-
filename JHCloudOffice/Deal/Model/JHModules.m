//
//  JHModules.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/24.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHModules.h"

@implementation JHModules
singleton_implementation(JHModules)
-(NSMutableArray *)modulesArray{
    if (_modulesArray == nil) {
        _modulesArray = [NSMutableArray array];
    }return _modulesArray;
}
@end

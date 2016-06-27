//
//  JHModulesData.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/27.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHModulesData.h"
#import "JHModules.h"
@implementation JHModulesData
singleton_implementation(JHModulesData)
-(NSMutableArray *)modulesArray{
    if (_modulesArray == nil) {
        _modulesArray = [NSMutableArray array];
    }
    return _modulesArray;
}


+ (void)getModulesArray{
    NSMutableArray *moduleArray = [NSMutableArray array];
    for (JHModules *modules in [JHModulesData sharedJHModulesData].modulesArray) {
        [moduleArray addObject:modules.Category];
    }
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [moduleArray count]; i++){
        
        if ([categoryArray containsObject:[moduleArray objectAtIndex:i]] == NO){
            
            [categoryArray addObject:[moduleArray objectAtIndex:i]];
        }
    }
    [JHModulesData sharedJHModulesData].moduleArray = [NSMutableArray arrayWithArray:categoryArray];
    for (NSString *str in categoryArray) {
        NSMutableArray *mutaArray = [NSMutableArray array];
        for (JHModules *modules in [JHModulesData sharedJHModulesData].modulesArray) {
            if ([modules.Category isEqualToString:str]) {
                [mutaArray addObject:modules];
            }
        }
        [JHModulesData sharedJHModulesData].allModuleArray = [NSArray arrayWithArray:mutaArray];
        
    }
}

@end

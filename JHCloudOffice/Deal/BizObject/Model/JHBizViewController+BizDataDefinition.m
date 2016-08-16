//
//  JHBizViewController+BizDataDefinition.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/8.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHBizViewController+BizDataDefinition.h"
#import "JHBizDataManager.h"
@implementation JHBizViewController (BizDataDefinition)
- (NSMutableArray *)rowsInfo {
    [[JHBizDataManager sharedJHBizDataManager] getItemDisplayName];
    NSMutableArray *cellsArray = [NSMutableArray array];
    int cell = 0;
    
    for (; cell < [JHBizDataManager sharedJHBizDataManager].itemDisplayNameArray.count; cell ++) {
        NSMutableArray *valuesArray = [NSMutableArray array];
        int value = 0;
        for (; value < 1; value ++) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[JHBizDataManager sharedJHBizDataManager].itemDisplayNameArray[cell][value] forKey:@"value"];
            [valuesArray addObject:dic];
        }
        NSDictionary *cells  = [NSDictionary dictionaryWithObject:[valuesArray mutableCopy] forKey:@"cells"];
        [cellsArray addObject:cells];
        
    }
    NSLog(@"%@",cellsArray);
    return cellsArray;
}
- (NSArray *)columnsInfo {
    NSArray *columns = @[
                         @{ @"title" : @"项目名称",
                            @"minWidth" : @50,
                            @"defWidth" : @100},
                         ];
    
    return columns;
}
@end

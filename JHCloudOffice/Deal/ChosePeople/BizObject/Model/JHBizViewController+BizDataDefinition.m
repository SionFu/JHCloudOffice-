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
    NSMutableArray *cellsArray = [NSMutableArray array];
    int cell = 0;
    for (; cell < [JHBizDataManager sharedJHBizDataManager].itemDisplayNameArray.count; cell ++) {
        NSMutableArray *valuesArray = [NSMutableArray array];
        int value = 0;
        for (; value < [JHBizDataManager sharedJHBizDataManager].itemTime; value ++) {
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
    //测试
    [JHBizDataManager sharedJHBizDataManager].itemTime = 1;
    NSMutableArray *columnsArray = [NSMutableArray array];
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:@"项目名称", nil];
    NSMutableArray *key = [NSMutableArray arrayWithObjects:@"title",@"minWidth",@"defWidth", nil];
    for (int time = 0; time <[JHBizDataManager sharedJHBizDataManager].itemTime ;time ++ ) {
        NSMutableArray *object = [NSMutableArray arrayWithObjects:titleArray[time],@50,@100, nil];
        if (time >= 1) {
            [titleArray addObject:[NSString stringWithFormat:@"第%d项",time]];
            [key addObject:@"subtitle"];
            [object addObject:@"轻触编辑"];
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:object forKeys:key];
        [columnsArray addObject:dic];
    }
    
    return columnsArray;
}
@end

//
//  JHBizDataManager.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/6.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHBizDataManager.h"
#import "JHPageDataManager.h"
@implementation JHBizDataManager
- (NSMutableArray *)bizObjectArray {
        _bizObjectArray = [JHPageDataManager sharedJHPageDataManager].bizObjectArray;
    return _bizObjectArray;
}
-(NSMutableArray *)itemDisplayNameArray {
    if (_itemDisplayNameArray == nil) {
        _itemDisplayNameArray = [NSMutableArray array];
    }
    return _itemDisplayNameArray;
}
- (void)getItemDisplayName {
    
    NSMutableArray *cellsArray = [NSMutableArray array];
    for (int i = 1; i < self.bizObjectArray.count; i ++) {
        NSMutableArray *valueArray = [NSMutableArray array];
        NSDictionary *dic = self.bizObjectArray[i];
        NSString *itemDisplayName = dic[@"ItemDisplayName"];
        valueArray[0] = itemDisplayName;
        [cellsArray addObject:[valueArray mutableCopy]];
    }
    self.itemDisplayNameArray = cellsArray;
}
singleton_implementation(JHBizDataManager)
@end

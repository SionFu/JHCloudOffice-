//
//  JHBizDataManager.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/6.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHBizDataManager.h"
#import "JHPageDataManager.h"
#import "JHPageDataItem.h"
@implementation JHBizDataManager
- (NSMutableArray *)bizObjectArray {
    //直接读取 从流程中获取的数据内容  (次数传输的为地址, 提高运算效率)
//    _bizObjectArray = [JHPageDataManager sharedJHPageDataManager].bizObjectArray;
    _bizObjectArray = [self.superiorParentidsArray lastObject];
    return _bizObjectArray;
}
-(NSMutableArray *)itemDisplayNameArray {
    if (_itemDisplayNameArray == nil) {
        _itemDisplayNameArray = [NSMutableArray array];
    }
    return _itemDisplayNameArray;
}
//- (NSMutableArray *)orguserTableViewArray {
//    if (_orguserTableViewArray == nil) {
//        _orguserTableViewArray = [NSMutableArray array];
//    }return _orguserTableViewArray;
//}
- (NSMutableArray *)superiorParentidsArray {
    if (_superiorParentidsArray == nil) {
        _superiorParentidsArray = [NSMutableArray array];
    }return _superiorParentidsArray;
}
-(NSMutableArray *)bizObjectObjArray{
    if (_bizObjectObjArray == nil) {
        _bizObjectObjArray = [NSMutableArray array];
    }return _bizObjectObjArray;
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
-(void)makeSourceFromServer {
     NSMutableArray *allItemArray = [NSMutableArray array];
     for (NSDictionary  *dic in self.bizObjectArray) {
         JHPageDataItem *dataItem = [JHPageDataItem new];
         [dataItem setValuesForKeysWithDictionary:dic];
         [allItemArray addObject:dataItem];
     }
    self.bizObjectObjArray = [NSMutableArray arrayWithArray:allItemArray];
}
- (void)addParentidsArray {
    [self.superiorParentidsArray addObject:self.parentidsArray];
}
- (void)removerLastParentidsArray {
    [self.superiorParentidsArray removeLastObject];
//    [self.orguserTableViewArray removeLastObject];
}
singleton_implementation(JHBizDataManager)
@end

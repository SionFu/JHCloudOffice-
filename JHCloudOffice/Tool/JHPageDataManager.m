//
//  JHPageDataManager.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/1.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPageDataManager.h"
#import "JHDataItemPermissions.h"
#import "JHPageDataItem.h"
@implementation JHPageDataManager
singleton_implementation(JHPageDataManager)
-(NSArray *)pageVisibleItemArray{
    if (_pageVisibleItemArray == nil) {
        _pageVisibleItemArray = [NSArray array];
    }else{
        if (!self.Used) {
            self.Used = true;
        NSMutableArray *muArray = [NSMutableArray new];
        for (NSDictionary *dic in _pageVisibleItemArray) {
            JHDataItemPermissions *per = [JHDataItemPermissions new];
            [per setValuesForKeysWithDictionary:dic];
            if ([per.Visible isEqualToString:@"True"]) {
                [muArray addObject:per];
            }
        }
        _pageVisibleItemArray = [NSArray arrayWithArray:muArray];
        }
    }
    return _pageVisibleItemArray;
}

-(NSMutableArray *)pageDataItemsArray{
    if (_pageDataItemsArray == nil) {
        _pageDataItemsArray = [NSMutableArray array];
    }else{
        if (!self.pageDataUsed) {
            self.pageDataUsed = true;
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dic in _pageDataItemsArray) {
            JHPageDataItem *dataItem = [JHPageDataItem new];
            [dataItem setValuesForKeysWithDictionary:dic];
            for (JHDataItemPermissions *per in self.pageVisibleItemArray) {
                if ([per.ItemName isEqualToString:dataItem.ItemName]) {
                    [muArray addObject:dataItem];
                }
            }
        }
        _pageDataItemsArray = [NSMutableArray arrayWithArray:muArray];
        }
    }
    return _pageDataItemsArray;
}

@end

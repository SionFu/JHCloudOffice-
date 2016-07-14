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
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSDictionary *dic in _pageDataItemsArray) {
            JHPageDataItem *dataItem = [JHPageDataItem new];
            [dataItem setValuesForKeysWithDictionary:dic];
            for (JHDataItemPermissions *per in self.pageVisibleItemArray) {
                if ([per.ItemName isEqualToString:dataItem.ItemName]) {
                    [muArray addObject:dataItem];
                    [itemArray addObject:per.ItemName];
                }
            }
        }
            if (self.itemNameArray == nil) {
                self.itemNameArray = [NSArray arrayWithArray:muArray];
            }
        _pageDataItemsArray = [NSMutableArray arrayWithArray:muArray];
        }
    }
    return _pageDataItemsArray;
}
-(NSMutableArray *)pageCategory{

    for (JHDataItemPermissions *per in self.pageVisibleItemArray) {
        self.Used = false;
//        NSLog(@"%@",per.ItemName);
    }
    NSMutableArray *itemMuarray = [NSMutableArray array];
    NSMutableArray *itemTypeMuarray = [NSMutableArray array];
    NSMutableArray *sourceMuarray = [NSMutableArray array];
    for (JHPageDataItem  *dataItem in [JHPageDataManager sharedJHPageDataManager].pageDataItemsArray) {
        NSLog(@"%@",dataItem.ItemName);
#warning 暂时显示 之后添加控件 需要用到
        NSLog(@"控件类型:%@,是否有子选项%@,数据源:%@",dataItem.ItemType[@"Value"],dataItem.Source,dataItem.SourceType[@"Value"]);
        [ JHPageDataManager sharedJHPageDataManager].pageDataUsed = false;
        [itemMuarray addObject:dataItem.ItemDisplayName];
        [itemTypeMuarray addObject:dataItem.ItemType[@"Value"]];
        if (dataItem.Source == nil) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"Button" forKey:@"Index"];
            dataItem.Source = [NSArray arrayWithObject:dic];
        }
        if ([dataItem.SourceType[@"Value"] isEqualToString:@"Server"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"Server" forKey:@"Index"];
            dataItem.Source = [NSArray arrayWithObject:dic];
        }
        //以下为时间 pick 里的不同日期,时间和 日期时间的不同区别
        if ([dataItem.Format[@"Key"] isEqualToString:@"Date"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"Date" forKey:@"Index"];
            dataItem.Source = [NSArray arrayWithObject:dic];
        }
        if ([dataItem.Format[@"Key"] isEqualToString:@"Time"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"Time" forKey:@"Index"];
            dataItem.Source = [NSArray arrayWithObject:dic];
        }
        if ([dataItem.Format[@"Key"] isEqualToString:@"DateTime"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"DateTime" forKey:@"Index"];
            dataItem.Source = [NSArray arrayWithObject:dic];
        }
        [sourceMuarray addObject:dataItem.Source];
    }
    _pageCategory = [NSMutableArray arrayWithArray:itemMuarray];
    self.typeArray = [NSArray arrayWithArray:itemTypeMuarray];
    self.sourceArray = [NSMutableArray arrayWithArray:sourceMuarray];
    return _pageCategory;
}

-(NSMutableArray *)sourceFromServerArray{
    if (_sourceFromServerArray == nil) {
        _sourceFromServerArray = [NSMutableArray array];
    }return _sourceFromServerArray;
}




@end

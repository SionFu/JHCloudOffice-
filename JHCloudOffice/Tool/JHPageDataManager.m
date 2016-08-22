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
#import "JHGetPageData.h"
#import "JHBizDataManager.h"
#import "JHOrguserManger.h"
@implementation JHPageDataManager
singleton_implementation(JHPageDataManager)
- (NSMutableArray *)bizObjectArray {
    if (_bizObjectArray == nil) {
        _bizObjectArray = [NSMutableArray array];
    }return _bizObjectArray;
}

-(NSArray *)pageVisibleItemArray{
    if (_pageVisibleItemArray == nil) {
        _pageVisibleItemArray = [NSArray array];
    }

    return _pageVisibleItemArray;
}
-(NSMutableArray *)pageAllDataItemsArray{
    if (_pageAllDataItemsArray == nil) {
        _pageAllDataItemsArray = [NSMutableArray array];
    }return _pageAllDataItemsArray;
}
-(void)getTrueItemInPage {
    
    NSMutableArray *muArray = [NSMutableArray new];
    for (NSDictionary *dic in _pageVisibleItemArray) {
        JHDataItemPermissions *per = [JHDataItemPermissions new];
        [per setValuesForKeysWithDictionary:dic];
        if ([per.Visible isEqualToString:@"True"]) {
            [muArray addObject:per];
        }
    }
    self.pageVisibleItemArray = [NSArray arrayWithArray:muArray];

}
-(NSMutableArray *)pageDataItemsArray{
    if (_pageDataItemsArray == nil) {
        _pageDataItemsArray = [NSMutableArray array];
    }
    return _pageDataItemsArray;
}
-(NSArray *)itemNameArray{
    if (_itemNameArray == nil) {
        _itemNameArray = [NSArray array];
    }return _itemNameArray;
}
-(void)getTheSameItemInPageItemsArray {
      NSMutableArray *muArray = [NSMutableArray array];
    NSMutableArray *itemArray = [NSMutableArray array];
 NSMutableArray *allItemArray = [NSMutableArray array];
    for (NSDictionary *dic in self.pageDataItemsArray) {
        JHPageDataItem *dataItem = [JHPageDataItem new];
        [dataItem setValuesForKeysWithDictionary:dic];
        [allItemArray addObject:dataItem];
        for (JHDataItemPermissions *per in self.pageVisibleItemArray) {
            if ([per.ItemName isEqualToString:dataItem.ItemName]) {
                [muArray addObject:dataItem];
                [itemArray addObject:per.ItemName];
            }
        }
    }
         self.itemNameArray = [NSArray arrayWithArray:itemArray];
    self.pageDataItemsArray = [NSMutableArray arrayWithArray:muArray];
 self.pageAllDataItemsArray = [NSMutableArray arrayWithArray:allItemArray];
}
-(NSMutableArray *)pageCategory{
    if (_pageCategory == nil) {
        _pageCategory = [NSMutableArray array];
    }
    return _pageCategory;
}
-(void)makeSourceFromServerWithArray:(NSMutableArray *)array {
    //打印流程中所流程表头名  self.pageDataItemsArray
//    for (JHDataItemPermissions *per in self.pageVisibleItemArray) {
//
//                NSLog(@"项目名称(内部名称)::==>>>%@",per.ItemName);
//    }
    NSMutableArray *itemMuarray = [NSMutableArray array];
    NSMutableArray *itemTypeMuarray = [NSMutableArray array];
    NSMutableArray *sourceMuarray = [NSMutableArray array];
    NSMutableArray *bizObjectArray = [NSMutableArray array];
    //防止有多个采购明细列表 将数据存在数组中
    for (JHPageDataItem  *dataItem in array) {
        //        NSLog(@"%@",dataItem.ItemName);
#warning 暂时显示 之后添加控件 需要用到
        NSLog(@"%@:%@,是否有子选项%@,数据源:%@,采购明细表:%@",dataItem.ItemDisplayName,dataItem.ItemType[@"Value"],dataItem.Source,dataItem.SourceType[@"Value"],dataItem.SubTableColumns);
        [itemMuarray addObject:dataItem.ItemDisplayName];
        [itemTypeMuarray addObject:dataItem.ItemType[@"Value"]];
        if (dataItem.Source == nil) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"Button" forKey:@"Key"];
            dataItem.Source = [NSArray arrayWithObject:dic];
        }
        if ([dataItem.SourceType[@"Value"] isEqualToString:@"Server"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"Server" forKey:@"Key"];
            dataItem.Source = [NSArray arrayWithObject:dic];
        }
        //将采购明细表中的数据源存储
        if ([dataItem.ItemType[@"Value"] isEqualToString:@"BizObjectArray"]) {
            bizObjectArray = [NSMutableArray arrayWithArray:dataItem.SubTableColumns];
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
    self.pageCategory = [NSMutableArray arrayWithArray:itemMuarray];
    self.typeArray = [NSArray arrayWithArray:itemTypeMuarray];
    self.sourceArray = [NSMutableArray arrayWithArray:sourceMuarray];
//    self.bizObjectArray = [NSMutableArray arrayWithArray:bizObjectArray];
    
    [JHBizDataManager sharedJHBizDataManager].parentidsArray = [bizObjectArray mutableCopy];
    [[JHBizDataManager sharedJHBizDataManager] addParentidsArray];
}

-(NSDictionary *)findOwercompanyWithKey:(NSInteger)index {
    JHPageDataItem *item = self.pageDataItemsArray[index];
     NSString *parentskey = item.Parents[0][@"Key"];
    NSDictionary *dic = [NSDictionary dictionary];
    for (JHPageDataItem *per in self.pageAllDataItemsArray) {
        if ([per.ItemName isEqualToString:parentskey]) {
            NSString *value = per.InitialValue[@"Value"];
            NSString *displayValue = per.InitialDisplayValue[@"Value"];
            NSString *type = per.ItemType[@"Value"];
            NSString *Key = per.InitialDisplayValue[@"Key"];
            dic = @{
                    @"value":value,
                    @"displayValue":displayValue,
                    @"type":type,
                    @"Key":Key,
                    };
        }
    }
    return dic;
}
- (NSArray*)readyToUploadDataWith:(NSArray *)dataArray {
    NSMutableArray *uploadDataArray = [NSMutableArray array];
    for (int i = 1; i < dataArray.count ; i++) {
        NSDictionary *dic = [NSDictionary dictionary];
       NSString *key = self.itemNameArray[i];
      NSString *type = self.typeArray[i];
        if ([type isEqualToString:@"MultiParticipant"]) {
            NSDictionary *saveUserDic = [NSDictionary dictionaryWithDictionary:[[JHOrguserManger sharedJHOrguserManger].saveAllListDic objectForKey:[NSString stringWithFormat:@"%d",i]]];
            dic = @{
                    @"key":key,
                    @"value":saveUserDic[@"Value"],
                    @"displayValue":saveUserDic[@"DisplayValue"],
                    @"type":type,
                    };
            
        }else if ([type isEqualToString:@"Bool"]) {
            NSString *str;
            if ([dataArray[i] isEqualToString:@"0"]) {
                str = @"false";
            }else {
                str = @"true";
            }
            dic = @{
                    @"key":key,
                    @"value":str,
                    @"displayValue":str,
                    @"type":type,
                    };
            
        }
        else {
            NSString *value = dataArray[i];
        
        dic = @{
                @"key":key,
                @"value":value,
                @"displayValue":dataArray[i],
                @"type":type,
                };
        }
        [uploadDataArray addObject:dic];
    }
    NSLog(@"%@",uploadDataArray);
    
    return 0;
}
-(NSMutableArray *)sourceFromServerArray{
    if (_sourceFromServerArray == nil) {
        _sourceFromServerArray = [NSMutableArray array];
    }return _sourceFromServerArray;
}

-(NSMutableArray *)datasFromServerArray{
    if (_datasFromServerArray == nil) {
        _datasFromServerArray = [NSMutableArray array];
    }return _datasFromServerArray;
}



@end

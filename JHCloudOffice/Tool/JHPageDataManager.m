//
//  JHPageDataManager.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/1.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPageDataManager.h"
#import "JHDataItemPermissions.h"
@implementation JHPageDataManager
singleton_implementation(JHPageDataManager)
-(NSArray *)pageVisibleItemArray{
    if (_pageVisibleItemArray == nil) {
        _pageVisibleItemArray = [NSArray array];
    }else{
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
    return _pageVisibleItemArray;
}
@end

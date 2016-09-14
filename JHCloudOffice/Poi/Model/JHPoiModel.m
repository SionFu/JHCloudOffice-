//
//  JHPoiModel.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/9.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPoiModel.h"

@implementation JHPoiModel
-(NSDictionary *)queueData {
    if (_queueData == nil) {
        _queueData = [NSDictionary dictionary];
    }return _queueData;
}
-(NSDictionary *)listData {
    if (_listData == nil) {
        _listData = [NSDictionary dictionary];
    }return _listData;
}
-(NSArray *)listArray {
    return self.listData[@"datas"];
}
-(NSDictionary *)allListData {
    if (_allListData == nil) {
        _allListData = [NSDictionary dictionary];
    }return  _allListData;
}
-(NSArray *)allListArray {
    return self.allListData[@"datas"];
}
-(NSArray *)queueDatasArray {
    return self.queueData[@"datas"];
}
singleton_implementation(JHPoiModel)
@end

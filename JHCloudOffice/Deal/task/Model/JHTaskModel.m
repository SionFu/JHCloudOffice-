//
//  JHTaskModel.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHTaskModel.h"

@implementation JHTaskModel
singleton_implementation(JHTaskModel)
-(NSDictionary *)taskDataDic {
    if (_taskDataDic == nil) {
        _taskDataDic = [NSDictionary dictionary];
    }return _taskDataDic;
}
-(NSArray *)taskArry {
    return self.taskDataDic[@"datas"];
}
@end

//
//  JHInstancesModel.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHInstancesModel.h"

@implementation JHInstancesModel
singleton_implementation(JHInstancesModel)
-(NSDictionary *)instancesDataDic {
    if (_instancesDataDic == nil) {
        _instancesDataDic = [NSDictionary dictionary];
    }return _instancesDataDic;
}
-(NSArray *)instancesArray {
    return self.instancesDataDic[@"datas"];
}
@end

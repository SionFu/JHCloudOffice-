//
//  JHInstancesModel.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface JHInstancesModel : NSObject
singleton_interface(JHInstancesModel)
@property (nonatomic, strong) NSDictionary *instancesDataDic;
@property (nonatomic, strong) NSArray *instancesArray;
@end

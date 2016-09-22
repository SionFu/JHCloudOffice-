//
//  JHTaskModel.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface JHTaskModel : NSObject
singleton_interface(JHTaskModel)
@property (nonatomic, strong)NSDictionary *taskDataDic;
@property (nonatomic, strong)NSArray *taskArry;
@end

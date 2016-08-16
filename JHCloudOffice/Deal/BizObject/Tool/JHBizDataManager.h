//
//  JHBizDataManager.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/6.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface JHBizDataManager : NSObject
singleton_interface(JHBizDataManager)
/**
 *  储存采购明细表  是流程数据
 */
@property (nonatomic, strong) NSMutableArray *bizObjectArray;
/**
 *  采购列表显示名称
 */
@property (nonatomic, strong) NSMutableArray *itemDisplayNameArray;
/**
 *  显示采购明细列表前获取表名!!
 */
- (void)getItemDisplayName;
@end

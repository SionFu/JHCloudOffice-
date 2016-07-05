//
//  JHPageDataManager.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/1.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface JHPageDataManager : NSObject
/**
 *  储存流程项目显示名称
 */
@property (nonatomic, strong) NSArray *pageVisibleItemArray;
/**
 *  显示字段内容
 */
@property (nonatomic, strong) NSMutableArray *pageDataItemsArray;
/**
 *  是否使用过数据
 */
@property (nonatomic, setter=isUsed:) BOOL Used;
@property (nonatomic, setter=isUsed:) BOOL pageDataUsed;
singleton_interface(JHPageDataManager)
@end

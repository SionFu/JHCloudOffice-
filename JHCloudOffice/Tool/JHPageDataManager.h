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
/**
 *  流程中所有的项目ItemName 上传字典中的 key
 */
@property (nonatomic, strong) NSArray *itemNameArray;

/**
 *  所有流程项目名称
 */
@property (nonatomic, strong)NSMutableArray *pageCategory;
/**
 *  所有项目的控件
 */
@property (nonatomic, strong)NSArray *typeArray;
/**
 *  所有二级选项菜单
 */
@property (nonatomic, strong)NSArray *sourceArray;
singleton_interface(JHPageDataManager)
@end

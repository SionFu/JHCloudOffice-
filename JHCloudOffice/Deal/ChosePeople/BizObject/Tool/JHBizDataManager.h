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
 *  总共添加几个采购明细列表
 */
@property (nonatomic, assign) NSInteger itemTime;
/**
 *  采购明细表中项目的类型
 */
@property (nonatomic, strong) NSArray *typeArray;
/**
 *  显示采购明细列表前获取表名!!
 */
- (void)getItemDisplayName;
/**
 *  获取二级菜单内容
 */
-(void)makeSourceFromServer;
@end

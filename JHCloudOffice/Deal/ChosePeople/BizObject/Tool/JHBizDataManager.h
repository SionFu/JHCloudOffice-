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
 *  储存采购明细表  是流程数据转换成模型
 */
@property (nonatomic, strong) NSMutableArray *bizObjectObjArray;

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
 *  获取二级菜单内容 将JSON数据内容转换成对象
 */
-(void)makeSourceFromServer;

/**
 * 保存当前推出的视图JHBizViewController
 */
//@property (nonatomic, strong) NSMutableArray *orguserTableViewArray;
/**
 *  从服务器上获取的 采购明细表数据
 */
@property (nonatomic, strong) NSArray *parentidsArray;
/**
 *  储存所有父级数组的数组
 */
@property (nonatomic, strong) NSMutableArray *superiorParentidsArray;
/**
 *  当用户点击的为最多行的时候 > superiorParentidsArray.count
 */
- (void)addParentidsArray;
/**
 *  当用户点击的行数小于当前的最多行数时 = superiorParentidsArray.count
 */
- (void)removerLastParentidsArray;
@end

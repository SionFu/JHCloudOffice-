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
 * 显示字段内容
 */
@property (nonatomic, strong) NSMutableArray *pageDataItemsArray;
/**
 *   全部显示字段内容
 */
@property (nonatomic, strong) NSMutableArray *pageAllDataItemsArray;

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
@property (nonatomic, strong)NSMutableArray *sourceArray;
/**
 *  从服务器获取的二级菜单内容
 */
@property (nonatomic, strong)NSMutableArray *sourceFromServerArray;
/**
 *  从服务器获取的配置原始数据
 */
@property (nonatomic, strong) NSMutableArray *datasFromServerArray;
/**
 *  储存最终上传的数据
 */
@property (nonatomic, strong) NSMutableArray *datasDicArray;
/**
 *  储存采购明细表是流程数据
 */
@property (nonatomic, strong) NSMutableArray *bizObjectArray;

/**
 *  获取菜单里需要显示的项目
 */
-(void)getTrueItemInPage;
/**
 *  获取两个服务器中相同的项目
 */
-(void)getTheSameItemInPageItemsArray;
/**
 *  获取二级菜单
 */
-(void)makeSourceFromServer;
/**
 *  根据传入数组的下标查找出父字段中的公司名称 返回查找组织查找字段 like
 *{
 *"key": "owercompany",
 *"value": "539e82c4-3415-4fd8-9db1-7485899efb7b",
 *"displayValue": "539e82c4-3415-4fd8-9db1-7485899efb7b",
 *"type": "ShortString"
 *}
 */
-(NSDictionary *)findOwercompanyWithKey:(NSInteger)index;
singleton_interface(JHPageDataManager)
@end

//
//  JHOrguserManger.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/19.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface JHOrguserManger : NSObject
/**
 *  储存DisplayValue
 */
@property (nonatomic, strong) NSMutableArray *displaysArray;
/**
 *  储存二级的所有parentid  从服务器获取二级菜单的数据
 *like
 {
    Other1 : 249,
	Key : tzr,
	Index : 1,
	DisplayValue : 公司领导,
	Type : OrganizationUnit,
	ExtType : OrganizationUnit,
	Value : 73c5fa30-526c-468a-8cbe-704f030ac45d
 }
 */
@property (nonatomic, strong) NSArray *parentidsArray;
/**
 *  储存多有父级数组的数组
 */
@property (nonatomic, strong) NSMutableArray *superiorParentidsArray;
/**
 *  在调用刷新 tableView 之前调用这个函数获取里面的所有display显示内容
 */
-(void)getDisplaysValue;
/**
 *  当用户点击的为最多行的时候 > superiorParentidsArray.count
 */
- (void)addParentidsArray;
/**
 *  当用户点击的行数小于当前的最多行数时 = superiorParentidsArray.count
 */
- (void)removerLastParentidsArray;
/**
 * 保存当前推出的视图JHOrguserTableViewController
 */
@property (nonatomic, strong) NSMutableArray *orguserTableViewArray;
/**
 *  储存选中人员的信息
 like:
 {
	Other1 : 孙树江,
	Key : tzr,
	Index : 10000,
	DisplayValue : 孙树江,
	Type : User,
	ExtType : User,
	Value : 056f4f9f-7070-4c20-83f2-3d1d50d4869c
 }
 */
@property (nonatomic, strong) NSDictionary *saveUserDic;

singleton_interface(JHOrguserManger)
@end

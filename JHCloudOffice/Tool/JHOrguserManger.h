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
 *  储存二级的所有parentid
 */
@property (nonatomic, strong) NSArray *parentidsArray;
/**
 *  在调用刷新 tableView 之前调用这个函数获取里面的所有display显示内容
 */
-(void)getDisplaysValue;
singleton_interface(JHOrguserManger)
@end

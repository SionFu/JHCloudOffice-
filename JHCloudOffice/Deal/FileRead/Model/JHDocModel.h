//
//  JHDocModel.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface JHDocModel : NSObject
singleton_interface(JHDocModel)
/**
 *  文件数据
 */
@property (nonatomic, strong) NSDictionary *docData;
/**
 *  第一二层文件夹内容
 like
 categoryid : 161,
	doccount : 9336,
	newDocCount : 9336,
	categoryname : 公文中心,
 */
@property (nonatomic, strong) NSArray *firDicArray;
/**
 *  第三层文件夹内容
 like 
	categoryid : 494,
	doccount : 90,
	newDocCount : 0,
	categoryname : 巨化
 */
@property (nonatomic, strong) NSArray *thiDicArray;
/**
 *  所有数据内容的数组
 */
@property (nonatomic, strong) NSMutableArray *allDataArray;
- (void)removeLasterDocArray;
@end

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
 *  所有文件夹数据内容的数组
 */
@property (nonatomic, strong) NSMutableArray *allDataArray;
- (void)removeLasterDocArray;
/**
 *  文件列表&通知的数据
 */
@property (nonatomic, strong) NSDictionary *fileListData;
/**
 *  文件列表内容数组
 */
@property (nonatomic, strong) NSArray *fileListArray;
/**
 *  文件内容数据
 */
@property (nonatomic, strong) NSDictionary *fileContentData;
/**
 *  文件中下载文件的 文件列表数组
 */
@property (nonatomic, strong) NSArray *fileSubArray;
/**
 *  文件中信息的内容 html 标记语言
 */
@property (nonatomic, strong) NSString *fileContentDetailStr;
@end

//
//  JHPoiModel.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/9.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface JHPoiModel : NSObject
singleton_interface(JHPoiModel)
/**
 *  已订阅 list 数据  订阅的所有数据 alllist
 */
@property (nonatomic, strong) NSDictionary *listData;
/**
 *  已订阅list数组
 */
@property (nonatomic ,strong) NSArray *listArray;
/**
 *    订阅的所有数据 alllist
 */
@property (nonatomic, strong) NSDictionary *allListData;
/**
 *  已订阅allList数组
 */
@property (nonatomic ,strong) NSArray *allListArray;
/**
 *  未查看数 unviewcount
 */
@property (nonatomic ,strong) NSNumber *unViewCount;
/**
 *  订阅的公司通知内容
 */
@property (nonatomic, strong) NSDictionary *queueData;
/**
 *  订阅公司通知 datas 数组
 */
@property (nonatomic, strong) NSArray *queueDatasArray;
@end

//
//  JHModulesData.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/27.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface JHModulesData : NSObject
singleton_interface(JHModulesData)
/**
 *  储存流程表数组内容
 */
@property (nonatomic, strong) NSMutableArray *modulesArray;
/**
 *  流程个数
 */
@property (nonatomic, strong) NSString *count;
/**
 *  错误编码
 */
@property (nonatomic, strong) NSString *errorCode;
/**
 *  错误信息
 */
@property (nonatomic, strong) NSString *errorMessage;
/**
 *  信任信息
 */
@property (nonatomic, strong) NSString *traceMessage;

/**
 *  相同的流程数组
 */
@property (nonatomic, strong) NSMutableArray *moduleArray;
/**
 *  相同的流程数组包括所有数据
 */
@property (nonatomic, strong) NSArray *allModuleArray;

/**
 *  将相同的数组存在一个数组中
 */
+ (void)getModulesArray;
@end

//
//  JHModules.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/24.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHModules : NSObject

/**
 *  流程类别
 */
@property (nonatomic, strong) NSString *ModuleType;
/**
 *  流程编码
 */
@property (nonatomic, strong) NSString *ModuleCode;
/**
 *  流程名称
 */
@property (nonatomic, strong) NSString *ModuleName;
/**
 *  流程数据模型编码
 */
@property (nonatomic, strong) NSString *SchemaCode;
/**
 *  流程版本号
 */
@property (nonatomic, strong) NSString *ModuleVersion;
/**
 *  开始环节编码  [环节编码]
 */
@property (nonatomic, strong) NSString *StartActivityCode;
/**
 *  开始环节表单编码(文件名)
 */
@property (nonatomic, strong) NSString *StartSheetCode;
/**
 *  分类名称
 */
@property (nonatomic, strong) NSString *Category;
/**
 *  分类排序
 */
@property (nonatomic, strong) NSString *CategoryIndex;
/**
 *  流程排序
 */
@property (nonatomic, strong) NSString *ModulesIndex;

@end

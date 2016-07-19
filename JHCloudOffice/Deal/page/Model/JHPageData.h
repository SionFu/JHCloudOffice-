//
//  JHPageData.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/15.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  上传数据模型
 */
@interface JHPageData : NSObject
/**
 *  ItemName
 */
@property (nonatomic, strong) NSString *key;
/**
 *  页面中的输入值
 */
@property (nonatomic, strong) NSString *value;
/**
 *  页面中的显示值
 */
@property (nonatomic, strong) NSString *displayValue;
/**
 *  数据类型
 */
@property (nonatomic, strong) NSString *type;
@end

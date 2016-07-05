//
//  JHPageDataItem.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPageDataItem : NSObject
@property (nonatomic, strong) NSDictionary *DisplayValueFormula;
@property (nonatomic, strong) NSDictionary *Format;
@property (nonatomic, strong) NSDictionary *Formula;
@property (nonatomic, assign) BOOL Hidden;
@property (nonatomic, assign) NSNumber *Index;
@property (nonatomic, strong) NSDictionary *InitialDisplayValue;
@property (nonatomic, strong) NSDictionary *InitialValue;
@property (nonatomic, assign) BOOL IsExtra;
/**
 *  显示在 cell 上的字符
 */
@property (nonatomic, strong) NSString *ItemDisplayName;
@property (nonatomic, strong) NSString *ItemName;
/**
 *  字段的接收内容,显示控件类型
 */
@property (nonatomic, strong) NSDictionary *ItemType;
@property (nonatomic, strong) NSString *ItemValue;
/**
 *  字段最长的内容
 */
@property (nonatomic, assign) NSNumber *MaxLength;
@property (nonatomic, strong) NSDictionary *Parents;
@property (nonatomic, assign) BOOL ReadOnly;
@property (nonatomic, strong) NSArray *Source;
@property (nonatomic, strong) NSDictionary *ShowOrHiddenAction;
@property (nonatomic, strong) NSDictionary *SourceType;
@property (nonatomic, strong) NSDictionary *Trackable;
@property (nonatomic, strong) NSDictionary *Validate;
/**
 *  防止未添加相应的值导致应用崩溃
 */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

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
@property (nonatomic, strong) NSDictionary *Formula;
@property (nonatomic, assign) BOOL Hidden;
@property (nonatomic, assign) int Index;
@property (nonatomic, assign) BOOL IsExtra;
@property (nonatomic, strong) NSString *ItemDisplayName;
@property (nonatomic, strong) NSString *ItemName;
@property (nonatomic, strong) NSString *ItemType;
@property (nonatomic, strong) NSString *ItemValue;
@property (nonatomic, assign) int MaxLength;
@property (nonatomic, assign) BOOL ReadOnly;
@property (nonatomic, strong) NSDictionary *SourceType;
@property (nonatomic, strong) NSDictionary *Trackable;

@end

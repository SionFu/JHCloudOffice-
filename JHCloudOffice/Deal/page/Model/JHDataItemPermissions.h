//
//  JHDataItemPermissions.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/1.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHDataItemPermissions : NSObject
/**
 *  是否可以编辑
 */
@property (nonatomic, strong) NSString *Editable;
/**
 *  项目名称
 */
@property (nonatomic, strong) NSString *ItemName;
@property (nonatomic, strong) NSString *MobileVisible;
@property (nonatomic, strong) NSString *Required;
@property (nonatomic, strong) NSString *TrackVisible;
/**
 *  显示项目名称
 */
@property (nonatomic, strong) NSString *ViewName;
/**
 *  是否可见
 */
@property (nonatomic, strong) NSString *Visible;
@end

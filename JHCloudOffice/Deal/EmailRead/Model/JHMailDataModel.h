//
//  JHMailDataModel.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/19.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface JHMailDataModel : NSObject
singleton_interface(JHMailDataModel)
/**
 *  获取邮件列表内容数据
 */
@property (nonatomic, strong) NSDictionary *mailListData;
/**
 *  邮件列表数组
 */
@property (nonatomic, strong) NSArray *mailListArray;
/**
 *  获取邮件列表内容数据
 */
@property (nonatomic, strong) NSDictionary *mailContentDataDic;
/**
 *  邮件附件数组
 */
@property (nonatomic, strong) NSArray *mailDocsArray;
@end

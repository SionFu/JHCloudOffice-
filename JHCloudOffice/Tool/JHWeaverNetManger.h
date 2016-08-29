//
//  JHWeaverNetManger.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWeaverNetManger : NSObject
/**
 *  获取知识文档列表目录
 *
 *  @param mainid      主目录id
 *  @param subid       一级目录id
 *  @param seccategory 二级目录id
 */
- (void)weaverCategoryObjectsgetDocContentWithMainid:(NSString *)mainid andSubid:(NSString *)subid andSeccategory:(NSString *)seccategory;
/**
 *
 */
- (void)docInfoObjectsgetNoticesWithMainid:(NSString *)mainid andSubid:(NSString *)subid andSeccategory:(NSString *)seccategory andnewOnly:(NSString *)newOnly andPage:(NSString *)page andPageSize:(NSString *)pageSize;
@end

//
//  JHGlobalModel.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface JHGlobalModel : NSObject
singleton_interface(JHGlobalModel);
/**
 *  导航的额标题
 */
@property (nonatomic, strong) id rootNavigationItem;
@end

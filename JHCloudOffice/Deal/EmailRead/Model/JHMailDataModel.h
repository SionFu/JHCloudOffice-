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
@property (nonatomic, strong) NSDictionary *mailData;
@end

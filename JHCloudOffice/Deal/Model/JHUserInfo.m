//
//  JHUserInfo.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHUserInfo.h"

@implementation JHUserInfo
singleton_implementation(JHUserInfo)
-(NSString *)notificationTime {
    if (_notificationTime == nil) {
        _notificationTime = @"2015/12/19";
    }
        return _notificationTime;
}
@end

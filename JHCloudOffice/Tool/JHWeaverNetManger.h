//
//  JHWeaverNetManger.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWeaverNetManger : NSObject
- (NSString *)proxyUrlWithUrl:(NSString *)url andisPost:(BOOL)isPost andisAttachment:(BOOL)isAttachment;
@end

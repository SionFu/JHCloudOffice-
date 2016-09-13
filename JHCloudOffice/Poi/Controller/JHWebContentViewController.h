//
//  JHWebContentViewController.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/12.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWebContentViewController : UIViewController
//传入的 url
@property (nonatomic ,strong) NSString *urlStr;
/**
 *  传入需要显示的数据
 */
@property (nonatomic, strong) NSDictionary *poiDic;
@end

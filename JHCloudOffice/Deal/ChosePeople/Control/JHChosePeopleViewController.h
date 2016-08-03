//
//  JHChosePeopleViewController.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/20.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHChosePeopleViewController : UIViewController
/**
 * 当前视图的标题
 */
@property (nonatomic, strong) NSString *navigationTitle;
/**
 *  当前视图的按钮 tag 值
 */
@property (nonatomic, assign)  NSInteger indexPathTag;
/**
 *  推出当前视图的控制器
 */
@property (nonatomic, strong) UITableView *indexView;
/**
 *  此为上传数据的原指针数据(DisplayValue)
 */
@property (nonatomic, strong) NSMutableArray *datasDicArray;
@end

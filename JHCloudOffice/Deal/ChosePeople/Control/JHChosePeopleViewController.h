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
 *  当前视图的按钮 tag 值 也是人员信息字典中的 key
 */
@property (nonatomic, assign)  NSInteger indexPathTag;
/**
 *  推出当前表格视图的控制器
 */
@property (nonatomic, strong) UITableView *indexView;
/**
 *  此为流程上传数据的原指针数据指针地址(DisplayValue)
 */
@property (nonatomic, strong) NSMutableArray *datasDicArray;
/**
 *  推出当前的视图
 */
@property (nonatomic, strong) UIView *indexNView;
/**
 *  推出当前视图的按钮
 */
@property (nonatomic, strong) UIButton *sendBtn;
@end

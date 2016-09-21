//
//  JHFileListTableViewController.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/1.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHFileListTableViewController : UITableViewController
/**
 *  文件夹编号文件  二级类目名称
 */
@property (nonatomic, strong)NSString *seccategory;
/**
 *  是不是没有阅读的文件内容
 */
@property (nonatomic, strong) NSString *isNewOnl;
@end

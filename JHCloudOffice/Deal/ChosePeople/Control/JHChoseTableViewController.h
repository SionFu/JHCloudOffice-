//
//  JHChoseTableViewController.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/3.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHChoseTableViewController : UITableViewController
/**
 *  显示此页面时就要刷新下表格视图 显示最新的 选择人员;
 */
- (void)reloadTableViewData;
@end

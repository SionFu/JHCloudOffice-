//
//  JHPageTableViewController.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BLOCk)();
@interface JHPageTableViewController : UITableViewController

/**
 *  流程标题
 */
@property (nonatomic, strong) NSString *pageNage;
@property (nonatomic, strong)BLOCk goToblock;
@end

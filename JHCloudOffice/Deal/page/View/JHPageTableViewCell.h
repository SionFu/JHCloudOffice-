//
//  JHPageTableViewCell.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHPageTableViewCell : UITableViewCell
/**
 *  显示流程名称
 */
@property (weak, nonatomic) IBOutlet UILabel *itemDisplayNameLabelText;
/**
 *  显示流程控件的内容
 */
@property (weak, nonatomic) IBOutlet UIView *controlTypeView;

@end

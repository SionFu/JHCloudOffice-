//
//  JHBizEditTableViewCell.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/18.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBizEditTableViewCell : UITableViewCell
/**
 *  显示流程名称
 */
@property (weak, nonatomic) IBOutlet UILabel *itemDisplayNameLabelText;
/**
 *  显示流程控件的内容
 */
@property (weak, nonatomic) IBOutlet UIView *controlTypeView;

@end

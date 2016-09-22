//
//  JHTaskTableViewCell.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTaskTableViewCell : UITableViewCell
/**
 *  项目名称
 */
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
/**
 *  发起项目名称
 */
@property (weak, nonatomic) IBOutlet UILabel *instanceNameLabel;
/**
 *  时间
*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  发起人姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *createUserNamelabel;
/**
 *  流程状态显示图片小红点
 */
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;

@end

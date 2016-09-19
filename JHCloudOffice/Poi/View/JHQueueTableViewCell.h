//
//  JHQueueTableViewCell.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/14.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHQueueTableViewCell : UITableViewCell
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *publicTitleLabel;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *publicTimeLabel;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *publicDescLabel;
/**
 *  查看全文
 */
@property (weak, nonatomic) IBOutlet UILabel *publicUrlLabel;
/**
 *  文件类型图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;

@end

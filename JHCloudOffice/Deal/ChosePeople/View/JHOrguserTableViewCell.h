//
//  JHOrguserTableViewCell.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/20.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHOrguserTableViewCell : UITableViewCell
/**
 *  cell 中左边视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/**
 *  cell 中中间文本组织名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  cell 中右边视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *footImage;

@end

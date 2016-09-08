//
//  JHPoiTableViewCell.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/7.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHPoiTableViewCell : UITableViewCell
/**
 *  标题头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *poiHandImaageView;
/**
 *  订阅标题
 */
@property (weak, nonatomic) IBOutlet UILabel *poiTitleLabel;
/**
 *  订阅内容
 */
@property (weak, nonatomic) IBOutlet UILabel *poiContentLabel;
/**
 *  是否订阅
 */
@property (weak, nonatomic) IBOutlet UILabel *poiRSSLabel;

@end

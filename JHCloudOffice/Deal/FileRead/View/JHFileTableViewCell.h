//
//  JHFileTableViewCell.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHFileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *readImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileTitleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDetailTextLabel;

@end

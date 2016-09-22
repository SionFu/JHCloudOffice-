//
//  JHEmailContentTableViewCell.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHEmailContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleTextlabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *readImageView;

@end

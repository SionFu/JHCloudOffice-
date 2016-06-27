//
//  JHHoneHeadView.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/23.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JHHomeMenuButtonDelegate <NSObject>
- (void)clickHomeMenuButton:(long)sender;
@end
@interface JHHoneHeadView : UIView
@property (nonatomic, weak) id<JHHomeMenuButtonDelegate> delegate;
@end

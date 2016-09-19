//
//  JHEmailContentViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/19.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHEmailContentViewController.h"
#import "JHWeaverNetManger.h"
@interface JHEmailContentViewController ()
@property (nonatomic ,strong)JHWeaverNetManger *manger;
@end

@implementation JHEmailContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manger = [JHWeaverNetManger new];
    [self.manger mailContentObjectsGetMailContent:self.mailContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

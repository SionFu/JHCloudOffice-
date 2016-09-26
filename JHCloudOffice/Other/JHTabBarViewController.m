//
//  JHTabBarViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/24.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHTabBarViewController.h"
#import "JHGlobalModel.h"
#import "JHScanCRCodeViewController.h"
@interface JHTabBarViewController ()<UITabBarDelegate,UITabBarControllerDelegate>
@property(nonatomic, strong)UIBarButtonItem *addRssButton;
@end

@implementation JHTabBarViewController

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
       self.title = @"巨化云办公";
    }
    if (item.tag == 1) {
        self.title = @"订阅项目";
    }
    if (item.tag == 2) {
        self.title = @"我的";
    }
    if (item.tag == 3) {
        self.title = @"更多";
    }
}


- (void)scanCRCodeViewController {
    JHScanCRCodeViewController *scanView = [JHScanCRCodeViewController new];
    [self.navigationController pushViewController:scanView animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巨化云办公";
    [JHGlobalModel sharedJHGlobalModel].rootNavigationItem = self.navigationItem;

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

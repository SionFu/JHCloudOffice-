//
//  JHMoreTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/8.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHMoreTableViewController.h"
#import "JHUserDefault.h"
#import "MBProgressHUD+KR.h"
@interface JHMoreTableViewController ()

@end

@implementation JHMoreTableViewController
- (void)viewWillAppear:(BOOL)animated {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    if (indexPath.row == 0) {
        [MBProgressHUD showSuccess:@"清除成功"];
        //删除临时文件
    }
    if (indexPath.row == 1) {
        //推出确定选择框
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定 注销登录?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JHUserDefault clearUser];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        }];
//        UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@" 取消" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:actionYes];
//        [alert addAction:actionNo];
//        [self presentViewController:alert animated:YES completion:nil];
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


@end

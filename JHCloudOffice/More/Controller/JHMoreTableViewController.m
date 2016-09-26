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
#import "JHGlobalModel.h"

@interface JHMoreTableViewController ()
@property (nonatomic, strong)UINavigationItem *rootNavigatioItem;

@end

@implementation JHMoreTableViewController
-(UINavigationItem *)rootNavigatioItem {
    return [JHGlobalModel sharedJHGlobalModel].rootNavigationItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [self addNavigationButton];
}
- (void)addNavigationButton {
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(addObject:)];
    //打开扫描二维码
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(scanCRCodeViewController)];
    //打开查找视图
    NSArray *buttonArray = [NSArray arrayWithObjects:scanButton,searchButton, nil];
    self.rootNavigatioItem.rightBarButtonItems = buttonArray;
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

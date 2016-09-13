//
//  JHPoiAllListTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/9.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPoiAllListTableViewController.h"
#import "JHRestApi.h"
#import "JHPoiModel.h"
#import "UIImageView+WebCache.h"
#import "JHPoiTableViewCell.h"
#import "JHSubscribeViewController.h"

@interface JHPoiAllListTableViewController ()<JHGetPoiListDelegate>
/**
 *  所有的订阅项目
 */
@property (nonatomic ,strong) NSArray * allListArray;
@property (nonatomic, strong)JHRestApi *apiManger;
@property (nonatomic ,strong ) UINib *nib;
@end

@implementation JHPoiAllListTableViewController
-(NSArray *)allListArray {
    return [JHPoiModel sharedJHPoiModel].allListArray;
}
- (void)viewWillAppear:(BOOL)animated {
    //开始获取订阅的消息
    self.apiManger = [JHRestApi new];
    self.apiManger.getPoiListdDelegate = self;
    [self.apiManger subscribeObjectsGetSubscribeObjectsWithAction:@"alllist"];
    
}
-(void)getPoiListSuccess {
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订阅列表";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(closeScanVC)];
    [self.navigationItem setLeftBarButtonItem:leftButton animated:YES];
}
-(void)closeScanVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    return self.allListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"reuseIdentifier";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHPoiTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
    }
    JHPoiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.poiTitleLabel.text = self.allListArray[indexPath.row][@"PUBLICNAME"];
    cell.poiContentLabel.text = self.allListArray[indexPath.row][@"PUBLICDESC"];
    [cell.poiHandImaageView sd_setImageWithURL:[NSURL URLWithString:self.allListArray[indexPath.row][@"PUSHICON"]] placeholderImage:[UIImage imageNamed:@"ic_dyh"]];
    if ([[NSString stringWithFormat:@"%@",self.allListArray[indexPath.row][@"IsFollow"]]isEqualToString:@"1"]) {
        cell.poiRSSLabel.text = @"已订阅";
    }else {
       cell.poiRSSLabel.text = @"未订阅";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHSubscribeViewController *subVC = [JHSubscribeViewController new];
    subVC.poiDic = self.allListArray[indexPath.row];
    [self.navigationController pushViewController:subVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

@end

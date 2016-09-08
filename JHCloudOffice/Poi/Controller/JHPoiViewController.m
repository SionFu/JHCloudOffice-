//
//  JHPoiViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/7.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPoiViewController.h"
#import "JHPoiTableViewCell.h"
@interface JHPoiViewController ()<UITableViewDataSource,UITableViewDelegate>
- (IBAction)rSSButtonClick:(UIBarButtonItem *)sender;
@property (nonatomic ,strong ) UINib *nib;
@end

@implementation JHPoiViewController
- (void)viewWillAppear:(BOOL)animated {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)sendEmail:(id)sender {

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"reuseIdentifier";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHPoiTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
    }
    JHPoiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    

    cell.poiTitleLabel.text = @"信息公司工作计划";
    cell.poiContentLabel.text = @"这是一段测试内容段测试内容段测试内容段测试内容的内容";
    cell.poiRSSLabel.text = @"已订阅";
    cell.poiHandImaageView.image = [UIImage imageNamed:@"untask"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)rSSButtonClick:(UIBarButtonItem *)sender {
    //推出订阅列表
}
@end

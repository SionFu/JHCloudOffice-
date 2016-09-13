//
//  JHPoiViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/7.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPoiViewController.h"
#import "JHPoiTableViewCell.h"
#import "JHRestApi.h"
#import "JHPoiModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+KR.h"
#import "JHPoiAllListTableViewController.h"
#import "JHWebContentViewController.h"
@interface JHPoiViewController ()<UITableViewDataSource,UITableViewDelegate,JHGetPoiListDelegate>
/**
 *  显示已订阅列表视图
 */
@property (weak, nonatomic) IBOutlet UITableView *poiListTableView;
- (IBAction)rSSButtonClick:(UIBarButtonItem *)sender;
@property (nonatomic ,strong ) UINib *nib;
@property (nonatomic ,strong) JHRestApi *apiManger;
/**
 *  本人的订阅项目
 */
@property (nonatomic ,strong) NSArray *listArray;
@end

@implementation JHPoiViewController

-(NSArray *)listArray {
    return [JHPoiModel sharedJHPoiModel].listArray;
}
- (void)viewWillAppear:(BOOL)animated {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.hidden = YES;
        //开始获取订阅的消息
    self.apiManger = [JHRestApi new];
    self.apiManger.getPoiListdDelegate = self;
    [self.apiManger subscribeObjectsGetSubscribeObjectsWithAction:@"list"];

}
-(void)getPoiListSuccess {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.poiListTableView reloadData];
//    [MBProgressHUD showSuccess:@"刷新数据成功"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showMessage:@"加载数据..." toView:self.view];
    
   }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"reuseIdentifier";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHPoiTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
    }
    JHPoiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    

    cell.poiTitleLabel.text = self.listArray[indexPath.row][@"PUBLICNAME"];
    cell.poiContentLabel.text = self.listArray[indexPath.row][@"PUBLICDESC"];
    cell.poiRSSLabel.text = @"";
    [cell.poiHandImaageView sd_setImageWithURL:[NSURL URLWithString:self.listArray[indexPath.row][@"PUSHICON"]] placeholderImage:[UIImage imageNamed:@"ic_dyh"]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[NSString stringWithFormat:@"%@",self.listArray[indexPath.row][@"PUSHTYPE"]] isEqualToString:@"9"]) {
        //推出UIWebView
        JHWebContentViewController *webView = [JHWebContentViewController new];
        webView.urlStr = self.listArray[indexPath.row][@"ENTERURL"];
        webView.poiDic = self.listArray[indexPath.row];
        [self.navigationController pushViewController:webView animated:YES];
    }else if ([[NSString stringWithFormat:@"%@",self.listArray[indexPath.row][@"PUSHTYPE"]] isEqualToString:@"1"]) {
        //推出自定义视图表格
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)rSSButtonClick:(UIBarButtonItem *)sender {
    //推出订阅列表
    JHPoiAllListTableViewController *allListView = [JHPoiAllListTableViewController new];
    UINavigationController *nVC = [[UINavigationController alloc]initWithRootViewController:allListView];
    [self.navigationController presentViewController:nVC animated:YES completion:nil];
}
@end

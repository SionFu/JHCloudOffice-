//
//  JHFileListTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/1.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHFileListTableViewController.h"
#import "JHFileContentViewController.h"
#import "JHWeaverNetManger.h"
#import "JHDocModel.h"
#import "MBProgressHUD+KR.h"
#import "JHFileTableViewCell.h"
#import "JHGlobalModel.h"
#import "MJRefresh.h"
@interface JHFileListTableViewController ()<JHFileListDelegate>
/**
 *  文件列表数组
 */
@property (nonatomic, strong)NSMutableArray *fileListArray;
@property (nonatomic, strong)JHWeaverNetManger *manger;
@property (nonatomic, strong)UINib *nib;
@property (nonatomic,assign)int page;

@property (nonatomic, strong)NSArray *lastRequest;

@end

@implementation JHFileListTableViewController
- (NSArray *)lastRequest {
    if (_lastRequest == nil) {
        _lastRequest = [NSArray array];
    }return _lastRequest;
}

- (NSMutableArray *)fileListArray {
    if (_fileListArray == nil) {
        _fileListArray = [NSMutableArray array];
    }
    return _fileListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建上拉下拉两个控件
    [self AddRefreshControl];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(closeScanVC)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    [self sendRequestToServer];
//    [MBProgressHUD showMessage:@"正在载入..."];
}
#pragma mark -- 和界面相关的方法
-(void)AddRefreshControl{
    //下拉刷新
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeal)];
    //执行刷新的动作
    [self.tableView.mj_header beginRefreshing];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeal)];
    
}
#pragma mark -- 和网络相关

//下拉刷新
- (void)loadNewDeal{
    self.page = 1;
    [self sendRequestToServer];
}
- (void)loadMoreDeal {
    self.page ++;
    [self sendRequestToServer];
}
- (void)sendRequestToServer {
    self.manger = [JHWeaverNetManger new];
    [self.manger docInfoObjectsgetNoticesWithMainid:@"" andSubid:@"" andSeccategory:self.seccategory andnewOnly:self.isNewOnl andPage:self.page andPageSize:@"14"];
    self.manger.getFileListDelegate = self;
}
-(void)closeScanVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)getFileListFaild {
    [MBProgressHUD showError:@"获取文件列表失败"];
}
-(void)getFileListSuccess {
    [MBProgressHUD hideHUD];
    //停止下拉刷新
    [self.tableView.mj_header endRefreshing];
    //停止上拉刷新
    [self.tableView.mj_footer endRefreshing];
    if ([self.lastRequest isEqualToArray: [JHDocModel sharedJHDocModel].fileListArray]) {
        return;
    }
    self.lastRequest = [JHDocModel sharedJHDocModel].fileListArray;
    //每次页面数为1时清除所有数据
    if (self.page == 1) {
        [self.fileListArray removeAllObjects];
    }
    [self.fileListArray addObjectsFromArray:[JHDocModel sharedJHDocModel].fileListArray];
    
    [self.tableView reloadData];
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
    return self.fileListArray.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"FileCell";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHFileTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier: cellIdentifier];
    }
    JHFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.fileTitleTextLabel.text = self.fileListArray[indexPath.row][@"docsubject"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSString *dateTimeStr = [NSString stringWithFormat:@"%@%@",self.fileListArray[indexPath.row][@"doccreatedate"],self.fileListArray[indexPath.row][@"doccreatetime"]];
    NSDate *date = [dateFormatter dateFromString:dateTimeStr];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH点mm分"];
    cell.timeDetailTextLabel.text = [dateFormatter stringFromDate:date];
    [cell.timeDetailTextLabel setTextColor:[UIColor grayColor]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSNumber *isNew = self.fileListArray[indexPath.row][@"isNew"];
    int inew = [isNew intValue];
    if (inew == 0) {
       cell.readImageView.image = [UIImage imageNamed:@"ic_remindernull"];
    }else {
    cell.readImageView.image = [UIImage imageNamed:@"ic_reminder"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果现实点击的为通知数每次点击 减去一
    if ([self.seccategory isEqualToString:@"541"]) {
        [JHGlobalModel sharedJHGlobalModel].unReadNoti --;
    }
    JHFileTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.readImageView.image = [UIImage imageNamed:@"ic_remindernull"];
    [cell reloadInputViews];
    //显示文件内容
    JHFileContentViewController *fileVC = [JHFileContentViewController new];
    //传入文件 id
    NSNumber *docIdNumber = self.fileListArray[indexPath.row][@"id"];
    fileVC.docId = [docIdNumber intValue];
    [self.navigationController pushViewController:fileVC animated:YES];
}
@end

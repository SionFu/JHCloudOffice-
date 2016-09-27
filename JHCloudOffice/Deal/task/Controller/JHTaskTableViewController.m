//
//  JHTaskTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHTaskTableViewController.h"
#import "JHRestApi.h"
#import "JHTaskModel.h"
#import "JHTaskTableViewCell.h"
#import "MBProgressHUD+KR.h"
#import "MJRefresh.h"
#import "JHGlobalModel.h"
#import "JHPageTableViewController.h"
@interface JHTaskTableViewController ()<JHGetTaskDelegate>
@property (nonatomic, strong)UINib *nib;
@property (nonatomic, strong)NSMutableArray *taskArray;
@property (nonatomic,assign)int page;
@property (nonatomic, strong)NSArray *lastRequest;
@end

@implementation JHTaskTableViewController
- (NSArray *)lastRequest {
    if (_lastRequest == nil) {
        _lastRequest = [NSArray array];
    }return _lastRequest;
}
-(NSMutableArray *)taskArray {
    if (_taskArray == nil) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建上拉下拉两个控件
    [self AddRefreshControl];
//    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    [self sendRequestToServer];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
//获取数据
-(void)sendRequestToServer{
    JHRestApi *apiManger = [JHRestApi new];
    apiManger.getTaskDelegate = self;
    int pageSize = 8;
    [apiManger moduleTaskItemsGetTasksWithSheet:@"DefaultSheet" andCode:@"" andStates:self.taskStates andKey:@"" andStartTime:@"" andEndTime:@"" andSort:@"" andDescOrAsc:@"" andPageSize:pageSize andPageIndex:self.page];
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
-(void)getTaskSuccess {
    //停止下拉刷新
    [self.tableView.mj_header endRefreshing];
    //停止上拉刷新
    [self.tableView.mj_footer endRefreshing];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([self.lastRequest isEqualToArray: [JHTaskModel sharedJHTaskModel].taskArry]) {
            return;
        }
    self.lastRequest = [JHTaskModel sharedJHTaskModel].taskArry;
    //每次页面数为1时清除所有数据
    if (self.page == 1) {
        [self.taskArray removeAllObjects];
    }
    [self.taskArray addObjectsFromArray:[JHTaskModel sharedJHTaskModel].taskArry];
    
    [self.tableView reloadData];
    
}
-(void)getTaskFaild {
    NSLog(@"网络错误");
    //获取数据失败停止刷新
    
    //停止下拉刷新
    [self.tableView.mj_header endRefreshing];
    //停止上拉刷新
    [self.tableView.mj_footer endRefreshing];
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
    return self.taskArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"TaskCell";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHTaskTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier: cellIdentifier];
    }
    JHTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *taskDic = self.taskArray[indexPath.row];
    cell.itemNameLabel.text = taskDic[@"ItemName"];
    cell.instanceNameLabel.text = taskDic[@"InstanceName"];

    // 时间戳转换
    NSRange range = {6,10};
    NSString *timeStr = [taskDic[@"ItemTime"] substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    double doubleTime = [timeStr doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:doubleTime];
    [formatter setDateFormat:@"MM月dd日 HH时mm分"];
    timeStr = [formatter stringFromDate:date];
    cell.timeLabel.text = timeStr;
    
    cell.createUserNamelabel.text = taskDic[@"CreateUserName"];
    NSNumber *isNew = taskDic[@"ItemState"];
    int inew = [isNew intValue];
    if (inew == 2) {
        cell.stateImageView.image = [UIImage imageNamed:@"ic_remindernull"];
    }else {
        cell.stateImageView.image = [UIImage imageNamed:@"ic_reminder"];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        //[UIFont fontWithName:@ "Arial" size:14.0]]; //非加粗
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [JHGlobalModel sharedJHGlobalModel].unReadTask --;
    JHPageTableViewController *pageView = [JHPageTableViewController new];
    NSDictionary *taskDic = [JHTaskModel sharedJHTaskModel].taskArry[indexPath.row];
    pageView.pageName = taskDic[@"ActivityDisplayName"];
    UINavigationController *nvpageVC = [[UINavigationController alloc]initWithRootViewController:pageView];
    [self.navigationController presentViewController:nvpageVC animated:YES completion:nil];
    
}
@end

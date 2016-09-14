//
//  JHQueueContentTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/14.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHQueueContentTableViewController.h"
#import "JHRestApi.h"
#import "JHSubscribeViewController.h"
#import "JHQueueTableViewCell.h"
#import "JHPoiModel.h"
#import "MBProgressHUD+KR.h"
@interface JHQueueContentTableViewController ()<JHQueueObjectsDelegate>
@property (nonatomic ,strong)JHRestApi *apiManger;
@property (nonatomic ,strong ) UINib *nib;
@property (nonatomic, strong ) NSArray *queueArray;
@end

@implementation JHQueueContentTableViewController
-(NSArray *)queueArray {
    return [JHPoiModel sharedJHPoiModel].queueDatasArray;
}
-(JHRestApi *)apiManger {
    if (_apiManger == nil) {
        _apiManger = [JHRestApi new];
    }return _apiManger;
}
- (void)viewWillAppear:(BOOL)animated {
    [JHPoiModel sharedJHPoiModel].queueData = nil;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.hidden = NO;
    //获取所有列表检查 此项目是否订阅
    [self.apiManger subscribeObjectsGetSubscribeObjectsWithAction:@"alllist"];
    self.apiManger.getQueueObjectsDelegate = self;
    [self.apiManger pushQueueObjectsGetPushQueueObjectsWithPublicGuid:self.poiDic[@"PUBLICGUID"] andPageSize:@"4" andPageIndex:@"1"];
}
-(void)getQueueObjectsSuccess {
    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //行高自适应====必须要给这两行
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //预估值
    self.tableView.estimatedRowHeight = 200;
    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    self.title = self.poiDic[@"PUBLICNAME"];
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //显示内容
    
    
}
-(UIBarButtonItem *)editButtonItem {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"····" style:UIBarButtonItemStylePlain target:self action:@selector(detalButtonClink:)];
    return rightButton;
}

- (void)detalButtonClink:(id)sender {
    //推出是否取消订阅视图
    JHSubscribeViewController *subView = [JHSubscribeViewController new];
    subView.poiDic = [JHRestApi getObjectFollowSubscribeInAllListWithPublicCode:self.poiDic[@"PUBLICCODE"]];
    [self.navigationController pushViewController:subView animated:YES];
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
    return self.queueArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"QueueCell";
    
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHQueueTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
    }
    JHQueueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateTimeStr = [NSString stringWithFormat:@"%@",self.queueArray[indexPath.row][@"PTIME"]];
    NSDate *date = [dateFormatter dateFromString:dateTimeStr];
    [dateFormatter setDateFormat:@"MM月dd日 HH时"];
    
    cell.publicTitleLabel.text = self.queueArray[indexPath.row][@"PTITLE"];
    cell.publicTimeLabel.text = [dateFormatter stringFromDate:date];
    cell.publicDescLabel.text = self.queueArray[indexPath.row][@"PDESC"];
    //判断是否需要显示 详细内容
    NSDictionary *dic = self.queueArray[indexPath.row];
    if ([[dic allKeys]containsObject:@"PURL"]) {
     cell.publicUrlLabel.hidden = NO;
    }
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//      自适应高度
//    return 400;
//
//}


@end

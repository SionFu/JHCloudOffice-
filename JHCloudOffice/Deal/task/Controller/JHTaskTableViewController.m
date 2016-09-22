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
@interface JHTaskTableViewController ()<JHGetTaskDelegate>
@property (nonatomic, strong)UINib *nib;
@property (nonatomic, strong)NSArray *taskArray;
@end

@implementation JHTaskTableViewController
-(NSArray *)taskArray {
    return [JHTaskModel sharedJHTaskModel].taskArry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    JHRestApi *apiManger = [JHRestApi new];
    apiManger.getTaskDelegate = self;
    int pageSize = 30;
    int pageIndex = 1;
    [apiManger moduleTaskItemsGetTasksWithSheet:@"DefaultSheet" andCode:@"" andStates:self.taskStates andKey:@"" andStartTime:@"" andEndTime:@"" andSort:@"" andDescOrAsc:@"" andPageSize:pageSize andPageIndex:pageIndex];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getTaskSuccess {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.tableView reloadData];
}
-(void)getTaskFaild {
    NSLog(@"网络错误");
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
    NSNumber *isNew = taskDic[@"InstanceState"];
    int inew = [isNew intValue];
    if (inew == 4) {
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
    
}
@end

//
//  JHInstancesTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHInstancesTableViewController.h"
#import "JHRestApi.h"
#import "JHInstancesModel.h"
@interface JHInstancesTableViewController ()<JHGetInstancesDelegate>
@property (nonatomic, strong)NSArray *instancesArray;
@end

@implementation JHInstancesTableViewController
-(NSArray *)instancesArray {
    return [JHInstancesModel sharedJHInstancesModel].instancesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    JHRestApi *apiManger = [JHRestApi new];
    int pageSize = 100;
    int pageIndex = 1;
    apiManger.getInstancesDelegate = self;
    [apiManger moduleInstancesGetInstancesWithCode:@"" andVersion:@"" andStates:@"" andStartTime:@"" andEndTime:@"" andKey:@"" andSort:@"" andisasc:@"" andPageSize:pageSize andPageIndex:pageIndex];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getInstancesSuccess {
    [self.tableView reloadData];
}
-(void)getInstancesFaild {
    
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
    return self.instancesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    NSDictionary *insdtancesDic = self.instancesArray[indexPath.row];
    cell.textLabel.text = insdtancesDic[@"InstanceName"];
    
    
    NSString *timeStr = insdtancesDic[@"CreatedTime"];
    NSDateFormatter *formart = [[NSDateFormatter alloc]init];
    [formart setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate *timeDate = [formart dateFromString:timeStr];
    [formart setDateFormat:@"mm月dd日 hh点mm分"];
    timeStr = [formart stringFromDate:timeDate];
    NSString *subTitle = [NSString stringWithFormat:@"进行中 %@",timeStr];
    [cell.detailTextLabel setTextColor:[UIColor grayColor]];
    NSNumber *isNew = insdtancesDic[@"State"];
    int inew = [isNew intValue];
    if (inew == 4) {
        //已完成
        subTitle = [NSString stringWithFormat:@"已完成  %@",timeStr];
        [cell.detailTextLabel setTextColor:[UIColor greenColor]];
    }
    cell.detailTextLabel.text = subTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end

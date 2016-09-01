//
//  JHFileListTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/1.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHFileListTableViewController.h"
#import "JHWeaverNetManger.h"
#import "JHDocModel.h"
#import "MBProgressHUD+KR.h"
@interface JHFileListTableViewController ()<JHFileListDelegate>
/**
 *  文件列表数组
 */
@property (nonatomic, strong)NSArray *fileListArray;
@property (nonatomic, strong)JHWeaverNetManger *manger;
@end

@implementation JHFileListTableViewController
- (NSArray *)fileListArray {
    return [JHDocModel sharedJHDocModel].fileListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.manger = [JHWeaverNetManger new];
    [self.manger docInfoObjectsgetNoticesWithMainid:@"" andSubid:@"" andSeccategory:[JHDocModel sharedJHDocModel].thiDicArray[self.cellForRowInFirDoc][@"categoryid"] andnewOnly:@"" andPage:@"" andPageSize:@""];
    self.manger.getFileListDelegate = self;
    [MBProgressHUD showMessage:@"正在载入..."];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getFileListFaild {
    [MBProgressHUD showError:@"获取文件列表失败"];
}
-(void)getFileListSuccess {
    [MBProgressHUD hideHUD];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    cell.textLabel.text = self.fileListArray[indexPath.row][@"docsubject"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self.fileListArray[indexPath.row][@"doccreatedate"]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:date];
    [cell.detailTextLabel setTextColor:[UIColor grayColor]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSNumber *isNew = self.fileListArray[indexPath.row][@"isNew"];
    int inew = [isNew intValue];
    if (inew == 0) {
       cell.imageView.image = [UIImage imageNamed:@"checkboxChecked"];
    }else {
    cell.imageView.image = [UIImage imageNamed:@"checkBoxDefault"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //显示文件内容
}
@end

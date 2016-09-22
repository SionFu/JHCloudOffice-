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
@interface JHFileListTableViewController ()<JHFileListDelegate>
/**
 *  文件列表数组
 */
@property (nonatomic, strong)NSArray *fileListArray;
@property (nonatomic, strong)JHWeaverNetManger *manger;
@property (nonatomic, strong)UINib *nib;
@end

@implementation JHFileListTableViewController
- (NSArray *)fileListArray {
    return [JHDocModel sharedJHDocModel].fileListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(closeScanVC)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    self.manger = [JHWeaverNetManger new];
    [self.manger docInfoObjectsgetNoticesWithMainid:@"" andSubid:@"" andSeccategory:self.seccategory andnewOnly:self.isNewOnl andPage:@"1" andPageSize:@"20"];
    self.manger.getFileListDelegate = self;
//    [MBProgressHUD showMessage:@"正在载入..."];
}
-(void)closeScanVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
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


- (UITableView*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

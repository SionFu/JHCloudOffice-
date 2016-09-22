//
//  JHReadEmailTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/19.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHReadEmailTableViewController.h"
#import "JHWeaverNetManger.h"
#import "JHMailDataModel.h"
#import "JHEmailContentViewController.h"
#import "MBProgressHUD+KR.h"
#import "JHEmailContentTableViewCell.h"
@interface JHReadEmailTableViewController ()<JHGetMailObjectsDelegate>
@property (nonatomic, strong)UINib *nib;
/**
 *  邮件列表数组
 */
@property (nonatomic, strong)NSArray *mailListArray;
@end

@implementation JHReadEmailTableViewController
-(NSArray *)mailListArray {
    return [JHMailDataModel sharedJHMailDataModel].mailListArray;
}
-(void)viewWillAppear:(BOOL)animated {
//    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
}
- (void)viewDidLoad {
    [super viewDidLoad];
        [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
    JHWeaverNetManger *manger = [JHWeaverNetManger new];
    manger.getMailObjectsDelegate = self;
    [manger mailObjectsGetMailInBoxWithNewOnly:self.unReadMail andFolderId:@"0" andPage:@"" andPageSize:@""];
     self.clearsSelectionOnViewWillAppear = YES;
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getMailObjectsSuccess {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.tableView reloadData];
}
- (void)getMailObjectFaild {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:@"网络错误"];
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
    return self.mailListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EmailCell";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHEmailContentTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
    }
    
    JHEmailContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.titleTextlabel.text = self.mailListArray[indexPath.row][@"subject"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:self.mailListArray[indexPath.row][@"senddate"]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH点mm分"];
    cell.timeDetailLabel.text = [NSString stringWithFormat:@"%@ %@",self.mailListArray[indexPath.row][@"sendfrom"],[dateFormatter stringFromDate:date]];
    [cell.timeDetailLabel setTextColor:[UIColor grayColor]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSNumber *isNew = self.mailListArray[indexPath.row][@"status"];
    int inew = [isNew intValue];
    if (inew == 1) {
        cell.readImageView.image = [UIImage imageNamed:@"ic_remindernull"];
    }else {
        cell.readImageView.image = [UIImage imageNamed:@"ic_reminder"];
//        cell.titleTextlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];

        //[UIFont fontWithName:@ "Arial" size:14.0]]; //非加粗
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //消去左边的小红点
    JHEmailContentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.readImageView.image = [UIImage imageNamed:@"ic_remindernull"];
    cell.titleTextlabel.font = [UIFont fontWithName:@"Arial" size:16];
    [cell reloadInputViews];
    JHEmailContentViewController *emailContemtVC = [JHEmailContentViewController new];
    emailContemtVC.mailContentDic = self.mailListArray[indexPath.row];
    [self.navigationController pushViewController:emailContemtVC animated:YES];
}

@end

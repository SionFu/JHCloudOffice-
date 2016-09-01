//
//  JHDocTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHDocTableViewController.h"
#import "JHWeaverNetManger.h"
#import "JHSubDirTableViewController.h"
#import "JHDocTableViewCell.h"
#import "MBProgressHUD+KR.h"
#import "JHDocModel.h"
@interface JHDocTableViewController ()<JHDocDelegate>
@property (nonatomic ,strong ) UINib *nib;
/**
 *  第一层文件数组内容
 */
@property (nonatomic,strong)NSArray *firDicArray;
@end

@implementation JHDocTableViewController
-(NSArray *)firDicArray {
    return  [JHDocModel sharedJHDocModel].firDicArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    JHWeaverNetManger *manger = [JHWeaverNetManger new];
    [manger weaverCategoryObjectsgetDocContentWithMainid:@"" andSubid:self.categoryid andSeccategory:@""];
    manger.getDocDelegate = self;
    [MBProgressHUD showMessage:@"正在载入..."];
}
-(void)getDocSuccess {
    [MBProgressHUD hideHUD];
    [self.tableView reloadData];
}
-(void)getDocFaild {
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
    return self.firDicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"docCell";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHDocTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier: cellIdentifier];
    }
    JHDocTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.headImageView.image = [UIImage imageNamed:@"folder1"];
    cell.docNameLabel.text = self.firDicArray[indexPath.row][@"categoryname"];
    NSString *doccount = self.firDicArray[indexPath.row][@"doccount"];
    NSString *newDocCount = self.firDicArray[indexPath.row][@"newDocCount"];
    cell.docCountLabel.text = [NSString stringWithFormat:@"%@/%@",newDocCount,doccount];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.title = self.firDicArray[indexPath.row][@"categoryname"];
    JHSubDirTableViewController *subVC = [JHSubDirTableViewController new];
    subVC.cellForRowInFirDoc = indexPath.row;
    [self.navigationController pushViewController:subVC animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end

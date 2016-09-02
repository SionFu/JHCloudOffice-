//
//  JHSubDirTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/30.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHSubDirTableViewController.h"
#import "JHDocTableViewCell.h"
#import "JHDocModel.h"
#import "JHDocTableViewController.h"
@interface JHSubDirTableViewController ()
@property (nonatomic ,strong ) UINib *nib;
/**
 *  第二层文件夹的内容
 */
@property (nonatomic ,strong) NSArray *secDicArray;
@end

@implementation JHSubDirTableViewController
-(NSArray *)secDicArray {
    return [JHDocModel sharedJHDocModel].firDicArray[self.cellForRowInFirDoc][@"subDirInfos"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(closeScanVC)];
    [self.navigationItem setRightBarButtonItem:rightButton];
}
-(void)closeScanVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
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

    return self.secDicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"docCell";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHDocTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier: cellIdentifier];
    }
    JHDocTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.headImageView.image = [UIImage imageNamed:@"folder1"];
    cell.docNameLabel.text = self.secDicArray[indexPath.row][@"categoryname"];
    NSString *doccount = self.secDicArray[indexPath.row][@"doccount"];
    NSString *newDocCount = self.secDicArray[indexPath.row][@"newDocCount"];
    cell.docCountLabel.text = [NSString stringWithFormat:@"%@/%@",newDocCount,doccount];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.title = self.secDicArray[indexPath.row][@"categoryname"];
    JHDocTableViewController *docVC = [JHDocTableViewController new];
    docVC.categoryid = self.secDicArray[indexPath.row][@"categoryid"];
    [self.navigationController pushViewController:docVC animated:YES];
    
}

@end

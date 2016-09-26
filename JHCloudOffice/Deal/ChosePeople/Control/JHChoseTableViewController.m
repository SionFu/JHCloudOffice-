//
//  JHChoseTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/3.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHChoseTableViewController.h"
#import "JHOrguserManger.h"
#import "JHOrguserTableViewCell.h"
@interface JHChoseTableViewController ()
@property (nonatomic ,strong ) UINib *nib;
@end

@implementation JHChoseTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reloadTableViewData {
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([JHOrguserManger sharedJHOrguserManger].saveUserDic.count == 0||[[JHOrguserManger sharedJHOrguserManger].saveUserDic[@"DisplayValue"] isEqualToString:@"轻触选择..."]) {
        return 0;
    }else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"reuseIdentifier";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHOrguserTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier: cellIdentifier];
    }
    JHOrguserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = [JHOrguserManger sharedJHOrguserManger].saveUserDic[@"DisplayValue"];
    cell.headImage.image = [UIImage imageNamed:@"ic_user"];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    return cell;
}



@end

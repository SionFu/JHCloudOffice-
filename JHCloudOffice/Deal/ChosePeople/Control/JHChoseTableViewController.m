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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

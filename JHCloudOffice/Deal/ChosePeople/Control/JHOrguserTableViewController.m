//
//  JHOrguserTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/20.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHOrguserTableViewController.h"
#import "JHOrguserManger.h"
#import "JHOrguserTableViewCell.h"
#import "JHNetworkManager.h"
#import "JHPageTableViewController.h"
@interface JHOrguserTableViewController ()<JHOrguser>
//声明表视图子类用这个表格初始化
@property (nonatomic, strong) NSArray *parentidsArray;
@property (nonatomic ,strong ) UINib *nib;
@end
#define TABLEVIEWFRAMEL CGRectMake(0, 0, self.view.frame.size.width /2, self.view.frame.size.height)
#define TABLEVIEWFRAMER CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.view.frame.size.height)
/*
 float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
 float navigationHeight = self.navigationController.navigationBar.frame.size.height;
 */
@implementation JHOrguserTableViewController
-(NSArray *)parentidsArray {
//    if (_parentidsArray == nil) {
        _parentidsArray = [NSArray arrayWithArray:[JHOrguserManger sharedJHOrguserManger].superiorParentidsArray.lastObject];
//    }
    return _parentidsArray;
}

-(void)getOrguserSuccess{
    JHOrguserTableViewController *ovc = [[JHOrguserTableViewController alloc]init];
     [self.navigationController pushViewController:ovc animated:YES];
}
-(void)dealloc {
   //视图消失时  自动删除 最后一个数组
    [[JHOrguserManger sharedJHOrguserManger]removerLastParentidsArray];
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    [JHNetworkManager sharedJHNetworkManager].getOrguserDelegate = self;
    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    return self.parentidsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"reuseIdentifier";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHOrguserTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier: cellIdentifier];
//        tableView.frame = TABLEVIEWFRAMEL;
    }
    JHOrguserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = self.parentidsArray[indexPath.row][@"DisplayValue"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[JHNetworkManager sharedJHNetworkManager]getUsersWithDic:self.parentidsArray[indexPath.row]];
    NSLog(@"%@",self.parentidsArray[indexPath.row]);

    self.title = self.parentidsArray[indexPath.row][@"DisplayValue"];
    JHNetworkManager *net = [JHNetworkManager new];
    net.getOrguserDelegate = self;
    
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
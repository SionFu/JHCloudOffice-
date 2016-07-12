//
//  JHPortalTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPortalTableViewController.h"
#import "JHModulesData.h"
#import "JHCategoryTableViewCell.h"
#import "JHModules.h"
#import "JHNetworkManager.h"
#import "JHPageTableViewController.h"
@interface JHPortalTableViewController ()
@property (nonatomic, strong)NSMutableArray *catrgoryArray;

@property (nonatomic ,strong ) UINib *nib;




@end

@implementation JHPortalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.catrgoryArray = [JHModulesData sharedJHModulesData].allModuleArray[i];
    ++i;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    i = 0;
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

    return self.catrgoryArray.count;
}
static int i = 0;
- (NSInteger)getNumberOfRowsInSection{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"CateGoryCell";
    
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHCategoryTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
    }
    JHCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    JHModules *data = self.catrgoryArray[indexPath.row];
    cell.textLabel.text = data.ModuleName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[[JHNetworkManager alloc]init] getPageSettingWithCurrentVC:[JHModulesData sharedJHModulesData].curreatVCIndex andRow:indexPath.row];
    
    JHPageTableViewController *pageVC = [[JHPageTableViewController alloc]init];
    UINavigationController *nvpageVC = [[UINavigationController alloc]initWithRootViewController:pageVC];
    JHModules *data = self.catrgoryArray[indexPath.row];
    pageVC.pageNage = data.ModuleName;
    //获取当前选择流程的流程数据
    [[JHNetworkManager sharedJHNetworkManager] getPageDatas];
    [self.navigationController presentViewController:nvpageVC animated:YES completion:nil];
    
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

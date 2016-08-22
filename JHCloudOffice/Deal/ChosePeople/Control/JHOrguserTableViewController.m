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
#import "JHPageDataManager.h"
@interface JHOrguserTableViewController ()<JHOrguser>
//声明表视图子类用这个表格初始化
@property (nonatomic, strong) NSArray *parentidsArray;
@property (nonatomic ,strong ) UINib *nib;
//上次选中的人员的行 cell
@property (nonatomic, strong) NSIndexPath *oldIndexPath;
/**
 *  储存选中人员的信息
 like:
 {
	Other1 : 孙树江,
	Key : tzr,
	Index : 10000,
	DisplayValue : 孙树江,
	Type : User,
	ExtType : User,
	Value : 056f4f9f-7070-4c20-83f2-3d1d50d4869c
 }
 */
@property (nonatomic, strong) NSDictionary *saveUserDic;
@end
#define TABLEVIEWFRAMEL CGRectMake(0, 0, self.view.frame.size.width /2, self.view.frame.size.height)
#define TABLEVIEWFRAMER CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.view.frame.size.height)
/*
 float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
 float navigationHeight = self.navigationController.navigationBar.frame.size.height;
 */
@implementation JHOrguserTableViewController
- (NSDictionary *)saveUserDic {
        _saveUserDic = [NSDictionary dictionaryWithDictionary:[JHOrguserManger sharedJHOrguserManger].saveUserDic];
    return _saveUserDic;
}
-(NSArray *)parentidsArray {
        _parentidsArray = [NSArray arrayWithArray:[JHOrguserManger sharedJHOrguserManger].superiorParentidsArray.lastObject];
    return _parentidsArray;
}

-(void)getOrguserSuccess{
    JHOrguserTableViewController *ovc = [[JHOrguserTableViewController alloc]init];
    [self.navigationController pushViewController:ovc animated:YES];
}
-(void)dealloc {
   //视图消失时  自动删除 最后一个数组
    [[JHOrguserManger sharedJHOrguserManger]removerLastParentidsArray];
    [[JHOrguserManger sharedJHOrguserManger].orguserTableViewArray.lastObject reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //将当前视图的 tableView 保存在数组中
    [[JHOrguserManger sharedJHOrguserManger].orguserTableViewArray addObject:self.tableView];
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
    }
    JHOrguserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = self.parentidsArray[indexPath.row][@"DisplayValue"];
    NSString *typeStr = self.parentidsArray[indexPath.row][@"Type"];
    if ([typeStr isEqualToString:@"OrganizationUnit"]) {
        cell.headImage.image = [UIImage imageNamed:@"ic_org"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if ([typeStr isEqualToString:@"Post"]||[typeStr isEqualToString:@"Group"]) {
        cell.headImage.image = [UIImage imageNamed:@"ic_post"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if ([typeStr isEqualToString:@"User"]) {
        cell.headImage.image = [UIImage imageNamed:@"ic_user"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (self.saveUserDic != nil&&[self.saveUserDic[@"Value"] isEqualToString: self.parentidsArray[indexPath.row][@"Value"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.oldIndexPath = indexPath;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.parentidsArray[indexPath.row][@"Type"] isEqualToString:@"User"]) {
        [JHOrguserManger sharedJHOrguserManger].saveUserDic = self.parentidsArray[indexPath.row];
        if (self.oldIndexPath == nil) {
            self.oldIndexPath = indexPath;
            //将 cell 的尾部 footImage 换成 勾 并储存这个 user 的字典内容
            [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        }else {
            if (self.oldIndexPath == indexPath) {
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else {
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                [tableView cellForRowAtIndexPath:self.oldIndexPath].accessoryType = UITableViewCellAccessoryNone;
                self.oldIndexPath = indexPath;
            }
        }
    }else {
        [[JHNetworkManager sharedJHNetworkManager]getUsersWithDic:self.parentidsArray[indexPath.row]];
        self.title = self.parentidsArray[indexPath.row][@"DisplayValue"];
        JHNetworkManager *net = [JHNetworkManager new];
//        JHOrguserTableViewController *ovc = [[JHOrguserTableViewController alloc]init];
//        [self.navigationController pushViewController:ovc animated:YES];
        net.getOrguserDelegate = self;
    }
    
}


@end

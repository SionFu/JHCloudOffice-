//
//  JHUserTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/7.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHUserTableViewController.h"
#import "JHFileManger.h"
#import "JHUserTableViewCell.h"
@interface JHUserTableViewController ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic ,strong) NSArray *contentArray;
@property (nonatomic ,strong) UINib *nib;
@end

@implementation JHUserTableViewController
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"已下载视图:%@",self.tableView);
    [self.tableView reloadData];
}
static  int nowIndexTableView = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  index == 1 我的订阅
     *  index == nil 我的邮件
     *  index == 2 我的流程
     *  index == nil 通知公告
     *  index == 3 已下载文件
     */
    nowIndexTableView++;
    if (nowIndexTableView == 3) {
        NSArray *filePathArray = [[JHFileManger new] showAllFile];
        NSLog(@"%@",filePathArray);
        self.contentArray = [NSArray arrayWithArray:filePathArray];
    }
    
    //自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //预估值
    self.tableView.estimatedRowHeight = 200;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return self.contentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"User";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHUserTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier: cellIdentifier];
    }
    JHUserTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.contentArray[indexPath.row][@"title"];
    cell.detailTextLabel.text = self.contentArray[indexPath.row][@"subTitle"];
    return cell;
}

#pragma Mark didselect
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (nowIndexTableView == 5 ) {
        NSLog(@"openFile");
        NSURL *url = [NSURL fileURLWithPath:self.contentArray[indexPath.row][@"filePath"]];
        _documentInteractionController = [UIDocumentInteractionController
                                          interactionControllerWithURL:url];
        [_documentInteractionController setDelegate:self];
        
        [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }
}

@end

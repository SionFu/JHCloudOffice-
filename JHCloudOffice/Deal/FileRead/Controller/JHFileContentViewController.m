//
//  JHFileContentViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/2.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHFileContentViewController.h"
#import "JHWeaverNetManger.h"
#import "MBProgressHUD+KR.h"
@interface JHFileContentViewController ()

@end

@implementation JHFileContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [MBProgressHUD showMessage:@"正在载入..."];
    JHWeaverNetManger *manger = [JHWeaverNetManger new];
    [manger docInfoContentObjectGetDocContentWithDocId:[NSString stringWithFormat:@"%d",self.docId]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

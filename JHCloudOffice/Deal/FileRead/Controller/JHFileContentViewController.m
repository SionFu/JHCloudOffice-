//
//  JHFileContentViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/2.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHFileContentViewController.h"
#import "JHWeaverNetManger.h"
#import "JHDocModel.h"
#import "MBProgressHUD+KR.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
@interface JHFileContentViewController ()<JHFileContentDelegate,UIWebViewDelegate>
/**
 *  进度条
 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/**
 *  显示文件内容 webView 视图
 */
@property (weak, nonatomic) IBOutlet UIWebView *fileContentWebView;
/**
 *  下载文件列表
 */
@property (weak, nonatomic) IBOutlet UIScrollView *fileSubScroolView;
/**
 *  文件中下载文件的 文件列表数组
 */
@property (nonatomic, strong) NSArray *fileSubArray;
/**
 *  文件中信息的内容 html 标记语言
 */
@property (nonatomic, strong) NSString *fileContentDetailStr;
@property (nonatomic ,strong) JHWeaverNetManger *manger;
@end

@implementation JHFileContentViewController
-(NSArray *)fileSubArray {
    return [JHDocModel sharedJHDocModel].fileSubArray;
}
-(NSString *)fileContentDetailStr {
    return [JHDocModel sharedJHDocModel].fileContentDetailStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件查看";
    [MBProgressHUD showMessage:@"正在载入..."];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(closeScanVC)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    self.manger = [JHWeaverNetManger new];
    self.manger.getFileContentDelegate = self;
    [self.manger docInfoContentObjectGetDocContentWithDocId:[NSString stringWithFormat:@"%d",self.docId]];
}
- (void)getFileContentSuccess {
    [MBProgressHUD hideHUD];
    self.fileContentWebView.delegate = self;
    NSLog(@"\n文件列表:%@",self.fileSubArray);
    [self.fileContentWebView loadHTMLString:self.fileContentDetailStr baseURL:nil];
    [self addFileArrayToButton];
}
- (void)addFileArrayToButton {
    for (int i = 0; i< self.fileSubArray.count; i++) {
        NSDictionary *fileDic = self.fileSubArray[i];
        UIButton *btn  = [[UIButton alloc]initWithFrame:CGRectMake(0, i * 30,SCREENWIDTH, 30)];
        [btn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setTitle:fileDic[@"fileName"] forState:UIControlStateNormal];
        [btn setTag:i+100];
        [btn addTarget:self action:@selector(fileDownBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.fileSubScroolView addSubview:btn];
    }
}
- (void)fileDownBtnClick:(UIButton *)sender {
    NSString *filePath = self.fileSubArray[sender.tag - 100][@"realpath"];
    //downloadFile
    [self.manger downloadFileWithRealPath:filePath];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    
    self.progressView.progress = totalBytesWritten *1.0 / totalBytesExpectedToWrite;
    NSLog(@"%f",self.progressView.progress);
    
    
}

-(void)getFileContentFaild {
    [MBProgressHUD showError:@"网络错误"];
}
-(void)closeScanVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

//
//  JHScanCRCodeViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHScanCRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "JHSendMailViewController.h"
@interface JHScanCRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *viewLayer;
@end

@implementation JHScanCRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *liftButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeScanVC)];
    [self.navigationItem setLeftBarButtonItem:liftButton];
    self.title = @"二维码扫描";
    //模拟器不能打开摄像头
//    [self starScanCIQRCode];
}
- (void)starScanCIQRCode {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *deviceinput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"扫描失败");
    }else {
        NSLog(@"扫描成功");
        
    }
    AVCaptureMetadataOutput *metadataOutput = [AVCaptureMetadataOutput new];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _session = [AVCaptureSession new];
    [_session addInput:deviceinput];
    [_session addOutput:metadataOutput];
    //设置视屏质量
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    //设置监听类型(必须在管道设置完之后)
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code];
    //把数据输出到屏幕上,给用户看
    _viewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _viewLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer addSublayer:self.viewLayer];
    //启动管道
    [self.session startRunning];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [_viewLayer removeFromSuperlayer];
        //取出扫描的数据
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
        NSString *str = [NSString stringWithFormat:@"%@",obj];
        NSLog(@"%@",str);
        //推出发送邮件视图
        JHSendMailViewController *sMailVC  = [JHSendMailViewController new];
        sMailVC.title = @"发送邮件";
        UINavigationController *nVC = [[UINavigationController alloc]initWithRootViewController:sMailVC];
        [self.navigationController presentViewController:nVC animated:YES completion:^{
           //显示邮件发送标题
            //传入发送邮件给谁的数据
        }];
    }
}
- (void)closeScanVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  JHDealViewViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHDealViewViewController.h"
#import "JHHoneHeadView.h"
#import "JHUserInfo.h"
#import "JHNetworkManager.h"
#import "JHProcessViewController.h"
#import "JHScanCRCodeViewController.h"
#import "JHSendMailViewController.h"
#import "JHDocTableViewController.h"
#import "MBProgressHUD+KR.h"

@interface JHDealViewViewController ()<JHHomeMenuButtonDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
/**
 *  用户姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *heandImageView;
/**
 *  显示本人的二维码
 */
- (IBAction)cIQRCodeButton:(id)sender;
@property (nonatomic, strong)NSString *userCIQRCodeStr;

@end

@implementation JHDealViewViewController
- (void)viewWillAppear:(BOOL)animated {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置滚动选择视图
    [self setUpHomeHeadView];
    //显示用户登陆信息
    [self showUserInfo];
    [self.heandImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageViewTep)]];
    //获取形成用户的二维码字符串
    [self getuserCIQRCodeStr];
    

}
- (void)searchBtnClick {
    NSLog(@"进入搜索视图");
}
-(void)headImageViewTep{
    //只能选择相册
//    [self choolImage:UIImagePickerControllerSourceTypePhotoLibrary];
    //警告框选择 两种选项
//        UIActionSheet *sht1 = [[UIActionSheet alloc]initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
//        [sht1 showInView:self.view];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择照片来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //可以打开相机
            UIImagePickerController *pc = [[UIImagePickerController alloc]init];
            pc.allowsEditing = YES;
            pc.delegate = self;
            pc.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pc animated:YES completion:nil];
        }
    }];
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *pc = [[UIImagePickerController alloc]init];
            pc.allowsEditing = YES;
            pc.delegate = self;
            pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pc animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 2) {
//    }else if (buttonIndex == 1){
//        UIImagePickerController *pc = [[UIImagePickerController alloc]init];
//        pc.allowsEditing = YES;
//        pc.delegate = self;
//        pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:pc animated:YES completion:nil];
//    }else{
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            //可以打开相机
//        }else{
//            NSLog(@"该设备暂时不支持打开相机");
//        }
//    }
//}

//-(void)choolImage:(UIImagePickerControllerSourceType)type{
//    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//    picker.sourceType =type;
//    picker.allowsEditing = YES;
//    //设置代理
//    picker.delegate = self;
//    [self presentViewController:picker animated:YES completion:nil];
//}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];//取原图还是编辑过的图片
        self.heandImageView.image = image;//选择的图片
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showUserInfo {
    self.nameLabel.text = [JHUserInfo sharedJHUserInfo].name;
    self.companyLabel.text = [JHUserInfo sharedJHUserInfo].company;
}
- (void)setUpHomeHeadView {
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    JHHoneHeadView *headView = [[JHHoneHeadView alloc]initWithFrame:CGRectMake(0, 0, screenWith, screenWith / 1.5)];
    headView.delegate = self;
    [self.headView addSubview: headView];
}
-(void)clickHomeMenuButton:(long)sender{
    NSLog(@"%ld",sender - 100);
    switch (sender - 100) {
        case 0:{
            JHProcessViewController *evc = [JHProcessViewController new];
            evc.title = @"发起流程";
            [self.navigationController pushViewController:evc animated:YES];
                }
            break;
        case 1:{
            //发送邮件
            JHSendMailViewController *sMailVC  = [JHSendMailViewController new];
            sMailVC.title = @"发送邮件";
            UINavigationController *nVC = [[UINavigationController alloc]initWithRootViewController:sMailVC];
            [self.navigationController presentViewController:nVC animated:YES completion:^{
                
            }];
        }
            break;
        case 2:{
            //打开集团彩云 app
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uban://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"uban://"]];
            }
            else
            {
                [MBProgressHUD showError:@"请先安装集团彩云App"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://"]];
            }
        }
            break;
        case 3:{
            //扫描二维码
            JHScanCRCodeViewController *sVC = [JHScanCRCodeViewController new];
            UINavigationController *uVC = [[UINavigationController alloc]initWithRootViewController:sVC];
            [self.navigationController presentViewController:uVC animated:YES completion:nil];
        }
            break;
        case 4:{
            //显示用户文档
            JHDocTableViewController *docVC = [JHDocTableViewController new];
            [self.navigationController pushViewController:docVC animated:YES];
        }
            break;
        default:
            break;
    }
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
#pragma GetAndShowUserCIQRCode
- (void)getuserCIQRCodeStr {
    self.userCIQRCodeStr = [NSString stringWithFormat:@"user:%@:%@:%@",[JHUserInfo sharedJHUserInfo].objectId,[JHUserInfo sharedJHUserInfo].name,[JHUserInfo sharedJHUserInfo].loginid];
}
- (IBAction)cIQRCodeButton:(id)sender {
    NSData *dataCode = [self.userCIQRCodeStr dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];//二维码
    [filter setValue:dataCode forKey:@"inputMessage"];
    CIImage *ciimage = filter.outputImage;
    UIImageView *ciqrCodeView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 50, 150, 150)];
    ciqrCodeView.layer.shadowOffset = CGSizeMake(0, 0.5);
    ciqrCodeView.layer.shadowColor = [UIColor blackColor].CGColor;
    ciqrCodeView.layer.shadowOpacity = 0.3;
    ciqrCodeView.image = [self createNonInterpolatedUIImageFormCIImage:ciimage size:500];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"我的二维码\n\n\n\n\n\n\n" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC.view addSubview:ciqrCodeView];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];

}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)ciImage size:(CGFloat)widthAndHeight
{
    CGRect extentRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(widthAndHeight / CGRectGetWidth(extentRect), widthAndHeight / CGRectGetHeight(extentRect));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extentRect) * scale;
    size_t height = CGRectGetHeight(extentRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    //    return [UIImage imageWithCGImage:scaledImage]; // 黑白图片
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    return [self imageBlackToTransparent:newImage withRed:52.0f andGreen:140.0f andBlue:220.0f];
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

@end

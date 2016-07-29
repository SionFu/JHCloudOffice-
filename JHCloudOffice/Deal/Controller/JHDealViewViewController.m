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
@interface JHDealViewViewController ()<JHHomeMenuButtonDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
/**
 *  用户姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *heandImageView;

@end

@implementation JHDealViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置滚动选择视图
    [self setUpHomeHeadView];
    //显示用户登陆信息
    [self showUserInfo];
    [self.heandImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageViewTep)]];

}
-(void)headImageViewTep{
    //只能选择相册
//    [self choolImage:UIImagePickerControllerSourceTypePhotoLibrary];
    //警告框选择 两种选项
//        UIActionSheet *sht1 = [[UIActionSheet alloc]initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
//        [sht1 showInView:self.view];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择照片来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    NSLog(@"%@",info);
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
            [self.navigationController pushViewController:evc animated:YES];
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

@end

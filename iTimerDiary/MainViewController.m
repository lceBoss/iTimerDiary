//
//  MainViewController.m
//  iTimerDiary
//
//  Created by tarena on 15/12/4.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "MainViewController.h"
#import "YRSideViewController.h"
#import "LCEDrawigViewController.h"
#import "LCEWriteDiaryViewController.h"
#import "LCEDrawImageViewController.h"
#import "LCEAlbumViewController.h"
#import "CLLockVC.h"

@interface MainViewController ()

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSString *isHasPwdPath;

@property (nonatomic, strong) UIView *pwdView;

@end

@implementation MainViewController




- (void)loadView {
    
    [super loadView];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.fileManager = [NSFileManager defaultManager];
    
    self.isHasPwdPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"PwdDidSetUp"];
    
    //  取isHasPwdPath文件
    if (YES == [self.fileManager fileExistsAtPath:self.isHasPwdPath]) {
        
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
            
            
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
            [lockVC dismiss:0];
            
        }];
        
    }

    
    self.navigationController.navigationBar.hidden = YES;
    
    
    
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.view.frame] ;
    
    imageview.image = [UIImage imageNamed:@"main_view_bg"];
    
    [self.view insertSubview:imageview atIndex:0];
    
    
}

- (IBAction)drawImage:(id)sender {
    
    YRSideViewController *sideVC = [[YRSideViewController alloc]init];;
    LCEDrawigViewController *drawingViewController = [[LCEDrawigViewController alloc]init];
    sideVC.leftViewController = drawingViewController;
    sideVC.leftViewShowWidth = 200;
    LCEDrawImageViewController *drawingImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"drawingImage"];
    drawingImageViewController.sideViewController = sideVC;
    drawingViewController.showrootVC = sideVC;
    sideVC.rootViewController = drawingImageViewController;
    drawingViewController.delegate = drawingImageViewController;
    [self presentViewController:sideVC animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark ---- 设置导航栏隐藏（当点击按钮时）

- (IBAction)clickWriteDiary:(id)sender {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

//- (IBAction)clickAlbumButton:(id)sender {
//    LCEAlbumViewController *albumVC = [[LCEAlbumViewController alloc] init];
//    
//    [self presentViewController:albumVC animated:YES completion:nil];
//    
//}


@end

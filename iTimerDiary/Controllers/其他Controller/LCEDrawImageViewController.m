//
//  LCEDrawImageViewController.m
//  iTimerDiary
//
//  Created by tarena on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCEDrawImageViewController.h"
#import "LCEdimageview.h"
#import "YRSideViewController.h"

@interface LCEDrawImageViewController ()
@property(nonatomic,strong)LCEdimageview *imageview;
@end

@implementation LCEDrawImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageview];
    
}

- (IBAction)backHome:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)drawingViewController:(LCEDrawigViewController *)drawingViewController didClickColorButton:(UIButton *)button withObject:(id)obj {
    self.imageview.color = obj;
    
    
}
- (void)drawingViewController:(LCEDrawigViewController *)drawingViewController didClickLineWidthButton:(UIButton *)button withLineWidth:(CGFloat)lineWidth {
    self.imageview.lineWidth = lineWidth;
    
    
}
- (void)drawingViewController:(LCEDrawigViewController *)drawingViewController didClickcleanActionButton:(UIButton *)button withcleanAction:(CGFloat)lineWidth  cleancolor:(UIColor *)color{
    self.imageview.lineWidth = lineWidth;
    self.imageview.color = color;
    
}

- (LCEdimageview *)imageview {
	if(_imageview == nil) {
		_imageview = [[LCEdimageview alloc] initWithFrame:self.view.frame];
        
        _imageview.backgroundColor = [UIColor clearColor];
        
        UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        leftbtn.frame = CGRectMake(self.imageview.frame.size.width-70, self.view.frame.size.height-110, 40, 40);
        
        [leftbtn setTitle:@"选颜色" forState:UIControlStateNormal];
        
        [leftbtn setBackgroundImage:[UIImage imageNamed:@"config_color"] forState:UIControlStateNormal];
        
        [leftbtn addTarget:self action:@selector(selectColor) forControlEvents:UIControlEventTouchUpInside];
        
        [_imageview addSubview:leftbtn];
        
	}
	return _imageview;
}
- (void)selectColor {
    
    [self.sideViewController showLeftViewController:YES];
}
- (IBAction)saveimageView:(id)sender {
    
    CGRect rect = CGRectMake(0, 20, self.imageview.frame.size.width , self.imageview.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIRectClip(CGRectMake(0, 0, self.imageview.frame.size.width, self.imageview.frame.size.height-120));
    [self.imageview.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    SEL abc = @selector(image:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(image, self, abc, NULL);
  
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
  
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];

    [alert show];

}

@end

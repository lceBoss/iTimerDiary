//
//  LCEDrawigViewController.m
//  iTimerDiary
//
//  Created by tarena on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCEDrawigViewController.h"
#import "LCEdimageview.h"
#define kwidth [UIScreen mainScreen].bounds.size.width
@interface LCEDrawigViewController (){
    UIView *backGroundView;
    UIView *selectColorView;
    UIView *selectWidthView;
    NSArray *ColorArray;
    UIButton *showrootVCbtn;
}


@end

@implementation LCEDrawigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imagevc = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    imagevc.image = [UIImage imageNamed:@"draw_bg_view"];
    
    [self.view insertSubview:imagevc  atIndex:0];
    
    [self myToolBar]; //创建工具栏视图

}


- (void)myToolBar {
    
    backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 200, kwidth+125)];
    backGroundView.backgroundColor = [UIColor clearColor];
    backGroundView.alpha = .75;
    [self.view addSubview:backGroundView]; //设置背景视图
    
    //创建功能按钮
    NSArray *functionArray = @[@"select_color",@"select_line_width"];
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        //[button setTitle:functionArray[i] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageNamed:functionArray[i]] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(kwidth / 4 * i+25, 0, 40, 40);
        button.tag = i + 10;
        [button addTarget:self action:@selector(moveRedView:) forControlEvents:UIControlEventTouchUpInside];
        [backGroundView addSubview:button];
    }
    
    //设置颜色选择按钮
    ColorArray = @[[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor redColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor],[UIColor blackColor],[UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor grayColor]];
    
    selectColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 100, kwidth+60)];
    selectColorView.backgroundColor  = [UIColor clearColor];
    
    [backGroundView addSubview:selectColorView];
    
    for (NSInteger j = 0; j < 12; j ++) {
        UIButton *selectColorbutton = [UIButton buttonWithType:UIButtonTypeSystem];
        [selectColorbutton setBackgroundColor:ColorArray[j]];
        [selectColorbutton setTitle:@"✨" forState:0];
        [selectColorbutton setShowsTouchWhenHighlighted:YES];
        selectColorbutton.frame = CGRectMake(20, 5 + (kwidth +60)/ 12 * j, 50, kwidth / 12 - 3);
        selectColorbutton.tag = j + 20;
        [selectColorbutton addTarget:self action:@selector(selectColorAction:) forControlEvents:UIControlEventTouchUpInside
         ];
        [selectColorView addSubview:selectColorbutton];
        
    }
    
    //设置线宽选择按钮
    selectWidthView = [[UIView alloc] initWithFrame:CGRectMake(100,50, 100, kwidth+60)];
    selectWidthView.backgroundColor = [UIColor clearColor];
    selectWidthView.hidden = YES;
    [backGroundView addSubview:selectWidthView];
    
    for (NSInteger k = 1; k <= 11; k++) {
        UIButton *lineWidthButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [lineWidthButton setTitle:[NSString stringWithFormat:@"%li",k] forState:UIControlStateNormal];
        [lineWidthButton setShowsTouchWhenHighlighted:YES];
        lineWidthButton.frame = CGRectMake(20, -5 + kwidth /10 * (k - 1),kwidth /10-5, 60);
        [lineWidthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        lineWidthButton.tag = k + 30;
        [lineWidthButton addTarget:self action:@selector(lineWidthAction:) forControlEvents:UIControlEventTouchUpInside];
        [selectWidthView addSubview:lineWidthButton];
        
        
    }
    
    //创建红色视图
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(23, 45, 40, 3)];
    redView.tag = 50;
    redView.backgroundColor = [UIColor redColor];
    [backGroundView addSubview:redView];
    
}



- (void)moveRedView:(UIButton *)button {
    //点击按钮时实现红色视图的移动
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    UIView *view = [backGroundView viewWithTag:50];
    CGFloat x = button.frame.origin.x;
    view.frame = CGRectMake(x, 45, 40, 3);
    [UIView commitAnimations];
    //点击按钮实现工具栏的切换
    if (button.tag == 11) {
        selectColorView.hidden = YES;
        selectWidthView.hidden = NO;
    }else if (button.tag == 10) {
        selectColorView.hidden = NO;
        selectWidthView.hidden = YES;
    }

}
//改变线条宽度
- (void)lineWidthAction:(UIButton *)button {
    
    CGFloat line = button.tag - 30;
    [self.delegate drawingViewController:self didClickLineWidthButton:button withLineWidth:line];
}
//改变线条颜色
- (void)selectColorAction:(UIButton *)button {
    
    id abc = ColorArray[button.tag-20];
    
    [self.delegate drawingViewController:self didClickColorButton:button withObject:abc];
}
//-(void)showerootVC{
//    
//    [self.showrootVC hideSideViewController:YES];
//}

@end

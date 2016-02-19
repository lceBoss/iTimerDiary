//
//  UIButton+LCESetBtnImage.m
//  iTimerDiary
//
//  Created by tarena on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "UIButton+LCESetBtnImage.h"

@implementation UIButton (LCESetBtnImage)

+ (UIButton *)buttonWithImageName:(NSString *)imageName withSelectedImageName:(NSString *)selectedImageName withTarget:(id)target withAction:(SEL)action {
    UIButton * button = [UIButton new];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, 50, 50);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonWithImageName:(NSString *)imageName withSelectBgImageName:(NSString *)selectBgImageName withTarget:(id)target withAction:(SEL)action {
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:selectBgImageName] forState:UIControlStateSelected];
    //[self setImage:[UIImage imageNamed:selectBgImageName] forState:UIControlStateSelected];
    self.frame = CGRectMake(0, 0, 40, 40);
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}


@end

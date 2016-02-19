//
//  UIButton+LCESetBtnImage.h
//  iTimerDiary
//
//  Created by tarena on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LCESetBtnImage)

+ (UIButton *)buttonWithImageName:(NSString *)imageName withSelectedImageName:(NSString *)selectedImageName withTarget:(id)target withAction:(SEL)action;

- (void)buttonWithImageName:(NSString *)imageName withSelectBgImageName:(NSString *)selectBgImageName withTarget:(id)target withAction:(SEL)action;

@end

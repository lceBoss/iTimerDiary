//
//  LCEDrowRoundView.h
//  iTimerDiary
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCEDrowRoundView : UIView

// 公开一个属性,用于记录外界传入的当前进度数值
@property(nonatomic)CGFloat downloadValue;

// 公开一个属性,用于记录外界传入的圆弧的颜色
@property(nonatomic,strong)UIColor *downloadColor;

@end

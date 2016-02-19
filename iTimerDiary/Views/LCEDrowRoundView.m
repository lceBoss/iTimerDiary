//
//  LCEDrowRoundView.m
//  iTimerDiary
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCEDrowRoundView.h"

@implementation LCEDrowRoundView



- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    CGFloat minWidth = MIN(self.bounds.size.width, self.bounds.size.height);
    
    // 设计圆弧
    [path addArcWithCenter:center radius:minWidth/2-10 startAngle:M_PI_2*3 endAngle:M_PI_2*3+self.downloadValue*2*M_PI clockwise:YES];
    
    // 设置颜色
    //if(self) if(self!=nil )
    if (self.downloadColor) {
        [self.downloadColor setStroke];
    }else{
        [[UIColor blueColor] setStroke];
    }
    
    path.lineWidth = 8;
    
    [path stroke];
}


@end

//
//  LCEdimageview.h
//  iTimerDiary
//
//  Created by tarena on 15/12/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSideViewController.h"

@interface LCEdimageview : UIView{
    CGPoint _start;
    CGPoint _move;
    CGMutablePathRef _path;
    NSMutableArray *_pathArray;
    CGFloat _lineWidth;
    UIColor *_color;
}
@property (nonatomic,assign)CGFloat lineWidth;
@property (nonatomic,strong)UIColor *color;
@property (nonatomic,strong)NSMutableArray *pathArray;




@end

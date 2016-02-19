//
//  LCEDrawigViewController.h
//  iTimerDiary
//
//  Created by tarena on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSideViewController.h"
@class LCEDrawigViewController;
@protocol LCEDrawigViewControllerDelegate
- (void)drawingViewController:(LCEDrawigViewController *)drawingViewController didClickColorButton:(UIButton *)button withObject:(id)obj;
- (void)drawingViewController:(LCEDrawigViewController *)drawingViewController didClickLineWidthButton:(UIButton *)button withLineWidth:(CGFloat)lineWidth;
- (void)drawingViewController:(LCEDrawigViewController *)drawingViewController didClickcleanActionButton:(UIButton *)button withcleanAction:(CGFloat)lineWidth  cleancolor:(UIColor *)color;
@end
@interface LCEDrawigViewController : UIViewController

@property (nonatomic, weak) id<LCEDrawigViewControllerDelegate> delegate;

@property(nonatomic,weak)YRSideViewController *showrootVC;

@end

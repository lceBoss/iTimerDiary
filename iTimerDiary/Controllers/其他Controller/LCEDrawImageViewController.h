//
//  LCEDrawImageViewController.h
//  iTimerDiary
//
//  Created by tarena on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCEDrawigViewController.h"
#import "YRSideViewController.h"

@interface LCEDrawImageViewController : UIViewController<LCEDrawigViewControllerDelegate>
@property (nonatomic, weak) YRSideViewController *sideViewController;
@end

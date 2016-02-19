//
//  LCESetIconViewController.h
//  iTimerDiary
//
//  Created by tarena on 15/12/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCESetIconViewController;

@protocol LCESetIconViewControllerDelegate <NSObject>

- (void)lceSetIconViewController:(LCESetIconViewController *)LCESetIconVC didFinishSelectedWeatherImage:(UIImage *)image withImageName:(NSString *)imageName;
- (void)lceSetIconViewController:(LCESetIconViewController *)LCESetIconVC didFinishSelectedKindImage:(UIImage *)image withImageName:(NSString *)imageName;
- (void)lceSetIconViewController:(LCESetIconViewController *)LCESetIconVC didFinishSelectedPaperImage:(UIImage *)image withImageName:(NSString *)imageName;
@end

@interface LCESetIconViewController : UIViewController

@property (nonatomic, strong) id <LCESetIconViewControllerDelegate> delegate;

@end

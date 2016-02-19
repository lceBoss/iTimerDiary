//
//  LCEDateSelectViewController.h
//  iTimerDiary
//
//  Created by tarena on 15/12/8.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCEDateSelectViewController;
@protocol LCEDateSelectViewControllerDelegate <NSObject>

-(void)setDateVC:(LCEDateSelectViewController *)setDateVC setWriteDiaryDate:(NSDate *)date;

@end
@interface LCEDateSelectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property(nonatomic,weak)id<LCEDateSelectViewControllerDelegate> delegate;

@end

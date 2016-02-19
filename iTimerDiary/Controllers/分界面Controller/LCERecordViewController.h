//
//  LCERecordViewController.h
//  iTimerDiary
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCERecordViewController;

@protocol LCERecordViewControllerDelegate <NSObject>

- (void)lceRecordViewController:(LCERecordViewController *)lceRecordVC didFinishRecord:(NSString *)soundFilePath withSoundDate:(NSDate *)soundDate;
   
@end

@interface LCERecordViewController : UIViewController

@property (nonatomic, weak) id<LCERecordViewControllerDelegate> delegate;


@end

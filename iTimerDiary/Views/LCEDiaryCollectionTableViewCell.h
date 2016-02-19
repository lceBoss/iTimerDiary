//
//  LCEDiaryCollectionTableViewCell.h
//  iTimerDiary
//
//  Created by tarena on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCEDiaryCollectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *kindImageView;
@property (weak, nonatomic) IBOutlet UIImageView *paperImageView;

@property (weak, nonatomic) IBOutlet UIImageView *recordImageView;
@property (weak, nonatomic) IBOutlet UILabel *diaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthAndDayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cameraImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diaryTextRightConstraint;

@end

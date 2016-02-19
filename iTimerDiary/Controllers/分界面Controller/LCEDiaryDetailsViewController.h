//
//  LCEDiaryDetailsViewController.h
//  iTimerDiary
//
//  Created by tarena on 15/12/26.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RACollectionViewReorderableTripletLayout.h>

@interface LCEDiaryDetailsViewController : UIViewController<RACollectionViewDelegateReorderableTripletLayout, RACollectionViewReorderableTripletLayoutDataSource>

@property (nonatomic, strong) NSDictionary *diaryDetailsDic;

@end

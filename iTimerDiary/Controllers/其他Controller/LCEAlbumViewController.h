//
//  LCEAlbumViewController.h
//  iTimerDiary
//
//  Created by tarena on 16/1/1.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACollectionViewReorderableTripletLayout.h"

@interface LCEAlbumViewController : UIViewController <RACollectionViewDelegateReorderableTripletLayout, RACollectionViewReorderableTripletLayoutDataSource>

@property (nonatomic, strong) NSDictionary *diaryDetailsDic;

@end

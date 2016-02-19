//
//  LCECameraViewController.h
//  iTimerDiary
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCECameraViewController;
@protocol  LCECameraViewControllerDelegate<NSObject>

-(void)cameraVC:(LCECameraViewController *)cameraVC setWriteDiaryCarmera:(NSArray *) photos;
@end

@interface LCECameraViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *cameraCollectionview;
@property (nonatomic, strong) NSMutableArray *cameraMutableArray;

@property(nonatomic,weak)id<LCECameraViewControllerDelegate> delegate;

@end

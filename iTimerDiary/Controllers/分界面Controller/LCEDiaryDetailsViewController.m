//
//  LCEDiaryDetailsViewController.m
//  iTimerDiary
//
//  Created by tarena on 15/12/26.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCEDiaryDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RACollectionViewCell.h"
#import "UMSocial.h"

#define kUMKey @"568134f367e58e334a001107"

#define kWBKey @"3549456642"

#define kWBSecret @"8a34286b03e6c73a5ca81926fe256ee5"

////友盟
//#define kUMKey    @"5657f8a367e58e3b660032d7"
////微信
//#define kWXKey    @"wx945b58aef3a271f0"
//#define kWXSecret   @"0ae78dd42761fd9681b04833c79a857b"



@interface LCEDiaryDetailsViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@property (nonatomic, strong) NSURL *fileURL;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *kindImageView;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@property (weak, nonatomic) IBOutlet UIImageView *paperImageView;

@property (weak, nonatomic) IBOutlet UITextView *diaryTextView;

@property (weak, nonatomic) IBOutlet UIButton *playSoundButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopConstraint;

@property (nonatomic, strong) NSMutableArray *photosArray;

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, strong) NSString *documentsPath;

//创建一个计时器来记录录音时间
@property (nonatomic, strong) NSTimer * timer;

//创建一个中间常量
@property (nonatomic, assign) NSTimeInterval timeInterval;

@end

@implementation LCEDiaryDetailsViewController

- (NSArray *)photos {
    if (!_photos) {
        _photos = [NSArray array];
    }
    return _photos;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.photoCollectionView.delegate = self;
    
    self.photoCollectionView.dataSource = self;
    
    self.navigationItem.title = @"日记详情";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:0 target:self action:@selector(clickEditBatButton)];

    [self showDiaryDetails];
    
    self.documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    if (self.photos.count != 0) {
        
        [self setupPhotosArray];
        
    }else {
        self.buttonTopConstraint.constant = 5;
        
        self.photoCollectionView.hidden = YES;
        //在动画内调用 layoutIfNeeded方法
        [UIView animateWithDuration:0 delay:0 options:optind animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];

    }
    
}

//player的懒加载
-(AVAudioPlayer *)player
{
    if (!_player) {
        
        NSError *error=nil;
        
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:self.fileURL error:&error];
        
        
        _player.delegate = self;
        
        
        
        if (error) {
            
            NSLog(@"error = %@",error);
            
        }
        
        [_player prepareToPlay];
            
            
    }
    return _player;
}


- (void)showDiaryDetails {
    
    NSDate *date = self.diaryDetailsDic[@"date"];
    
    NSString *kindImageName = self.diaryDetailsDic[@"look_kind"];
    
    NSString *weatherImageName = self.diaryDetailsDic[@"look_weather"];
    
    NSString *paperImageName = self.diaryDetailsDic[@"paper_icon"];
    
    NSString *diaryText = self.diaryDetailsDic[@"diaryText"];
    
    NSString *soundFilePath = self.diaryDetailsDic[@"soundFilePath"];
    
    self.photos = self.diaryDetailsDic[@"photos"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    
    dateFormatter.dateFormat = @"yyyy年MM月dd日 EEEE HH:mm";

    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    self.dateLabel.text = dateStr;
    
    self.weatherImageView.image = [UIImage imageNamed:weatherImageName];
    
    self.kindImageView.image = [UIImage imageNamed:kindImageName];
    
    self.diaryTextView.text = diaryText;
    
    self.paperImageView.image = [UIImage imageNamed:paperImageName];
    
    if (soundFilePath != nil) {
        
        NSString *str = [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject], soundFilePath];
        
        
        self.fileURL = [NSURL fileURLWithPath:str];
        
        
        [self.playSoundButton setImage:[UIImage imageNamed:@"start_play_button"] forState:UIControlStateNormal];
        
        [self.playSoundButton setImage:[UIImage imageNamed:@"stop_play_button"] forState:UIControlStateSelected];
        
        [self.playSoundButton addTarget:self action:@selector(clickPlaySoundButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }else {
        
        [self.playSoundButton setImage:[UIImage imageNamed:@"add_sound_file_no"] forState:UIControlStateNormal];
        
        self.playSoundButton.enabled = NO;
        
    }
    
}

- (void)clickPlaySoundButton:(NSString *)soundFilePath {
    
    self.playSoundButton.selected = !self.playSoundButton.selected;
    
    UInt32 doChangeDefaultRoute = 1;
    
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    if (self.playSoundButton.selected == YES) {
        
        [self.player play];
        
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playSoundDuration:) userInfo:nil repeats:YES];
        
        self.timer = timer;
        
        
    }else {
        
        [self.player pause];
        
    }

}
- (void)playSoundDuration:(NSTimer *)timer {
    self.timer = timer;
    
    self.timeInterval += 1;
    
    if (self.timeInterval > self.player.duration) {
        
        self.playSoundButton.selected = NO;
        
        [self.timer invalidate];
        
    }
}



- (void)clickEditBatButton {
    
    //创建AlertController实例，并说明样式
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //有分享功能
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享到社交网络" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了分享按钮");
        //执行分享日记功能
        
        CGRect rect = CGRectMake(0, 20, self.view.frame.size.width , self.view.frame.size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIRectClip(CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-10));
        [self.view.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        
        //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
        [UMSocialSnsService presentSnsIconSheetView:self appKey:kUMKey shareText:[NSString stringWithFormat:@"我写的一篇日记，分享给你们哈:%@", self.diaryTextView.text] shareImage:image
          shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession, UMShareToQQ, UMShareToSms, UMShareToEmail, UMShareToQzone,nil] delegate:nil];
        
        
    }];
    
    //有取消功能按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    //添加行为到控制器中
    [alertController addAction:shareAction];
    
    [alertController addAction:cancelAction];
    
    //推出控制器，显示界面
    //两个控制器之间的切换，方法一就是使用present方法
    [self presentViewController:alertController animated:YES completion:nil];
}





- (void)setupPhotosArray
{
    [_photosArray removeAllObjects];
    
    _photosArray = nil;
    
    _photosArray = [NSMutableArray array];
    
    for (int i = 0; i < self.photos.count; i++) {
        
        UIImage *photo = [UIImage imageWithContentsOfFile:[self.documentsPath stringByAppendingPathComponent:self.photos[i]]];
        
        [_photosArray addObject:photo];
        
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _photosArray.count;
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(5.f, 0, 5.f, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section
{
    
    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}

- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return .3f;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.photoCollectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    UIImage *image = [_photosArray objectAtIndex:fromIndexPath.item];
    
    [_photosArray removeObjectAtIndex:fromIndexPath.item];
    
    [_photosArray insertObject:image atIndex:toIndexPath.item];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    RACollectionViewCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    [cell.imageView removeFromSuperview];
    
    cell.imageView.frame = cell.bounds;
    
    cell.imageView.image = _photosArray[indexPath.item];
    
    [cell.contentView addSubview:cell.imageView];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_photosArray.count == 1) {
        return;
    }
    [self.photoCollectionView performBatchUpdates:^{
        
        /**
         *  以下注释的是设置用户点击哪个图片就删除哪个图片的操作
         */
        
//        [_photosArray removeObjectAtIndex:indexPath.item];
//        [self.photoCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        
        [self.photoCollectionView reloadData];
        
    }];
}






@end

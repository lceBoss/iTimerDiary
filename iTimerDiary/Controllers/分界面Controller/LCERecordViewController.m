//
//  LCERecordViewController.m
//  iTimerDiary
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCERecordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LCEDrowRoundView.h"
#import "LCEWriteDiaryViewController.h"

@interface LCERecordViewController ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate>

@property(nonatomic,strong)AVAudioRecorder *recorder;

@property(nonatomic,strong)AVAudioPlayer *player;

@property(nonatomic,strong)NSURL *fileURL;

@property (weak, nonatomic) IBOutlet UIButton *startRecordBtn;

@property (weak, nonatomic) IBOutlet UIButton *stopRecordBtn;

@property (weak, nonatomic) IBOutlet LCEDrowRoundView *drawRoundView;

@property (weak, nonatomic) IBOutlet UIImageView *recodeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@property (weak, nonatomic) IBOutlet UISlider *textSlider;

@property (weak, nonatomic) IBOutlet UIButton *PlayOrStopButton;

@property (weak, nonatomic) IBOutlet UIView *soundFileView;

@property (weak, nonatomic) IBOutlet UILabel *soundTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;

//创建一个计时器来记录录音时间
@property (nonatomic, strong) NSTimer * timer;

//创建一个中间常量
@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) NSString *soundFilePath;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSDate *date;

@end

@implementation LCERecordViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    NSLog(@"进入主界面");

    self.fileManager = [NSFileManager defaultManager];
    
    self.date = [NSDate date];
    
    self.soundFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"soundFile%@", self.date]];
    
    self.fileURL = [NSURL fileURLWithPath:self.soundFilePath];
    
    self.player.delegate =self;
    
    self.stopRecordBtn.hidden = YES;
    
    self.soundFileView.hidden = YES;
    
    self.playImageView.hidden = YES;
    
    self.PlayOrStopButton.hidden = YES;
    
    self.view.userInteractionEnabled = YES;
    
    self.saveButton.enabled = NO;
    
    self.textSlider.hidden = YES;
    
    //    设置播放录音按钮选中与未选中图
    [self configePlayOrStopButtonBgImage];
    
    self.drawRoundView.downloadValue = self.textSlider.value;
    
    
    
    
    
    
    
}


-(AVAudioRecorder *)recorder
{
    if (!_recorder) {
        
        NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey,[NSNumber numberWithInt:16],AVEncoderBitRateKey,[NSNumber numberWithInt:1],AVNumberOfChannelsKey,[NSNumber numberWithFloat:8000.0],AVSampleRateKey,nil];
        _recorder = [[AVAudioRecorder alloc] initWithURL:self.fileURL settings:recordSetting error:nil];
        
        _recorder.meteringEnabled = YES;
        
    }
    return _recorder;
}

-(AVAudioPlayer *)player
{
    
    NSError *error=nil;
    _player=[[AVAudioPlayer alloc]initWithContentsOfURL:self.fileURL error:&error];
    _player.delegate = self;
    if (error) {
        NSLog(@"error = %@",error);
    }
    
    [_player prepareToPlay];
    
    return _player;
}

#pragma mark －－－－点击开始录音 （启动圆形进度条）－－－－

- (IBAction)clickStartRecordBtn:(id)sender {

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    [session requestRecordPermission:^(BOOL granted) {
        if (granted) {
            
            if ([self.recorder prepareToRecord]) {

                [self.recorder record];
                self.stopRecordBtn.hidden = NO;
                self.drawRoundView.downloadColor = [UIColor orangeColor];
                self.recodeImageView.image = [UIImage imageNamed:@"recode_icon_yes"];
                self.cancelButton.enabled = NO;
                //启动计时器
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChangeValue:) userInfo:nil repeats:YES];
                self.timer = timer;
                self.recordTimeLabel.text = [NSString stringWithFormat:@"%g.0", self.textSlider.value];
            }
        }
        
    }];
    
}

#pragma mark - - - -点击结束录音 （并把录音文件显示出来）
#pragma mark - - - -显示播放按钮 （并启动中间圆形slider画图模式）
- (IBAction)clickStopRecordBtn:(id)sender {

    
    //    停止录音

    [self.recorder stop];
    
    [self.timer invalidate];
    
    self.recodeImageView.hidden = YES;
    
    self.playImageView.hidden = NO;
    
    self.soundFileView.hidden = NO;
    
    self.drawRoundView.downloadValue = 0;
    
    self.textSlider.value = 0;
    
    self.drawRoundView.downloadColor = [UIColor greenColor];
    
    [self.drawRoundView setNeedsDisplay];
    
    self.PlayOrStopButton.hidden = NO;
    
    self.PlayOrStopButton.selected = NO;
    
    self.cancelButton.enabled = YES;
    
    self.saveButton.enabled = YES;
    
    self.playImageView.image = [UIImage imageNamed:@"play_icon_no"];
    
    //    显示录音总时间显示到soundFileView上
    self.soundTimeLabel.text = self.recordTimeLabel.text;
    
    self.recordTimeLabel.text = [NSString stringWithFormat:@"0.0 / %@", self.soundTimeLabel.text];
    
}

#pragma mark ---- 点击删除录音文件
- (IBAction)clickDeleteSoundFile:(id)sender {
    
    self.soundFileView.hidden = YES;
    
    self.playImageView.hidden = YES;
    
    self.stopRecordBtn.hidden = YES;
    
    self.recodeImageView.hidden = NO;
    
    self.recodeImageView.image = [UIImage imageNamed:@"recode_icon_no"];
    
    self.recordTimeLabel.text = @"0.0";
    
    self.PlayOrStopButton.hidden = YES;
    
    self.saveButton.enabled = NO;
    
    self.textSlider.value = 0;
    
    self.drawRoundView.downloadValue = 0;
    
    [self.drawRoundView setNeedsDisplay];
    
    //    执行删除的动作
    NSError *error = nil;
    if (![self.fileManager removeItemAtPath:self.soundFilePath error:&error]) {
        
        NSLog(@"删除文件失败:%@", error.userInfo);
        
    }
    
}
#pragma mark ---- 点击 播放 / 暂停 录音

- (IBAction)clickPlayOrStopRecorde:(UIButton *)sender {

    sender.selected = !sender.selected;
    
    UInt32 doChangeDefaultRoute = 1;
    
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    self.playImageView.image = [UIImage imageNamed:@"play_icon_yes"];
    
    [self.player play];
    
    if (sender.selected == YES) {
        
        
        

        self.deleteButton.enabled = NO;
        
        //启动计时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(PlayTimeValue:) userInfo:nil repeats:YES];
        
        self.timer = timer;
        
    }else {
        
        [self.player pause];
        
        [self.timer invalidate];
        
        self.deleteButton.enabled = YES;
        
    }
}


- (void)PlayTimeValue:(NSTimer *)timer {
    
    self.timer = timer;
    
    self.timeInterval += 1;
    
    self.textSlider.value += 1 / [self.soundTimeLabel.text floatValue];
    
    self.drawRoundView.downloadValue = self.textSlider.value;
    
    [self.drawRoundView setNeedsDisplay];
    
    self.recordTimeLabel.text = [NSString stringWithFormat:@"%g.0 / %@", self.timeInterval , self.soundTimeLabel.text];
    
    NSTimeInterval t = [self.soundTimeLabel.text integerValue];
    
    if (self.timeInterval > t) {
        
        self.timeInterval = 0;
        
        self.textSlider.value = 0;
        
        self.drawRoundView.downloadValue = 0;
        
        [self.drawRoundView setNeedsDisplay];
        
        self.playImageView.image = [UIImage imageNamed:@"play_icon_no"];
        
        self.deleteButton.enabled = YES;
        
        self.PlayOrStopButton.selected = NO;
        
        self.recordTimeLabel.text = [NSString stringWithFormat:@"%g.0 / %@", self.timeInterval , self.soundTimeLabel.text];
        
        [self.timer invalidate];
    }
}

- (void)timeChangeValue:(NSTimer *)timer {
    
    self.timer = timer;
    
    self.textSlider.value += 0.00333333333333;
    
    self.recordTimeLabel.text = [NSString stringWithFormat:@"%g.0", self.textSlider.value /0.00333333333333 * 1];
    
    self.drawRoundView.downloadValue = self.textSlider.value;
    
    //重新绘图
    [self.drawRoundView setNeedsDisplay];
    
    if (self.textSlider.value > 1) {
        
        [timer invalidate];
        
    }
}

- (IBAction)changeValue:(UISlider *)sender {
    //    画圆进度同步进行
    //只要有了新的下载数值,就赋给drawRoundView
    self.drawRoundView.downloadValue = sender.value;
    //重新绘图
    [self.drawRoundView setNeedsDisplay];
}

- (IBAction)clickSaveButton:(id)sender {
    
    
    
    [self.delegate lceRecordViewController:self didFinishRecord:[NSString stringWithFormat:@"%@", self.fileURL] withSoundDate:self.date];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickBack:(id)sender {
    
    //    执行删除的动作
    NSError *error = nil;
    if ([self.fileManager fileExistsAtPath:self.soundFilePath]) {
        
        if (![self.fileManager removeItemAtPath:self.soundFilePath error:&error]) {
            
            NSLog(@"删除文件失败:%@", error.userInfo);
            
        }
        
    }
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 设置播放录音按钮选中与未选中图 */
- (void)configePlayOrStopButtonBgImage {
    
    [self.PlayOrStopButton setImage:[UIImage imageNamed:@"start_play_button"] forState:UIControlStateNormal];
    
    [self.PlayOrStopButton setImage:[UIImage imageNamed:@"stop_play_button"] forState:UIControlStateSelected];
    
    [self.PlayOrStopButton addTarget:self action:@selector(clickPlayOrStopRecorde:) forControlEvents:UIControlEventTouchUpInside];
}

@end

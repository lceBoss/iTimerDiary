//
//  LCEWriteDiaryViewController.m
//  iTimerDiary
//
//  Created by tarena on 15/12/5.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCEWriteDiaryViewController.h"
#import "LCEDateSelectViewController.h"
#import "LCESetIconViewController.h"
#import "LCECameraViewController.h"
#import "LCERecordViewController.h"
#import "LCEDiary.h"

@interface LCEWriteDiaryViewController ()<LCEDateSelectViewControllerDelegate, LCESetIconViewControllerDelegate,LCECameraViewControllerDelegate, LCERecordViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeKeyboardButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textBottomContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopStateContraint;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekAndTime;
@property (weak, nonatomic) IBOutlet UIImageView *kindImageView;
@property (weak, nonatomic) IBOutlet UIImageView *paperImageView;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@property(nonatomic,strong)NSDate *date;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@property (weak, nonatomic) IBOutlet UITextView *diaryTextView;

@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) NSString *diaryPath;

@property (nonatomic, strong) LCEDiary *diary;

@property (nonatomic, strong) NSMutableArray *diaryArray;
@property (nonatomic, strong) NSMutableDictionary *diaryDic;
@property (nonatomic, strong) NSString *soundFilePath;
@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) NSMutableArray *photoNames;

@property (nonatomic, strong) NSString *photoPath;

@property (nonatomic, strong) NSString *documentsPath;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSString *soundFilePaths;



@end

@implementation LCEWriteDiaryViewController

- (NSMutableArray *)photoNames {
    if (!_photoNames) {
        _photoNames = [NSMutableArray array];
    }
    return _photoNames;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableDictionary *)diaryDic {
    if (!_diaryDic) {
        _diaryDic = [[NSMutableDictionary alloc] init];
    }
    return _diaryDic;
}
- (LCEDiary *)diary {
    if (!_diary) {
        _diary = [[LCEDiary alloc] init];
    }
    return _diary;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.fileManager = [NSFileManager defaultManager];
    
    self.closeKeyboardButton.hidden = YES;
    
    self.documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    self.diaryPath = [self.documentsPath stringByAppendingPathComponent:@"diary.plist"];
    
    
    self.photoCountLabel.hidden = YES;
    
    self.photoCountLabel.layer.cornerRadius = self.photoCountLabel.frame.size.width*0.5;
    
    self.photoCountLabel.layer.masksToBounds = YES;
    
    self.saveButton.enabled = NO;
    
//    [self.diaryDic setValue:@"look_weather1" forKey:@"look_weather"];
}

//View看的见时，增加注册监听键盘
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //增加键盘的弹起通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加键盘的收起通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //判断用户点击编辑日期时机
    NSDate *date=nil;
    
    if (self.date == nil) {
        
        date = [NSDate date];
        
    }else{
        
        date=self.date;
        
    }
    

    [self setTimeLabelsWithDate:date];
    
}




//有键盘弹起此方法就会被自动执行
- (void)openKeyboard:(NSNotification *)noti {
    //获取键盘的frame数据
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获取键盘动画的种类
    int options = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    //获取键盘动画的时长
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //修改按钮框底部的约束的值
    self.textBottomContraint.constant = keyboardFrame.size.height;
    
    self.bottomConstraint.constant = keyboardFrame.size.height - 8;
    
    //修改整体编辑向上移动
    self.TopStateContraint.constant = -64;
    
    self.closeKeyboardButton.hidden = NO;
    
    //在动画内调用 layoutIfNeeded方法
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
}
#pragma mark ----- 收回键盘时执行的方法
- (void)closeKeyboard:(NSNotification *)noti {
    //获取键盘动画的种类
    int options = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    //获取键盘动画的时长
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = 0;
    self.textBottomContraint.constant = 0;
    self.TopStateContraint.constant = 0;
    
    //在动画内调用layoutIfNeede方法
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

//View看不见时，取消注册的键盘监听
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //取消注册过的通知
    //只按照通知的名字，取消掉具体的某个通知，而不是全部一次性取消掉多有注册过的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
}
//点击关闭按钮关闭键盘

- (IBAction)clickCloseKeyboardButton:(id)sender {
    [self.view endEditing:YES];
    self.closeKeyboardButton.hidden = YES;
    
    [self.diaryDic setValue:self.diaryTextView.text forKey:@"diaryText"];
    
    if (self.diaryTextView.text.length != 0) {
        
        self.saveButton.enabled = YES;
        
    }else {
        self.saveButton.enabled = NO;
    }
    
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickBack:(id)sender {
    
    
    
    if (self.saveButton.enabled == YES) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //创建按钮行为
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除日记" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            
            NSError *error = nil;
            
            if ([self.fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", self.documentsPath, self.soundFilePaths]]) {
                
                if (![self.fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", self.documentsPath, self.soundFilePaths] error:&error]) {
                    
                    NSLog(@"删除录音文件失败%@", error.userInfo);
                    
                }
                
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        
            

            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
//            点击了取消按钮
        
        }];
        
        [alertController addAction:deleteAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }else if (self.saveButton.enabled == NO) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }

    
    
}

#pragma mark ---- 设置导航栏样式（进而改变状态栏）
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark ----- Segue反向传值

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navi=segue.destinationViewController;
    id setVC = [navi.viewControllers firstObject];
    
    if ([setVC isKindOfClass:[LCEDateSelectViewController class]]) {
        LCEDateSelectViewController *setDateVC=(LCEDateSelectViewController *)setVC;
        setDateVC.delegate=self;
    }
    if ([setVC isKindOfClass:[LCESetIconViewController class]]) {
        LCESetIconViewController * setIconVC = (LCESetIconViewController *)setVC;
        setIconVC.delegate = self;
    }
    if ([setVC isKindOfClass:[LCECameraViewController class]]) {
        LCECameraViewController *setCameraVC=(LCECameraViewController *)setVC;
        setCameraVC.delegate=self;
    }
    if ([setVC isKindOfClass:[LCERecordViewController class]]) {
        LCERecordViewController *recordVC = (LCERecordViewController *)setVC;
        recordVC.delegate = self;
    }
}

#pragma mark ----- 设置时间的Label显示日期数据

-(void)setTimeLabelsWithDate:(NSDate *)date
{
    //创建月份格式化器
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    //设置格式化的标准
    monthFormatter.dateFormat = @"MM月";
    //将date进行格式化
    NSString  *monthString = [monthFormatter stringFromDate:date];
    
    //创建日格式化器
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
    //设置格式化的标准
    dayFormatter.dateFormat = @"dd日";
    //将date进行格式化
    NSString  *dayString = [dayFormatter stringFromDate:date];
    
    //创建星期 和 时间 格式化器
    NSDateFormatter *weekAndTimeFormatter = [[NSDateFormatter alloc] init];
    //设置中文
    weekAndTimeFormatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    //设置格式化的标准
    weekAndTimeFormatter.dateFormat = @"EEEE HH:mm";
    //将date进行格式化
    NSString  *weekAndTimeString = [weekAndTimeFormatter stringFromDate:date];
    
    self.monthLabel.text=monthString;
    
    self.dayLabel.text=dayString;
    
    self.weekAndTime.text=weekAndTimeString;
    
    //如果设置用户没点击编辑时间按钮则执行下面代码
    [self.diaryDic setValue:date forKey:@"date"];
    
}

#pragma mark LCECameraDelegate-------- 照相照片代理实现方法
-(void)cameraVC:(LCECameraViewController *)cameraVC setWriteDiaryCarmera:(NSArray *)photos
{
    if (photos.count != 0) {
        self.photoCountLabel.hidden = NO;
        
        self.photoCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)photos.count];
        self.saveButton.enabled = YES;
        
        [self.cameraButton setImage:photos[0] forState:0];
    }
    
    self.photoNames = [NSMutableArray arrayWithArray:photos];
    
    
}

#pragma mark LCESetDateVC Delegate-----日期设置代理实现方法
-(void)setDateVC:(LCEDateSelectViewController *)setDateVC setWriteDiaryDate:(NSDate *)date
{
    
    self.date=date;
    
    [self.diaryDic setValue:self.date forKey:@"date"];
    
    self.saveButton.enabled = YES;
    
}

#pragma mark --- LCESetIconImageVC Delegate -----贴图代理实现方法

- (void)lceSetIconViewController:(LCESetIconViewController *)LCESetIconVC didFinishSelectedWeatherImage:(UIImage *)image withImageName:(NSString *)imageName {
    
    
    [self.diaryDic setValue:imageName forKey:@"look_weather"];
    
    
    
    self.saveButton.enabled = YES;
    
    self.weatherImageView.image = image;
    
}
- (void)lceSetIconViewController:(LCESetIconViewController *)LCESetIconVC didFinishSelectedKindImage:(UIImage *)image withImageName:(NSString *)imageName {
    
    
        
    [self.diaryDic setValue:imageName forKey:@"look_kind"];
    
    self.saveButton.enabled = YES;
    
    self.kindImageView.image = image;
    
    
    
}
- (void)lceSetIconViewController:(LCESetIconViewController *)LCESetIconVC didFinishSelectedPaperImage:(UIImage *)image withImageName:(NSString *)imageName {
    self.paperImageView.image = image;
    
    self.saveButton.enabled = YES;
    
    [self.diaryDic setValue:imageName forKey:@"paper_icon"];
}

#pragma mark ---- LCERecordVC Delegate ----- 录音路径代理实现方法

- (void)lceRecordViewController:(LCERecordViewController *)lceRecordVC didFinishRecord:(NSString *)soundFilePath withSoundDate:(NSDate *)soundDate {
    
//    NSString *soundFilePaths = [soundFilePath substringFromIndex:144];
    self.soundFilePaths = [NSString stringWithFormat:@"soundFile%@", soundDate];
    

    
    if (soundFilePath.length != 0) {
        [self.recordButton setBackgroundImage:[UIImage imageNamed:@"diary_sound_green_button"] forState:UIControlStateNormal];
        self.saveButton.enabled = YES;
    }
    
    
    [self.diaryDic setValue:self.soundFilePaths forKey:@"soundFilePath"];
    
}

- (IBAction)clickSaveDiaryButton:(UIButton *)sender {
    
    
    self.saveButton.selected = YES;
    
    for (int i = 0; i < self.photoNames.count; i ++) {
        
        NSDate * date = [NSDate date];
        
        NSString *photoFileName = [NSString stringWithFormat:@"%@photo%d",date, i];
        
        self.photoPath = [self.documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", photoFileName]];
        
        [self.photos addObject:photoFileName];
        
        [UIImagePNGRepresentation(self.photoNames[i])writeToFile:self.photoPath atomically:YES];
    }

    [self.diaryDic setValue:self.photos forKey:@"photos"];
    
    self.diaryArray = [[NSMutableArray alloc] initWithContentsOfFile:self.diaryPath];
    
    if (self.diaryArray == nil) {
        
        self.diaryArray = [[NSMutableArray alloc] init];
        
    }
    
    [self.diaryArray addObject:self.diaryDic];
    
    if (![self.diaryArray writeToFile:self.diaryPath atomically:YES]) {
        
        NSLog(@"写入失败");
        
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  LCEDateSelectViewController.m
//  iTimerDiary
//
//  Created by tarena on 15/12/8.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCEDateSelectViewController.h"
#import "LCEDiary.h"

@interface LCEDateSelectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSString * diaryPath;
//@property (nonatomic, strong) NSDate * localDate;

@end

@implementation LCEDateSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.datePicker addTarget:self action:@selector(loadTimeLable:) forControlEvents:UIControlEventValueChanged];
    [self loadTimeLable:self.datePicker];
    
    
    
}

- (void)loadTimeLable:(UIDatePicker *)picker {
    NSDate * date = self.datePicker.date;
    
    //创建格式化器
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //设置格式化的标准
    formatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    //将date进行格式化
    NSString * dateString = [formatter stringFromDate:date];
    self.timeLabel.text = dateString;
    
}

#pragma mark ---- 点击保存按钮执行逻辑
- (IBAction)clickSaveBtn:(id)sender {
    
    //反向传值
    
    [self.delegate setDateVC:self setWriteDiaryDate:self.datePicker.date];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectCurrentTime:(id)sender {
    //获取选择器中的日期
    
    self.datePicker.date = [NSDate date];
    [self loadTimeLable:self.datePicker];

}
- (IBAction)clickBackOrCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

//
//  LCEDiaryCollectionTableViewController.m
//  iTimerDiary
//
//  Created by tarena on 15/12/4.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCEDiaryCollectionTableViewController.h"
#import "LCEDiaryCollectionTableViewCell.h"
#import "LCEDiaryDetailsViewController.h"


@interface LCEDiaryCollectionTableViewController ()
@property (nonatomic, strong) NSMutableArray *diaryArray;

@property (nonatomic, strong) NSString *documentsPath;

@property (nonatomic, strong)NSDateFormatter *formatter;

@property (nonatomic, strong) NSString *diaryPath;

@property (nonatomic, strong) NSFileManager *manager;

@end

@implementation LCEDiaryCollectionTableViewController

- (NSMutableArray *)diaryArray {
    if (!_diaryArray) {
        _diaryArray = [NSMutableArray array];
    }
    return _diaryArray;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
    }
    return _formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [NSFileManager defaultManager];
    
    self.documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    self.diaryPath = [self.documentsPath stringByAppendingPathComponent:@"diary.plist"];
    
    self.diaryArray = [[NSMutableArray alloc] initWithContentsOfFile:self.diaryPath];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(clickEditButton:)];

    
}

- (void)clickEditButton:(UIBarButtonItem *)item {
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing == YES) {
        [item setTitle:@"完成"];
    }else {
        [item setTitle:@"编辑"];
    }
    
}

- (IBAction)clickBack:(id)sender {
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.diaryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.tableFooterView = [UIView new];
    
    LCEDiaryCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiaryCollectionCell" forIndexPath:indexPath];

    NSDictionary *diaryDic = self.diaryArray[indexPath.row];

    NSDate *date = diaryDic[@"date"];
    
    NSString *kindImageName = diaryDic[@"look_kind"];
    
    NSString *weatherImageName = diaryDic[@"look_weather"];

    NSString *paperImageName = diaryDic[@"paper_icon"];

    NSString *diaryText = diaryDic[@"diaryText"];
    
    NSString *soundFilePath = diaryDic[@"soundFilePath"];
    
    NSArray *photos = diaryDic[@"photos"];
    
    if (photos.count == 0) {
        cell.diaryTextRightConstraint.constant = 8;
        
        cell.cameraImageView.hidden = YES;
        //在动画内调用 layoutIfNeeded方法
        [UIView animateWithDuration:0 delay:0 options:optind animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        
    }else {
        cell.diaryTextRightConstraint.constant = 90;
        
        cell.cameraImageView.hidden = NO;
        cell.cameraImageView.image = [UIImage imageWithContentsOfFile:[self.documentsPath stringByAppendingPathComponent:photos[0]]];
        [UIView animateWithDuration:0 delay:0 options:optind animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        
    }
    
    cell.paperImageView.image = [UIImage imageNamed:paperImageName];
    
    cell.kindImageView.image = [UIImage imageNamed:kindImageName];
    
    cell.weatherImageView.image = [UIImage imageNamed:weatherImageName];
    
    cell.weatherLabel.text = [self configWeatherDescription:weatherImageName];
    
    cell.monthAndDayLabel.text = [self configMonthAndDayDateFormant:date];
    
    cell.dayLabel.text = [self configDayDateFormant:date];
    
    cell.weekdayLabel.text = [self configWeekdayDateFormant:date];
    
    cell.diaryLabel.text = diaryText;
    
    if (soundFilePath != nil) {
        
        cell.recordImageView.image = [UIImage imageNamed:@"diary_sound"];
        
    }else {
        
        cell.recordImageView.image = [UIImage imageNamed:@"moment_detail_sound_gray"];
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    LCEDiaryDetailsViewController *diaryDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCEDiaryDetailsViewController"];
    
    diaryDetailsVC.diaryDetailsDic = self.diaryArray[indexPath.row];
    
    
    [self.navigationController pushViewController:diaryDetailsVC animated:YES];
    
}

#pragma mark ------ 表格的编辑模式：两问一答
//问一：该行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//问二：该行的编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//答一：参数editingStyle就是点击的那个按钮的样式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    
//    执行沙盒的数据删除操作
//    拼接文件的绝对路径
    self.diaryPath = [self.documentsPath stringByAppendingPathComponent:@"diary.plist"];
    
    self.diaryArray = [[NSMutableArray alloc] initWithContentsOfFile:self.diaryPath];
    
    if (self.diaryArray == nil) {
        self.diaryArray = [[NSMutableArray alloc] init];
        
    }
    //    删除功能
    //    1.先删除数组中的数据
    
    NSDictionary *deleteDic = self.diaryArray[indexPath.row];
    
    NSString *deleteSoundStr = deleteDic[@"soundFilePath"];
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@", self.documentsPath, deleteSoundStr];
    
    NSError *soundError = nil;
    if (![self.manager removeItemAtPath:soundFilePath error:&soundError]) {
        
        NSLog(@"删除录音文件失败%@", soundError.userInfo);
        
    }
    
    NSArray *photosArray = deleteDic[@"photos"];
    
    for (int i = 0; i < photosArray.count; i ++) {
        NSString *deletePhotosPath = [self.documentsPath stringByAppendingPathComponent:photosArray[i]];
        
        //    执行删除的动作
        NSError *error = nil;
        if (![self.manager removeItemAtPath:deletePhotosPath error:&error]) {
            
            NSLog(@"删除照片失败:%@", error.userInfo);
            
        }
    }
    
    
    
    
    [self.diaryArray removeObjectAtIndex:indexPath.row];
    
    if (![self.diaryArray writeToFile:self.diaryPath atomically:YES]) {
        
        NSLog(@"写入失败");
        
    }
    
//    刷新界面
//    不用reloadData来刷新整个界面
//    指定要删除的数据对应的行，从表视图删除即可
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}




#pragma mark ----- 表格的移动：一问一答

//问1：是否可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

//答1：移动后做什么
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //    秩序完成数组中数据的顺序的调整，界面无需做操作，系统完成
    //    1.先将原位置的数据取出
    NSDictionary *dic = self.diaryArray[sourceIndexPath.row];
    
    //    2.将该位置的数据从数组中remove
    [self.diaryArray removeObjectAtIndex:sourceIndexPath.row];
    
    //    3.将第一步记录的那个数据，按照新的位置再添加回数组
    [self.diaryArray insertObject:dic atIndex:destinationIndexPath.row];
    
}



- (NSString *)configWeatherDescription:(NSString *)weatherImageName {
    if ([weatherImageName isEqualToString:@"look_weather1"]) {
        
        return @"晴";
        
    }else if ([weatherImageName isEqualToString:@"look_weather2"]) {
        
        return @"云";
        
    }else if ([weatherImageName isEqualToString:@"look_weather3"]) {
        
        return @"阴";
        
    }else if ([weatherImageName isEqualToString:@"look_weather4"]) {
        
        return @"雨";
        
    }else if ([weatherImageName isEqualToString:@"look_weather5"]) {
        
        return @"雷";
        
    }else if ([weatherImageName isEqualToString:@"look_weather6"]) {
        
        return @"雪";
        
    }else if ([weatherImageName isEqualToString:@"look_weather7"]){
        
        return @"雾";
        
    }else {
        return @"";
    }
}

- (NSString *)configMonthAndDayDateFormant:(NSDate *)date {
    //设置格式化的标准
    self.formatter.dateFormat = @"MM月dd日 HH:mm";
    
    //将date进行格式化
    NSString  *monthAndDay = [self.formatter stringFromDate:date];
    
    return monthAndDay;
}
- (NSString *)configDayDateFormant:(NSDate *)date {
    //设置格式化的标准
    self.formatter.dateFormat = @"dd";
    //将date进行格式化
    NSString  *dayString = [self.formatter stringFromDate:date];
    return dayString;
}
- (NSString *)configWeekdayDateFormant:(NSDate *)date {
    //设置中文
    self.formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    
    self.formatter.dateFormat = @"EEEE";
    //将date进行格式化
    NSString  *weekdayString = [self.formatter stringFromDate:date];
    
    return weekdayString;
}



@end

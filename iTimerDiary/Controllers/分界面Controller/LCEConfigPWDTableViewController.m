//
//  LCEConfigPWDTableViewController.m
//  iTimerDiary
//
//  Created by tarena on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "LCEConfigPWDTableViewController.h"
#import "CLLockVC.h"

@interface LCEConfigPWDTableViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *PWDSwitch;

@property (nonatomic, assign) BOOL hasPwd;
@property (nonatomic, strong) NSString *documentsPath;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *isHasPwdPath;
@property (weak, nonatomic) IBOutlet UITableViewCell *changePWDCell;

@end

@implementation LCEConfigPWDTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    self.fileManager = [NSFileManager defaultManager];
    
    self.isHasPwdPath = [self.documentsPath stringByAppendingPathComponent:@"PwdDidSetUp"];
    
//  取isHasPwdPath文件
    if (YES == [self.fileManager fileExistsAtPath:self.isHasPwdPath]) {
        self.PWDSwitch.on = YES;
        
        self.changePWDCell.hidden = NO;
        
    }else {
        self.PWDSwitch.on = NO;
        
        self.changePWDCell.hidden = YES;
        
    }
    
    
    self.tableView.tableFooterView = [UIView new];
    
    
    
}
- (IBAction)openOrShotSwitch:(id)sender {
    
    if (self.PWDSwitch.on == YES) {
        
//        设置密码

        self.hasPwd = [CLLockVC hasPwd];
        self.hasPwd = NO;
        if(self.hasPwd == YES){
            
            NSLog(@"已经设置过密码了，你可以验证或者修改密码");
        }else{
            
            [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                
            
                
                NSString *secondContent = @"PwdDidSetUp";
                if ([self.fileManager createFileAtPath:self.isHasPwdPath contents:[secondContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
                    
                    self.changePWDCell.hidden = NO;
                    
                }
                
                [lockVC dismiss:1.0f];
                
            }];
        }
        
    }else {
        
//        关闭密码

        self.hasPwd = [CLLockVC hasPwd];
        
        if (self.hasPwd == NO){
            
            NSLog(@"你还没有设置密码，请先设置密码");
        }else {
            
            [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
                
            } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                
                
                NSError *error = nil;
                if (![self.fileManager removeItemAtPath:self.isHasPwdPath error:&error]) {
                    
                    NSLog(@"删除密码文件文件失败");
                    
                }
                self.changePWDCell.hidden = YES;
                
                //            消失推迟一分钟
                [lockVC dismiss:1.0f];
                
            }];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 2;
    }else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (1 == indexPath.section) {
        
        
        
        if (0 == indexPath.row) {
            
            self.hasPwd = [CLLockVC hasPwd];
            
            if(!self.hasPwd){
                
                NSLog(@"你还没有设置密码，请先设置密码");
                
            }else {
                
                [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                    
                    [lockVC dismiss:.5f];
                }];
            }
            
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
        
    }else {
        
        return 20.0;
        
    }
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    
//    
//    
//    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

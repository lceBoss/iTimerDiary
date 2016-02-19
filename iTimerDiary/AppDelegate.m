//
//  AppDelegate.m
//  iTimerDiary
//
//  Created by tarena on 15/12/4.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "CLLockVC.h"


#define kUMKey @"568134f367e58e334a001107"

#define kWBKey @"3549456642"

#define kWBSecret @"8a34286b03e6c73a5ca81926fe256ee5"


//以下是老师申请好的有关Key
//友盟
//#define kUMKey    @"5657f8a367e58e3b660032d7"
////微信
//#define kWXKey    @"wx945b58aef3a271f0"
//#define kWXSecret   @"0ae78dd42761fd9681b04833c79a857b"



@interface AppDelegate ()




@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UMSocialData setAppKey:kUMKey];

    
//    由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法，
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    //设置分享到QQ/Qzone的应用Id，和分享url 链接
//    [UMSocialQQHandler setQQWithAppId:@"1104980325" appKey:@"pNKrrSBaUvlc6WWK" url:@"http://www.umeng.com/social"];
    
//    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    [bar setBarTintColor:[UIColor clearColor]];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigation_bg_image"] forBarMetrics:UIBarMetricsDefault];
    
    // 3.只有在有导航的情况下,如果需要修改状态栏的文字颜色,那么,只要设置导航栏的样式即可
    [bar setBarStyle:UIBarStyleBlack];
    
    // 4.修改左右按钮的文字颜色
    [bar setTintColor:[UIColor whiteColor]];
    
    
    
    return YES;
}




- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *str = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"PwdDidSetUp"];
    
    //  取isHasPwdPath文件
    if (YES == [manager fileExistsAtPath:str]) {
        
        [CLLockVC showVerifyLockVCInVC:[[[UIApplication sharedApplication] keyWindow] rootViewController]  forgetPwdBlock:^{
            NSLog(@"忘记密码");
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            NSLog(@"密码正确这是在AppDelegate里调用的");
            
            //            消失推迟一分钟
            [lockVC dismiss:0];
            
        }];
        
    }

   
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

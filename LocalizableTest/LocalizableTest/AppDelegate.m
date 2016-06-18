//
//  AppDelegate.m
//  LocalizableTest
//
//  Created by cz on 16/3/16.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "HealthKitViewController.h"
#import "AppGroupsViewController.h"
#import "CloudKitViewController.h"
#import "PushViewController.h"
#import "ApplePayViewController.h"
#import "AuthenticationViewController.h"
#import "MapViewController.h"

#import "BPush.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"

#import "UMSocialInstagramHandler.h"
#import "UMSocialWhatsappHandler.h"
#import "UMSocialLineHandler.h"
#import "UMSocialTumblrHandler.h"
#import "UMSocialAlipayShareHandler.h"
#import "UMSocialFacebookHandler.h"

static NSString *umengAppkey = @"5763d74f67e58e5fc10014fa";
static BOOL isBackGroundActivateApplication;

@interface AppDelegate () <BMKGeneralDelegate>

@property (strong, nonatomic) BMKMapManager* mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:umengAppkey];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    

    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxdc1e388c3822c80b" appSecret:@"a393c1527aaccb95f3a4c88d6d1455f6" url:@"http://www.umeng.com/social"];
    
//    // 打开新浪微博的SSO开关
//    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
//                                              secret:@"04b48b094faeb16683c32669824ebdad"
//                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    
//    // 设置支付宝分享的appId
//    [UMSocialAlipayShareHandler setAlipayShareAppId:@"2015111700822536"];
//    
//    //    //设置分享到QQ空间的应用Id，和分享url 链接
//    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
//    //    //设置支持没有客户端情况下使用SSO授权
//    [UMSocialQQHandler setSupportWebView:YES];

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"osgL2ZfyyXfG3DKsGNkMNUtk" pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    // 禁用地理位置推送 需要再绑定接口前调用。
    [BPush disableLbs];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.mapManager = [BMKMapManager new];
    if (![self.mapManager start:@"wbW1GPdZpWW2oUEH2d1YLftggsgFZZjH" generalDelegate:self]) {
        NSLog(@"manager start failed!");
    }

    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result) {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }

    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:@"troy://"]) {
        NSLog(@"TestAppDemo1 request params: %@", urlStr);
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"troy://" withString:@""];
        NSString *dest;
        if ([urlStr hasPrefix:@"?"]) {
            NSRange range = [urlStr rangeOfString:@"?"];
            NSLog(@"%@", NSStringFromRange(range));
            dest = [urlStr substringWithRange:NSMakeRange(0, range.location)];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@?", dest] withString:@""];
            NSArray *paramArray = [urlStr componentsSeparatedByString:@"&"];
            NSLog(@"paramArray: %@", paramArray);
            NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            for (int i = 0; i < paramArray.count; i++) {
                NSString *str = paramArray[i];
                NSArray *keyArray = [str componentsSeparatedByString:@"="];
                NSString *key = keyArray[0];
                NSString *value = keyArray[1];
                [paramsDic setObject:value forKey:key];
                NSLog(@"key:%@ ==== value:%@", key, value);
            }
        } else {
            dest = urlStr;
        }
        [self push:dest];
    }
    return NO;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本地通知"
                                                    message:notMess
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}


// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
//        [self.viewController addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodBind,result]];
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        // 网络错误
        if (error) {
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
            // 获取channel_id
            NSString *myChannel_id = [BPush getChannelId];
            NSLog(@"==%@",myChannel_id);
            [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"result ============== %@",result);
                }
            }];
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"设置tag成功");
                }
            }];
        }
    }];
    // 打印到日志 textView 中
//    [self.viewController addLogString:[NSString stringWithFormat:@"Register use deviceToken : %@",deviceToken]];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication) {
        NSLog(@"applacation is unactive ===== %@",userInfo);
        NSString *dest = [userInfo valueForKey:@"key"];
        [self push:dest];
    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"background is Activated Application ");
        // 此处可以选择激活应用提前下载邮件图片等内容。
        isBackGroundActivateApplication = YES;
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
//    [self.viewController addLogString:[NSString stringWithFormat:@"Received Remote Notification :\n%@",userInfo]];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"backgroud : %@",userInfo);
}

- (void)push:(NSString *)dest {
    BaseViewController *baseVC;
    HealthKitViewController *healthKitVC;
    AppGroupsViewController *appGroupsVC;
    CloudKitViewController *cloudKitVC;
    PushViewController *pushVC;
    ApplePayViewController *applePayVC;
    AuthenticationViewController *authenticationVC;
    MapViewController *mapVC;
    
    NSLog(@"rootViewController # %@", self.window.rootViewController);
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    if ([@"webView" isEqualToString:dest]) {
        baseVC = [BaseViewController new];
        [nav pushViewController:baseVC animated:YES];
    } else if ([@"healthKit" isEqualToString:dest]) {
        healthKitVC = [HealthKitViewController new];
        [nav pushViewController:healthKitVC animated:YES];
    } else if ([@"appGroups" isEqualToString:dest]) {
        appGroupsVC = [AppGroupsViewController new];
        [nav pushViewController:appGroupsVC animated:YES];
    } else if ([@"cloudKit" isEqualToString:dest]) {
        cloudKitVC = [CloudKitViewController new];
        [nav pushViewController:cloudKitVC animated:YES];
    } else if ([@"push" isEqualToString:dest]) {
        pushVC = [PushViewController new];
        [nav pushViewController:pushVC animated:YES];
    } else if ([@"applePay" isEqualToString:dest]) {
        applePayVC = [ApplePayViewController new];
        [nav pushViewController:applePayVC animated:YES];
    } else if ([@"map" isEqualToString:dest]) {
        mapVC = [MapViewController new];
        [nav pushViewController:mapVC animated:YES];
    } else {
        authenticationVC = [AuthenticationViewController new];
        [nav presentViewController:authenticationVC animated:YES completion:nil];
    }
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UMSocialSnsService  applicationDidBecomeActive];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Map
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else {
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"授权成功");
    } else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end

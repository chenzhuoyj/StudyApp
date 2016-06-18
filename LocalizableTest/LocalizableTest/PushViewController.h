//
//  PushViewController.h
//  LocalizableTest
//
//  Created by cz on 16/6/16.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "DJLBaseViewController.h"

@interface PushViewController : DJLBaseViewController


// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime title:(NSString *)title;

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key;


@end

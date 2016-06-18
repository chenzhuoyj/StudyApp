//
//  PushViewController.m
//  LocalizableTest
//
//  Created by cz on 16/6/16.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "PushViewController.h"
#import "BPush.h"

@interface PushViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;

@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Push";
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    NSArray *array = @[@"Time", @"Title"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    self.segmentedControl.frame = CGRectMake(0, 0, 200, 40);
    self.segmentedControl.center = CGPointMake(self.view.center.x, self.view.center.y-180);
    self.segmentedControl.tintColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self
                              action:@selector(segmentAction:)
                    forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];

    
    self.textField = [UITextField new];
    self.textField.frame = CGRectMake(0, 0, 200, 40);
    self.textField.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    self.textField.textColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    self.textField.tintColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.font = [UIFont systemFontOfSize:20.0f];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.keyboardType = UIKeyboardTypePhonePad;
    self.textField.placeholder = @"Time";
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
//    [self.textField becomeFirstResponder];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Push" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.center = CGPointMake(self.view.center.x, self.view.center.y);
    [button setTitleColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    button.layer.cornerRadius = 5;
    [self.view addSubview:button];

}

- (void)segmentAction:(UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self.textField resignFirstResponder];
            self.textField.keyboardType = UIKeyboardTypePhonePad;
            self.textField.placeholder = @"Time";
            [self.textField becomeFirstResponder];
            break;
        case 1:
            [self.textField resignFirstResponder];
            self.textField.keyboardType = UIKeyboardTypeDefault;
            self.textField.placeholder = @"Title";
            [self.textField becomeFirstResponder];
            break;
        default:
            break;
    }
}

- (void)push {
    NSInteger time;
    NSString *title;
    if (self.textField.text.length <= 0) {
        return;
    }
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            time = self.textField.text.integerValue;
            [self bPushLocalNotification:time tite:@"Time is gone!"];
//            [PushViewController registerLocalNotification:time tite:@"Time is gone!"];
            break;
        case 1:
            title = self.textField.text;
            [self bPushLocalNotification:30 tite:title];
//            [PushViewController registerLocalNotification:30 tite:title];
            break;
        default:
            break;
    }
    self.textField.text = @"";
    [self.textField resignFirstResponder];
}

- (void)bPushLocalNotification:(NSInteger)alertTime tite:(NSString *)title  {
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
    [BPush localNotification:fireDate alertBody:title badge:2 withFirstAction:@"打开" withSecondAction:@"关闭" userInfo:userDict soundName:nil region:nil regionTriggersOnce:YES category:nil useBehaviorTextInput:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime tite:(NSString *)title {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody = title;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSDayCalendarUnit;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}
@end

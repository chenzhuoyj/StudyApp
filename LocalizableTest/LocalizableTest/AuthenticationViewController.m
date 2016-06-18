//
//  AuthenticationViewController.m
//  LocalizableTest
//
//  Created by cz on 16/6/17.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "AuthenticationViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Authentication";
    [self authentication];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initViews {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"指纹" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(authentication) forControlEvents:UIControlEventTouchUpInside];
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

- (void)authentication {
    LAContext *context = [LAContext new];
    NSError *error;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"验证身份" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"success");
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
}

@end

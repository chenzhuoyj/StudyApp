//
//  AppGroupsViewController.m
//  LocalizableTest
//
//  Created by cz on 16/6/14.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "AppGroupsViewController.h"

@interface AppGroupsViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *button;

@end

@implementation AppGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"AppGroups";
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    self.textField = [UITextField new];
    self.textField.frame = CGRectMake(0, 0, 200, 40);
    self.textField.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    self.textField.textColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    self.textField.tintColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.font = [UIFont systemFontOfSize:20.0f];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.placeholder = @"AppGroups";
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    [self.textField becomeFirstResponder];
    
    self.label = [UILabel new];
    self.label.frame = CGRectMake(0, 0, 200, 40);
    self.label.center = CGPointMake(self.view.center.x, self.textField.center.y+60);
    self.label.textColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:20.0f];
    self.label.text = @"AppGroups";
    [self.view addSubview:self.label];

    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setTitle:@"Save" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.button.frame = CGRectMake(0, 0, 200, 40);
    self.button.center = CGPointMake(self.view.center.x, self.label.center.y+60);
    [self.button setTitleColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    self.button.backgroundColor = [UIColor whiteColor];
    self.button.layer.borderWidth = 1;
    self.button.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    self.button.layer.cornerRadius = 5;
    [self.view addSubview:self.button];
    
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Read" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(read) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 200, 40);
    button.center = CGPointMake(self.view.center.x, self.button.center.y+60);
    [button setTitleColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    button.layer.cornerRadius = 5;
    [self.view addSubview:button];

}

- (void)save {
    NSString *input = self.textField.text;
    self.label.text = input;
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dajialai.troy"];
    [userDefaults setObject:input forKey:@"shared"];
    [userDefaults synchronize];
}

- (void)read {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dajialai.troy"];
    [userDefaults synchronize];
    NSString *value = [userDefaults valueForKey:@"shared"];
    self.label.text = value;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

@end

//
//  HealthKitViewController.m
//  LocalizableTest
//
//  Created by cz on 16/6/14.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "HealthKitViewController.h"
#import <HealthKit/HealthKit.h>

@interface HealthKitViewController ()

@property (strong, nonatomic) HKHealthStore *healthStore;

@property (strong, nonatomic) UILabel *stepCountLabel; //today

@property (strong, nonatomic) UILabel *weekStepCountLabel; //week

@property (strong, nonatomic) UILabel *monthStepCountLabel; //month

@property (strong, nonatomic) UILabel *yearStepCountLabel; //year

@end

@implementation HealthKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"HealthKit";
    [self initViews];
    
    if (![HKHealthStore isHealthDataAvailable]) {
        [self alertTitle:@"无HealthKit"];
    }
    
    self.healthStore = [HKHealthStore new];
    
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKObjectType *energyBurned = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    NSSet *healthSet = [NSSet setWithObjects:stepCount, energyBurned, nil];
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
        } else {
            [self alertTitle:@"获取失败"];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self update];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    
    //设置滑动回退

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Update" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.center = CGPointMake(self.view.center.x, self.view.center.y-200);
    [button setTitleColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    button.layer.cornerRadius = 5;
    [self.view addSubview:button];
    
    self.stepCountLabel = [UILabel new];
    self.stepCountLabel.frame = CGRectMake(0, 0, 200, 80);
    self.stepCountLabel.center = CGPointMake(button.center.x, button.center.y+100);
    self.stepCountLabel.textColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    self.stepCountLabel.textAlignment = NSTextAlignmentCenter;
    self.stepCountLabel.font = [UIFont systemFontOfSize:40.0f];
    [self.view addSubview:self.stepCountLabel];
    
    self.weekStepCountLabel = [UILabel new];
    self.weekStepCountLabel.frame = CGRectMake(0, 0, 100, 40);
    self.weekStepCountLabel.center = CGPointMake(button.center.x, self.stepCountLabel.center.y+60);
    self.weekStepCountLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    self.weekStepCountLabel.textAlignment = NSTextAlignmentCenter;
    self.weekStepCountLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.view addSubview:self.weekStepCountLabel];

    self.monthStepCountLabel = [UILabel new];
    self.monthStepCountLabel.frame = CGRectMake(0, 0, 100, 40);
    self.monthStepCountLabel.center = CGPointMake(button.center.x, self.weekStepCountLabel.center.y+60);
    self.monthStepCountLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    self.monthStepCountLabel.textAlignment = NSTextAlignmentCenter;
    self.monthStepCountLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.view addSubview:self.monthStepCountLabel];
    
    self.yearStepCountLabel = [UILabel new];
    self.yearStepCountLabel.frame = CGRectMake(0, 0, 100, 40);
    self.yearStepCountLabel.center = CGPointMake(button.center.x, self.monthStepCountLabel.center.y+60);
    self.yearStepCountLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    self.yearStepCountLabel.textAlignment = NSTextAlignmentCenter;
    self.yearStepCountLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.view addSubview:self.yearStepCountLabel];
}

- (void)update {
    [self readStepCount:[self predicateForSamplesToday] resultsHandler:^(NSInteger totleSteps) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //查询是在多线程中进行的，如果要对UI进行刷新，要回到主线程中
            self.stepCountLabel.text = [NSString stringWithFormat:@"%ld", totleSteps];
        }];
    }];
    
    [self readStepCount:[self predicateForSamplesThisweek] resultsHandler:^(NSInteger totleSteps) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //查询是在多线程中进行的，如果要对UI进行刷新，要回到主线程中
            self.weekStepCountLabel.text = [NSString stringWithFormat:@"%ld", totleSteps];
        }];
    }];
    [self readStepCount:[self predicateForSamplesThismonth] resultsHandler:^(NSInteger totleSteps) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //查询是在多线程中进行的，如果要对UI进行刷新，要回到主线程中
            self.monthStepCountLabel.text = [NSString stringWithFormat:@"%ld", totleSteps];
        }];
    }];
    [self readStepCount:[self predicateForSamplesThisyear] resultsHandler:^(NSInteger totleSteps) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //查询是在多线程中进行的，如果要对UI进行刷新，要回到主线程中
            self.yearStepCountLabel.text = [NSString stringWithFormat:@"%ld", totleSteps];
        }];
    }];
}


- (void)readStepCount:(NSPredicate *)predicate resultsHandler:(void(^)(NSInteger totleSteps))resultsHandler{
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:0 sortDescriptors:@[start, end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        NSInteger totleSteps = 0;
        for (HKQuantitySample *quantitySample in results) {
            HKQuantity *quantity = quantitySample.quantity;
            HKUnit *heightUnit = [HKUnit countUnit];
            double usersHeight = [quantity doubleValueForUnit:heightUnit];
            totleSteps += usersHeight;
        }
        resultsHandler(totleSteps);
    }];
    [self.healthStore executeQuery:sampleQuery];
}

- (void)getKilocalorieUnit:(NSPredicate *)predicate {
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *sum = [result sumQuantity];
        double value = [sum doubleValueForUnit:[HKUnit kilocalorieUnit]];
        NSLog(@"%@卡路里 ---> %.2lf",quantityType.identifier,value);
    }];
    [self.healthStore executeQuery:query];
}



- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [NSDate date];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

- (NSPredicate *)predicateForSamplesThisweek {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:now];
    // 获取今天是周几
    NSInteger weekDay = [components weekday];
    // 获取几天是几号
    NSInteger day = [components day];
    
    long firstDiff;
    if (weekDay == 1) {
        firstDiff = -6;
    } else {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
    }
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *firstDayComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:now];
    [firstDayComponents setDay:day + firstDiff];
    [firstDayComponents setHour:0];
    [firstDayComponents setMinute:0];
    [firstDayComponents setSecond: 0];

    NSDate *startDate = [calendar dateFromComponents:firstDayComponents];
    NSDate *endDate = [NSDate date];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

- (NSPredicate *)predicateForSamplesThismonth {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:now];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [NSDate date];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

- (NSPredicate *)predicateForSamplesThisyear {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:now];
    [components setMonth:1];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [NSDate date];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

#pragma mark - alert

- (void)alertTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

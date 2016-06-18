//
//  CloudKitViewController.m
//  LocalizableTest
//
//  Created by cz on 16/6/15.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "CloudKitViewController.h"
#import <CloudKit/CloudKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CloudKitViewController () <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *currentLocation;

@property (nonatomic,strong) UITextView *textView;


@end

@implementation CloudKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CloudKit";
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    self.textView = [UITextView new];
    self.textView.frame = CGRectMake(0, 0, 200, 160);
    self.textView.center = CGPointMake(self.view.center.x, self.view.center.y-120);
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    self.textView.layer.cornerRadius = 5;
    self.textView.tintColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    self.textView.textColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    [self.view addSubview:self.textView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Locate" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getLocation) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.center = CGPointMake(self.view.center.x, self.view.center.y);
    [button setTitleColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    button.layer.cornerRadius = 5;
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"Query" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(query) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(0, 0, 100, 40);
    button2.center = CGPointMake(self.view.center.x, self.view.center.y+80);
    [button2 setTitleColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [button2.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    button2.backgroundColor = [UIColor whiteColor];
    button2.layer.borderWidth = 1;
    button2.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    button2.layer.cornerRadius = 5;
    [self.view addSubview:button2];

}

- (void)getLocation {
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
    }
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        [_locationManager requestAlwaysAuthorization];
        //每隔多少米定位一次（这里的设置为任何的移动）
        self.locationManager.distanceFilter=kCLDistanceFilterNone;
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
        // 开始定位
        [self.locationManager startUpdatingLocation];
    } else {
        //提示用户无法进行定位操作
    }
}

- (void)query {
    CKDatabase *publicDB = [[CKContainer defaultContainer] publicCloudDatabase];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Establishment" predicate:[NSPredicate predicateWithValue:YES]];
    [publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        for (CKRecord *record in results) {
            NSMutableString *str = [NSMutableString stringWithFormat:@""];
            
            [self getCityByLocation:[record valueForKey:@"location"] city:^(NSString *city) {
                NSString *cityValue = [NSString stringWithFormat:@"location : %@\n", city];
                for (NSString *key in [record allKeys]) {
                    if ([key isEqualToString:@"location"]) {
                        [str appendString:cityValue];
                    } else if ([[record valueForKey:key] isKindOfClass:[NSDate class]]) {
                        [str appendString:key];
                        [str appendFormat:@" : %@\n", [self stringFromDate:[record valueForKey:key]]];;
                    }else {
                        [str appendString:key];
                        [str appendFormat:@" : %@\n", [record valueForKey:key]];
                    }
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //查询是在多线程中进行的，如果要对UI进行刷新，要回到主线程中
                    self.textView.text = str;
                }];
            }];
        }
    }];
}

- (void)getCityByLocation:(CLLocation *)location city:(void(^)(NSString *city))block {
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@"%@", [NSString stringWithFormat:@"%@ %@ %@", [test objectForKey:@"Country"],[test objectForKey:@"State"], [test objectForKey:@"SubLocality"]]);
            NSString *city = [NSString stringWithFormat:@"%@ %@ %@", [test objectForKey:@"Country"],[test objectForKey:@"State"], [test objectForKey:@"SubLocality"]];
            block(city);
        }
    }];
}

- (void)initData {
    NSDate *birth = [self dateFromString:@"1992-10-04 00:00:00"];
    
    CKDatabase *publicDB = [[CKContainer defaultContainer] publicCloudDatabase];
    
    CKRecordID *establishmentId = [[CKRecordID alloc] initWithRecordName:@"establishment"];
    CKRecord *establishment = [[CKRecord alloc] initWithRecordType:@"Establishment" recordID:establishmentId];
    [establishment setValue:@"joey" forKey:@"name"];
    [establishment setValue:birth forKey:@"birth"];
    [establishment setValue:self.currentLocation forKey:@"location"];
    [establishment setValue:@(18) forKey:@"age"];
    
    [publicDB saveRecord:establishment completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"success");
        }
    }];
}

//输入的日期字符串形如：@"1992-05-21 13:08:08"
- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:9]];
    NSString *destString = [dateFormatter stringFromDate:date];
    return destString;
}

// 成功调用，locations位置数组，元素按照时间排序
-(void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    CLLocationDegrees latitude =  coor.latitude;
    CLLocationDegrees longitude = coor.longitude;
    self.currentLocation = currentLocation;
    [self.locationManager stopUpdatingLocation];
    NSLog(@"%f # %f", latitude, longitude);
    [self initData];
}

// 失败调用
-(void)locationManager:(nonnull CLLocationManager *)manager didFailWithError:(nonnull NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

@end

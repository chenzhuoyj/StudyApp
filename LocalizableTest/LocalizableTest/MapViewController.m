//
//  MapViewController.m
//  LocalizableTest
//
//  Created by cz on 16/6/17.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface MapViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate>


@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) UIButton *startBtn;
@property (strong, nonatomic) UIButton *stopBtn;
@property (strong, nonatomic) BMKLocationService *locService;

@property (strong, nonatomic) BMKPlanNode *startPoint;
@property (strong, nonatomic) BMKPlanNode *endPoint;

@property (strong, nonatomic) BMKPointAnnotation *bmkPointAnnotation;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Map";
    
    [self initViews];

    [self initData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    CGFloat weight = (self.view.frame.size.width-20)/3;
    self.startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
    [self.startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    self.startBtn.frame = CGRectMake(5, 69, weight, 40);
    [self.startBtn setTitleColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [self.startBtn.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    self.startBtn.backgroundColor = [UIColor whiteColor];
    self.startBtn.layer.borderWidth = 1;
    self.startBtn.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    self.startBtn.layer.cornerRadius = 5;
    [self.view addSubview:self.startBtn];
    
    
    self.stopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopBtn setTitle:@"Stop" forState:UIControlStateNormal];
    [self.stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    self.stopBtn.frame = CGRectMake(weight+5, 69, weight, 40);
    [self.stopBtn setTitleColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [self.stopBtn.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    self.stopBtn.backgroundColor = [UIColor whiteColor];
    self.stopBtn.layer.borderWidth = 1;
    self.stopBtn.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    self.stopBtn.layer.cornerRadius = 5;
    [self.stopBtn setEnabled:NO];
    [self.stopBtn setAlpha:0.6];
    [self.view addSubview:self.stopBtn];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"OpenMap" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openMap) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(2*(weight+5), 69, weight, 40);
    [button setTitleColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    button.layer.cornerRadius = 5;
    [self.view addSubview:button];
    
    
    self.mapView = [BMKMapView new];
    self.mapView.frame = CGRectMake(0, 114, self.view.frame.size.width, self.view.frame.size.height-114);
    [self.mapView setShowMapScaleBar:YES];
    //自定义比例尺的位置
    self.mapView.mapScaleBarPosition = CGPointMake(self.mapView.frame.size.width - 70, self.mapView.frame.size.height - 70);

    [self.view addSubview:self.mapView];
}

- (void)initData {
    self.locService = [BMKLocationService new];
    self.startPoint = [BMKPlanNode new];
    self.endPoint = [BMKPlanNode new];
    self.bmkPointAnnotation = [BMKPointAnnotation new];
    
    BMKLocationViewDisplayParam *param = [BMKLocationViewDisplayParam new];
    param.accuracyCircleStrokeColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:0.5];
    param.accuracyCircleFillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.3];
    [self.mapView updateLocationViewWithParam:param];
    [self start];
}

- (void)start {
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层

    [self.mapView setTrafficEnabled:YES];
    [self.stopBtn setEnabled:YES];
    [self.stopBtn setAlpha:1.0];
}

- (void)stop {
    [self.locService stopUserLocationService];
    self.mapView.showsUserLocation = NO;
    [self.mapView setTrafficEnabled:NO];
    [self.stopBtn setEnabled:NO];
    [self.stopBtn setAlpha:0.6];
    [self.startBtn setEnabled:YES];
    [self.startBtn setAlpha:1.0];
}

- (void)openMap {
    BMKOpenDrivingRouteOption *opt = [BMKOpenDrivingRouteOption new];
    opt.appScheme = @"troy://";
    opt.startPoint = self.startPoint;
    
    opt.endPoint = self.endPoint;
    
    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapDrivingRoute:opt];
    NSLog(@"%d", code);

}

#pragma mark - Map life cycle
/**
*在地图View将要启动定位时，会调用此函数
*@param mapView 地图View
*/
- (void)willStartLocatingUser {
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    [self.mapView updateLocationData:userLocation];
    CLLocationCoordinate2D coor = userLocation.location.coordinate;
    //指定起点名称
    self.startPoint.name = @"我的位置";
    self.startPoint.pt = coor;
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser {
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"location error");
}

/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
    [self.mapView removeAnnotation:self.bmkPointAnnotation];
    self.endPoint.name = @"地图上的位置";
    self.endPoint.pt = coordinate;
    self.bmkPointAnnotation.coordinate = coordinate;
    self.bmkPointAnnotation.title = @"地图上的位置";
    [self.mapView addAnnotation:self.bmkPointAnnotation];
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}



@end

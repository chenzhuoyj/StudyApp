//
//  ViewController.m
//  LocalizableTest
//
//  Created by cz on 16/3/16.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "HealthKitViewController.h"
#import "AppGroupsViewController.h"
#import "CloudKitViewController.h"
#import "PushViewController.h"
#import "ApplePayViewController.h"
#import "AuthenticationViewController.h"
#import "MapViewController.h"
#import "UmengViewController.h"

static NSString *identifier = @"cell";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Home";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.data = @[@"WebView" ,
                  @"Health Kit",
                  @"App Groups",
                  @"CloudKit",
                  @"Push",
                  @"Apple Pay",
                  @"Map",
                  @"Umeng Share",
                  @"Authentication"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseViewController *baseVC;
    HealthKitViewController *healthKitVC;
    AppGroupsViewController *appGroupsVC;
    CloudKitViewController *cloudKitVC;
    PushViewController *pushVC;
    ApplePayViewController *applePayVC;
    AuthenticationViewController * authenticationVC;
    MapViewController *mapVC;
    UmengViewController *umengVC;
    
    switch (indexPath.row) {
        case 0:
            baseVC = [BaseViewController new];
            [self.navigationController pushViewController:baseVC animated:YES];
            break;
        case 1:
            healthKitVC = [HealthKitViewController new];
            [self.navigationController pushViewController:healthKitVC animated:YES];
            break;
        case 2:
            appGroupsVC = [AppGroupsViewController new];
            [self.navigationController pushViewController:appGroupsVC animated:YES];
            break;
        case 3:
            cloudKitVC = [CloudKitViewController new];
            [self.navigationController pushViewController:cloudKitVC animated:YES];
            break;
        case 4:
            pushVC = [PushViewController new];
            [self.navigationController pushViewController:pushVC animated:YES];
            break;
        case 5:
            applePayVC = [ApplePayViewController new];
            [self.navigationController pushViewController:applePayVC animated:YES];
            break;
        case 6:
            mapVC = [MapViewController new];
            [self.navigationController pushViewController:mapVC animated:YES];
            break;
        case 7:
            umengVC = [UmengViewController new];
            [self.navigationController pushViewController:umengVC animated:YES];
            break;
        case 8:
            authenticationVC = [AuthenticationViewController new];
            [self.navigationController presentViewController:authenticationVC animated:YES completion:nil];
            break;
        default:
            break;
    }
}
@end

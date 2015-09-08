//
//  ViewController.m
//  location
//
//  Created by Bettina Hegedus on 2015. 09. 08..
//  Copyright (c) 2015. Bettina Hegedus. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic,strong) CLLocationManager * locationManager;

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) MKPointAnnotation * myAnnotiation;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) UIAlertController * alertCtrl;
@property (nonatomic) BOOL callGuard; // boolean to filter out first (locationManager:didChangeAuthorizationStatus:) call
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (nonatomic, weak) IBOutlet UIImageView * walkerImageView;

- (IBAction)startButtonTouched:(id)sender;
- (IBAction)stopButtonTouched:(id)sender;
@end

@implementation ViewController

@synthesize walkerImageView = _walkerImageView;

#pragma mark - Getter Setter

-(void)setWalkerImageView:(UIImageView *)walkerImageView {
    UIImage *walker1 = [UIImage imageNamed:@"Walker-1"];
    UIImage *walker2 = [UIImage imageNamed:@"Walker-2"];
    UIImage *walker3 = [UIImage imageNamed:@"Walker-3"];
    UIImage *walker4 = [UIImage imageNamed:@"Walker-4"];
    
    walkerImageView.animationImages = @[walker1, walker2, walker3, walker4];
    walkerImageView.animationDuration = 0.5;
    walkerImageView.animationRepeatCount = 4;
    _walkerImageView = walkerImageView;
}

#pragma mark - Helpers

-(void) showMyAlert {
    UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"Location Access Disabled"
                                                                        message:@"In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'."
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"To Settings"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

                                                             
                                                         }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Exit"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               
                                                               exit(0);
                                                               
                                                           }];
    
    [alertCtrl addAction:defaultAction];
    [alertCtrl addAction:cancelAction];
    self.alertCtrl = alertCtrl;
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            [self.locationManager requestAlwaysAuthorization];
            break;
        }
        
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self.locationManager startUpdatingLocation];
            break;
        }
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        default: {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self showMyAlert];
            });
            
           
            
            break;
        }
    }
    
    self.startButton.enabled = NO;
    self.stopButton.enabled = YES;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    // filtering out first call
    if (self.callGuard == NO) {
        self.callGuard = YES;
        return;
    }
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) { // now it's enabled
        
        if (self.alertCtrl != nil) {
            [self.alertCtrl dismissViewControllerAnimated:NO completion:nil];
        }
        
        [self.locationManager startUpdatingLocation];
    
    } else {
        
        [self showMyAlert];
        
    }
    
}

-(void) locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    static int counter = 0;
    
    if ([oldLocation distanceFromLocation:newLocation] > 0) {
        [self.walkerImageView startAnimating];
    }
    
    NSLog(@"updated %d",counter++);
    
    
    self.latitudeLabel.text = [ NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    self.longitudeLabel.text = [ NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    self.mapView.region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    
    if (self.myAnnotiation == nil) {
        self.myAnnotiation = [MKPointAnnotation new];
    }
    
    self.myAnnotiation.coordinate = newLocation.coordinate;
    
    if ([self.mapView.annotations containsObject:self.myAnnotiation] == NO) {
        [self.mapView addAnnotation:self.myAnnotiation];
    }
    
}


#pragma mark - Target Actions

- (IBAction)startButtonTouched:(UIButton *)sender {
    self.startButton.enabled = NO;
    self.stopButton.enabled = YES;
    
    [self.locationManager startUpdatingLocation];
}
- (IBAction)stopButtonTouched:(UIButton *)sender {
    [self.walkerImageView stopAnimating];
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
    
    [self.locationManager stopUpdatingLocation];
}
@end

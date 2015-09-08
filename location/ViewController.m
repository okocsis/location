//
//  ViewController.m
//  location
//
//  Created by Bettina Hegedus on 2015. 09. 08..
//  Copyright (c) 2015. Bettina Hegedus. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) CLLocationManager * locationManager;

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)startButtonTouched:(id)sender;
- (IBAction)stopButtonTouched:(id)sender;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    
}

-(void) locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    self.latitudeLabel.text = [ NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    self.longitudeLabel.text = [ NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    self.mapView.region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (IBAction)startButtonTouched:(id)sender {
    
    [self.locationManager startUpdatingLocation];
}
- (IBAction)stopButtonTouched:(id)sender {
    
    
    [self.locationManager stopUpdatingLocation];
}
@end

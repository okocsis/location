//
//  ViewController.m
//  location
//
//  Created by Bettina Hegedus on 2015. 09. 08..
//  Copyright (c) 2015. Bettina Hegedus. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize locationManager;
@synthesize latitude;
@synthesize longitude;


- (void)viewDidLoad {
    
 

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
       [super viewDidLoad];
    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    self.latitude.text = [ NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    self.longitude.text = [ NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    self.mapView.region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    
}

-(void) viewDidUnload
{
    [self setLatitude:nil];
    [self setLongitude:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (IBAction)btnAction:(id)sender {
    
    [self.locationManager startUpdatingLocation];
}
- (IBAction)btnStop:(id)sender {
    
    
    [self.locationManager stopUpdatingLocation];
}
@end

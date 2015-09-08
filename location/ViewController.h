//
//  ViewController.h
//  location
//
//  Created by Bettina Hegedus on 2015. 09. 08..
//  Copyright (c) 2015. Bettina Hegedus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

- (IBAction)btnAction:(id)sender;
@property (nonatomic,strong) CLLocationManager * locationManager;





@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;

- (IBAction)btnStop:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end


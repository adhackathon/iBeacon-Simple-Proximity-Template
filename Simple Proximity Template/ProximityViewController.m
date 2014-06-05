//
//  ViewController.m
//  Simple Proximity Template
//

#import "ProximityViewController.h"
#import "ESTBeaconManager.h"

@interface ProximityViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;

@end

@implementation ProximityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup Estimote beacon manager
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    // create sample region object (you can additionaly pass major / minor values)
    ESTBeaconRegion * region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"EstimoteSampleRegion"];
    
    // start looking for estimtoe beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self.beaconManager startRangingBeaconsInRegion:region];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.beaconManager stopRangingBeaconsInRegion:self.region];
    
    [super viewDidDisappear:animated];
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    // Checks if there is any beacons available and find the closests one, then shows the proximity.
    if (beacons.count > 0)
    {
        ESTBeacon * closestsBeacon = [beacons firstObject];
        
        self.proximityLabel.text = [self textForProximity:closestsBeacon.proximity];
    }
}

- (NSString *)textForProximity:(CLProximity)proximity
{
    switch (proximity) {
        case CLProximityFar:
            return @"Far";
            break;
        case CLProximityNear:
            return @"Near";
            break;
        case CLProximityImmediate:
            return @"Immediate";
            break;
            
        default:
            return @"Unknown";
            break;
    }
}

@end

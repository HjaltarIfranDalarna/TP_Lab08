#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITextField *cityTo;
@property (weak, nonatomic) IBOutlet UITextField *cityFrom;

- (IBAction)showFlights:(id)sender;
- (IBAction)isCityFrom:(id)sender;
- (IBAction)isCityTo:(id)sender;


@end


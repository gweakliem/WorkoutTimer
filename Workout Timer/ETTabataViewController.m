//
//  ETTabataViewController.m
//  
//
//  Created by Gordon Weakliem on 1/23/14.
//
//

#import "ETTabataViewController.h"

typedef NS_ENUM(NSInteger, kETCounter){
    kETCounterRunning = 0,
    kETCounterStopped,
    kETCounterReset,
    kETCounterEnded
};

typedef NS_ENUM(NSInteger, kETTabataState) {
    kETRest = 0,
    kETAction = 1
};

@interface ETTabataViewController ()
@property (strong, nonatomic) IBOutlet UIButton *startStopButton;
@property (strong, nonatomic) IBOutlet TTCounterLabel *restCounterLabel;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet TTCounterLabel *actionCounterLabel;
@end

@implementation ETTabataViewController {
int repetitions;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self customizeAppearance: self.restCounterLabel withTextColor:[UIColor yellowColor]];
    [self customizeAppearance: self.actionCounterLabel withTextColor:[UIColor cyanColor]];
    self.actionCounterLabel.countdownDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopButtonPressed:(UIButton *)sender {
    if (self.actionCounterLabel.isRunning) {
        [self.actionCounterLabel stop];
        
        [self updateUIForState:kETCounterStopped];
    } else {
        self->repetitions = 0;
        [self.actionCounterLabel start];
        
        [self updateUIForState:kETCounterRunning];
    }}

- (IBAction)resetButtonPressed:(UIButton *)sender {
    [self.restCounterLabel reset];
    [self.actionCounterLabel reset];
    
    [self updateUIForState:kETCounterReset];
}

#pragma mark UI Helpers
- (void)updateUIForState:(NSInteger)state {
    switch (state) {
        case kETCounterRunning:
            [self.startStopButton setTitle:NSLocalizedString(@"Stop", @"Stop") forState:UIControlStateNormal];
            self.resetButton.hidden = YES;
            break;
            
        case kETCounterStopped:
            [self.startStopButton setTitle:NSLocalizedString(@"Start", @"Start") forState:UIControlStateNormal];
            self.resetButton.hidden = NO;
            break;
            
        case kETCounterReset:
            [self.startStopButton setTitle:NSLocalizedString(@"Start", @"Start") forState:UIControlStateNormal];
            self.resetButton.hidden = YES;
        self.startStopButton.hidden = NO;
            break;
            
        case kETCounterEnded:
            self.startStopButton.hidden = YES;
            self.resetButton.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (void)customizeAppearance: (TTCounterLabel*)counterLabel withTextColor:(UIColor*) color {
    [counterLabel setStartValue:20000];
    counterLabel.countDirection = kCountDirectionDown;
    [counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:75]];
    [counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:75]];
    
    // The font property of the label is used as the font for H,M,S and MS
    [counterLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:45]];
    
    // Default label properties
    counterLabel.textColor = color;
    
    // After making any changes we need to call update appearance
    [counterLabel updateApperance];
}

- (void)countdownDidEnd {
    [self updateUIForState:kETCounterEnded];
}

@end

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
    kETSwitchToAction,
    kETSwitchToRest,
    kETCounterStopped,
    kETCounterReset,
    kETCounterEnded
};

@interface ETTabataViewController ()
@property (strong, nonatomic) IBOutlet UIButton *startStopButton;
@property (strong, nonatomic) IBOutlet TTCounterLabel *restCounterLabel;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet TTCounterLabel *actionCounterLabel;
@property (strong, nonatomic) IBOutlet UILabel *repetitionLabel;
@end

@implementation ETTabataViewController {
    int repetitions;
    bool tabataIsActionState;
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
	
    // initially set to default tabata times
    [self customizeAppearance: self.restCounterLabel withTextColor:[UIColor yellowColor] andStartValue:10000];
    [self customizeAppearance: self.actionCounterLabel withTextColor:[UIColor cyanColor] andStartValue:20000];
    self.actionCounterLabel.countdownDelegate = self;
    self.restCounterLabel.countdownDelegate = self;
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
        [self.repetitionLabel setText:@"0"];
        self->tabataIsActionState = NO;
        [self toggleTabataState];
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

- (void)customizeAppearance: (TTCounterLabel*)counterLabel withTextColor:(UIColor*) color andStartValue:(long)startValue {
    [counterLabel setStartValue:startValue];
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

-(BOOL) toggleTabataState
{
    self->tabataIsActionState = !self->tabataIsActionState;
    if (self->tabataIsActionState) {
        [self.actionCounterLabel start];
        [self.restCounterLabel reset];
    } else  {
        [self.actionCounterLabel reset];
        [self.restCounterLabel start];
        self->repetitions++;
    }
    return self->tabataIsActionState;
}

- (void)countdownDidEnd {
    [self toggleTabataState];
    [self.repetitionLabel setText:[NSString stringWithFormat:@"%d",self->repetitions]];
    if (self->repetitions == 8) {
        [self.actionCounterLabel stop];
        [self updateUIForState:kETCounterEnded];
    }
}

@end

    //
//  iVisiteDetailTherapy.m
//  iVisite
//
//  Created by mk on 02.02.11.
//  Copyright 2011 HTW Berlin. All rights reserved.
//

#import "iVisiteDetailTherapy.h"
#import "Behandlung.h"


@implementation iVisiteDetailTherapy

@synthesize selectedTherapy;
@synthesize textBoxIst;
@synthesize textBoxSoll;
@synthesize textView;


- (IBAction)dismissView {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)textFieldShouldReturn:(id)sender {
	[sender resignFirstResponder];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	Behandlung *b = (Behandlung *)[selectedTherapy objectAtIndex:0];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd.MM.yyyy hh:mm"];
	
	NSString *istTermin =   [dateFormatter stringFromDate:b.istTermin];
	NSString *sollTermin =   [dateFormatter stringFromDate:b.planTermin];
	
	
	textView.text = b.beschreibung;
	textBoxIst.text = istTermin;
	textBoxSoll.text = sollTermin;
	
	[dateFormatter release];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[selectedTherapy dealloc];
	[textBoxIst dealloc];
	[textBoxSoll dealloc];
	[textView dealloc];
	
    [super dealloc];
}


@end

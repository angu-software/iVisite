//
//  iVisiteViewController.m
//  iVisite
//
//  Created by Andreas on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iVisiteViewController.h"
#import "iVisiteListPatients.h"



@implementation iVisiteViewController

@synthesize containerView,progressBar,progressLabel;
@synthesize listData;

-(IBAction)simulateStart
{
	
	/*mainController = [[Controller alloc] init];
	[containerView insertSubview:mainController atIndex:0];
	[self.view addSubview:viewListPatients.view];
	[mainController run];*/
	
	iVisiteListPatients *NView = [[iVisiteListPatients alloc] initWithNibName:nil bundle:nil];
	[self presentModalViewController:NView animated:YES];
	[NView release];
	
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
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
	
	mainController = [[Controller alloc] init];
	[mainController setFrame:[self.view bounds]];
	[mainController setParent: self];
	[mainController setDelegate:self];
	[containerView insertSubview:mainController atIndex:0];
	
}

-(void) resetData{
	[mainController resetData];
	[progressLabel setText:@"Waiting for data..."];
	[progressBar setProgress:0];
}

- (void) viewDidAppear:(BOOL)animated {
	[mainController run];
}

-(void) showTableView{
	iVisiteListPatients* tvPatients = [[iVisiteListPatients alloc] initWithNibName:@"iVisiteListPatients" bundle:nil];
	[tvPatients setParent:self];
	if(listData != nil){
		[tvPatients setListData:listData];
	}
	[self presentModalViewController:tvPatients animated:YES];
	[tvPatients release];
}

#pragma mark MainControllerDelegate methods

-(void) progressOnParsingData:(float)progress{
	[progressLabel setText:@"Receiving data..."];
	[progressBar setProgress:progress];
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	if (listData != nil) {
		[listData release];
	}
    [super dealloc];
}

@end

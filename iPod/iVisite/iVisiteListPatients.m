//
//  iVisiteListPatients.m
//  iVisite
//
//  Created by mk on 01.02.11.
//  Copyright 2011 HTW Berlin. All rights reserved.
//

#import "iVisiteListPatients.h"
#import "iVisiteDetailPatient.h"
#import "Patient.h"
#import "Behandlung.h"


@implementation iVisiteListPatients

@synthesize listData;
@synthesize parent;

-(IBAction)showAbout
{
	UIAlertView *aboutView = [[UIAlertView alloc]
							  initWithTitle:@"Info" message:@"Projekt iVisite..." delegate:self cancelButtonTitle:@"Schließen" otherButtonTitles:nil
							  ];
	[aboutView show];
}

-(IBAction) dissmissView{
	[self dismissModalViewControllerAnimated:YES];
	if (parent != nil) {
		[parent resetData];
	}
}

// Loads dummy data and set to listdata
- (void)setDummyData 
{

 Arzt *a = [[Arzt alloc] initWith:@"dr.becker" Geraet:@"123123123" ];
 
 NSDate *date = [[NSDate alloc] init ];
 Patient *p1 = [[Patient alloc] initWith:@"aaaaa" Arzt:a Geschlecht:0 Aufnahme:date];
 Patient *p2 = [[Patient alloc] initWith:@"bbbb" Arzt:a Geschlecht:0 Aufnahme:date];
 
 Behandlung *b1 = [[Behandlung alloc] initWith:@"beschreibung1" Patient:p1 Termin:date ];
 Behandlung *b2 = [[Behandlung alloc] initWith:@"beschreibung2" Patient:p1 Termin:date ];
 Behandlung *b3 = [[Behandlung alloc] initWith:@"beschreibung3" Patient:p1 Termin:date ];
 
 Behandlung *b11 = [[Behandlung alloc] initWith:@"beschreibung11" Patient:p1 Termin:date ];
 Behandlung *b12 = [[Behandlung alloc] initWith:@"beschreibung12" Patient:p1 Termin:date ];
 Behandlung *b13 = [[Behandlung alloc] initWith:@"beschreibung13" Patient:p1 Termin:date ];
 
 Behandlung *b21 = [[Behandlung alloc] initWith:@"beschreibung21" Patient:p2 Termin:date ];
 Behandlung *b22 = [[Behandlung alloc] initWith:@"beschreibung22" Patient:p2 Termin:date ];
 Behandlung *b23 = [[Behandlung alloc] initWith:@"beschreibung23" Patient:p2 Termin:date ];
 
 [p1 add:b1];
 [p1 add:b2];
 [p1 add:b3];
 [p1 add:b11];
 [p1 add:b12];
 [p1 add:b13];
 
 [p2 add:b21];
 [p2 add:b22];
 [p2 add:b23];
 
 NSMutableArray *simData = [[NSMutableArray alloc] init];
 [simData addObject:p1];
 [simData addObject:p2];
 
 self.listData = simData;
 [simData release];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	if (listData==nil) {
		[self setDummyData];
	}
	
	[super viewDidLoad];
    
	
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
	if(listData != nil){
		[listData dealloc];
	}
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [self.listData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
	return @"Patienten";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:SimpleTableIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	Patient *p = (Patient *)[listData objectAtIndex:row];
	
	unichar sexchar = 0x2642;
	//Is a woman?
	if (p.geschlecht==1) {
		sexchar  = 	0x2640; 
	}
	NSString *title = [NSString stringWithFormat:@"%@ %C",p.name,sexchar];
	
	cell.textLabel.text = title;
	return cell;
	
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	Patient *p = [listData objectAtIndex:row];
	NSMutableArray *ma = [[NSMutableArray alloc] init];
	NSMutableArray *th = [[NSMutableArray alloc] init];
	[ma addObject:p];
	th = p.behandlungen;
	 
	iVisiteDetailPatient *NView = [[iVisiteDetailPatient alloc] initWithNibName:nil bundle:nil];
	NView.selectedPatient = ma;
	NView.selectedTherapys = th;
	
	[ma release];
	[th release];
	
	[self presentModalViewController:NView animated:YES];
	
}

@end

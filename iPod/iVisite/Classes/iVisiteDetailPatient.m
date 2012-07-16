    //
//  iVisiteDetailPatient.m
//  iVisite
//
//  Created by mk on 02.02.11.
//  Copyright 2011 HTW Berlin. All rights reserved.
//

#import "iVisiteDetailTherapy.h"
#import "iVisiteDetailPatient.h"
#import "Patient.h"
#import "Behandlung.h";


@implementation iVisiteDetailPatient

@synthesize selectedPatient;
@synthesize selectedTherapys;


- (IBAction)dismissView {
    [self dismissModalViewControllerAnimated:YES];
}

/* // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.title = @"My Title";

    }
    return self;
}*/


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
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
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [self.selectedTherapys count];
}


//Sets the table header text
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	Patient *p = (Patient *)[selectedPatient objectAtIndex:0];
	unichar sexchar = 0x2642;
	//Is a woman?
	if (p.geschlecht==1) {
		sexchar  = 	0x2640; 
	}
	NSString *title =[NSString stringWithFormat:@"Behandlungen von %@ %C", p.name, sexchar];
	return title;
}

//Sets the table footer text
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section

{
	Patient *p = (Patient *)[selectedPatient objectAtIndex:0];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd.MM.yyyy hh:mm"];
	
	NSString *footer = [
						[NSString alloc] 
						initWithFormat:@"Patient seit %@", 
							[dateFormatter stringFromDate:p.aufnahme]
						];
	
	[dateFormatter release];
	return footer;
}

//Render the table cells
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
	
	Behandlung *b = (Behandlung *)[selectedTherapys objectAtIndex:row];
	
	cell.textLabel.text = b.beschreibung;
	return cell;
	
}


#pragma mark -
#pragma mark Table view delegate

//Event if table cell is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	Behandlung *b = [selectedTherapys objectAtIndex:row];
	
	NSMutableArray *ma = [[NSMutableArray alloc] init];
	[ma addObject:b];
	
	
	iVisiteDetailTherapy *NView = [[iVisiteDetailTherapy alloc] initWithNibName:nil bundle:nil];
	NView.selectedTherapy = ma;
	[ma release];
	
	[self presentModalViewController:NView animated:YES];

}


@end

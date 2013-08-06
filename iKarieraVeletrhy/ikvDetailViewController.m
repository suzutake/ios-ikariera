//
//  ikvDetailViewController.m
//  iKarieraVeletrhy
//
//  Created by takerukun on 13/08/03.
//  Copyright (c) 2013年 cz.senman.ikariera_mobile. All rights reserved.
//

#import "ikvDetailViewController.h"

@interface ikvDetailViewController ()
- (void)configureView;
@end

@implementation ikvDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        
        // set Info Label
        self.Label_Info_JobfairName.text = [[self.detailItem valueForKey:@"name"] description];
        self.Label_Info_JobfairName.adjustsFontSizeToFitWidth = YES;
        self.Label_Info_Informace.text = @"Základní informace:";
        self.Label_Info_Informace.adjustsFontSizeToFitWidth = YES;
        
        NSString *beforeDescript = @"";
        beforeDescript = [[self.detailItem valueForKey:@"descript"] description];
        
        NSString *afterDescript = [beforeDescript stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
        self.Label_Info_Information.numberOfLines=3;
        self.Label_Info_Information.text = afterDescript;
        //If numberOfLines greater than 1, adjustsFontSizeToFitWidth doesn't work.
        
        self.Label_Info_Datum.text = @"Datum konání:";
        self.Label_Info_Datum.adjustsFontSizeToFitWidth = YES;
        self.Label_Info_DateTurm.text = [NSString stringWithFormat:@"%@-%@",[[self.detailItem valueForKey:@"dateBegin"] description],[[self.detailItem valueForKey:@"dateEnd"] description]];
        self.Label_Info_DateTurm.adjustsFontSizeToFitWidth = YES;
        
        self.Label_Info_Misto.text = @"Misto konání:";
        self.Label_Info_Misto.adjustsFontSizeToFitWidth = YES;
        self.Label_Info_place.text = [[self.detailItem valueForKey:@"place"] description];
        self.Label_Info_place.adjustsFontSizeToFitWidth = YES;
        self.Label_Info_Street_City.text = [NSString stringWithFormat:@"%@,%@",[[self.detailItem valueForKey:@"street"] description],[[self.detailItem valueForKey:@"city"] description]];
        self.Label_Info_Street_City.adjustsFontSizeToFitWidth = YES;
        self.Label_Info_country.text = [[self.detailItem valueForKey:@"country"] description];
        self.Label_Info_country.adjustsFontSizeToFitWidth = YES;
        
        // set Firmy Label
        self.Label_Firmy_Firmy.text = @"Přehled firem účastnících se veletrhu: ";
        self.Label_Firmy_Firmy.adjustsFontSizeToFitWidth = YES;
        
        self.Label_Firmy_JobfairName.text = [[self.detailItem valueForKey:@"name"] description];
        self.Label_Firmy_JobfairName.adjustsFontSizeToFitWidth = YES;
        
        // set Prednasky Label
        self.Label_Prednasky_Prednasky.text = @"Přednášky";
        self.Label_Prednasky_Prednasky.adjustsFontSizeToFitWidth = YES;
    }
    
    self.View_Info.hidden=NO;
    [self.View_Info setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
    self.View_Firmy.hidden=YES;
    [self.View_Firmy setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
    self.View_Prednasky.hidden=YES;
    [self.View_Prednasky setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    UISwipeGestureRecognizer *rightswipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRight:)];
    // swipe direction is right ->
    rightswipe.direction = UISwipeGestureRecognizerDirectionRight;
    // use one finger
    rightswipe.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:rightswipe];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeLeft:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:leftSwipe];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)ikvDetailViewSegment:(UISegmentedControl *)sender {
    NSLog(@"Segment Control Clicked.");
    switch (self.ikvDetailViewSegment.selectedSegmentIndex) {
        case 0:
            self.View_Info.hidden=NO;
            self.View_Firmy.hidden=YES;
            self.View_Prednasky.hidden=YES;
            break;
            
        case 1:
            self.View_Info.hidden=YES;
            self.View_Firmy.hidden=NO;
            self.View_Prednasky.hidden=YES;
            break;
            
        case 2:
            self.View_Info.hidden=YES;
            self.View_Firmy.hidden=YES;
            self.View_Prednasky.hidden=NO;
            break;
            
        default:
            break;
    }
}

-(void)SwipeRight:(UISwipeGestureRecognizer *)gesture {
    NSLog(@"right swipe recognized!");
    switch (self.ikvDetailViewSegment.selectedSegmentIndex) {
        case 0:
            self.ikvDetailViewSegment.selectedSegmentIndex=1;
            self.View_Info.hidden=YES;
            self.View_Firmy.hidden=NO;
            self.View_Prednasky.hidden=YES;
            
            //add animation
            [self.View_Firmy setFrame:CGRectMake(-200, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            [self.View_Firmy setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
            [UIView commitAnimations];
            
            break;
            
        case 1:
            self.ikvDetailViewSegment.selectedSegmentIndex=2;
            self.View_Info.hidden=YES;
            self.View_Firmy.hidden=YES;
            self.View_Prednasky.hidden=NO;
            
            //add animation
            [self.View_Prednasky setFrame:CGRectMake(-200, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            [self.View_Prednasky setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
            [UIView commitAnimations];
            
            break;
            
        case 2:
            break;
            
        default:
            break;
    }
    
}

-(void)SwipeLeft:(UISwipeGestureRecognizer *)gesture {
    NSLog(@"left swipe recognized!");
    switch (self.ikvDetailViewSegment.selectedSegmentIndex) {
        case 0:            
            break;
            
        case 1:
            self.ikvDetailViewSegment.selectedSegmentIndex=0;
            self.View_Info.hidden=NO;
            self.View_Firmy.hidden=YES;
            self.View_Prednasky.hidden=YES;
            
            //add animation
            [self.View_Info setFrame:CGRectMake(200, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            [self.View_Info setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
            [UIView commitAnimations];
            
            break;
            
        case 2:
            self.ikvDetailViewSegment.selectedSegmentIndex=1;
            self.View_Info.hidden=YES;
            self.View_Firmy.hidden=NO;
            self.View_Prednasky.hidden=YES;
            
            //add animation
            [self.View_Firmy setFrame:CGRectMake(200, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            [self.View_Firmy setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-self.navigationController.navigationBar.frame.size.height)];
            [UIView commitAnimations];
            
            break;
            
        default:
            break;
    }

}

@end
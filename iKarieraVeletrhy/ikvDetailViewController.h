//
//  ikvDetailViewController.h
//  iKarieraVeletrhy
//
//  Created by takerukun on 13/08/03.
//  Copyright (c) 2013年 cz.senman.ikariera_mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ikvDetailViewController : UIViewController<NSXMLParserDelegate>

@property (strong, nonatomic) id detailItem;

// Labels Info
@property (weak, nonatomic) IBOutlet UILabel *Label_Info_JobfairName;
@property (weak, nonatomic) IBOutlet UILabel *Label_Info_Informace;
@property (weak, nonatomic) IBOutlet UILabel *Label_Info_Information;

@property (weak, nonatomic) IBOutlet UILabel *Label_Info_Datum;
@property (weak, nonatomic) IBOutlet UILabel *Label_Info_DateTurm;

@property (weak, nonatomic) IBOutlet UILabel *Label_Info_Misto;
@property (weak, nonatomic) IBOutlet UILabel *Label_Info_place;
@property (weak, nonatomic) IBOutlet UILabel *Label_Info_Street_City;
@property (weak, nonatomic) IBOutlet UILabel *Label_Info_country;


// Labels Firmy
@property (weak, nonatomic) IBOutlet UILabel *Label_Firmy_Firmy;
@property (weak, nonatomic) IBOutlet UILabel *Label_Firmy_JobfairName;

// Labels Prednasky
@property (weak, nonatomic) IBOutlet UILabel *Label_Prednasky_Prednasky;


// Segmented Control
@property (weak, nonatomic) IBOutlet UISegmentedControl *ikvDetailViewSegment;
- (IBAction)ikvDetailViewSegment:(UISegmentedControl *)sender;


// View
@property (weak, nonatomic) IBOutlet UIView *View_Info;
@property (weak, nonatomic) IBOutlet UIView *View_Firmy;
@property (weak, nonatomic) IBOutlet UIView *View_Prednasky;


// Swipe Gesture
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *SwipeRight;


@end

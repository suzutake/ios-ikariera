//
//  ikvDetailViewController.h
//  iKarieraVeletrhy
//
//  Created by takerukun on 13/08/03.
//  Copyright (c) 2013年 cz.senman.ikariera_mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ikvDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

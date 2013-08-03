//
//  ikvMasterViewController.h
//  iKarieraVeletrhy
//
//  Created by takerukun on 13/08/03.
//  Copyright (c) 2013年 cz.senman.ikariera_mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface ikvMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

//
//  ikvAppDelegate.h
//  iKarieraVeletrhy
//
//  Created by takerukun on 13/08/03.
//  Copyright (c) 2013年 cz.senman.ikariera_mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ikvAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

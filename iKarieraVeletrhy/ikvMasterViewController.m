//
//  ikvMasterViewController.m
//  iKarieraVeletrhy
//
//  Created by takerukun on 13/08/03.
//  Copyright (c) 2013年 cz.senman.ikariera_mobile. All rights reserved.
//

#import "ikvMasterViewController.h"
#import "ikvDetailViewController.h"
#import "ikvJobfair.h"

@interface ikvMasterViewController (){
    // add for parser
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableArray *name;
    NSMutableArray *city;
    NSMutableArray *country;
    ikvJobfair *_parsedIkvjobfair;
    NSString *_attr;
    NSString *_elementName;
    
    //NSMutableString *currentName;
    int _elementParsedCount;
    NSString *_lastParsedString;
    
    
    //add
    BOOL isList;
    BOOL isMap;
    BOOL isEntry;
    
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ikvMasterViewController

//@synthesize currentContent;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"iKariera Veletrhy";
    
    // if network is available.
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [self resetAllData:context entityName:@"JobfairCoreData"];
    
    
    
    // =====================================
    // below is xmlparser pattern
    // =====================================
    feeds=[[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://37.59.135.194:8080/ikariera/android-jobfair/get-active-jobfairs"];
    
    
    //=======================
    // choose parser system
    //=======================
    
    // If I choose below parser, it will be single thread program.
    
    
    
    // add for utf-8
    NSError *error;
    NSString * dataString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    //parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser = [[NSXMLParser alloc] initWithData:data];
    // end add
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    // when network is available, parse will start.
    NSLog(@"parser.parse will start.");
    //_currentContent = [[NSMutableString alloc]init];
    [parser parse];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// insert Jobfair data @ Core data
/*
-(void)insertNewJobfairData:(id)sender jobfair:(ikvJobfair*)_ikvJobfair
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // set Jobfair datas
    [newManagedObject setValue:_ikvJobfair.id forKey:@"id"];
    [newManagedObject setValue:_ikvJobfair.city forKey:@"city"];
    [newManagedObject setValue:_ikvJobfair.country forKey:@"country"];
    [newManagedObject setValue:_ikvJobfair.dateBegin forKey:@"dateBegin"];
    [newManagedObject setValue:_ikvJobfair.dateEnd forKey:@"dateEnd"];
    [newManagedObject setValue:_ikvJobfair.descript forKey:@"descript"];
    [newManagedObject setValue:_ikvJobfair.exhibitor forKey:@"exhibitor"];
    [newManagedObject setValue:_ikvJobfair.link forKey:@"link"];
    [newManagedObject setValue:_ikvJobfair.map forKey:@"map"];
    [newManagedObject setValue:_ikvJobfair.name forKey:@"name"];
    [newManagedObject setValue:_ikvJobfair.place forKey:@"place"];
    [newManagedObject setValue:_ikvJobfair.presentationRoom forKey:@"presentationRoom"];
    [newManagedObject setValue:_ikvJobfair.street forKey:@"street"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}
 */

//
// delete all data in a entity
//
-(void)resetAllData:(NSManagedObjectContext *)context entityName:(NSString *)deleteEntityName
{
    NSUInteger count=0;
    
    for (NSEntityDescription *entity in [[[context persistentStoreCoordinator] managedObjectModel] entities]) {
        NSString *_entityName = [entity name];
        if ([_entityName isEqualToString:deleteEntityName]) {
            NSLog(@"Delete entityName is %@",_entityName);
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:[entity name] inManagedObjectContext:context]];
            NSArray *temp = [context executeFetchRequest:request error:NULL];
            if (temp) {
                count += [temp count];
            }
            for (NSManagedObject *object in temp) {
                [context deleteObject:object];
            }
        }
        
    }
    NSLog(@"Entity = %d", count);
    
    [context save:NULL];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JobfairCoreData" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

//
// set tableview contents
//
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"name"] description];
    //cell.detailTextLabel.text = [[object valueForKey:@"city"] description];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@,%@", [[object valueForKey:@"dateBegin"] description],[[object valueForKey:@"dateEnd"] description],[[object valueForKey:@"city"] description]];
}



// =====================================
// below is xmlparser pattern
// =====================================

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{    
    //NSLog(@"start parse XML");
    _elementName = elementName;
    
    //trying
    _elementParsedCount=0;
    _lastParsedString=nil;
    
    NSManagedObjectContext* context;
    context = self.managedObjectContext;
    
    if ([elementName isEqualToString:@"list"]) {
        _parsedIkvjobfair = [[ikvJobfair alloc]init];
        
        //_parsedIkvjobfair.id=@"";
        //_parsedIkvjobfair.name=@"";
        
        isList=YES;
    }
    if ([elementName isEqualToString:@"map"]) {
        isMap=YES;
        
    }
    if ([elementName isEqualToString:@"entry"]) {
        isEntry=YES;
    }
    _attr=[attributeDict objectForKey:@"key"];
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
    if ([_elementName isEqualToString:@"entry"]) {
        // Trim new line char and space
        string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(isEntry){
            if([_attr isEqualToString:@"id"]){
                // if parsed charactor contains foreign charactor like czech,german, it can't set one time.
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.id = string;
                NSLog(@"_parsedIkvjobfair.id is %@",_parsedIkvjobfair.id);
                _elementParsedCount++;
                
            }else if([_attr isEqualToString:@"name"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.name = string;
                NSLog(@"_parsedIkvjobfair.name is %@",_parsedIkvjobfair.name);
                _elementParsedCount++;
                
            }else if([_attr isEqualToString:@"city"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.city = string;
                NSLog(@"_parsedIkvjobfair.city is %@",_parsedIkvjobfair.city);
                _elementParsedCount++;
                
            }else if([_attr isEqualToString:@"country"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.country = string;
                _elementParsedCount++;
            
            }else if([_attr isEqualToString:@"dateBegin"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.dateBegin = string;
                _elementParsedCount++;
            
            }else if([_attr isEqualToString:@"dateEnd"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.dateEnd = string;
                _elementParsedCount++;
            }else if([_attr isEqualToString:@"description"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.descript = string;
                NSLog(@"_parsedIkvjobfair.descript is %@",_parsedIkvjobfair.descript);
                _elementParsedCount++;
                
            }else if([_attr isEqualToString:@"exhibitor"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.exhibitor = string;
                _elementParsedCount++;
                
            }
            else if([_attr isEqualToString:@"link"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.link = string;
                _elementParsedCount++;
                
            }
            else if([_attr isEqualToString:@"map"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.map = string;
                _elementParsedCount++;
                
            }
            else if([_attr isEqualToString:@"place"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.place = string;
                _elementParsedCount++;
                
            }
            else if([_attr isEqualToString:@"presentationRoom"]){
                
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.presentationRoom = string;
                _elementParsedCount++;
                
            }
            else if([_attr isEqualToString:@"street"]){
                if(_elementParsedCount > 0){
                    string = [NSString stringWithFormat:@"%@%@", _lastParsedString,string];
                }
                _lastParsedString=string;
                _parsedIkvjobfair.street = string;
                NSLog(@"_parsedIkvjobfair.street is %@",_parsedIkvjobfair.street);
                _elementParsedCount++;
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    
    //_item.title = [_item.title stringByAppendingString:[NSString stringWithFormat:@"%@ %@ %@",_dateBegin,_dateEnd,_city]];
    if ([elementName isEqualToString:@"list"]) {
        //NSLog(@"endElement.list");
        isList=NO;
        //[self.masterJobfairList addObject:_jobfair];
        
        //NSLog(@"add _jobfair to _items");
        // start add Core data.
        NSLog(@"start core data.");
        [self insertNewJobfairData:self jobfair:_parsedIkvjobfair];
        
    }else if ([elementName isEqualToString:@"map"]) {
        //NSLog(@"endElement.map");
        isMap=NO;
    }else if([elementName isEqualToString:@"entry"]){
        //NSLog(@"endElement.entry");
        /*
        if([_attr isEqualToString:@"name"]){
            //_currentContent = [NSString stringWithString:self._currentContent];
            //NSLog(@"_currentContext is %@",currentName);
            //[_parsedIkvjobfair.name stringByAppendingString:currentName];
            NSLog(@"_parsedIkvjobfair.name is %@",_parsedIkvjobfair.name);
        }
         */
        
        isEntry=NO;
    }
    
    //_currentContent = nil;
}

// insert Jobfair data @ Core data
-(void)insertNewJobfairData:(id)sender jobfair:(ikvJobfair*)_ikvJobfair
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSLog(@"entity name is %@",[entity name]);
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    //NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"JobfairCoreData" inManagedObjectContext:context];
    
    // set Jobfair datas
    
    //dynamic data
    
    [newManagedObject setValue:_ikvJobfair.id forKey:@"id"];
    [newManagedObject setValue:_ikvJobfair.city forKey:@"city"];
    [newManagedObject setValue:_ikvJobfair.country forKey:@"country"];
    [newManagedObject setValue:_ikvJobfair.dateBegin forKey:@"dateBegin"];
    [newManagedObject setValue:_ikvJobfair.dateEnd forKey:@"dateEnd"];
    [newManagedObject setValue:_ikvJobfair.descript forKey:@"descript"];
    [newManagedObject setValue:_ikvJobfair.exhibitor forKey:@"exhibitor"];
    [newManagedObject setValue:_ikvJobfair.link forKey:@"link"];
    [newManagedObject setValue:_ikvJobfair.map forKey:@"map"];
    [newManagedObject setValue:_ikvJobfair.name forKey:@"name"];
    [newManagedObject setValue:_ikvJobfair.place forKey:@"place"];
    [newManagedObject setValue:_ikvJobfair.presentationRoom forKey:@"presentationRoom"];
    [newManagedObject setValue:_ikvJobfair.street forKey:@"street"];
     
    
    // test static data
    /*
    //[newManagedObject setValue:@"jobfairId00" forKey:@"id"];
    [newManagedObject setValue:_parsedIkvjobfair.id forKey:@"id"];
    
    //[newManagedObject setValue:@"jobfairCity00" forKey:@"city"];
    [newManagedObject setValue:_parsedIkvjobfair.city forKey:@"city"];
    
    //[newManagedObject setValue:@"jobfairName00" forKey:@"name"];
    [newManagedObject setValue:_parsedIkvjobfair.name forKey:@"name"];
    */
     
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"parserDidEndDocument called.");
    // =====================================
    // below is reload TableView
    // (useless in this class because this is not tableView class.)
    // =====================================
    /*
     dispatch_async(dispatch_get_main_queue(), ^{
     [self.refreshControl endRefreshing];
     [self.tableView reloadData];
     });
     */
    
    //NSLog(@"aho _jobfair.city is %@",_jobfair.city);
    
}

-(NSString *)adjustString:(NSString*)beforeString
{
    NSError* error;
    __block NSString* _newString;
    //NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:@"^[¥r¥n]|[¥r¥n]|[ ^t^b]|[\t]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:@"^[¥r¥n]|[ ^t^b]|[\t]" options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:beforeString options:0 range:NSMakeRange(0, [beforeString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
     {
         _newString = [regex stringByReplacingMatchesInString:beforeString options:0 range:NSMakeRange(0, [beforeString length]) withTemplate:@""];
         
     }];
    return _newString;
}

@end

//
//  MasterViewController.h
//  KhanAcademyBrowser
//
//  Created by Paul Agron on 1/15/15.
//  Copyright (c) 2015 Paul Agron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


// Insist on atomic just in case...
@property (strong) NSURLConnection* connection;


-(void) enableRefresh;
-(void) disableRefresh;
@end


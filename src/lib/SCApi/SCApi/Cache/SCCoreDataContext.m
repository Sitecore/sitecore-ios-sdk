#import "SCCoreDataContext.h"

//https://github.com/dodikk/iOS-custom-framework-example/blob/master/CalculatorUIMock/CalculatorUIMock/CMResourceManager.m

@interface SCCoreDataContext ()

@property ( nonatomic, retain, readonly ) NSManagedObjectModel* managedObjectModel;
@property ( nonatomic, retain, readonly ) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end

@implementation SCCoreDataContext

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store         
 coordinator for the application.
 */
-(NSManagedObjectContext *) managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in    
 application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if ( persistentStoreCoordinator != nil )
    {
        return persistentStoreCoordinator;
    }

    NSString* path_ = [ NSString documentsPathByAppendingPathComponent: @"SCCoreData.sqlite" ];
    NSURL* storeUrl = [ NSURL fileURLWithPath: path_ ];

    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] 
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if ( ! [ persistentStoreCoordinator addPersistentStoreWithType: NSInMemoryStoreType 
                                                     configuration: nil
                                                               URL: storeUrl
                                                           options: nil
                                                             error: &error ] ) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should 
         not use this function in a shipping application, although it may be useful during 
         development. If it is not possible to recover from the error, display an alert panel that 
         instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object 
         model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    

    return persistentStoreCoordinator;
}

+(id)sharedCoreDataContext
{
    static id instance_ = nil;

    if ( !instance_ )
    {
        instance_ = [ self new ];
    }

    return instance_;
}

@end

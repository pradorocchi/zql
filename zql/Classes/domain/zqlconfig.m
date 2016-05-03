#import "zqlconfig.h"

static NSString* const zqlfoldername = @"zql";

@interface zqlconfig ()

@property(copy, nonatomic)NSString *dbname;

@end

@implementation zqlconfig

+(instancetype)shared
{
    static zqlconfig *singleton;
    static dispatch_once_t once;
    dispatch_once(&once, ^(void) { singleton = [[self alloc] init]; });
    
    return singleton;
}

#pragma mark private

-(NSString*)pathforfolder
{
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbfolder = [documents stringByAppendingPathComponent:zqlfoldername];
    
    return dbfolder;
}

-(NSString*)pathfordb:(NSString*)dbname
{
    NSString *dbfolder = [self pathforfolder];
    NSString *dbpath = [dbfolder stringByAppendingPathComponent:dbname];
    
    return dbpath;
}

#pragma mark public

-(void)createdb:(NSString*)dbname
{
    NSString *dbfolder = [self pathforfolder];
    NSString *dbpath = [self pathfordb:dbname];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if(![filemanager fileExistsAtPath:dbfolder])
    {
        NSURL *folderurl = [NSURL fileURLWithPath:dbfolder];
        [filemanager createDirectoryAtURL:folderurl withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    [filemanager createFileAtPath:dbpath contents:nil attributes:nil];
    [self startdb:dbname];
}

-(void)startdb:(NSString*)dbname
{
    self.dbname = [self pathfordb:dbname];
}

@end
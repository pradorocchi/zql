#import "zqlqueryprocessor.h"
#import "zqlresultsuccess.h"

@interface zqlqueryprocessor ()

@property(weak, nonatomic)zqlquery *query;
@property(assign, nonatomic)sqlite3_stmt *statement;

@end

@implementation zqlqueryprocessor

-(instancetype)init:(zqlquery*)query
{
    self = [super init];
    self.query = query;
    
    return self;
}

#pragma mark functionality

-(NSInteger)stepresult
{
    return sqlite3_step(self.statement);
}

-(NSString*)columnname:(NSInteger)index
{
    const char *colname = sqlite3_column_name(self.statement, (int)index);
    NSString *columname = [NSString stringWithUTF8String:colname];
    
    return columname;
}

-(zqltype*)typeforcolumn:(NSInteger)index
{
    NSInteger sqltype = sqlite3_column_type(self.statement, (int)index);
    zqltype *type = [zqltype fromsqltype:sqltype];
    
    return type;
}

#pragma mark public

-(zqlresult*)prepare:(sqlite3*)sqlite
{
    NSInteger resultnumber = sqlite3_prepare_v2(sqlite, self.query.querystring.UTF8String, -1, &_statement, nil);
    zqlresult *result = [zqlresult sqlresponse:resultnumber];
    
    return result;
}

-(zqlresult*)step
{
    NSInteger resultnumber = [self stepresult];
    zqlresult *result = [zqlresult sqlresponse:resultnumber];
    
    if([result isKindOfClass:[zqlresultsuccess class]])
    {
        zqlresultsuccess *success = (zqlresultsuccess*)result;
        
        if(success.moresteps)
        {
            NSInteger columncount = sqlite3_column_count(self.statement);
            NSInteger newresultnumber = resultnumber;
            
            while(resultnumber == newresultnumber)
            {
                for(NSInteger indexcolumn = 0; indexcolumn < columncount; indexcolumn++)
                {
                    zqltype *type = [self typeforcolumn:indexcolumn];
                    NSString *columname = [self columnname:indexcolumn];
                }
                
                newresultnumber = [self stepresult];
            }
            
            
            
            
        }
    }
    
    return result;
}

-(void)finalizestatement
{
    sqlite3_finalize(self.statement);
}

-(void)lastinsert:(sqlite3*)sqlite result:(zqlresultsuccess*)result
{
    NSInteger lastinsert = (NSInteger)sqlite3_last_insert_rowid(sqlite);
    result.lastinsertid = lastinsert;
}

@end
#import "zqlparam.h"

@interface zqlparam ()

@property(copy, nonatomic)NSString *comparename;

@end

@implementation zqlparam

+(instancetype)type:(zqltype*)type name:(NSString*)name value:(id)value
{
    zqlparam *param;
    
    if(type && name)
    {
        param = [[zqlparam alloc] init:name];
        param.type = type;
        param.value = value;
    }
    
    return param;
}

-(instancetype)init:(NSString*)name
{
    self = [super init];
    self.name = name;
    self.comparename = name.lowercaseString;
    
    return self;
}

@end
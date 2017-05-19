

#import <Foundation/Foundation.h>

@interface AFServiceManager : NSObject

+(id)mySharedManager;
-(void)getDataFromService:(NSString *)serviceName withParameters:(NSDictionary *)parameters withCompletionBlock:(void(^)(BOOL,id,NSError*))completion;

@end

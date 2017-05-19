/* This is a manual class for handling the API calls */
// A single class to handle both POST and GET calls

#import "AFServiceManager.h"
#import "AFNetworking.h"

#define base_URL @"http://www.*********.com/********api/"

static AFServiceManager *serviceManager = nil;

@interface AFServiceManager()
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end

@implementation AFServiceManager

+(id)mySharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[self alloc]init];
        [self setBaseURL];
    });
    return serviceManager;
}

+(void)setBaseURL {
    serviceManager.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:base_URL]];
    serviceManager.sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    serviceManager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
}

#pragma mark GET
-(void)getDataFromService:(NSString *)serviceName withParameters:(NSDictionary *)parameters withCompletionBlock:(void(^)(BOOL,id,NSError*))completion{
    [serviceManager.sessionManager GET:serviceName parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        completion(YES,responseObject,nil);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        completion(NO,nil,error);
    }];
}

#pragma mark POST
-(void)postDataFromService:(NSString *)serviceName withParameters:(NSDictionary *)parameters withCompletionBlock:(void(^)(BOOL,id,NSError*))completion{
    [serviceManager.sessionManager POST:serviceName parameters:parameters progress:nil  success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(YES,responseObject,nil);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        completion(NO,nil,error);
    }];
}

@end

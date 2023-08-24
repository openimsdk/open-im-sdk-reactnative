#import "UploadFileCallbackProxy.h"

@implementation NSDictionary (Extensions)

- (NSString *)json {
    NSString *json = nil;

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return (error ? nil : json);
}

@end

@interface RNUploadFileCallbackProxy()

@property (nonatomic, copy) RCTPromiseResolveBlock resolver;
@property (nonatomic, copy) RCTPromiseRejectBlock rejecter;
@property (nonatomic, copy) NSString* msg;
@property (nonatomic, weak) OpenIMSDKRN* module;

@end

@implementation RNUploadFileCallbackProxy

- (id)initWithMessage:(NSString *)msg module:(OpenIMSDKRN *)module resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter{
    if (self = [super init]) {
        self.msg = msg;
        self.module = module;
        self.resolver = resolver;
        self.rejecter = rejecter;
    }
    return self;
}

- (void)onError:(int32_t)errCode errMsg:(NSString * _Nullable)errMsg {
    self.rejecter([NSString stringWithFormat:@"%d",errCode],errMsg,nil);
}

- (void)onSuccess:(NSString * _Nullable)data {
    self.resolver(data);
}

- (void)onProgress:(long)progress {
    NSDictionary *data = @{
        @"progress":[NSString stringWithFormat:@"%ld",progress],
        @"message":self.msg
    };
    [self.module pushEvent:@"UploadFileProgress" errCode:@(0) errMsg:@"" data:[data json]];
}
@end

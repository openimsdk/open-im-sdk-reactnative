#import "SendMessageCallbackProxy.h"

@implementation NSDictionary (Extensions)

- (NSString *)json {
    NSString *json = nil;

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return (error ? nil : json);
}

@end

@interface RNSendMessageCallbackProxy()

@property (nonatomic, copy) RCTPromiseResolveBlock resolver;
@property (nonatomic, copy) RCTPromiseRejectBlock rejecter;
@property (nonatomic, copy) NSString* msg;
@property (nonatomic, weak) OpenIMSDKRN* module;

@end

@implementation RNSendMessageCallbackProxy

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

- (NSDictionary *)parseJsonStr2Dict:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Error while parsing JSON: %@", error.localizedDescription);
        return nil;
    }
    NSDictionary *data = (NSDictionary *)jsonObject;
    return data;
}

- (void)onSuccess:(NSString * _Nullable)data {
    NSDictionary *messageDict = [self parseJsonStr2Dict:data];
    self.resolver(messageDict);
}

- (void)onProgress:(long)progress {
    NSDictionary *messageDict = [self parseJsonStr2Dict:self.msg];
    NSDictionary *data = @{
        @"progress":@(progress),
        @"message":messageDict
    };
    [self.module pushEvent:@"SendMessageProgress" data:data];
}
@end

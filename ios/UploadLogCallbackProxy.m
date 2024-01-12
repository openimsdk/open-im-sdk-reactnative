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

@interface RNUploadLogCallbackProxy()

@property (nonatomic, copy) NSString* opid;
@property (nonatomic, weak) OpenIMSDKRN* module;

@end

@implementation RNUploadLogCallbackProxy

- (nonnull id)initWithOpid:(nonnull NSString *)operationID module:(nonnull OpenIMSDKRN *)module {
    if (self = [super init]) {
        self.opid = operationID;
        self.module = module;
    }
    return self;
}
- (void)onProgress:(long)current size:(long)size {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"current"] = @(current);
    params[@"size"] = @(size);
    params[@"operationID"] = operationID;
    [self sendWithCtx:ctx eventName:@"uploadOnProgress" params:params];
}



@end

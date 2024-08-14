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

@property (nonatomic, copy) NSString* opid;
@property (nonatomic, weak) OpenIMSDKRN* module;

@end

@implementation RNUploadFileCallbackProxy

- (nonnull id)initWithOpid:(nonnull NSString *)operationID module:(nonnull OpenIMSDKRN *)module resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter {
    if (self = [super init]) {
        self.opid = operationID;
        self.module = module;
    }
    return self;
}

- (void)complete:(int64_t)size url:(NSString * _Nullable)url typ:(long)typ {
    
}

- (void)hashPartComplete:(NSString * _Nullable)partsHash fileHash:(NSString * _Nullable)fileHash {
    
}

- (void)hashPartProgress:(long)index size:(int64_t)size partHash:(NSString * _Nullable)partHash {
    
}

- (void)open:(int64_t)size {
    
}

- (void)partSize:(int64_t)partSize num:(long)num {
    
}

- (void)uploadComplete:(int64_t)fileSize streamSize:(int64_t)streamSize storageSize:(int64_t)storageSize {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSNumber numberWithLongLong:fileSize] forKey:@"fileSize"];
    [data setObject:[NSNumber numberWithLongLong:streamSize] forKey:@"streamSize"];
    [data setObject:[NSNumber numberWithLongLong:storageSize] forKey:@"storageSize"];
    [data setObject:self.opid forKey:@"operationID"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:data forKey:@"data"];
    params[@"errCode"] = @(0);
    params[@"errMsg"] = @"";
    
    [self.module pushEvent:@"uploadComplete" data:params];
}


- (void)uploadID:(NSString * _Nullable)uploadID {
    
}

- (void)uploadPartComplete:(long)index partSize:(int64_t)partSize partHash:(NSString * _Nullable)partHash {
    
}



@end

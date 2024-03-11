#import "CallbackProxy.h"

@interface RNCallbackProxy()

@property (nonatomic, copy) RCTPromiseResolveBlock resolver;
@property (nonatomic, copy) RCTPromiseRejectBlock rejecter;

@end

@implementation RNCallbackProxy

- (id)initWithCallback:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter {
    if (self = [super init]) {
        self.resolver = resolver;
        self.rejecter = rejecter;
    }
    return self;
}

- (NSDictionary *)parseJsonStr2Dict:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    NSDictionary *data = (NSDictionary *)jsonObject;
    return data;
}

- (NSArray *)parseJsonStr2Array:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    NSArray *data = (NSArray *)jsonObject;
    return data;
}

- (void)onError:(int32_t)errCode errMsg:(NSString * _Nullable)errMsg {
    self.rejecter([NSString stringWithFormat:@"%d",errCode],errMsg,nil);
}

- (void)onSuccess:(NSString * _Nullable)data {
    NSDictionary *dataDict = [self parseJsonStr2Dict:data];
    if (dataDict) {
        self.resolver(dataDict);
    } else {
        NSArray *dataArray = [self parseJsonStr2Array:data];
        if (dataArray) {
            self.resolver(dataArray);
        } else {
            self.resolver(data);
        }
    }
}

@end

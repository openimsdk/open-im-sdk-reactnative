#import "CallbackProxy.h"

@interface RNCallbackProxy()

@property (nonatomic, copy) RCTPromiseResolveBlock resolver;
@property (nonatomic, copy) RCTPromiseRejectBlock rejecter;
@property (nonatomic, copy, nullable) RNOIMSuccessCallback _onSuccess;

@end

@implementation RNCallbackProxy

- (id)initWithCallback:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter {
    return [self initWithCallback:resolver rejecter:rejecter onSuccess:nil];
}

- (id)initWithCallback:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter onSuccess:(RNOIMSuccessCallback _Nullable)onSuccess {
    if (self = [super init]) {
        self.resolver = resolver;
        self.rejecter = rejecter;
        self._onSuccess = onSuccess;
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
    if (self._onSuccess) {
        id result = self._onSuccess(data);
        self.resolver(result);
        return;
    }

    if (!data) {
        self.resolver(nil);
        return;
    }

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

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

- (void)onError:(int32_t)errCode errMsg:(NSString * _Nullable)errMsg {
    self.rejecter([NSString stringWithFormat:@"%d",errCode],errMsg,nil);
}

- (void)onSuccess:(NSString * _Nullable)data {
    self.resolver(data);
}


@end

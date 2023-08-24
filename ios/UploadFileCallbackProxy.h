#import "OpenImSdkRn.h"

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#endif

@import OpenIMCore;

NS_ASSUME_NONNULL_BEGIN

@interface RNUploadFileCallbackProxy : NSObject <Open_im_sdk_callbackUploadFileCallBack>

- (id)initWithMessage:(NSString *)msg module:(OpenIMSDKRN *)module resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter;

@end

NS_ASSUME_NONNULL_END

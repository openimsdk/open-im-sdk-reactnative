@import OpenIMCore;
#import "CallbackProxy.h"

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#endif

@interface OpenIMSDKRN : RCTEventEmitter <RCTBridgeModule,Open_im_sdkIMSDKListener, Open_im_sdkOnAdvancedMsgListener, Open_im_sdkOnFriendshipListener, Open_im_sdkOnConversationListener, Open_im_sdkOnGroupListener>

- (void)pushEvent:(NSString *) eventName errCode:(NSNumber *) errCode errMsg:(NSString *) errMsg data:(NSString *) data;

@end
  

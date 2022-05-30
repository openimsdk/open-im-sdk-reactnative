@import OpenIMCore;
#import "CallbackProxy.h"

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#endif

@interface OpenIMSDKRN : RCTEventEmitter <RCTBridgeModule,Open_im_sdk_callbackOnConnListener,Open_im_sdk_callbackOnUserListener, Open_im_sdk_callbackOnAdvancedMsgListener, Open_im_sdk_callbackOnFriendshipListener, Open_im_sdk_callbackOnConversationListener, Open_im_sdk_callbackOnGroupListener,Open_im_sdk_callbackOnSignalingListener>

- (void)pushEvent:(NSString *) eventName errCode:(NSNumber *) errCode errMsg:(NSString *) errMsg data:(NSString *) data;

@end
  

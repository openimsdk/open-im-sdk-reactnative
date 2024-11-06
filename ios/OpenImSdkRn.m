#import "OpenImSdkRn.h"
#import "SendMessageCallbackProxy.h"
#import "UploadFileCallbackProxy.h"
#import "UploadLogCallbackProxy.h"

@implementation NSDictionary (Extensions)

- (NSString *)json {
    NSString *json = nil;

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return (error ? nil : json);
}

@end

@implementation NSArray (Extensions)

- (NSString *)json {
    NSString *json = nil;

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return (error ? nil : json);
}

@end

@implementation NSString (Extensions)

- (NSString *)json {
    return [NSString stringWithFormat:@"\"%@\"",self];
}

@end


@implementation OpenIMSDKRN

bool hasListeners;

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents
{
  return @[
  @"onConnectSuccess",
  @"onConnecting",
  @"onConnectFailed",
  @"onKickedOffline",
  @"onSelfInfoUpdated",
  @"onUserStatusChanged",
  @"onUserTokenExpired",
  @"onUserTokenInvalid",
  @"onRecvNewMessages",
  @"onRecvOfflineNewMessages",
  @"onMsgDeleted" ,
  @"onRecvC2CReadReceipt",
  @"onNewRecvMessageRevoked",
  @"onRecvMessageRevoked",
  @"onRecvNewMessage",
  @"onRecvOfflineNewMessage",
  @"onRecvOnlineOnlyMessage",
  @"onRecvMessageExtensionsAdded",
  @"onRecvMessageExtensionsChanged",
  @"onRecvMessageExtensionsDeleted",
  
  @"onConversationChanged",
  @"onConversationUserInputStatusChanged",
  @"onNewConversation",
  @"onSyncServerFailed",
  @"onSyncServerFinish",
  @"onSyncServerStart",
  @"onSyncServerProgress",
  @"onTotalUnreadMessageCountChanged",
  
  @"onBlackAdded",
  @"onBlackDeleted",
  @"onFriendApplicationAccepted",
  @"onFriendApplicationAdded",
  @"onFriendApplicationDeleted",
  @"onFriendApplicationRejected",
  @"onFriendInfoChanged",
  @"onFriendAdded",
  @"onFriendDeleted",

  @"onGroupApplicationAccepted",
  @"onGroupApplicationRejected",
  @"onGroupApplicationAdded",
  @"onGroupApplicationDeleted",
  @"onGroupInfoChanged",
  @"onGroupMemberInfoChanged",
  @"onGroupMemberAdded",
  @"onGroupMemberDeleted",
  @"onJoinedGroupAdded",
  @"onJoinedGroupDeleted",
  @"onGroupDismissed",
  @"SendMessageProgress",
  @"uploadComplete",
  @"onReceiveNewMessages",
  @"onReceiveOfflineNewMessages",
  @"onRecvCustomBusinessMessage",
  @"uploadOnProgress"
  ];
}

-(void)startObserving {
    hasListeners = YES;
}

-(void)stopObserving {
    hasListeners = NO;
}

- (void)pushEvent:(NSString *)eventName data:(id)data {
    [self sendEventWithName:eventName body:data];
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

- (NSArray *)parseJsonStr2Array:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Error while parsing JSON: %@", error.localizedDescription);
        return nil;
    }
    NSArray *data = (NSArray *)jsonObject;
    return data;
}

RCT_EXPORT_METHOD(initSDK:(NSDictionary *)config operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  
    NSMutableDictionary *newConfig = [config mutableCopy];
    [newConfig setObject:@1 forKey:@"platformID"];
  
    BOOL flag = Open_im_sdkInitSDK(self,operationID,[newConfig json]);
    Open_im_sdkSetUserListener(self);
    Open_im_sdkSetConversationListener(self);
    Open_im_sdkSetFriendListener(self);
    Open_im_sdkSetGroupListener(self);
    Open_im_sdkSetAdvancedMsgListener(self);
    if (flag) {
        resolve(@"init success");
    }else{
        reject(@"-1",@"please check params and dir",nil);
    }
}

RCT_EXPORT_METHOD(setUserListener) {
    Open_im_sdkSetUserListener(self);
}

RCT_EXPORT_METHOD(login:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkLogin(proxy, operationID, [options valueForKey:@"userID"], [options valueForKey:@"token"]);
}

RCT_EXPORT_METHOD(logout:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkLogout(proxy,operationID);
}

RCT_EXPORT_METHOD(setAppBackgroundStatus:(BOOL)isBackground operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetAppBackgroundStatus(proxy, operationID, isBackground);
}

RCT_EXPORT_METHOD(networkStatusChange:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkNetworkStatusChanged(proxy, operationID);
}

RCT_EXPORT_METHOD(getLoginStatus:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    long status = Open_im_sdkGetLoginStatus(operationID);
    resolver(@(status));
}

RCT_EXPORT_METHOD(getLoginUserID:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString* uid = Open_im_sdkGetLoginUserID();
    resolver(uid);
}

RCT_EXPORT_METHOD(getUsersInfo:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetUsersInfo(proxy,operationID,[uidList json]);
}

RCT_EXPORT_METHOD(setSelfInfo:(NSDictionary *)info operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetSelfInfo(proxy,operationID,[info json]);
}

RCT_EXPORT_METHOD(getSelfUserInfo:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetSelfUserInfo(proxy, operationID);
}

RCT_EXPORT_METHOD(getUserStatus:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetUserStatus(proxy, operationID,[uidList json]);
}

RCT_EXPORT_METHOD(subscribeUsersStatus:(NSArray *)userIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSubscribeUsersStatus(proxy, operationID, [userIDList json]);
}

RCT_EXPORT_METHOD(unsubscribeUsersStatus:(NSArray *)userIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkUnsubscribeUsersStatus(proxy, operationID, [userIDList json]);
}

RCT_EXPORT_METHOD(getSubscribeUsersStatus:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetSubscribeUsersStatus(proxy, operationID);
}

RCT_EXPORT_METHOD(setConversationListener) {
    Open_im_sdkSetConversationListener(self);
}

RCT_EXPORT_METHOD(getAllConversationList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetAllConversationList(proxy,operationID);
}

RCT_EXPORT_METHOD(getConversationListSplit:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetConversationListSplit(proxy,operationID,[[options valueForKey:@"offset"] longValue], [[options valueForKey:@"count"] longValue]);
}

RCT_EXPORT_METHOD(getOneConversation:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetOneConversation(proxy,operationID, [[options valueForKey:@"sessionType"] intValue], [options valueForKey:@"sourceID"]);
}

RCT_EXPORT_METHOD(getMultipleConversation:(NSArray *)conversationIDList operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetMultipleConversation(proxy, operationID,  [conversationIDList json]);
}

RCT_EXPORT_METHOD(setGlobalRecvMessageOpt:(NSInteger)opt operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
  
    NSDictionary *param = @{
      @"globalRecvMsgOpt":@(opt),
    };
  
    Open_im_sdkSetSelfInfo(proxy, operationID, [param json]);
}

RCT_EXPORT_METHOD(hideAllConversations:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkHideAllConversations(proxy, operationID);
}

RCT_EXPORT_METHOD(hideConversation:(NSString *)conversationID operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkHideConversation(proxy, operationID, conversationID);
}

RCT_EXPORT_METHOD(setConversation:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
  
    NSString *conversationID = [options valueForKey:@"conversationID"];
  
    Open_im_sdkSetConversation(proxy,operationID, conversationID, [options json]);
}

RCT_EXPORT_METHOD(setConversationDraft:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
  
  
    NSString *conversationID = [options valueForKey:@"conversationID"];
    NSString *draftText = [options valueForKey:@"draftText"];

    Open_im_sdkSetConversationDraft(proxy,operationID, conversationID, draftText);
}

RCT_EXPORT_METHOD(resetConversationGroupAtType:(NSString *)conversationID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
  
    NSDictionary *param = @{
      @"groupAtType":@(0),
    };
    Open_im_sdkSetConversation(proxy, operationID, conversationID, [param json]);
}

RCT_EXPORT_METHOD(pinConversation:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
  
    NSDictionary *param = @{
      @"isPinned":options[@"isPinned"],
    };
  
    Open_im_sdkSetConversation(proxy,operationID, [options valueForKey:@"conversationID"], [param json]);
}

RCT_EXPORT_METHOD(setConversationPrivateChat:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
  
    NSDictionary *param = @{
      @"isPrivateChat":options[@"isPrivate"],
    };
  Open_im_sdkSetConversation(proxy,operationID, [options valueForKey:@"conversationID"], [param json] );
}

RCT_EXPORT_METHOD(setConversationBurnDuration:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
  
    NSDictionary *param = @{
      @"burnDuration":options[@"burnDuration"],
    };
  Open_im_sdkSetConversation(proxy,operationID,[options valueForKey:@"conversationID"], [param json]);
}

RCT_EXPORT_METHOD(setConversationRecvMessageOpt:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
  
    NSDictionary *param = @{
      @"recvMsgOpt":options[@"opt"],
    };
    Open_im_sdkSetConversation(proxy, operationID , [options valueForKey:@"conversationID"], [param json]);
}

RCT_EXPORT_METHOD(getTotalUnreadMsgCount:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetTotalUnreadMsgCount(proxy, operationID);
}

RCT_EXPORT_METHOD(getAtAllTag:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *atAllTag = Open_im_sdkGetAtAllTag(operationID);
    resolver(atAllTag);
}

RCT_EXPORT_METHOD(createAdvancedTextMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSArray *messageEntityList = options[@"messageEntityList"];
    NSString *text = options[@"text"];
    
    NSString *result = Open_im_sdkCreateAdvancedTextMessage(operationID, text, [messageEntityList json]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createTextAtMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *messageJson = @"";
    NSDictionary *message = options[@"message"];
    if (message != nil) {
        messageJson = [message json];
    }

    NSString *text = options[@"text"];
    NSArray *atUsersInfo = options[@"atUsersInfo"];

    NSArray *atUserIDList = options[@"atUserIDList"];
    if (!atUserIDList) {
        atUserIDList = [NSArray array];
    }
    
    NSString *result = Open_im_sdkCreateTextAtMessage(operationID, text, [atUserIDList json], [atUsersInfo json], messageJson);
    NSDictionary *messageObj = [self parseJsonStr2Dict:result];
    if (messageObj) {
        resolver(messageObj);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createTextMessage:(NSString *)textMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateTextMessage(operationID,textMsg);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createLocationMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *description = options[@"description"];
    double longitude = [options[@"longitude"] doubleValue];
    double latitude = [options[@"latitude"] doubleValue];

    NSString *result = Open_im_sdkCreateLocationMessage(operationID, description, longitude, latitude);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createCustomMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateCustomMessage(operationID, options[@"data"], options[@"extension"] ,options[@"description"]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createQuoteMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateQuoteMessage(operationID,options[@"text"],options[@"message"]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createAdvancedQuoteMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateAdvancedQuoteMessage(operationID,options[@"text"] ,options[@"message"],options[@"messageEntityList"]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createCardMessage:(NSDictionary *)cardElem operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateCardMessage(operationID, [cardElem json]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createImageMessage:(NSString *)imagePath operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateImageMessage(operationID,imagePath);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createImageMessageFromFullPath:(NSString *)imagePath operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateImageMessageFromFullPath(operationID,imagePath);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createImageMessageByURL:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSDictionary *sourcePicture = options[@"sourcePicture"];
    NSDictionary *bigPicture = options[@"bigPicture"];
    NSDictionary *snapshotPicture = options[@"snapshotPicture"];
    NSString *sourcePath = options[@"sourcePath"]; 
    
    NSString *result = Open_im_sdkCreateImageMessageByURL(operationID, sourcePath, [sourcePicture json], [bigPicture json], [snapshotPicture json]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createSoundMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateSoundMessage(operationID,options[@"soundPath"],[options[@"duration"] integerValue]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createSoundMessageFromFullPath:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *soundPath = options[@"soundPath"];
    NSInteger duration = [options[@"duration"] integerValue];
        
    NSString *result = Open_im_sdkCreateSoundMessageFromFullPath(operationID, soundPath, (long)duration);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createSoundMessageByURL:(NSDictionary *)soundInfo operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateSoundMessageByURL(operationID, [soundInfo json]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createVideoMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *videoPath = options[@"videoPath"];
    NSString *videoType = options[@"videoType"];
    NSString *snapshotPath = options[@"snapshotPath"];
    NSInteger duration = [options[@"duration"] integerValue];    
     
    NSString *result = Open_im_sdkCreateVideoMessage(operationID, videoPath, videoType, (long)duration, snapshotPath);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createVideoMessageFromFullPath:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *videoPath = options[@"videoPath"];
    NSString *videoType = options[@"videoType"];
    NSString *snapshotPath = options[@"snapshotPath"];
    NSInteger duration = [options[@"duration"] integerValue];

    NSString *result = Open_im_sdkCreateVideoMessageFromFullPath(operationID, videoPath, videoType, (long)duration, snapshotPath);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createVideoMessageByURL:(NSDictionary *)videoInfo operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateVideoMessageByURL(operationID, [videoInfo json]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createFileMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *filePath = options[@"filePath"];
    NSString *fileName = options[@"fileName"];
    
    NSString *result = Open_im_sdkCreateFileMessage(operationID, filePath, fileName);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createFileMessageFromFullPath:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *filePath = options[@"filePath"];
    NSString *fileName = options[@"fileName"];
    
    NSString *result = Open_im_sdkCreateFileMessageFromFullPath(operationID, filePath, fileName);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createFileMessageByURL:(NSDictionary *)fileInfo operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateFileMessageByURL(operationID, [fileInfo json]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createMergerMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSDictionary *messageList = options[@"messageList"];
    NSDictionary *summaryList = options[@"summaryList"];
    NSString *title = options[@"title"];

    NSString *result = Open_im_sdkCreateMergerMessage(operationID, [messageList json], title, [summaryList json]);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createFaceMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSInteger index = [options[@"index"] integerValue];
    NSString *dataStr = options[@"dataStr"];
    
    NSString *result = Open_im_sdkCreateFaceMessage(operationID, (long)index, dataStr);
    NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(createForwardMessage:(NSDictionary *)message operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *result = Open_im_sdkCreateForwardMessage(operationID, [message json]);
    NSDictionary *messageObj = [self parseJsonStr2Dict:result];
    if (messageObj) {
        resolver(messageObj);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(getConversationIDBySessionType:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
   NSString *sourceID = options[@"sourceID"];
   NSInteger sessionType = [options[@"sessionType"] integerValue];

   NSString *result = Open_im_sdkGetConversationIDBySessionType(operationID, sourceID, (long)sessionType);
   NSDictionary *message = [self parseJsonStr2Dict:result];
    if (message) {
        resolver(message);
    } else {
        resolver(result);
    }
}

RCT_EXPORT_METHOD(sendMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSDictionary *message = options[@"message"];
    NSString *recvID = options[@"recvID"];
    NSString *groupID = options[@"groupID"];
    NSDictionary *offlinePushInfo = options[@"offlinePushInfo"];

    BOOL isOnlineOnly = [options[@"isOnlineOnly"] boolValue];
    if(!isOnlineOnly) {
        isOnlineOnly = NO;
    }

    if (!offlinePushInfo) {
        offlinePushInfo = @{
            @"title": @"you have a new message",
            @"desc": @"new message",
            @"ex": @"",
            @"iOSPushSound": @"+1",
            @"iOSBadgeCount": @YES
        };
    }

    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:[message json] module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessage(proxy, operationID, [message json], recvID, groupID, [offlinePushInfo json], isOnlineOnly);
}

RCT_EXPORT_METHOD(sendMessageNotOss:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSDictionary *message = options[@"message"];
    NSString *recvID = options[@"recvID"];
    NSString *groupID = options[@"groupID"];
    NSDictionary *offlinePushInfo = options[@"offlinePushInfo"];
    
    BOOL isOnlineOnly = [options[@"isOnlineOnly"] boolValue];
    if(!isOnlineOnly) {
        isOnlineOnly = NO;
    }

    if (!offlinePushInfo) {
        offlinePushInfo = @{
            @"title": @"you have a new message",
            @"desc": @"new message",
            @"ex": @"",
            @"iOSPushSound": @"+1",
            @"iOSBadgeCount": @YES
        };
    }

    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:[message json] module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessageNotOss(proxy, operationID, [message json], recvID, groupID, [offlinePushInfo json], isOnlineOnly);
}

RCT_EXPORT_METHOD(findMessageList:(NSDictionary *)findOptions operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *findOptionsJson = [findOptions json];
    
    Open_im_sdkFindMessageList(proxy, operationID, findOptionsJson);
}

RCT_EXPORT_METHOD(getAdvancedHistoryMessageList:(NSDictionary *)findOptions operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *findOptionsJson = [findOptions json];

    Open_im_sdkGetAdvancedHistoryMessageList(proxy, operationID, findOptionsJson);
}

RCT_EXPORT_METHOD(getAdvancedHistoryMessageListReverse:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [options json];

    Open_im_sdkGetAdvancedHistoryMessageListReverse(proxy, operationID, optionsJson);
}

RCT_EXPORT_METHOD(revokeMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"];
    NSString *clientMsgID = options[@"clientMsgID"];

    Open_im_sdkRevokeMessage(proxy, operationID, conversationID, clientMsgID);
}

RCT_EXPORT_METHOD(searchConversation:(NSString *)searchParams operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolve rejecter:reject];

    Open_im_sdkSearchConversation(proxy, operationID, searchParams);
}

RCT_EXPORT_METHOD(typingStatusUpdate:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *recvID = options[@"recvID"];
    NSString *msgTip = options[@"msgTip"];

    Open_im_sdkTypingStatusUpdate(proxy, operationID, recvID, msgTip);
}

RCT_EXPORT_METHOD(changeInputStates:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];

    Open_im_sdkChangeInputStates(proxy, operationID, [options valueForKey:@"conversationID"], [[options valueForKey:@"focus"] boolValue]);
}

RCT_EXPORT_METHOD(getInputStates:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];

    Open_im_sdkGetInputStates(proxy, operationID, [options valueForKey:@"conversationID"], [options valueForKey:@"userID"]);
}

RCT_EXPORT_METHOD(markConversationMessageAsRead:(NSString *)conversationID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkMarkConversationMessageAsRead(proxy,operationID, conversationID);
}

RCT_EXPORT_METHOD(markMessagesAsReadByMsgID:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"];
    NSArray *clientMsgIDList = options[@"clientMsgIDList"];

    Open_im_sdkMarkMessagesAsReadByMsgID(proxy,operationID, conversationID, [clientMsgIDList json]);
}

RCT_EXPORT_METHOD(deleteMessageFromLocalStorage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"]; 
    NSString *clientMsgID = options[@"clientMsgID"];

    Open_im_sdkDeleteMessageFromLocalStorage(proxy, operationID, conversationID, clientMsgID);
}

RCT_EXPORT_METHOD(deleteMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"];
    NSString *clientMsgID = options[@"clientMsgID"];

    Open_im_sdkDeleteMessage(proxy, operationID, conversationID, clientMsgID);
}

RCT_EXPORT_METHOD(deleteAllMsgFromLocalAndSvr:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteAllMsgFromLocalAndSvr(proxy, operationID);
}

RCT_EXPORT_METHOD(deleteAllMsgFromLocal:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteAllMsgFromLocal(proxy, operationID);
}

RCT_EXPORT_METHOD(clearConversationAndDeleteAllMsg:(NSString *)conversationID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkClearConversationAndDeleteAllMsg(proxy, operationID, conversationID);
}

RCT_EXPORT_METHOD(deleteConversationAndDeleteAllMsg:(NSString *)conversationID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteConversationAndDeleteAllMsg(proxy, operationID, conversationID);
}

RCT_EXPORT_METHOD(insertSingleMessageToLocalStorage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSDictionary *message = options[@"message"];
    NSString *recvID = options[@"recvID"];
    NSString *sendID = options[@"sendID"];

    Open_im_sdkInsertSingleMessageToLocalStorage(proxy, operationID, [message json], recvID, sendID);
}

RCT_EXPORT_METHOD(insertGroupMessageToLocalStorage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSDictionary *message = options[@"message"];
    NSString *recvID = options[@"recvID"];
    NSString *sendID = options[@"sendID"];

    Open_im_sdkInsertGroupMessageToLocalStorage(proxy, operationID, [message json], recvID, sendID);
}

RCT_EXPORT_METHOD(searchLocalMessages:(NSDictionary *)searchParam operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSearchLocalMessages(proxy, operationID, [searchParam json]);
}

RCT_EXPORT_METHOD(setMessageLocalEx:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"];
    NSString *clientMsgID = options[@"clientMsgID"];
    NSString *localEx = options[@"localEx"];

    Open_im_sdkSetMessageLocalEx(proxy, operationID, conversationID, clientMsgID, localEx);
}

RCT_EXPORT_METHOD(getSpecifiedFriendsInfo:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
  
    NSArray *userIDList = [options valueForKey:@"userIDList"];
    Open_im_sdkGetSpecifiedFriendsInfo(proxy, operationID, [userIDList json], [[options valueForKey:@"filterBlack"] boolValue]);
}

RCT_EXPORT_METHOD(getFriendList:(BOOL)filterBlack operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetFriendList(proxy, operationID, filterBlack);
}

RCT_EXPORT_METHOD(getFriendListPage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSInteger offset = [options[@"offset"] integerValue];
    NSInteger count = [options[@"count"] integerValue];
    
    Open_im_sdkGetFriendListPage(proxy, operationID, (int32_t)offset, (int32_t)count, [[options valueForKey:@"filterBlack"] boolValue]);
}

RCT_EXPORT_METHOD(searchFriends:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [options json];
    
    Open_im_sdkSearchFriends(proxy, operationID, optionsJson);
}

RCT_EXPORT_METHOD(checkFriend:(NSArray *)userIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDListString = [userIDList json];

    Open_im_sdkCheckFriend(proxy, operationID, userIDListString);
}

RCT_EXPORT_METHOD(addFriend:(NSDictionary *)paramsReq operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *paramsReqJson = [paramsReq json];

    Open_im_sdkAddFriend(proxy, operationID, paramsReqJson);
}

RCT_EXPORT_METHOD(setFriendRemark:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
  
    NSArray *friendUserIDs = @[options[@"toUserID"]];
    NSDictionary *param = @{
        @"friendUserIDs":friendUserIDs,
        @"remark":options[@"remark"],
    };
    Open_im_sdkUpdateFriends(proxy, operationID, [param json]);
}

RCT_EXPORT_METHOD(deleteFriend:(NSString *)friendUserID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteFriend(proxy, operationID, friendUserID);
}

RCT_EXPORT_METHOD(getFriendApplicationListAsRecipient:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetFriendApplicationListAsRecipient(proxy, operationID);
}

RCT_EXPORT_METHOD(getFriendApplicationListAsApplicant:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetFriendApplicationListAsApplicant(proxy, operationID);
}

RCT_EXPORT_METHOD(acceptFriendApplication:(NSDictionary *)userIDHandleMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDHandleMsgJson = [userIDHandleMsg json];
    
    Open_im_sdkAcceptFriendApplication(proxy, operationID, userIDHandleMsgJson);
}

RCT_EXPORT_METHOD(refuseFriendApplication:(NSDictionary *)userIDHandleMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDHandleMsgJson = [userIDHandleMsg json];

    Open_im_sdkRefuseFriendApplication(proxy, operationID, userIDHandleMsgJson);
}

RCT_EXPORT_METHOD(addBlack:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *toUserID = options[@"toUserID"];
    NSString *ex = options[@"ex"];

    if (!ex) {
        ex = @"";
    }

    Open_im_sdkAddBlack(proxy, operationID, toUserID, ex);
}

RCT_EXPORT_METHOD(getBlackList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetBlackList(proxy, operationID);
}

RCT_EXPORT_METHOD(removeBlack:(NSString *)removeUserID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRemoveBlack(proxy, operationID, removeUserID);
}

RCT_EXPORT_METHOD(setFriendListener) {
    Open_im_sdkSetFriendListener(self);
}

RCT_EXPORT_METHOD(setGroupListener) {
    Open_im_sdkSetGroupListener(self);
}

// Group
RCT_EXPORT_METHOD(createGroup:(NSDictionary *)ginfo operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkCreateGroup(proxy,operationID, [ginfo json]);
}

RCT_EXPORT_METHOD(joinGroup:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];

    NSInteger joinSource = [options[@"joinSource"] integerValue]; 
    NSString *groupID = options[@"groupID"];
    NSString *reqMsg = options[@"reqMsg"];
    NSString *ex = options[@"ex"];

    if (!ex) {
        ex = @"";
    }

    Open_im_sdkJoinGroup(proxy, operationID, groupID, reqMsg, (int32_t)joinSource, ex);
}

RCT_EXPORT_METHOD(quitGroup:(NSString *)gid operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkQuitGroup(proxy, operationID, gid);
}

RCT_EXPORT_METHOD(dismissGroup:(NSString *)groupID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDismissGroup(proxy, operationID, groupID);
}

RCT_EXPORT_METHOD(changeGroupMute:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    BOOL isMute = [options[@"isMute"] boolValue];
    
    Open_im_sdkChangeGroupMute(proxy, operationID, groupID, isMute);
}

RCT_EXPORT_METHOD(setGroupMemberRoleLevel:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];

    Open_im_sdkSetGroupMemberInfo(proxy, operationID, [options json]);
}

RCT_EXPORT_METHOD(setGroupMemberInfo:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];

    Open_im_sdkSetGroupMemberInfo(proxy, operationID, [options json]);
}

RCT_EXPORT_METHOD(getJoinedGroupList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetJoinedGroupList(proxy, operationID);
}

RCT_EXPORT_METHOD(getJoinedGroupListPage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSInteger offset = [options[@"offset"] integerValue];
    NSInteger count = [options[@"count"] integerValue];
    
    Open_im_sdkGetJoinedGroupListPage(proxy, operationID, (int32_t)offset, (int32_t)count);
}

RCT_EXPORT_METHOD(getSpecifiedGroupsInfo:(NSArray *)groupIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupIDListJson = [groupIDList json];

    Open_im_sdkGetSpecifiedGroupsInfo(proxy, operationID, groupIDListJson);
}

RCT_EXPORT_METHOD(searchGroups:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [options json];

    Open_im_sdkSearchGroups(proxy, operationID, optionsJson);
}

RCT_EXPORT_METHOD(setGroupInfo:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];

    Open_im_sdkSetGroupInfo(proxy, operationID, [options json]);
}

RCT_EXPORT_METHOD(setGroupVerification:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSDictionary *param = @{
        @"groupID":options[@"groupID"],
        @"needVerification":options[@"verification"],
    };

    Open_im_sdkSetGroupInfo(proxy, operationID, [param json]);
}

RCT_EXPORT_METHOD(setGroupLookMemberInfo:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSDictionary *param = @{
        @"groupID":options[@"groupID"],
        @"lookMemberInfo":options[@"rule"],
    };

    Open_im_sdkSetGroupInfo(proxy, operationID, [param json]);
}

RCT_EXPORT_METHOD(setGroupApplyMemberFriend:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSDictionary *param = @{
        @"groupID":options[@"groupID"],
        @"applyMemberFriend":options[@"rule"],
    };
    
  Open_im_sdkSetGroupInfo(proxy, operationID, [param json]);
}

RCT_EXPORT_METHOD(getGroupMemberList:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSInteger filter = [options[@"filter"] integerValue];
    NSInteger offset = [options[@"offset"] integerValue];
    NSInteger count = [options[@"count"] integerValue];

    Open_im_sdkGetGroupMemberList(proxy, operationID, groupID, (int32_t)filter, (int32_t)offset, (int32_t)count);
}

RCT_EXPORT_METHOD(getGroupMemberOwnerAndAdmin:(NSString *)groupID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupMemberOwnerAndAdmin(proxy, operationID, groupID);
}

RCT_EXPORT_METHOD(getGroupMemberListByJoinTimeFilter:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSArray *filterUserIDList = options[@"filterUserIDList"];
    NSInteger offset = [options[@"offset"] integerValue]; 
    NSInteger count = [options[@"count"] integerValue]; 
    NSInteger joinTimeBegin = [options[@"joinTimeBegin"] integerValue]; 
    NSInteger joinTimeEnd = [options[@"joinTimeEnd"] integerValue]; 
    
    Open_im_sdkGetGroupMemberListByJoinTimeFilter(proxy, operationID, groupID, (int32_t)offset, (int32_t)count, (long)joinTimeBegin, (long)joinTimeEnd, [filterUserIDList json]);
}

RCT_EXPORT_METHOD(getSpecifiedGroupMembersInfo:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSArray *userIDList = options[@"userIDList"];
    
    Open_im_sdkGetSpecifiedGroupMembersInfo(proxy, operationID, groupID, [userIDList json]);
}

RCT_EXPORT_METHOD(getUsersInGroup:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSArray *userIDList = options[@"userIDList"];
    
    Open_im_sdkGetUsersInGroup(proxy, operationID, groupID, [userIDList json]);
}

RCT_EXPORT_METHOD(kickGroupMember:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *reason = options[@"reason"];
    NSArray *userIDList = options[@"userIDList"];

    Open_im_sdkKickGroupMember(proxy, operationID, groupID, reason, [userIDList json]);
}

RCT_EXPORT_METHOD(transferGroupOwner:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *newOwnerUserID = options[@"newOwnerUserID"];

    Open_im_sdkTransferGroupOwner(proxy, operationID, groupID, newOwnerUserID);
}

RCT_EXPORT_METHOD(inviteUserToGroup:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *reason = options[@"reason"];
    NSArray *userIDList = options[@"userIDList"];

    Open_im_sdkInviteUserToGroup(proxy, operationID, groupID, reason, [userIDList json]);
}

RCT_EXPORT_METHOD(getGroupApplicationListAsRecipient:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupApplicationListAsRecipient(proxy, operationID);
}

RCT_EXPORT_METHOD(getGroupApplicationListAsApplicant:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupApplicationListAsApplicant(proxy, operationID);
}

RCT_EXPORT_METHOD(acceptGroupApplication:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *fromUserID = options[@"fromUserID"];
    NSString *handleMsg = options[@"handleMsg"];
    
    Open_im_sdkAcceptGroupApplication(proxy, operationID, groupID, fromUserID, handleMsg);
}

RCT_EXPORT_METHOD(refuseGroupApplication:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *fromUserID = options[@"fromUserID"];
    NSString *handleMsg = options[@"handleMsg"];

    Open_im_sdkRefuseGroupApplication(proxy, operationID, groupID, fromUserID, handleMsg);
}

RCT_EXPORT_METHOD(setGroupMemberNickname:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSDictionary *param = @{
        @"groupID":options[@"groupID"],
        @"userID":options[@"userID"],
        @"nickname":options[@"groupMemberNickname"],
    };

    Open_im_sdkSetGroupMemberInfo(proxy, operationID, [param json]);
}

RCT_EXPORT_METHOD(searchGroupMembers:(NSDictionary *)searchOptions operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *searchOptionsJson = [searchOptions json];

    Open_im_sdkSearchGroupMembers(proxy, operationID, searchOptionsJson);
}

RCT_EXPORT_METHOD(isJoinGroup:(NSString *)groupID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkIsJoinGroup(proxy, operationID, groupID);
}

RCT_EXPORT_METHOD(addAdvancedMsgListener) {
    Open_im_sdkSetAdvancedMsgListener(self);
}

// Third
RCT_EXPORT_METHOD(unInitSDK:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    Open_im_sdkUnInitSDK(operationID);
}

RCT_EXPORT_METHOD(updateFcmToken:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSArray *userIDList = options[@"userIDList"];
    NSInteger expiredTime = [options[@"expiredTime"] integerValue];

    Open_im_sdkUpdateFcmToken(proxy, operationID, [userIDList json], (long)expiredTime);
}

RCT_EXPORT_METHOD(setAppBadge:(int32_t)appUnreadCount operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetAppBadge(proxy, operationID, appUnreadCount);
}

RCT_EXPORT_METHOD(uploadLogs:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    RNUploadLogCallbackProxy * uploadProxy = [[RNUploadLogCallbackProxy alloc] initWithOpid:operationID module:self resolver:resolver rejecter:rejecter];
    
    NSString *ex = options[@"ex"];

    if (!ex) {
        ex = @"";
    }
    
    Open_im_sdkUploadLogs(proxy,operationID,[[options valueForKey:@"line"] longValue],ex,uploadProxy);
}

RCT_EXPORT_METHOD(logs:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];

    Open_im_sdkLogs(proxy, operationID, [[options valueForKey:@"logLevel"] longValue],[options valueForKey:@"file"],[[options valueForKey:@"line"] longValue],[options valueForKey:@"msgs"],[options valueForKey:@"err"],[options valueForKey:@"keyAndValue"]);
}

RCT_EXPORT_METHOD(getSdkVersion:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *version = Open_im_sdkGetSdkVersion();
    resolver(version);
}

RCT_EXPORT_METHOD(uploadFile:(NSDictionary *)reqData operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    RNUploadFileCallbackProxy * uploadProxy = [[RNUploadFileCallbackProxy alloc] initWithOpid:operationID module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkUploadFile(proxy,operationID, [reqData json],uploadProxy);
}

// -------------------- Open_im_sdkIMSDKListener --------------------

- (void)onConnectSuccess {
    [self pushEvent:@"onConnectSuccess" data:nil];
}

- (void)onConnecting {
    [self pushEvent:@"onConnecting" data:nil];
}

- (void)onKickedOffline {
    [self pushEvent:@"onKickedOffline" data:nil];
}

- (void)onUserTokenExpired {
    [self pushEvent:@"onUserTokenExpired" data:nil];
}

- (void)onUserTokenInvalid:(NSString* _Nullable)errMsg {
    [self pushEvent:@"onUserTokenInvalid" data:nil];
}

- (void)onConnectFailed:(int32_t)errCode errMsg:(NSString * _Nullable)errMsg {
    NSDictionary *data = @{
        @"errCode": @(errCode),
        @"errMsg": (errMsg ? errMsg : @"")
    };

    [self pushEvent:@"onConnectFailed" data:data];
}

 // -------------------- Open_im_sdkUserListener --------------------

- (void)onSelfInfoUpdated:(NSString* _Nullable)userInfo {
    NSDictionary *data = [self parseJsonStr2Dict:userInfo];
    [self pushEvent:@"onSelfInfoUpdated" data:data];
}

- (void)onUserStatusChanged:(NSString * _Nullable)statusMap {
    NSDictionary *data = [self parseJsonStr2Dict:statusMap];
    [self pushEvent:@"onUserStatusChanged" data:data];
}

- (void)onUserCommandAdd:(NSString* _Nullable)userCommand {
    [self pushEvent:@"onUserCommandAdd" data:nil];
}

- (void)onUserCommandDelete:(NSString* _Nullable)userCommand {
    [self pushEvent:@"onUserCommandDelete" data:nil];
}

- (void)onUserCommandUpdate:(NSString* _Nullable)userCommand {
    [self pushEvent:@"onUserCommandUpdate" data:nil];
}

// -------------------- Open_im_sdk_callbackOnBatchMsgListener --------------------

- (void)onRecvNewMessages:(NSString * _Nullable)messageList {
    NSArray *messageListArray = [self parseJsonStr2Array:messageList];
    [self pushEvent:@"onRecvNewMessages" data:messageListArray];
}
- (void)onRecvOfflineNewMessages:(NSString* _Nullable)messageList {
    NSArray *messageListArray = [self parseJsonStr2Array:messageList];
    [self pushEvent:@"onRecvOfflineNewMessages" data:messageListArray];
}

// -------------------- Open_im_sdkIMSDKAdvancedMsgListener --------------------

- (void)onMsgDeleted:(NSString* _Nullable)message {
    NSDictionary *messageDict = [self parseJsonStr2Dict:message];
    [self pushEvent:@"onMsgDeleted" data:messageDict];
}

- (void)onNewRecvMessageRevoked:(NSString *)messageRevoked {
    NSDictionary *messageRevokedDict = [self parseJsonStr2Dict:messageRevoked];
    [self pushEvent:@"onNewRecvMessageRevoked" data:messageRevokedDict];
}

- (void)onRecvC2CReadReceipt:(NSString* _Nullable)msgReceiptList {
    NSArray *msgReceiptListArray = [self parseJsonStr2Array:msgReceiptList];
    [self pushEvent:@"onRecvC2CReadReceipt" data:msgReceiptListArray];
}

 - (void)onRecvMessageRevoked:(NSString* _Nullable)msgId {
    [self pushEvent:@"onRecvMessageRevoked" data:msgId];
}

 - (void)onRecvNewMessage:(NSString* _Nullable)message {
    NSDictionary *messageDict = [self parseJsonStr2Dict:message];
    [self pushEvent:@"onRecvNewMessage" data:messageDict];
}

- (void)onRecvOfflineNewMessage:(NSString * _Nullable)message {
    NSArray *messageListArray = [self parseJsonStr2Array:message];
    [self pushEvent:@"onRecvOfflineNewMessage" data:messageListArray];
}

- (void)onRecvOnlineOnlyMessage:(NSString * _Nullable)message {
    NSArray *messageListArray = [self parseJsonStr2Array:message];
    [self pushEvent:@"onRecvOnlineOnlyMessage" data:messageListArray];
}

// -------------------- Open_im_sdkOnFriendshipListener --------------------

- (void)onBlackAdded:(NSString * _Nullable)blackInfo {
    NSDictionary *blackInfoDict = [self parseJsonStr2Dict:blackInfo];
    [self pushEvent:@"onBlackAdded" data:blackInfoDict];
}

- (void)onBlackDeleted:(NSString * _Nullable)blackInfo {
    NSDictionary *blackInfoDict = [self parseJsonStr2Dict:blackInfo];
    [self pushEvent:@"onBlackDeleted" data:blackInfoDict];
}

- (void)onFriendAdded:(NSString * _Nullable)friendInfo {
    NSDictionary *friendInfoDict = [self parseJsonStr2Dict:friendInfo];
    [self pushEvent:@"onFriendAdded" data:friendInfoDict];
}

- (void)onFriendApplicationAccepted:(NSString * _Nullable)friendApplication {
    NSDictionary *friendApplicationDict = [self parseJsonStr2Dict:friendApplication];
    [self pushEvent:@"onFriendApplicationAccepted" data:friendApplicationDict];
}

- (void)onFriendApplicationAdded:(NSString * _Nullable)friendApplication {
    NSDictionary *friendApplicationDict = [self parseJsonStr2Dict:friendApplication];
    [self pushEvent:@"onFriendApplicationAdded" data:friendApplicationDict];
}

- (void)onFriendApplicationDeleted:(NSString * _Nullable)friendApplication {
    NSDictionary *friendApplicationDict = [self parseJsonStr2Dict:friendApplication];
    [self pushEvent:@"onFriendApplicationDeleted" data:friendApplicationDict];
}

- (void)onFriendApplicationRejected:(NSString * _Nullable)friendApplication {
    NSDictionary *friendApplicationDict = [self parseJsonStr2Dict:friendApplication];
    [self pushEvent:@"onFriendApplicationRejected" data:friendApplicationDict];
}

- (void)onFriendDeleted:(NSString * _Nullable)friendInfo {
    NSDictionary *friendInfoDict = [self parseJsonStr2Dict:friendInfo];
    [self pushEvent:@"onFriendDeleted" data:friendInfoDict];
}

- (void)onFriendInfoChanged:(NSString * _Nullable)friendInfo {
    NSDictionary *friendInfoDict = [self parseJsonStr2Dict:friendInfo];
    [self pushEvent:@"onFriendInfoChanged" data:friendInfoDict];
}

// -------------------- Open_im_sdkOnConversationListener --------------------

- (void)onConversationChanged:(NSString* _Nullable)conversationList {
    NSArray *conversationListArray = [self parseJsonStr2Array:conversationList];
    [self pushEvent:@"onConversationChanged" data:conversationListArray];
}

- (void)onConversationUserInputStatusChanged:(NSString* _Nullable)datils {
    NSDictionary *datilsDic = [self parseJsonStr2Dict:datils];
    [self pushEvent:@"onInputStatusChanged" data:datilsDic];
}

- (void)onNewConversation:(NSString* _Nullable)conversationList {
    NSArray *conversationListArray = [self parseJsonStr2Array:conversationList];
    [self pushEvent:@"onNewConversation" data:conversationListArray];
}

- (void)onSyncServerFailed:(BOOL)reinstalled {
    [self pushEvent:@"onSyncServerFailed" data:@(reinstalled)];
}

- (void)onSyncServerFinish:(BOOL)reinstalled {
    [self pushEvent:@"onSyncServerFinish" data:@(reinstalled)];
}

- (void)onSyncServerStart:(BOOL)reinstalled {
    [self pushEvent:@"onSyncServerStart" data:@(reinstalled)];
}

- (void)onSyncServerProgress:(long)progress {
    [self pushEvent:@"onSyncServerProgress" data:@(progress)];
}

- (void)onTotalUnreadMessageCountChanged:(int32_t)totalUnreadCount {
    [self pushEvent:@"onTotalUnreadMessageCountChanged" data:@(totalUnreadCount)];
}

// -------------------- Open_im_sdkOnGroupListener --------------------

- (void)onGroupApplicationAccepted:(NSString * _Nullable)groupApplication {
    NSDictionary *groupApplicationDict = [self parseJsonStr2Dict:groupApplication];
    [self pushEvent:@"onGroupApplicationAccepted" data:groupApplicationDict];
}

- (void)onGroupApplicationAdded:(NSString * _Nullable)groupApplication {
    NSDictionary *groupApplicationDict = [self parseJsonStr2Dict:groupApplication];
    [self pushEvent:@"onGroupApplicationAdded" data:groupApplicationDict];
}

- (void)onGroupApplicationDeleted:(NSString * _Nullable)groupApplication {
    NSDictionary *groupApplicationDict = [self parseJsonStr2Dict:groupApplication];
    [self pushEvent:@"onGroupApplicationDeleted" data:groupApplicationDict];
}

- (void)onGroupApplicationRejected:(NSString * _Nullable)groupApplication {
    NSDictionary *groupApplicationDict = [self parseJsonStr2Dict:groupApplication];
    [self pushEvent:@"onGroupApplicationRejected" data:groupApplicationDict];
}

- (void)onGroupInfoChanged:(NSString * _Nullable)groupInfo {
    NSDictionary *groupInfoDict = [self parseJsonStr2Dict:groupInfo];
    [self pushEvent:@"onGroupInfoChanged" data:groupInfoDict];
}

- (void)onGroupMemberAdded:(NSString * _Nullable)groupMemberInfo {
    NSDictionary *groupMemberInfoDict = [self parseJsonStr2Dict:groupMemberInfo];
    [self pushEvent:@"onGroupMemberAdded" data:groupMemberInfoDict];
}

- (void)onGroupMemberDeleted:(NSString * _Nullable)groupMemberInfo {
    NSDictionary *groupMemberInfoDict = [self parseJsonStr2Dict:groupMemberInfo];
    [self pushEvent:@"onGroupMemberDeleted" data:groupMemberInfoDict];
}

- (void)onGroupMemberInfoChanged:(NSString * _Nullable)groupMemberInfo {
    NSDictionary *groupMemberInfoDict = [self parseJsonStr2Dict:groupMemberInfo];
    [self pushEvent:@"onGroupMemberInfoChanged" data:groupMemberInfoDict];
}

- (void)onJoinedGroupAdded:(NSString * _Nullable)groupInfo {
    NSDictionary *groupInfoDict = [self parseJsonStr2Dict:groupInfo];
    [self pushEvent:@"onJoinedGroupAdded" data:groupInfoDict];
}

- (void)onJoinedGroupDeleted:(NSString * _Nullable)groupInfo {
    NSDictionary *groupInfoDict = [self parseJsonStr2Dict:groupInfo];
    [self pushEvent:@"onJoinedGroupDeleted" data:groupInfoDict];
}

- (void)onGroupDismissed:(NSString * _Nullable)groupInfo {
    NSDictionary *groupInfoDict = [self parseJsonStr2Dict:groupInfo];
    [self pushEvent:@"onGroupDismissed" data:groupInfoDict];
}

- (void)onReceiveNewMessages:(NSString* _Nullable)receiveNewMessagesCallback{
    [self pushEvent:@"onReceiveNewMessages" data:receiveNewMessagesCallback];
}

- (void)onReceiveOfflineNewMessages:(NSString* _Nullable)receiveOfflineNewMessages{
    [self pushEvent:@"onReceiveOfflineNewMessages" data:receiveOfflineNewMessages];
}

- (void)onRecvCustomBusinessMessage:(NSString* _Nullable)receiveCustomBusinessMessage{
    [self pushEvent:@"onRecvCustomBusinessMessage" data:receiveCustomBusinessMessage];
}
@end

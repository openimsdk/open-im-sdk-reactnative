#import "OpenImSdkRn.h"
#import "SendMessageCallbackProxy.h"
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

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"onConnectSuccess",@"onConnecting",@"onConnectFailed",@"onKickedOffline",@"onSelfInfoUpdated",@"onUserTokenExpired",
  @"onRecvC2CReadReceipt",@"onRecvMessageRevoked",@"onRecvNewMessage",@"onRecvGroupReadReceipt",@"onConversationChanged",@"onNewConversation",@"onSyncServerFailed",@"onSyncServerFinish",@"onSyncServerStart",@"onTotalUnreadMessageCountChanged",@"onBlackAdded",@"onBlackDeleted",@"onFriendApplicationAccepted",@"onFriendApplicationAdded",@"onFriendApplicationDeleted",@"onFriendApplicationRejected",@"onFriendInfoChanged",@"onFriendAdded",@"onFriendDeleted",@"onGroupApplicationAccepted",@"onGroupApplicationRejected",@"onGroupApplicationAdded",@"onGroupApplicationDeleted",@"onGroupInfoChanged",@"onGroupMemberInfoChanged",@"onGroupMemberAdded",@"onGroupMemberDeleted",@"onJoinedGroupAdded",@"onJoinedGroupDeleted",@"SendMessageProgress",@"onInvitationCancelled",@"onInvitationTimeout",@"onInviteeAccepted",@"onInviteeAcceptedByOtherDevice",@"onInviteeRejected",@"onInviteeRejectedByOtherDevice",@"onReceiveNewInvitation",@"onHangUp"];
}

// 在添加第一个监听函数时触发
-(void)startObserving {
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

- (void)pushEvent:(NSString *) eventName errCode:(NSNumber *) errCode errMsg:(NSString *) errMsg data:(NSString *) data{
    NSDictionary *param = @{
        @"errMsg":errMsg,
        @"errCode": errCode,
        @"data":data
    };
    [self sendEventWithName:eventName body:param];
}
// 创建随机operation ID
- (NSString *)generateRandomOpid
{
    // Generate a unique identifier as operationID
    NSString *uniqueId = [[NSUUID UUID] UUIDString];
    return uniqueId;
}

RCT_EXPORT_METHOD(initSDK:(NSDictionary *)config operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    BOOL flag = Open_im_sdkInitSDK(self,operationID,[config json]);
     Open_im_sdkSetUserListener(self);
     Open_im_sdkSetConversationListener(self);
     Open_im_sdkSetFriendListener(self);
     Open_im_sdkSetGroupListener(self);
     Open_im_sdkSetAdvancedMsgListener(self);
    //  Open_im_sdkSetSignalingListener(self);
    if (flag) {
        resolve(@"init success");
    }else{
        reject(@"-1",@"please check params and dir",nil);
    }
}

RCT_EXPORT_METHOD(setUserListener)
{
    Open_im_sdkSetUserListener(self);
}

RCT_EXPORT_METHOD(login:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];

    NSString *generatedOpid = operationID ?: [self generateRandomOpid]; // Generate random operationID if not provided

    Open_im_sdkLogin(proxy, generatedOpid, [options valueForKey:@"userID"], [options valueForKey:@"token"]);
}

RCT_EXPORT_METHOD(logout:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    Open_im_sdkLogout(proxy,generatedOpid);
}

RCT_EXPORT_METHOD(setAppBackgroundStatus:(BOOL)isBackground operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetAppBackgroundStatus(proxy, generatedOpid, isBackground);
}

RCT_EXPORT_METHOD(networkStatusChange:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkNetworkStatusChanged(proxy, generatedOpid);
}

RCT_EXPORT_METHOD(getLoginStatus:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    long status = Open_im_sdkGetLoginStatus(generatedOpid);
    
    resolver(@(status));
}

RCT_EXPORT_METHOD(getLoginUser:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString* uid = Open_im_sdkGetLoginUserID();
    resolver(uid);
}
//User
RCT_EXPORT_METHOD(getUsersInfo:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetUsersInfo(proxy,generatedOpid,[uidList json]);
}

RCT_EXPORT_METHOD(setSelfInfo:(NSDictionary *)info operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetSelfInfo(proxy,generatedOpid,[info json]);
}

RCT_EXPORT_METHOD(getSelfUserInfo:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetSelfUserInfo(proxy, generatedOpid);
}

//Conversation & Message

RCT_EXPORT_METHOD(setConversationListener)
{
    Open_im_sdkSetConversationListener(self);
}

RCT_EXPORT_METHOD(getAllConversationList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetAllConversationList(proxy,generatedOpid);
}

RCT_EXPORT_METHOD(getConversationListSplit:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetConversationListSplit(proxy,generatedOpid,[[options valueForKey:@"offset"] longValue], [[options valueForKey:@"count"] longValue]);
}

RCT_EXPORT_METHOD(getOneConversation:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetOneConversation(proxy,generatedOpid, [[options valueForKey:@"sessionType"] intValue], [options valueForKey:@"sourceID"]);
}

RCT_EXPORT_METHOD(getMultipleConversation:(NSArray *)conversationIDList operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetMultipleConversation(proxy, generatedOpid,  [conversationIDList json]);
}

RCT_EXPORT_METHOD(setGlobalRecvMessageOpt:(NSInteger)opt operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetGlobalRecvMessageOpt(proxy, generatedOpid, opt);
}

RCT_EXPORT_METHOD(hideConversation:(NSString *)conversationID operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkHideConversation(proxy, generatedOpid, conversationID);
}

RCT_EXPORT_METHOD(getConversationRecvMessageOpt:(NSArray *)conversationIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetConversationRecvMessageOpt(proxy, generatedOpid, [conversationIDList json]);
}
RCT_EXPORT_METHOD(deleteAllConversationFromLocal:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkDeleteAllConversationFromLocal(proxy, generatedOpid);
}

RCT_EXPORT_METHOD(setConversationDraft:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *conversationID = [options valueForKey:@"conversationID"];
    NSString *draftText = [options valueForKey:@"draftText"];
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    if (conversationID == nil || draftText == nil) {
        NSString *errorMessage = @"Missing conversationID or draftText";
        NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: errorMessage};
        NSError *error = [NSError errorWithDomain:@"YourErrorDomain" code:0 userInfo:errorInfo];
        rejecter(@"MISSING_ARGUMENTS", errorMessage, error);
        return;
    }
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    // Assuming `Open_im_sdkSetConversationDraft` is a valid function
    Open_im_sdkSetConversationDraft(proxy,generatedOpid, conversationID, draftText);
    
    resolver(@"Draft set successfully");
}

RCT_EXPORT_METHOD(resetConversationGroupAtType:(NSString *)conversationID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkResetConversationGroupAtType(proxy, generatedOpid, conversationID);
}

RCT_EXPORT_METHOD(pinConversation:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkPinConversation(proxy,generatedOpid, [options valueForKey:@"conversationID"], [[options valueForKey:@"isPinned"] boolValue]);
}

RCT_EXPORT_METHOD(setConversationPrivateChat:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetConversationPrivateChat(proxy,generatedOpid, [options valueForKey:@"conversationID"], [[options valueForKey:@"isPrivate"] boolValue] );
}

RCT_EXPORT_METHOD(setConversationBurnDuration:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetConversationBurnDuration(proxy,generatedOpid,[options valueForKey:@"conversationID"], [[options valueForKey:@"burnDuration"] intValue]);
}

RCT_EXPORT_METHOD(setConversationRecvMessageOpt:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetConversationRecvMessageOpt(proxy, generatedOpid , [options valueForKey:@"conversationID"], [[options valueForKey:@"opt"] longValue]);
}

RCT_EXPORT_METHOD(getTotalUnreadMsgCount:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetTotalUnreadMsgCount(proxy, generatedOpid);
}
RCT_EXPORT_METHOD(getAtAllTag:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *atAllTag = Open_im_sdkGetAtAllTag(generatedOpid);
    resolver(atAllTag);
}

RCT_EXPORT_METHOD(createAdvancedTextMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSArray *messageEntityList = options[@"messageEntityList"];
    NSString *messageEntityListJson = [messageEntityList json];
    NSString *text = options[@"text"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateAdvancedTextMessage(generatedOpid, text, messageEntityListJson);
    resolver(result);
}


RCT_EXPORT_METHOD(createTextAtMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *messageJson = @"";
    NSDictionary *message = options[@"message"];
    if (message != nil) {
        messageJson = [self dictionaryToJson:message];
    }
    NSString *text = options[@"text"];
    NSArray *atUserIDList = options[@"atUserIDList"];
    NSString *atUserIDListStr = [atUserIDList componentsJoinedByString:@","];
    NSArray *atUsersInfo = options[@"atUsersInfo"];
    NSString *atUsersInfoStr = [atUsersInfo componentsJoinedByString:@","];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateTextAtMessage(generatedOpid, text, atUserIDListStr, atUsersInfoStr, messageJson);
    resolver(result);
}

- (NSString *)dictionaryToJson:(NSDictionary *)dictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
RCT_EXPORT_METHOD(createTextMessage:(NSString *)textMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateTextMessage(generatedOpid,textMsg);
    resolver(result);
}

RCT_EXPORT_METHOD(createLocationMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateLocationMessage(generatedOpid,options[@"description"], [options[@"longitude"] doubleValue],[options[@"latitude"] doubleValue]);
    resolver(result);
}

RCT_EXPORT_METHOD(createCustomMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateCustomMessage(generatedOpid,options[@"data"], options[@"extension"] ,options[@"description"]);
    resolver(result);
}

RCT_EXPORT_METHOD(createQuoteMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateQuoteMessage(generatedOpid,options[@"text"],options[@"message"]);
    resolver(result);
}

RCT_EXPORT_METHOD(createAdvancedQuoteMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateAdvancedQuoteMessage(generatedOpid,options[@"text"] ,options[@"message"],options[@"messageEntityList"]);
    resolver(result);
}
RCT_EXPORT_METHOD(createCardMessage:(NSDictionary *)cardElem operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateCardMessage(generatedOpid,[self dictionaryToJson:cardElem]);
    resolver(result);
}

RCT_EXPORT_METHOD(createImageMessage:(NSString *)imagePath operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    NSString *result = Open_im_sdkCreateImageMessage(generatedOpid,imagePath);
    resolver(result);
}

RCT_EXPORT_METHOD(createImageMessageFromFullPath:(NSString *)imagePath operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateImageMessageFromFullPath(generatedOpid,imagePath);
    resolver(result);
}

RCT_EXPORT_METHOD(createImageMessageByURL:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *jsonStr1 = [self dictionaryToJson:options[@"sourcePicture"]];
    NSString *jsonStr2 = [self dictionaryToJson:options[@"bigPicture"]];
    NSString *jsonStr3 = [self dictionaryToJson:options[@"snapshotPicture"]];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateImageMessageByURL(generatedOpid,jsonStr1,jsonStr2,jsonStr3);
    resolver(result);
}

RCT_EXPORT_METHOD(createSoundMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateSoundMessage(generatedOpid,options[@"soundPath"],[options[@"duration"] integerValue]);
    resolver(result);
}
RCT_EXPORT_METHOD(createSoundMessageFromFullPath:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *soundPath = [options objectForKey:@"soundPath"];
    NSInteger duration = [[options objectForKey:@"duration"] integerValue];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateSoundMessageFromFullPath(generatedOpid, soundPath, (long)duration);
    resolver(result);
}

RCT_EXPORT_METHOD(createSoundMessageByURL:(NSDictionary *)soundInfo operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateSoundMessageByURL(generatedOpid, [soundInfo json]);
    resolver(result);
}

RCT_EXPORT_METHOD(createVideoMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *videoPath = [options objectForKey:@"videoPath"];
    NSString *videoType = [options objectForKey:@"videoType"];
    NSInteger duration = [[options objectForKey:@"duration"] integerValue];
    NSString *snapshotPath = [options objectForKey:@"snapshotPath"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateVideoMessage(generatedOpid, videoPath, videoType, (long)duration, snapshotPath);
    resolver(result);
}

RCT_EXPORT_METHOD(createVideoMessageFromFullPath:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *videoPath = [options objectForKey:@"videoPath"];
    NSString *videoType = [options objectForKey:@"videoType"];
    NSInteger duration = [[options objectForKey:@"duration"] integerValue];
    NSString *snapshotPath = [options objectForKey:@"snapshotPath"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateVideoMessageFromFullPath(generatedOpid, videoPath, videoType, (long)duration, snapshotPath);
    resolver(result);
}

RCT_EXPORT_METHOD(createVideoMessageByURL:(NSDictionary *)videoInfo operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateVideoMessageByURL(operationID, [videoInfo json]);
    resolver(result);
}

RCT_EXPORT_METHOD(createFileMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *filePath = [options objectForKey:@"filePath"];
    NSString *fileName = [options objectForKey:@"fileName"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateFileMessage(generatedOpid, filePath, fileName);
    resolver(result);
}
RCT_EXPORT_METHOD(createFileMessageFromFullPath:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *filePath = options[@"filePath"];
    NSString *fileName = options[@"fileName"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateFileMessageFromFullPath(generatedOpid, filePath, fileName);
    resolver(result);
}

RCT_EXPORT_METHOD(createFileMessageByURL:(NSDictionary *)fileInfo operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateFileMessageByURL(generatedOpid, [fileInfo json]);
    resolver(result);
}

RCT_EXPORT_METHOD(createMergerMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *messageList = [options[@"messageList"] description];
    NSString *title = options[@"title"];
    NSString *summaryList = [options[@"summaryList"] description];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateMergerMessage(generatedOpid, messageList, title, summaryList);
    resolver(result);
}

RCT_EXPORT_METHOD(createFaceMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSNumber *index = options[@"index"];
    NSString *dataStr = options[@"dataStr"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkCreateFaceMessage(generatedOpid, [index intValue], dataStr);
    resolver(result);
}

RCT_EXPORT_METHOD(createForwardMessage:(NSDictionary *)message operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = Open_im_sdkCreateForwardMessage(operationID, [self readableMapToString:message]);
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    resolver(result);
}

- (NSString *)readableMapToString:(NSDictionary *)map
{
    // Convert NSDictionary to JSON string
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:map options:0 error:&error];
    if (!jsonData) {
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
RCT_EXPORT_METHOD(getConversationIDBySessionType:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *sourceID = options[@"sourceID"];
    NSNumber *sessionType = options[@"sessionType"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    NSString *result = Open_im_sdkGetConversationIDBySessionType(generatedOpid, sourceID, sessionType.intValue);
    resolver(result);
}

RCT_EXPORT_METHOD(findMessageList:(NSDictionary *)findOptions operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *findOptionsJson = [self dictionaryToJson:findOptions];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkFindMessageList(proxy, operationID, findOptionsJson);
}

RCT_EXPORT_METHOD(getAdvancedHistoryMessageList:(NSDictionary *)findOptions operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *findOptionsJson = [self dictionaryToJson:findOptions];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetAdvancedHistoryMessageList(proxy, generatedOpid, findOptionsJson);
}

RCT_EXPORT_METHOD(getAdvancedHistoryMessageListReverse:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [self dictionaryToJson:options];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetAdvancedHistoryMessageListReverse(proxy, generatedOpid, optionsJson);
}

RCT_EXPORT_METHOD(revokeMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"];
    NSString *clientMsgID = options[@"clientMsgID"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkRevokeMessage(proxy, generatedOpid, conversationID, clientMsgID);
}

RCT_EXPORT_METHOD(typingStatusUpdate:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *recvID = options[@"recvID"];
    NSString *msgTip = options[@"msgTip"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkTypingStatusUpdate(proxy, generatedOpid, recvID, msgTip);
}

// RCT_EXPORT_METHOD(markGroupMessageHasRead:(NSString *)gid operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkMarkGroupMessageHasRead(proxy,operationID, gid);
// }

// RCT_EXPORT_METHOD(getTotalUnreadMsgCount:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetTotalUnreadMsgCount(proxy,operationID);
// }

// RCT_EXPORT_METHOD(pinConversation:(NSString *)cveid isPin:(BOOL)isPin operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkPinConversation(proxy,operationID,cveid, isPin);
// }

// RCT_EXPORT_METHOD(setConversationDraft:(NSString *)cveid draft:(NSString *)draft operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkSetConversationDraft(proxy,operationID,cveid, draft);
// }

// RCT_EXPORT_METHOD(deleteConversation:(NSString *)cveid operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkDeleteConversation(proxy,operationID,cveid);
// }

// RCT_EXPORT_METHOD(getMultipleConversation:(NSArray *)cveids operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetMultipleConversation(proxy,operationID,[cveids json]);
// }

// RCT_EXPORT_METHOD(getOneConversation:(NSString *)sourceId sessionType:(nonnull NSNumber *)sessionType operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetOneConversation(proxy,operationID, [sessionType longValue],sourceId);
// }

// RCT_EXPORT_METHOD(getConversationIDBySessionType:(NSString *)sourceId sessionType:(nonnull NSNumber *)sessionType resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     NSString *str = Open_im_sdkGetConversationIDBySessionType(sourceId,[sessionType longValue]);
//     resolver(str);
// }

// RCT_EXPORT_METHOD(setConversationRecvMessageOpt:(NSArray *)cveids status:(nonnull NSNumber *)status operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkSetConversationRecvMessageOpt(proxy,operationID, [cveids json], [status longValue]);
// }

// RCT_EXPORT_METHOD(getConversationRecvMessageOpt:(NSArray *)cveids operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetConversationRecvMessageOpt(proxy,operationID, [cveids json]);
// }

RCT_EXPORT_METHOD(getFriendList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetFriendList(proxy, generatedOpid);
}

RCT_EXPORT_METHOD(getFriendListPage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSInteger offset = [options[@"offset"] integerValue];
    NSInteger count = [options[@"count"] integerValue];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetFriendListPage(proxy, generatedOpid, offset, count);
}

RCT_EXPORT_METHOD(searchFriends:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [self dictionaryToJson:options];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSearchFriends(proxy, generatedOpid, optionsJson);
}

RCT_EXPORT_METHOD(checkFriend:(NSArray *)userIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDListString = [userIDList componentsJoinedByString:@","];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkCheckFriend(proxy, generatedOpid, userIDListString);
}

RCT_EXPORT_METHOD(addFriend:(NSDictionary *)paramsReq operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *paramsReqJson = [self dictionaryToJson:paramsReq];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkAddFriend(proxy, generatedOpid, paramsReqJson);
}

RCT_EXPORT_METHOD(setFriendRemark:(NSString *)userIDRemark operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetFriendRemark(proxy, generatedOpid, userIDRemark);
}

RCT_EXPORT_METHOD(deleteFriend:(NSString *)friendUserID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkDeleteFriend(proxy, generatedOpid, friendUserID);
}
RCT_EXPORT_METHOD(getFriendApplicationListAsRecipient:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetFriendApplicationListAsRecipient(proxy, generatedOpid);
}

RCT_EXPORT_METHOD(getFriendApplicationListAsApplicant:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetFriendApplicationListAsApplicant(proxy, generatedOpid);
}

RCT_EXPORT_METHOD(acceptFriendApplication:(NSDictionary *)userIDHandleMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDHandleMsgJson = [self dictionaryToJson:userIDHandleMsg];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkAcceptFriendApplication(proxy, generatedOpid, userIDHandleMsgJson);
}

RCT_EXPORT_METHOD(refuseFriendApplication:(NSDictionary *)userIDHandleMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDHandleMsgJson = [self dictionaryToJson:userIDHandleMsg];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkRefuseFriendApplication(proxy, generatedOpid, userIDHandleMsgJson);
}

RCT_EXPORT_METHOD(addBlack:(NSString *)blackUserID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkAddBlack(proxy, generatedOpid, blackUserID);
}
RCT_EXPORT_METHOD(getBlackList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetBlackList(proxy, generatedOpid);
}

RCT_EXPORT_METHOD(removeBlack:(NSString *)removeUserID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkRemoveBlack(proxy, generatedOpid, removeUserID);
}

// RCT_EXPORT_METHOD(setGroupListener)
// {
//     Open_im_sdkSetGroupListener([self createGroupListener]);
// }

//- (RNGroupListener *)createGroupListener
//{
//    RNGroupListener *groupListener = [[RNGroupListener alloc] initWithReactBridge:self.bridge];
//    return groupListener;
//}

RCT_EXPORT_METHOD(setFriendListener)
{
    Open_im_sdkSetFriendListener(self);
}

// RCT_EXPORT_METHOD(getFriendList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetFriendList(proxy,operationID);
// }

// RCT_EXPORT_METHOD(getRecvFriendApplicationList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetRecvFriendApplicationList(proxy,operationID);
// }

// RCT_EXPORT_METHOD(getSendFriendApplicationList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetSendFriendApplicationList(proxy,operationID);
// }

// RCT_EXPORT_METHOD(addFriend:(NSDictionary *)reqParams operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkAddFriend(proxy,operationID, [reqParams json]);
// }

// RCT_EXPORT_METHOD(getDesignatedFriendsInfo:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetDesignatedFriendsInfo(proxy,operationID, [uidList json]);
// }

// RCT_EXPORT_METHOD(setFriendRemark:(NSDictionary *)friendInfo operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkSetFriendRemark(proxy,operationID,[friendInfo json]);
// }

// RCT_EXPORT_METHOD(refuseFriendApplication:(NSDictionary *)userIDHandleMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkRefuseFriendApplication(proxy,operationID, [userIDHandleMsg json]);
// }

// RCT_EXPORT_METHOD(acceptFriendApplication:(NSDictionary *)userIDHandleMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkAcceptFriendApplication(proxy,operationID, [userIDHandleMsg json]);
// }

// RCT_EXPORT_METHOD(deleteFriend:(NSString *)uid operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkDeleteFriend(proxy, operationID, uid);
// }

// RCT_EXPORT_METHOD(checkFriend:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkCheckFriend(proxy,operationID, [uidList json]);
// }

// RCT_EXPORT_METHOD(removeBlack:(NSString *)uid operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkRemoveBlack(proxy, operationID, uid);
// }

// RCT_EXPORT_METHOD(getBlackList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetBlackList(proxy,operationID);
// }

// RCT_EXPORT_METHOD(addBlack:(NSString *)uid operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkAddBlack(proxy, operationID, uid);
// }

RCT_EXPORT_METHOD(setGroupListener)
{
    Open_im_sdkSetGroupListener(self);
}

// RCT_EXPORT_METHOD(inviteUserToGroup:(NSString *)gid reason:(NSString *)reason uidList:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkInviteUserToGroup(proxy,operationID,gid, reason, [uidList json]);
// }

// RCT_EXPORT_METHOD(kickGroupMember:(NSString *)gid reason:(NSString *)reason uidList:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkKickGroupMember(proxy,operationID,gid, reason, [uidList json]);
// }

// RCT_EXPORT_METHOD(getGroupMembersInfo:(NSString *)gid uidList:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetGroupMembersInfo(proxy,operationID, gid, [uidList json]);
// }

// RCT_EXPORT_METHOD(getGroupMemberList:(NSString *)gid filter:(nonnull NSNumber *)filter offset:(nonnull NSNumber *)offset count:(nonnull NSNumber *)count operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetGroupMemberList(proxy,operationID, gid, [filter intValue], [offset intValue],[count intValue]);
// }

// RCT_EXPORT_METHOD(getJoinedGroupList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetJoinedGroupList(proxy,operationID);
// }
RCT_EXPORT_METHOD(joinGroup:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSNumber *joinSource = [options objectForKey:@"joinSource"];
    NSString *groupID = [options objectForKey:@"groupID"];
    NSString *reqMsg = [options objectForKey:@"reqMsg"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkJoinGroup(proxy, generatedOpid, groupID, reqMsg, joinSource.intValue);
}

RCT_EXPORT_METHOD(quitGroup:(NSString *)gid operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkQuitGroup(proxy, generatedOpid, gid);
}

RCT_EXPORT_METHOD(dismissGroup:(NSString *)groupID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkDismissGroup(proxy, generatedOpid, groupID);
}

RCT_EXPORT_METHOD(changeGroupMute:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = [options objectForKey:@"groupID"];
    NSNumber *isMute = [options objectForKey:@"isMute"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkChangeGroupMute(proxy, generatedOpid, groupID, isMute.boolValue);
}
RCT_EXPORT_METHOD(setGroupMemberRoleLevel:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *userID = options[@"userID"];
    NSInteger roleLevel = [options[@"roleLevel"] integerValue];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetGroupMemberRoleLevel(proxy, generatedOpid, groupID, userID, roleLevel);
}

RCT_EXPORT_METHOD(setGroupMemberInfo:(NSDictionary *)data operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *dataJson = [self dictionaryToJson:data];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetGroupMemberInfo(proxy, generatedOpid, dataJson);
}

RCT_EXPORT_METHOD(getJoinedGroupList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetJoinedGroupList(proxy, generatedOpid);
}

RCT_EXPORT_METHOD(getSpecifiedGroupsInfo:(NSArray *)groupIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupIDListJson = [groupIDList json];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetSpecifiedGroupsInfo(proxy, generatedOpid, groupIDListJson);
}

RCT_EXPORT_METHOD(searchGroups:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [self dictionaryToJson:options];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSearchGroups(proxy, generatedOpid, optionsJson);
}

RCT_EXPORT_METHOD(setGroupInfo:(NSDictionary *)jsonGroupInfo operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *jsonGroupInfoJson = [self dictionaryToJson:jsonGroupInfo];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetGroupInfo(proxy, generatedOpid, jsonGroupInfoJson);
}
RCT_EXPORT_METHOD(setGroupVerification:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *verification = options[@"verification"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetGroupVerification(proxy, generatedOpid, groupID, [verification intValue]);
}

RCT_EXPORT_METHOD(setGroupLookMemberInfo:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *rule = options[@"rule"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetGroupLookMemberInfo(proxy, generatedOpid, groupID, [rule intValue]);
}

RCT_EXPORT_METHOD(setGroupApplyMemberFriend:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *rule = options[@"rule"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetGroupApplyMemberFriend(proxy, generatedOpid, groupID, [rule intValue]);
}

RCT_EXPORT_METHOD(getGroupMemberList:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *filter = options[@"filter"];
    NSNumber *offset = options[@"offset"];
    NSNumber *count = options[@"count"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetGroupMemberList(proxy, generatedOpid, groupID, [filter intValue], [offset intValue], [count intValue]);
}

RCT_EXPORT_METHOD(getGroupMemberOwnerAndAdmin:(NSString *)groupID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetGroupMemberOwnerAndAdmin(proxy, generatedOpid, groupID);
}

RCT_EXPORT_METHOD(getGroupMemberListByJoinTimeFilter:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *offset = options[@"offset"];
    NSNumber *count = options[@"count"];
    NSNumber *joinTimeBegin = options[@"joinTimeBegin"];
    NSNumber *joinTimeEnd = options[@"joinTimeEnd"];
    NSArray *filterUserIDList = options[@"filterUserIDList"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetGroupMemberListByJoinTimeFilter(proxy, generatedOpid, groupID, [offset intValue], [count intValue], [joinTimeBegin intValue], [joinTimeEnd intValue], [filterUserIDList json]);
}
RCT_EXPORT_METHOD(getSpecifiedGroupMembersInfo:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSArray *userIDList = options[@"userIDList"];
    NSString *userIDListJson = [userIDList json];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetSpecifiedGroupMembersInfo(proxy, generatedOpid, groupID, userIDListJson);
}

RCT_EXPORT_METHOD(kickGroupMember:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *reason = options[@"reason"];
    NSArray *userIDList = options[@"userIDList"];
    NSString *userIDListJson = [userIDList json];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkKickGroupMember(proxy, generatedOpid, groupID, reason, userIDListJson);
}

RCT_EXPORT_METHOD(transferGroupOwner:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *gid = options[@"gid"];
    NSString *uid = options[@"uid"];
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkTransferGroupOwner(proxy, generatedOpid, gid, uid);
}

RCT_EXPORT_METHOD(inviteUserToGroup:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *reason = options[@"reason"];
    NSArray *userIDList = options[@"userIDList"];
    NSString *userIDListJson = [userIDList json];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkInviteUserToGroup(proxy, generatedOpid, groupID, reason, userIDListJson);
}

RCT_EXPORT_METHOD(getGroupApplicationListAsRecipient:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetGroupApplicationListAsRecipient(proxy, generatedOpid);
}

RCT_EXPORT_METHOD(getGroupApplicationListAsApplicant:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkGetGroupApplicationListAsApplicant(proxy, generatedOpid);
}
RCT_EXPORT_METHOD(acceptGroupApplication:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *gid = options[@"gid"];
    NSString *fromUserID = options[@"fromUserID"];
    NSString *handleMsg = options[@"handleMsg"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkAcceptGroupApplication(proxy, generatedOpid, gid, fromUserID, handleMsg);
}


RCT_EXPORT_METHOD(refuseGroupApplication:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *gid = options[@"gid"];
    NSString *fromUserID = options[@"fromUserID"];
    NSString *handleMsg = options[@"handleMsg"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkRefuseGroupApplication(proxy, generatedOpid, gid, fromUserID, handleMsg);
}

RCT_EXPORT_METHOD(setGroupMemberNickname:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *userID = options[@"userID"];
    NSString *groupMemberNickname = options[@"groupMemberNickname"];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSetGroupMemberNickname(proxy, generatedOpid, groupID, userID, groupMemberNickname);
}


RCT_EXPORT_METHOD(searchGroupMembers:(NSDictionary *)searchOptions operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *searchOptionsJson = [self dictionaryToJson:searchOptions];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkSearchGroupMembers(proxy, generatedOpid, searchOptionsJson);
}
RCT_EXPORT_METHOD(isJoinGroup:(NSString *)groupID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkIsJoinGroup(proxy, generatedOpid, groupID);
}

RCT_EXPORT_METHOD(addAdvancedMsgListener)
{
    Open_im_sdkSetAdvancedMsgListener(self);
}


RCT_EXPORT_METHOD(sendMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = options[@"message"];
    NSString *recid = options[@"recvID"];
    NSString *gid = options[@"groupID"];
    NSDictionary *offlinePushInfo = options[@"offlinePushInfo"];
    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:msg module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessage(proxy,operationID, msg, recid, gid, [offlinePushInfo json]);
}

RCT_EXPORT_METHOD(sendMessageNotOss:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = options[@"message"];
    NSString *recid = options[@"recvID"];
    NSString *gid = options[@"groupID"];
    NSDictionary *offlinePushInfo = options[@"offlinePushInfo"];
    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:msg module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessageNotOss(proxy,operationID, msg, recid, gid, [offlinePushInfo json]);
}

RCT_EXPORT_METHOD(createGroup:(NSDictionary *)ginfo operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    NSString *generatedOpid = operationID ?: [self generateRandomOpid];
    
    Open_im_sdkCreateGroup(proxy,generatedOpid,[ginfo json]);
}

RCT_EXPORT_METHOD(uploadFile:(NSDictionary *)reqData operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    RNUploadFileCallbackProxy * uploadProxy = [[RNUploadFileCallbackProxy alloc] initWithOpid:operationID module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkUploadFile(proxy,operationID, [reqData json],uploadProxy);
}



// MARK: - Open_im_sdkIMSDKListener

- (void)onConnectSuccess {
    [self pushEvent:@"onConnectSuccess" errCode:@(0) errMsg:@"" data:@"connectSuccess"];
}

- (void)onConnecting {
    [self pushEvent:@"onConnecting" errCode:@(0) errMsg:@"" data:@"connecting"];
}

- (void)onKickedOffline {
    [self pushEvent:@"onKickedOffline" errCode:@(0) errMsg:@"" data:@"kickedOffline"];
}

- (void)onUserTokenExpired {
    [self pushEvent:@"onUserTokenExpired" errCode:@(0) errMsg:@"" data:@"userTokenExpired"];
}

- (void)onConnectFailed:(int32_t)errCode errMsg:(NSString * _Nullable)errMsg {
    [self pushEvent:@"onConnectFailed" errCode:@(errCode) errMsg:errMsg data:@"connectFailed"];
}


 // MARK: - Open_im_sdkUserListener

- (void)onSelfInfoUpdated:(NSString* _Nullable)userInfo {
    [self pushEvent:@"onSelfInfoUpdated" errCode:@(0) errMsg:@"" data:userInfo];
}

 // MARK: - Open_im_sdkIMSDKAdvancedMsgListener

 - (void)onRecvC2CReadReceipt:(NSString* _Nullable)msgReceiptList {
     [self pushEvent:@"onRecvC2CReadReceipt" errCode:@(0) errMsg:@"" data:msgReceiptList];
 }

 - (void)onRecvMessageRevoked:(NSString* _Nullable)msgId {
     [self pushEvent:@"onRecvMessageRevoked" errCode:@(0) errMsg:@"" data:msgId];
 }

 - (void)onRecvNewMessage:(NSString* _Nullable)message {
     [self pushEvent:@"onRecvNewMessage" errCode:@(0) errMsg:@"" data:message];
 }

- (void)onRecvGroupReadReceipt:(NSString * _Nullable)groupMsgReceiptList {
    [self pushEvent:@"onRecvGroupReadReceipt" errCode:@(0) errMsg:@"" data:groupMsgReceiptList];
}



 // MARK: - Open_im_sdkOnFriendshipListener


- (void)onBlackAdded:(NSString * _Nullable)blackInfo {
    [self pushEvent:@"onBlackAdded" errCode:@(0) errMsg:@"" data:blackInfo];
}

- (void)onBlackDeleted:(NSString * _Nullable)blackInfo {
    [self pushEvent:@"onBlackDeleted" errCode:@(0) errMsg:@"" data:blackInfo];
}

- (void)onFriendAdded:(NSString * _Nullable)friendInfo {
    [self pushEvent:@"onFriendAdded" errCode:@(0) errMsg:@"" data:friendInfo];
}

- (void)onFriendApplicationAccepted:(NSString * _Nullable)friendApplication {
    [self pushEvent:@"onFriendApplicationAccepted" errCode:@(0) errMsg:@"" data:friendApplication];
}

- (void)onFriendApplicationAdded:(NSString * _Nullable)friendApplication {
    [self pushEvent:@"onFriendApplicationAdded" errCode:@(0) errMsg:@"" data:friendApplication];
}

- (void)onFriendApplicationDeleted:(NSString * _Nullable)friendApplication {
    [self pushEvent:@"onFriendApplicationDeleted" errCode:@(0) errMsg:@"" data:friendApplication];
}

- (void)onFriendApplicationRejected:(NSString * _Nullable)friendApplication {
    [self pushEvent:@"onFriendApplicationRejected" errCode:@(0) errMsg:@"" data:friendApplication];
}

- (void)onFriendDeleted:(NSString * _Nullable)friendInfo {
    [self pushEvent:@"onFriendDeleted" errCode:@(0) errMsg:@"" data:friendInfo];
}

- (void)onFriendInfoChanged:(NSString * _Nullable)friendInfo {
    [self pushEvent:@"onFriendInfoChanged" errCode:@(0) errMsg:@"" data:friendInfo];
}

 // MARK: - Open_im_sdkOnConversationListener

 - (void)onConversationChanged:(NSString* _Nullable)conversationList {
     [self pushEvent:@"onConversationChanged" errCode:@(0) errMsg:@"" data:conversationList];
 }

 - (void)onNewConversation:(NSString* _Nullable)conversationList {
     [self pushEvent:@"onNewConversation" errCode:@(0) errMsg:@"" data:conversationList];
 }

 - (void)onSyncServerFailed {
     [self pushEvent:@"onSyncServerFailed" errCode:@(0) errMsg:@"" data:@"syncServerFailed"];
 }

 - (void)onSyncServerFinish {
     [self pushEvent:@"onSyncServerFinish" errCode:@(0) errMsg:@"" data:@"syncServerFinish"];
 }

 - (void)onSyncServerStart {
     [self pushEvent:@"onSyncServerStart" errCode:@(0) errMsg:@"" data:@"syncServerStart"];
 }

 - (void)onTotalUnreadMessageCountChanged:(int32_t)totalUnreadCount {
     [self pushEvent:@"onTotalUnreadMessageCountChanged" errCode:@(0) errMsg:@"" data:[NSString stringWithFormat:@"%d",totalUnreadCount]];
 }


 // MARK: - Open_im_sdkOnGroupListener
- (void)onGroupApplicationAccepted:(NSString * _Nullable)groupApplication {
    [self pushEvent:@"onGroupApplicationAccepted" errCode:@(0) errMsg:@"" data:groupApplication];
}

- (void)onGroupApplicationAdded:(NSString * _Nullable)groupApplication {
    [self pushEvent:@"onGroupApplicationAdded" errCode:@(0) errMsg:@"" data:groupApplication];
}

- (void)onGroupApplicationDeleted:(NSString * _Nullable)groupApplication {
    [self pushEvent:@"onGroupApplicationDeleted" errCode:@(0) errMsg:@"" data:groupApplication];
}

- (void)onGroupApplicationRejected:(NSString * _Nullable)groupApplication {
    [self pushEvent:@"onGroupApplicationRejected" errCode:@(0) errMsg:@"" data:groupApplication];
}

- (void)onGroupInfoChanged:(NSString * _Nullable)groupInfo {
    [self pushEvent:@"onGroupInfoChanged" errCode:@(0) errMsg:@"" data:groupInfo];
}

- (void)onGroupMemberAdded:(NSString * _Nullable)groupMemberInfo {
    [self pushEvent:@"onGroupMemberAdded" errCode:@(0) errMsg:@"" data:groupMemberInfo];
}

- (void)onGroupMemberDeleted:(NSString * _Nullable)groupMemberInfo {
    [self pushEvent:@"onGroupMemberDeleted" errCode:@(0) errMsg:@"" data:groupMemberInfo];
}

- (void)onGroupMemberInfoChanged:(NSString * _Nullable)groupMemberInfo {
    [self pushEvent:@"onGroupMemberInfoChanged" errCode:@(0) errMsg:@"" data:groupMemberInfo];
}

- (void)onJoinedGroupAdded:(NSString * _Nullable)groupInfo {
    [self pushEvent:@"onJoinedGroupAdded" errCode:@(0) errMsg:@"" data:groupInfo];
}

- (void)onJoinedGroupDeleted:(NSString * _Nullable)groupInfo {
    [self pushEvent:@"onJoinedGroupDeleted" errCode:@(0) errMsg:@"" data:groupInfo];
}

// MARK: - Open_im_sdk_callbackOnSignalingListener

- (void)onInvitationCancelled:(NSString* _Nullable)invitationCancelledCallback{
    [self pushEvent:@"onInvitationCancelled" errCode:@(0) errMsg:@"" data:invitationCancelledCallback];
}
- (void)onInvitationTimeout:(NSString* _Nullable)invitationTimeoutCallback{
    [self pushEvent:@"onInvitationTimeout" errCode:@(0) errMsg:@"" data:invitationTimeoutCallback];
}
- (void)onInviteeAccepted:(NSString* _Nullable)inviteeAcceptedCallback{
    [self pushEvent:@"onInviteeAccepted" errCode:@(0) errMsg:@"" data:inviteeAcceptedCallback];
}
- (void)onInviteeAcceptedByOtherDevice:(NSString* _Nullable)inviteeAcceptedCallback{
    [self pushEvent:@"onInviteeAcceptedByOtherDevice" errCode:@(0) errMsg:@"" data:inviteeAcceptedCallback];
}
- (void)onInviteeRejected:(NSString* _Nullable)inviteeRejectedCallback{
    [self pushEvent:@"onInviteeRejected" errCode:@(0) errMsg:@"" data:inviteeRejectedCallback];
}
- (void)onInviteeRejectedByOtherDevice:(NSString* _Nullable)inviteeRejectedCallback{
    [self pushEvent:@"onInviteeRejectedByOtherDevice" errCode:@(0) errMsg:@"" data:inviteeRejectedCallback];
}
- (void)onReceiveNewInvitation:(NSString* _Nullable)receiveNewInvitationCallback{
    [self pushEvent:@"onReceiveNewInvitation" errCode:@(0) errMsg:@"" data:receiveNewInvitationCallback];
}
- (void)onHangUp:(NSString* _Nullable)hangUpCallback{
    [self pushEvent:@"onHangUp" errCode:@(0) errMsg:@"" data:hangUpCallback];
}

@end

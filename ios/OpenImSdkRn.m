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

RCT_EXPORT_METHOD(initSDK:(NSDictionary *)config opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    BOOL flag = Open_im_sdkInitSDK(self,opid,[config json]);
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

// RCT_EXPORT_METHOD(login:(NSString *)uid token:(NSString *)token opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkLogin(proxy,opid,uid, token);
// }

RCT_EXPORT_METHOD(login:(NSString *)opid options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkLogin(proxy,opid,[options valueForKey:@"userID"],[options valueForKey:@"token"]);
}//need check

RCT_EXPORT_METHOD(logout:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkLogout(proxy,opid);
}

RCT_EXPORT_METHOD(setAppBackgroundStatus:(NSString *)operationID isBackground:(BOOL)isBackground resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetAppBackgroundStatus(proxy, operationID, isBackground);
}

RCT_EXPORT_METHOD(networkStatusChange:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkNetworkStatusChanged(proxy, operationID);
}

RCT_EXPORT_METHOD(getLoginStatus:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    long status = Open_im_sdkGetLoginStatus(operationID);
    resolver(@(status));
}//need check

RCT_EXPORT_METHOD(getLoginUser:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString* uid = Open_im_sdkGetLoginUserID();
    resolver(uid);
}//need check
//User
RCT_EXPORT_METHOD(getUsersInfo:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetUsersInfo(proxy,opid,[uidList json]);
}

RCT_EXPORT_METHOD(setSelfInfo:(NSDictionary *)info opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetSelfInfo(proxy,opid,[info json]);
}

RCT_EXPORT_METHOD(getSelfUserInfo:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetSelfUserInfo(proxy, opid);
}

//Conversation & Message

RCT_EXPORT_METHOD(setConversationListener)
{
    Open_im_sdkSetConversationListener(self);
}

RCT_EXPORT_METHOD(getAllConversationList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetAllConversationList(proxy,opid);
}

RCT_EXPORT_METHOD(getConversationListSplit:(NSString *)opid options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
     Open_im_sdkGetConversationListSplit(proxy,opid,[[options valueForKey:@"offset"] longValue], [[options valueForKey:@"count"] longValue]);
}//need check

RCT_EXPORT_METHOD(getOneConversation:(NSString *)opid options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetOneConversation(proxy,opid, [[options valueForKey:@"sessionType"] intValue], [options valueForKey:@"sourceID"]);
}//need check

RCT_EXPORT_METHOD(getMultipleConversation:(NSString *)opid conversationIDList:(NSArray *)conversationIDList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetMultipleConversation(proxy, opid,  [conversationIDList json]);
}//need check

RCT_EXPORT_METHOD(setGlobalRecvMessageOpt:(NSString *)opid opt:(NSInteger)opt resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetGlobalRecvMessageOpt(proxy, opid, opt);
}

RCT_EXPORT_METHOD(hideConversation:(NSString *)opid conversationID:(NSString *)conversationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkHideConversation(proxy, opid, conversationID);
}

RCT_EXPORT_METHOD(getConversationRecvMessageOpt:(NSString *)opid conversationIDList:(NSArray *)conversationIDList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetConversationRecvMessageOpt(proxy, opid, [conversationIDList json]);
}
RCT_EXPORT_METHOD(deleteAllConversationFromLocal:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteAllConversationFromLocal(proxy, operationID);
}

RCT_EXPORT_METHOD(setConversationDraft:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetConversationDraft(proxy,opid, [options valueForKey:@"conversationID"],[options valueForKey:@"draftText"]);
}

RCT_EXPORT_METHOD(resetConversationGroupAtType:(NSString *)operationID conversationID:(NSString *)conversationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkResetConversationGroupAtType(proxy, operationID, conversationID);
}

RCT_EXPORT_METHOD(pinConversation:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkPinConversation(proxy,opid, [options valueForKey:@"conversationID"], [[options valueForKey:@"isPinned"] boolValue]);
}

RCT_EXPORT_METHOD(setConversationPrivateChat:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetConversationPrivateChat(proxy,opid, [options valueForKey:@"conversationID"], [[options valueForKey:@"isPrivate"] boolValue] );
}
RCT_EXPORT_METHOD(setConversationBurnDuration:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetConversationBurnDuration(proxy,opid,[options valueForKey:@"conversationID"], [[options valueForKey:@"burnDuration"] intValue]);
}

RCT_EXPORT_METHOD(setConversationRecvMessageOpt:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetConversationRecvMessageOpt(proxy, opid, [options valueForKey:@"conversationID"], [[options valueForKey:@"opt"] longValue]);
}

RCT_EXPORT_METHOD(getTotalUnreadMsgCount:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetTotalUnreadMsgCount(proxy, operationID);
}
RCT_EXPORT_METHOD(getAtAllTag:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *atAllTag = Open_im_sdkGetAtAllTag(opid);
    [proxy resolve:atAllTag];
}

RCT_EXPORT_METHOD(createAdvancedTextMessage:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSArray *messageEntityList = options[@"messageEntityList"];
    NSString *messageEntityListJson = [self arrayToJson:messageEntityList];
    NSString *text = options[@"text"];
    
    NSString *result = Open_im_sdkCreateAdvancedTextMessage(operationID, text, messageEntityListJson);
    [proxy resolve:result];
}


RCT_EXPORT_METHOD(createTextAtMessage:(NSString *)opid options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
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
    NSString *result = Open_im_sdkCreateTextAtMessage(opid, text, atUserIDListStr, atUsersInfoStr, messageJson);
    [proxy resolve:result];
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
RCT_EXPORT_METHOD(createTextMessage:(NSString *)operationID textMsg:(NSString *)textMsg resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = [Open_im_sdk createTextMessage:operationID textMsg:textMsg];
    resolver(result);
}

RCT_EXPORT_METHOD(createLocationMessage:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = [Open_im_sdk createLocationMessage:operationID description:options[@"description"] longitude:[options[@"longitude"] doubleValue] latitude:[options[@"latitude"] doubleValue]];
    resolver(result);
}

RCT_EXPORT_METHOD(createCustomMessage:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = [Open_im_sdk createCustomMessage:operationID data:options[@"data"] extension:options[@"extension"] description:options[@"description"]];
    resolver(result);
}

RCT_EXPORT_METHOD(createQuoteMessage:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = [Open_im_sdk createQuoteMessage:operationID text:options[@"text"] message:options[@"message"]];
    resolver(result);
}

RCT_EXPORT_METHOD(createAdvancedQuoteMessage:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = [Open_im_sdk createAdvancedQuoteMessage:operationID text:options[@"text"] message:options[@"message"] messageEntityList:options[@"messageEntityList"]];
    resolver(result);
}
RCT_EXPORT_METHOD(createCardMessage:(NSString *)operationID cardElem:(NSDictionary *)cardElem resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = [Open_im_sdk createCardMessage:operationID data:[self dictionaryToJson:cardElem]];
    resolver(result);
}

RCT_EXPORT_METHOD(createImageMessage:(NSString *)operationID imagePath:(NSString *)imagePath resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = [Open_im_sdk createImageMessage:operationID imagePath:imagePath];
    resolver(result);
}

RCT_EXPORT_METHOD(createImageMessageFromFullPath:(NSString *)operationID imagePath:(NSString *)imagePath resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = [Open_im_sdk createImageMessageFromFullPath:operationID imagePath:imagePath];
    resolver(result);
}

RCT_EXPORT_METHOD(createImageMessageByURL:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *jsonStr1 = [self dictionaryToJson:options[@"sourcePicture"]];
    NSString *jsonStr2 = [self dictionaryToJson:options[@"bigPicture"]];
    NSString *jsonStr3 = [self dictionaryToJson:options[@"snapshotPicture"]];
    NSString *result = [Open_im_sdk createImageMessageByURL:operationID jsonStr1:jsonStr1 jsonStr2:jsonStr2 jsonStr3:jsonStr3];
    resolver(result);
}

RCT_EXPORT_METHOD(createSoundMessage:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = [Open_im_sdk createSoundMessage:operationID soundPath:options[@"soundPath"] duration:[options[@"duration"] integerValue]];
    resolver(result);
}
RCT_EXPORT_METHOD(createSoundMessageFromFullPath:(NSString *)OperationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *soundPath = [options objectForKey:@"soundPath"];
    NSInteger duration = [[options objectForKey:@"duration"] integerValue];
    NSString *result = Open_im_sdkCreateSoundMessageFromFullPath(OperationID, soundPath, (long)duration);
    resolver(result);
}

RCT_EXPORT_METHOD(createSoundMessageByURL:(NSString *)OperationID soundInfo:(NSDictionary *)soundInfo resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *soundInfoStr = [self readableMapToString:soundInfo];
    NSString *result = Open_im_sdkCreateSoundMessageByURL(OperationID, soundInfoStr);
    resolver(result);
}

RCT_EXPORT_METHOD(createVideoMessage:(NSString *)OperationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *videoPath = [options objectForKey:@"videoPath"];
    NSString *videoType = [options objectForKey:@"videoType"];
    NSInteger duration = [[options objectForKey:@"duration"] integerValue];
    NSString *snapshotPath = [options objectForKey:@"snapshotPath"];
    NSString *result = Open_im_sdkCreateVideoMessage(OperationID, videoPath, videoType, (long)duration, snapshotPath);
    resolver(result);
}

RCT_EXPORT_METHOD(createVideoMessageFromFullPath:(NSString *)OperationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *videoPath = [options objectForKey:@"videoPath"];
    NSString *videoType = [options objectForKey:@"videoType"];
    NSInteger duration = [[options objectForKey:@"duration"] integerValue];
    NSString *snapshotPath = [options objectForKey:@"snapshotPath"];
    NSString *result = Open_im_sdkCreateVideoMessageFromFullPath(OperationID, videoPath, videoType, (long)duration, snapshotPath);
    resolver(result);
}

RCT_EXPORT_METHOD(createVideoMessageByURL:(NSString *)OperationID videoInfo:(NSDictionary *)videoInfo resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *videoInfoStr = [self readableMapToString:videoInfo];
    NSString *result = Open_im_sdkCreateVideoMessageByURL(OperationID, videoInfoStr);
    resolver(result);
}

RCT_EXPORT_METHOD(createFileMessage:(NSString *)OperationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *filePath = [options objectForKey:@"filePath"];
    NSString *fileName = [options objectForKey:@"fileName"];
    NSString *result = Open_im_sdkCreateFileMessage(OperationID, filePath, fileName);
    resolver(result);
}
RCT_EXPORT_METHOD(createFileMessageFromFullPath:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *filePath = options[@"filePath"];
    NSString *fileName = options[@"fileName"];
    NSString *result = Open_im_sdkCreateFileMessageFromFullPath(operationID, filePath, fileName);
    resolver(result);
}

RCT_EXPORT_METHOD(createFileMessageByURL:(NSString *)operationID fileInfo:(NSDictionary *)fileInfo resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = Open_im_sdkCreateFileMessageByURL(operationID, [self readableMapToString:fileInfo]);
    resolver(result);
}

RCT_EXPORT_METHOD(createMergerMessage:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *messageList = [options[@"messageList"] description];
    NSString *title = options[@"title"];
    NSString *summaryList = [options[@"summaryList"] description];
    NSString *result = Open_im_sdkCreateMergerMessage(operationID, messageList, title, summaryList);
    resolver(result);
}

RCT_EXPORT_METHOD(createFaceMessage:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSNumber *index = options[@"index"];
    NSString *dataStr = options[@"dataStr"];
    NSString *result = Open_im_sdkCreateFaceMessage(operationID, [index intValue], dataStr);
    resolver(result);
}

RCT_EXPORT_METHOD(createForwardMessage:(NSString *)operationID message:(NSDictionary *)message resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = Open_im_sdkCreateForwardMessage(operationID, [self readableMapToString:message]);
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
RCT_EXPORT_METHOD(getConversationIDBySessionType:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *sourceID = options[@"sourceID"];
    NSNumber *sessionType = options[@"sessionType"];
    NSString *result = Open_im_sdkGetConversationIDBySessionType(operationID, sourceID, sessionType.intValue);
    resolver(result);
}

RCT_EXPORT_METHOD(findMessageList:(NSString *)operationID findOptions:(NSDictionary *)findOptions resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *findOptionsJson = [self dictionaryToJson:findOptions];
    Open_im_sdkFindMessageList(proxy, operationID, findOptionsJson);
}

RCT_EXPORT_METHOD(getAdvancedHistoryMessageList:(NSString *)operationID findOptions:(NSDictionary *)findOptions resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *findOptionsJson = [self dictionaryToJson:findOptions];
    Open_im_sdkGetAdvancedHistoryMessageList(proxy, operationID, findOptionsJson);
}

RCT_EXPORT_METHOD(getAdvancedHistoryMessageListReverse:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [self dictionaryToJson:options];
    Open_im_sdkGetAdvancedHistoryMessageListReverse(proxy, operationID, optionsJson);
}

RCT_EXPORT_METHOD(revokeMessage:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"];
    NSString *clientMsgID = options[@"clientMsgID"];
    Open_im_sdkRevokeMessage(proxy, operationID, conversationID, clientMsgID);
}

RCT_EXPORT_METHOD(typingStatusUpdate:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *recvID = options[@"recvID"];
    NSString *msgTip = options[@"msgTip"];
    Open_im_sdkTypingStatusUpdate(proxy, operationID, recvID, msgTip);
}

// RCT_EXPORT_METHOD(markGroupMessageHasRead:(NSString *)gid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkMarkGroupMessageHasRead(proxy,opid, gid);
// }

// RCT_EXPORT_METHOD(getTotalUnreadMsgCount:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetTotalUnreadMsgCount(proxy,opid);
// }

// RCT_EXPORT_METHOD(pinConversation:(NSString *)cveid isPin:(BOOL)isPin opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkPinConversation(proxy,opid,cveid, isPin);
// }

// RCT_EXPORT_METHOD(setConversationDraft:(NSString *)cveid draft:(NSString *)draft opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkSetConversationDraft(proxy,opid,cveid, draft);
// }

// RCT_EXPORT_METHOD(deleteConversation:(NSString *)cveid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkDeleteConversation(proxy,opid,cveid);
// }

// RCT_EXPORT_METHOD(getMultipleConversation:(NSArray *)cveids opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetMultipleConversation(proxy,opid,[cveids json]);
// }

// RCT_EXPORT_METHOD(getOneConversation:(NSString *)sourceId sessionType:(nonnull NSNumber *)sessionType opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetOneConversation(proxy,opid, [sessionType longValue],sourceId);
// }

// RCT_EXPORT_METHOD(getConversationIDBySessionType:(NSString *)sourceId sessionType:(nonnull NSNumber *)sessionType resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     NSString *str = Open_im_sdkGetConversationIDBySessionType(sourceId,[sessionType longValue]);
//     resolver(str);
// }

// RCT_EXPORT_METHOD(setConversationRecvMessageOpt:(NSArray *)cveids status:(nonnull NSNumber *)status opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkSetConversationRecvMessageOpt(proxy,opid, [cveids json], [status longValue]);
// }

// RCT_EXPORT_METHOD(getConversationRecvMessageOpt:(NSArray *)cveids opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetConversationRecvMessageOpt(proxy,opid, [cveids json]);
// }

RCT_EXPORT_METHOD(getFriendList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetFriendList(proxy, operationID);
}

RCT_EXPORT_METHOD(getFriendListPage:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSInteger offset = [options[@"offset"] integerValue];
    NSInteger count = [options[@"count"] integerValue];
    Open_im_sdkGetFriendListPage(proxy, operationID, offset, count);
}

RCT_EXPORT_METHOD(searchFriends:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [self dictionaryToJson:options];
    Open_im_sdkSearchFriends(proxy, operationID, optionsJson);
}

RCT_EXPORT_METHOD(checkFriend:(NSArray *)userIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDListString = [userIDList componentsJoinedByString:@","];
    Open_im_sdkCheckFriend(proxy, operationID, userIDListString);
}

RCT_EXPORT_METHOD(addFriend:(NSDictionary *)paramsReq operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *paramsReqJson = [self dictionaryToJson:paramsReq];
    Open_im_sdkAddFriend(proxy, operationID, paramsReqJson);
}

RCT_EXPORT_METHOD(setFriendRemark:(NSString *)userIDRemark operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetFriendRemark(proxy, operationID, userIDRemark);
}

RCT_EXPORT_METHOD(deleteFriend:(NSString *)friendUserID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteFriend(proxy, operationID, friendUserID);
}
RCT_EXPORT_METHOD(getFriendApplicationListAsRecipient:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetFriendApplicationListAsRecipient(proxy, operationID);
}

RCT_EXPORT_METHOD(getFriendApplicationListAsApplicant:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetFriendApplicationListAsApplicant(proxy, operationID);
}

RCT_EXPORT_METHOD(acceptFriendApplication:(NSDictionary *)userIDHandleMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDHandleMsgJson = [self dictionaryToJson:userIDHandleMsg];
    Open_im_sdkAcceptFriendApplication(proxy, operationID, userIDHandleMsgJson);
}

RCT_EXPORT_METHOD(refuseFriendApplication:(NSDictionary *)userIDHandleMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDHandleMsgJson = [self dictionaryToJson:userIDHandleMsg];
    Open_im_sdkRefuseFriendApplication(proxy, operationID, userIDHandleMsgJson);
}

RCT_EXPORT_METHOD(addBlack:(NSString *)blackUserID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAddBlack(proxy, operationID, blackUserID);
}
RCT_EXPORT_METHOD(getBlackList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetBlackList(proxy, operationID);
}

RCT_EXPORT_METHOD(removeBlack:(NSString *)removeUserID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRemoveBlack(proxy, operationID, removeUserID);
}

// RCT_EXPORT_METHOD(setGroupListener)
// {
//     Open_im_sdkSetGroupListener([self createGroupListener]);
// }

- (RNGroupListener *)createGroupListener
{
    RNGroupListener *groupListener = [[RNGroupListener alloc] initWithReactBridge:self.bridge];
    return groupListener;
}

RCT_EXPORT_METHOD(setFriendListener)
{
    Open_im_sdkSetFriendListener(self);
}

// RCT_EXPORT_METHOD(getFriendList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetFriendList(proxy,opid);
// }

// RCT_EXPORT_METHOD(getRecvFriendApplicationList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetRecvFriendApplicationList(proxy,opid);
// }

// RCT_EXPORT_METHOD(getSendFriendApplicationList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetSendFriendApplicationList(proxy,opid);
// }

// RCT_EXPORT_METHOD(addFriend:(NSDictionary *)reqParams opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkAddFriend(proxy,opid, [reqParams json]);
// }

// RCT_EXPORT_METHOD(getDesignatedFriendsInfo:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetDesignatedFriendsInfo(proxy,opid, [uidList json]);
// }

// RCT_EXPORT_METHOD(setFriendRemark:(NSDictionary *)friendInfo opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkSetFriendRemark(proxy,opid,[friendInfo json]);
// }

// RCT_EXPORT_METHOD(refuseFriendApplication:(NSDictionary *)userIDHandleMsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkRefuseFriendApplication(proxy,opid, [userIDHandleMsg json]);
// }

// RCT_EXPORT_METHOD(acceptFriendApplication:(NSDictionary *)userIDHandleMsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkAcceptFriendApplication(proxy,opid, [userIDHandleMsg json]);
// }

// RCT_EXPORT_METHOD(deleteFriend:(NSString *)uid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkDeleteFriend(proxy, opid, uid);
// }

// RCT_EXPORT_METHOD(checkFriend:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkCheckFriend(proxy,opid, [uidList json]);
// }

// RCT_EXPORT_METHOD(removeBlack:(NSString *)uid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkRemoveBlack(proxy, opid, uid);
// }

// RCT_EXPORT_METHOD(getBlackList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetBlackList(proxy,opid);
// }

// RCT_EXPORT_METHOD(addBlack:(NSString *)uid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkAddBlack(proxy, opid, uid);
// }

RCT_EXPORT_METHOD(setGroupListener)
{
    Open_im_sdkSetGroupListener(self);
}

// RCT_EXPORT_METHOD(inviteUserToGroup:(NSString *)gid reason:(NSString *)reason uidList:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkInviteUserToGroup(proxy,opid,gid, reason, [uidList json]);
// }

// RCT_EXPORT_METHOD(kickGroupMember:(NSString *)gid reason:(NSString *)reason uidList:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkKickGroupMember(proxy,opid,gid, reason, [uidList json]);
// }

// RCT_EXPORT_METHOD(getGroupMembersInfo:(NSString *)gid uidList:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetGroupMembersInfo(proxy,opid, gid, [uidList json]);
// }

// RCT_EXPORT_METHOD(getGroupMemberList:(NSString *)gid filter:(nonnull NSNumber *)filter offset:(nonnull NSNumber *)offset count:(nonnull NSNumber *)count opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetGroupMemberList(proxy,opid, gid, [filter intValue], [offset intValue],[count intValue]);
// }

// RCT_EXPORT_METHOD(getJoinedGroupList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
// {
//     RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
//     Open_im_sdkGetJoinedGroupList(proxy,opid);
// }
RCT_EXPORT_METHOD(joinGroup:(NSString *)opid options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSNumber *joinSource = [options objectForKey:@"joinSource"];
    NSString *groupID = [options objectForKey:@"groupID"];
    NSString *reqMsg = [options objectForKey:@"reqMsg"];
    Open_im_sdkJoinGroup(proxy, opid, groupID, reqMsg, joinSource.intValue);
}

RCT_EXPORT_METHOD(quitGroup:(NSString *)gid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkQuitGroup(proxy, opid, gid);
}

RCT_EXPORT_METHOD(dismissGroup:(NSString *)opid groupID:(NSString *)groupID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDismissGroup(proxy, opid, groupID);
}

RCT_EXPORT_METHOD(changeGroupMute:(NSString *)opid options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = [options objectForKey:@"groupID"];
    NSNumber *isMute = [options objectForKey:@"isMute"];
    Open_im_sdkChangeGroupMute(proxy, opid, groupID, isMute.boolValue);
}
RCT_EXPORT_METHOD(setGroupMemberRoleLevel:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *userID = options[@"userID"];
    NSInteger roleLevel = [options[@"roleLevel"] integerValue];
    Open_im_sdkSetGroupMemberRoleLevel(proxy, operationID, groupID, userID, roleLevel);
}

RCT_EXPORT_METHOD(setGroupMemberInfo:(NSString *)operationID data:(NSDictionary *)data resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *dataJson = [self dictionaryToJson:data];
    Open_im_sdkSetGroupMemberInfo(proxy, operationID, dataJson);
}

RCT_EXPORT_METHOD(getJoinedGroupList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetJoinedGroupList(proxy, operationID);
}

RCT_EXPORT_METHOD(getSpecifiedGroupsInfo:(NSString *)operationID groupIDList:(NSArray *)groupIDList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupIDListJson = [self arrayToJson:groupIDList];
    Open_im_sdkGetSpecifiedGroupsInfo(proxy, operationID, groupIDListJson);
}

RCT_EXPORT_METHOD(searchGroups:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [self dictionaryToJson:options];
    Open_im_sdkSearchGroups(proxy, operationID, optionsJson);
}

RCT_EXPORT_METHOD(setGroupInfo:(NSString *)operationID jsonGroupInfo:(NSDictionary *)jsonGroupInfo resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *jsonGroupInfoJson = [self dictionaryToJson:jsonGroupInfo];
    Open_im_sdkSetGroupInfo(proxy, operationID, jsonGroupInfoJson);
}
RCT_EXPORT_METHOD(setGroupVerification:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *verification = options[@"verification"];
    Open_im_sdkSetGroupVerification(proxy, operationID, groupID, [verification intValue]);
}

RCT_EXPORT_METHOD(setGroupLookMemberInfo:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *rule = options[@"rule"];
    Open_im_sdkSetGroupLookMemberInfo(proxy, operationID, groupID, [rule intValue]);
}

RCT_EXPORT_METHOD(setGroupApplyMemberFriend:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *rule = options[@"rule"];
    Open_im_sdkSetGroupApplyMemberFriend(proxy, operationID, groupID, [rule intValue]);
}

RCT_EXPORT_METHOD(getGroupMemberList:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *filter = options[@"filter"];
    NSNumber *offset = options[@"offset"];
    NSNumber *count = options[@"count"];
    Open_im_sdkGetGroupMemberList(proxy, operationID, groupID, [filter intValue], [offset intValue], [count intValue]);
}

RCT_EXPORT_METHOD(getGroupMemberOwnerAndAdmin:(NSString *)operationID groupID:(NSString *)groupID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupMemberOwnerAndAdmin(proxy, operationID, groupID);
}

RCT_EXPORT_METHOD(getGroupMemberListByJoinTimeFilter:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *offset = options[@"offset"];
    NSNumber *count = options[@"count"];
    NSNumber *joinTimeBegin = options[@"joinTimeBegin"];
    NSNumber *joinTimeEnd = options[@"joinTimeEnd"];
    NSArray *filterUserIDList = options[@"filterUserIDList"];
    
    Open_im_sdkGetGroupMemberListByJoinTimeFilter(proxy, operationID, groupID, [offset intValue], [count intValue], [joinTimeBegin intValue], [joinTimeEnd intValue], filterUserIDList);
}
RCT_EXPORT_METHOD(getSpecifiedGroupMembersInfo:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSArray *userIDList = options[@"userIDList"];
    NSString *userIDListJson = [self arrayToJson:userIDList];
    Open_im_sdkGetSpecifiedGroupMembersInfo(proxy, operationID, groupID, userIDListJson);
}

RCT_EXPORT_METHOD(kickGroupMember:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *reason = options[@"reason"];
    NSArray *userIDList = options[@"userIDList"];
    NSString *userIDListJson = [self arrayToJson:userIDList];
    Open_im_sdkKickGroupMember(proxy, operationID, groupID, reason, userIDListJson);
}

RCT_EXPORT_METHOD(transferGroupOwner:(NSString *)gid uid:(NSString *)uid operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkTransferGroupOwner(proxy, operationID, gid, uid);
}

RCT_EXPORT_METHOD(inviteUserToGroup:(NSString *)operationID options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *reason = options[@"reason"];
    NSArray *userIDList = options[@"userIDList"];
    NSString *userIDListJson = [self arrayToJson:userIDList];
    Open_im_sdkInviteUserToGroup(proxy, operationID, groupID, reason, userIDListJson);
}

RCT_EXPORT_METHOD(getGroupApplicationListAsRecipient:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupApplicationListAsRecipient(proxy, operationID);
}

RCT_EXPORT_METHOD(getGroupApplicationListAsApplicant:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupApplicationListAsApplicant(proxy, operationID);
}
RCT_EXPORT_METHOD(acceptGroupApplication:(NSString *)opid options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *gid = options[@"gid"];
    NSString *fromUserID = options[@"fromUserID"];
    NSString *handleMsg = options[@"handleMsg"];
    Open_im_sdkAcceptGroupApplication(proxy, opid, gid, fromUserID, handleMsg);
}


RCT_EXPORT_METHOD(refuseGroupApplication:(NSString *)opid options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *gid = options[@"gid"];
    NSString *fromUserID = options[@"fromUserID"];
    NSString *handleMsg = options[@"handleMsg"];
    Open_im_sdkRefuseGroupApplication(proxy, opid, gid, fromUserID, handleMsg);
}

RCT_EXPORT_METHOD(setGroupMemberNickname:(NSString *)opid options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *userID = options[@"userID"];
    NSString *groupMemberNickname = options[@"groupMemberNickname"];
    Open_im_sdkSetGroupMemberNickname(proxy, opid, groupID, userID, groupMemberNickname);
}


RCT_EXPORT_METHOD(searchGroupMembers:(NSString *)operationID searchOptions:(NSDictionary *)searchOptions resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *searchOptionsJson = [self dictionaryToJson:searchOptions];
    Open_im_sdkSearchGroupMembers(proxy, operationID, searchOptionsJson);
}
RCT_EXPORT_METHOD(isJoinGroup:(NSString *)opid groupID:(NSString *)groupID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkIsJoinGroup(proxy, opid, groupID);
}

// RCT_EXPORT_METHOD(addAdvancedMsgListener)
// {
//     Open_im_sdkSetAdvancedMsgListener([AdvancedMsgListener initWithReactContext:self.bridge]);
// }

RCT_EXPORT_METHOD(addAdvancedMsgListener)
{
    Open_im_sdkSetAdvancedMsgListener(self);
}

RCT_EXPORT_METHOD(sendMessage:(NSString *)operationID offlinePushInfo:(NSDictionary *)offlinePushInfo resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *message = offlinePushInfo[@"message"];
    NSString *receiver = offlinePushInfo[@"receiver"];
    NSString *groupID = offlinePushInfo[@"groupID"];

    NSDictionary *options = @{
        @"message": message,
        @"receiver": receiver,
        @"groupID": groupID
    };
    NSString *optionsJson = [self dictionaryToJson:options];

    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSendMessage(proxy, operationID, optionsJson);
}

RCT_EXPORT_METHOD(sendMessageNotOss:(NSString *)operationID offlinePushInfo:(NSDictionary *)offlinePushInfo resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *message = offlinePushInfo[@"message"];
    NSString *receiver = offlinePushInfo[@"receiver"];
    NSString *groupID = offlinePushInfo[@"groupID"];

    NSDictionary *options = @{
        @"message": message,
        @"receiver": receiver,
        @"groupID": groupID
    };
    NSString *optionsJson = [self dictionaryToJson:options];

    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSendMessageNotOss(proxy, operationID, optionsJson);
}


////
/*RCT_EXPORT_METHOD(changeGroupMemberMute:(NSString *)opid options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = [options objectForKey:@"groupID"];
    NSString *userID = [options objectForKey:@"userID"];
    NSNumber *mutedSeconds = [options objectForKey:@"mutedSeconds"];
    Open_im_sdkChangeGroupMemberMute(proxy, opid, groupID, userID, mutedSeconds.intValue);
}

RCT_EXPORT_METHOD(createGroup:(NSDictionary *)ginfo mList:(NSArray *)mList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkCreateGroup(proxy,opid,[ginfo json], [mList json]);
}

RCT_EXPORT_METHOD(setGroupInfo:(NSString *)gid ginfo:(NSDictionary *)ginfo opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetGroupInfo(proxy,opid,gid,[ginfo json]);
}

RCT_EXPORT_METHOD(getGroupsInfo:(NSArray *)gids opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupsInfo(proxy,opid,[gids json]);
}

RCT_EXPORT_METHOD(joinGroup:(NSString *)gid reason:(NSString *)reason opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkJoinGroup(proxy,opid,gid, reason);
}

RCT_EXPORT_METHOD(quitGroup:(NSString *)gid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkQuitGroup(proxy,opid,gid);
}

RCT_EXPORT_METHOD(transferGroupOwner:(NSString *)gid uid:(NSString *)uid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkTransferGroupOwner(proxy,opid,gid, uid);
}

RCT_EXPORT_METHOD(getRecvGroupApplicationList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetRecvGroupApplicationList(proxy,opid);
}

RCT_EXPORT_METHOD(getSendGroupApplicationList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetSendGroupApplicationList(proxy,opid);
}

RCT_EXPORT_METHOD(acceptGroupApplication:(NSString *)gid fuid:(NSString *)fuid handleMsg:(NSString *)handleMsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAcceptGroupApplication(proxy,opid,gid,fuid,handleMsg);
}

RCT_EXPORT_METHOD(refuseGroupApplication:(NSString *)gid fuid:(NSString *)fuid handleMsg:(NSString *)handleMsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRefuseGroupApplication(proxy,opid,gid,fuid,handleMsg);
}


RCT_EXPORT_METHOD(sendMessage:(NSString *)msg recid:(NSString *)recid gid:(NSString *)gid offlinePushInfo:(NSDictionary *)offlinePushInfo opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:msg module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessage(proxy,opid, msg, recid, gid, [offlinePushInfo json]);
}

RCT_EXPORT_METHOD(sendMessageNotOss:(NSString *)msg recid:(NSString *)recid gid:(NSString *)gid offlinePushInfo:(NSDictionary *)offlinePushInfo opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:msg module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessageNotOss(proxy,opid, msg, recid, gid, [offlinePushInfo json]);
}

RCT_EXPORT_METHOD(getHistoryMessageList:(NSDictionary *)options opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetHistoryMessageList(proxy,opid, [options json]);
}

RCT_EXPORT_METHOD(revokeMessage:(NSDictionary *)msg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRevokeMessage(proxy,opid, [msg json]);
}

RCT_EXPORT_METHOD(deleteMessageFromLocalStorage:(NSDictionary *)msg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteMessageFromLocalStorage(proxy,opid, [msg json]);
}

RCT_EXPORT_METHOD(insertSingleMessageToLocalStorage:(NSDictionary *)msg recv:(NSString *)recv sender:(NSString *)sender opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkInsertSingleMessageToLocalStorage(proxy,opid, [msg json], recv, sender);
}

RCT_EXPORT_METHOD(insertGroupMessageToLocalStorage:(NSDictionary *)msg gid:(NSString *)gid sender:(NSString *)sender opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkInsertGroupMessageToLocalStorage(proxy,opid, [msg json], gid, sender);
}


RCT_EXPORT_METHOD(searchLocalMessages:(NSArray *)params opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSearchLocalMessages(proxy,opid, [params json]);
}

RCT_EXPORT_METHOD(markC2CMessageAsRead:(NSString *)uid mids:(NSArray *)mids opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkMarkC2CMessageAsRead(proxy,opid, uid, [mids json]);
}

RCT_EXPORT_METHOD(typingStatusUpdate:(NSString *)uid tip:(NSString *)tip opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkTypingStatusUpdate(proxy,opid,uid, tip);
}

RCT_EXPORT_METHOD(createTextMessage:(NSString *)text opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateTextMessage(opid,text);
    resolver(msg);
}

RCT_EXPORT_METHOD(createTextAtMessage:(NSString *)text atIDs:(NSArray *)atIDs atInfos:(NSArray *)atInfos quteMsg:(NSDictionary *)quteMsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateTextAtMessage(opid,text, [atIDs json], [atInfos json], [quteMsg json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createImageMessage:(NSString *)path opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateImageMessage(opid,path);
    resolver(msg);
}

RCT_EXPORT_METHOD(createImageMessageFromFullPath:(NSString *)path opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateImageMessageFromFullPath(opid,path);
    resolver(msg);
}

RCT_EXPORT_METHOD(createImageMessageByURL:(NSDictionary *)sourcePicture bigPicture:(NSDictionary *)bigPicture snapshotPicture:(NSDictionary *)snapshotPicture opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateImageMessageByURL(opid,[sourcePicture json],[bigPicture json],[snapshotPicture json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createSoundMessage:(NSString *)path duration:(nonnull NSNumber *)duration opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateSoundMessage(opid,path, [duration intValue]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createSoundMessageFromFullPath:(NSString *)path duration:(nonnull NSNumber *)duration opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateSoundMessageFromFullPath(opid,path, [duration intValue]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createSoundMessageByURL:(NSDictionary *)soundBaseInfo opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateSoundMessageByURL(opid,[soundBaseInfo json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createVideoMessage:(NSString *)path type:(NSString *)type duration:(nonnull NSNumber *)duration snapshotPath:(NSString *)snapshotPath opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateVideoMessage(opid,path, type, [duration intValue], snapshotPath);
    resolver(msg);
}

RCT_EXPORT_METHOD(createVideoMessageFromFullPath:(NSString *)path type:(NSString *)type duration:(nonnull NSNumber *)duration snapshotPath:(NSString *)snapshotPath opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateVideoMessageFromFullPath(opid,path, type, [duration intValue], snapshotPath);
    resolver(msg);
}

RCT_EXPORT_METHOD(createVideoMessageByURL:(NSDictionary *)info opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateVideoMessageByURL(opid,[info json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createFileMessage:(NSString *)path name:(NSString *)name opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateFileMessage(opid,path, name);
    resolver(msg);
}


RCT_EXPORT_METHOD(createFileMessageFromFullPath:(NSString *)path name:(NSString *)name opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateFileMessageFromFullPath(opid,path, name);
    resolver(msg);
}

RCT_EXPORT_METHOD(createFileMessageByURL:(NSDictionary *)info opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateFileMessageByURL(opid,[info json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createMergerMessage:(NSArray *)msgList title:(NSString *)title summaryList:(NSArray *)summaryList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateMergerMessage(opid,[msgList json], title, [summaryList json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createForwardMessage:(NSDictionary *)fmsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateForwardMessage(opid,[fmsg json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createLocationMessage:(double)latitude longitude:(double)longitude desc:(NSString *)desc opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateLocationMessage(opid,desc, longitude, latitude);
    resolver(msg);
}

RCT_EXPORT_METHOD(createCustomMessage:(NSString *)data ex:(NSString *)ex desc:(NSString *)desc opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateCustomMessage(opid,data, ex, desc);
    resolver(msg);
}

RCT_EXPORT_METHOD(createQuoteMessage:(NSString *)text qmsg:(NSDictionary *)qmsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateQuoteMessage(opid,text, [qmsg json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createCardMessage:(NSString *)content opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateCardMessage(opid,content);
    resolver(msg);
}

RCT_EXPORT_METHOD(clearC2CHistoryMessage:(NSString *)uid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkClearC2CHistoryMessage(proxy,opid, uid);
}

RCT_EXPORT_METHOD(clearGroupHistoryMessage:(NSString *)gid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkClearGroupHistoryMessage(proxy,opid, gid);
}

RCT_EXPORT_METHOD(signalingInvite:(NSDictionary *)signalInviteReq opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSignalingInvite(proxy, opid, [signalInviteReq json]);
}

RCT_EXPORT_METHOD(signalingInviteInGroup:(NSDictionary *)signalInviteInGroupReq opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSignalingInviteInGroup(proxy, opid, [signalInviteInGroupReq json]);
}

RCT_EXPORT_METHOD(signalingAccept:(NSDictionary *)signalAcceptReq opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSignalingAccept(proxy, opid, [signalAcceptReq json]);
}

RCT_EXPORT_METHOD(signalingCancel:(NSDictionary *)signalCancelReq opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSignalingCancel(proxy, opid, [signalCancelReq json]);
}

RCT_EXPORT_METHOD(signalingReject:(NSDictionary *)signalRejectReq opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSignalingReject(proxy, opid, [signalRejectReq json]);
}

RCT_EXPORT_METHOD(signalingHungUp:(NSDictionary *)signalHungUpReq opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSignalingHungUp(proxy, opid, [signalHungUpReq json]);
}*/





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

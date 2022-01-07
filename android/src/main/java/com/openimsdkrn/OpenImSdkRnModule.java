
package com.openimsdkrn;



import com.alibaba.fastjson.JSON;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;


import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

import com.openimsdkrn.listener.AdvancedMsgListener;
import com.openimsdkrn.listener.InitSDKListener;
import com.openimsdkrn.listener.OnConversationListener;
import com.openimsdkrn.listener.OnFriendshipListener;
import com.openimsdkrn.listener.OnGroupListener;
import open_im_sdk.Open_im_sdk;

public class OpenImSdkRnModule extends ReactContextBaseJavaModule {

    final private ReactApplicationContext reactContext;

    public OpenImSdkRnModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "OpenIMSDKRN";
    }

    private String readableMap2string(ReadableMap map){
        JSONObject json = JSONObject.parseObject(map.toString());
        JSONObject json2 = json.getJSONObject("NativeMap");
        return json2.toJSONString();
    }

    @ReactMethod
    public void addListener(String eventName) {
        // Set up any upstream listeners or background tasks as necessary
    }

    @ReactMethod
    public void removeListeners(Integer count) {
        // Remove upstream listeners, stop unnecessary background tasks
    }

    @ReactMethod
    public void initSDK(ReadableMap options, Promise promise) {
        boolean initialized = Open_im_sdk.initSDK(readableMap2string(options), new InitSDKListener(reactContext));
        setConversationListener();
        setFriendListener();
        setGroupListener();
        addAdvancedMsgListener();
        if(initialized){
            promise.resolve("init success");
        }else{
            promise.reject("-1","please check params and dir" );
        }
    }

    @ReactMethod
    public void login(String uid, String token, Promise promise) {
        Open_im_sdk.login(uid, token, new BaseImpl(promise));
    }

    @ReactMethod
    public void logout(Promise promise) {
        Open_im_sdk.logout(new BaseImpl(promise));
    }

    @ReactMethod
    public void getLoginStatus(Promise promise) {
        long status = Open_im_sdk.getLoginStatus();
        promise.resolve((int)status);
    }

    @ReactMethod
    public void getUsersInfo(ReadableArray uidList, Promise promise) {
        Open_im_sdk.getUsersInfo(uidList.toString(), new BaseImpl(promise));
    }

    @ReactMethod
    public void setSelfInfo(ReadableMap userInfo,Promise promise) {
        Open_im_sdk.setSelfInfo(readableMap2string(userInfo), new BaseImpl(promise));
    }


//    Conversation
    @ReactMethod
    public void setConversationListener() {
        Open_im_sdk.setConversationListener(new OnConversationListener(reactContext));
    }

    @ReactMethod
    public void getAllConversationList(Promise promise) {
        Open_im_sdk.getAllConversationList(new BaseImpl(promise));
    }

    @ReactMethod
    public void getConversationListSplit(Integer offset, Integer count, Promise promise) {
        Open_im_sdk.getConversationListSplit(new BaseImpl(promise), offset, count);
    }

    @ReactMethod
    public void markSingleMessageHasRead(String uid, Promise promise) {
        Open_im_sdk.markSingleMessageHasRead(new BaseImpl(promise), uid);
    }

    @ReactMethod
    public void markGroupMessageHasRead(String gid, Promise promise) {
        Open_im_sdk.markGroupMessageHasRead(new BaseImpl(promise), gid);
    }

    @ReactMethod
    public void getTotalUnreadMsgCount(Promise promise) {
        Open_im_sdk.getTotalUnreadMsgCount(new BaseImpl(promise));
    }

    @ReactMethod
    public void pinConversation(String conversationID, Boolean isPinned, Promise promise) {
        Open_im_sdk.pinConversation(conversationID, isPinned, new BaseImpl(promise));
    }

    @ReactMethod
    public void setConversationDraft(String conversationID, String draft, Promise promise) {
        Open_im_sdk.setConversationDraft(conversationID, draft, new BaseImpl(promise));
    }

    @ReactMethod
    public void deleteConversation(String conversationID, Promise promise) {
        Open_im_sdk.deleteConversation(conversationID, new BaseImpl(promise));
    }

    @ReactMethod
    public void getMultipleConversation(ReadableArray conversationIDs, Promise promise) {
        Open_im_sdk.getMultipleConversation(conversationIDs.toString(), new BaseImpl(promise));
    }

    @ReactMethod
    public void getOneConversation(String sourceId, Integer sessionType, Promise promise) {
        Open_im_sdk.getOneConversation(sourceId, sessionType, new BaseImpl(promise));
    }

    @ReactMethod
    public void getConversationID(String sourceId, Integer sessionType, Promise promise) {
        String id = Open_im_sdk.getConversationIDBySessionType(sourceId, sessionType);
        promise.resolve(id);
    }

    @ReactMethod
    public void setConversationRecvMessageOpt(ReadableArray conversationIDs, Integer status, Promise promise) {
        Open_im_sdk.setConversationRecvMessageOpt(new BaseImpl(promise), conversationIDs.toString(), status);
    }

    @ReactMethod
    public void getConversationRecvMessageOpt(ReadableArray conversationIDs, Promise promise) {
        Open_im_sdk.getConversationRecvMessageOpt(new BaseImpl(promise), conversationIDs.toString());
    }

//    friend relationship
    @ReactMethod
    public void setFriendListener() {
        Open_im_sdk.setFriendListener(new OnFriendshipListener(reactContext));
    }

    @ReactMethod
    public void getFriendList(Promise promise) {
        Open_im_sdk.getFriendList(new BaseImpl(promise));
    }

    @ReactMethod
    public void getFriendApplicationList(Promise promise) {
        Open_im_sdk.getFriendApplicationList(new BaseImpl(promise));
    }

    @ReactMethod
    public void addFriend(ReadableMap paramsReq, Promise promise) {
        Open_im_sdk.addFriend(new BaseImpl(promise), readableMap2string(paramsReq));
    }

    @ReactMethod
    public void getFriendsInfo(ReadableArray uidList, Promise promise) {
        Open_im_sdk.getFriendsInfo(new BaseImpl(promise), uidList.toString());
    }

    @ReactMethod
    public void setFriendInfo(ReadableMap friendInfo, Promise promise) {
        Open_im_sdk.setFriendInfo(readableMap2string(friendInfo), new BaseImpl(promise));
    }

    @ReactMethod
    public void refuseFriendApplication(String uid, Promise promise) {
        Open_im_sdk.refuseFriendApplication(new BaseImpl(promise), JSON.toJSONString(uid));
    }

    @ReactMethod
    public void acceptFriendApplication(String uid, Promise promise) {
        Open_im_sdk.acceptFriendApplication(new BaseImpl(promise), JSON.toJSONString(uid));
    }

    @ReactMethod
    public void deleteFromFriendList(String uid, Promise promise) {
        Open_im_sdk.deleteFromFriendList(JSON.toJSONString(uid), new BaseImpl(promise));
    }

    @ReactMethod
    public void checkFriend(ReadableArray uidList, Promise promise) {
        Open_im_sdk.checkFriend(new BaseImpl(promise), uidList.toString());
    }

    @ReactMethod
    public void deleteFromBlackList(String uid, Promise promise) {
        Open_im_sdk.deleteFromBlackList(new BaseImpl(promise), JSON.toJSONString(uid));
    }

    @ReactMethod
    public void getBlackList(Promise promise) {
        Open_im_sdk.getBlackList(new BaseImpl(promise));
    }

    @ReactMethod
    public void addToBlackList(String uid, Promise promise) {
        Open_im_sdk.addToBlackList(new BaseImpl(promise), JSON.toJSONString(uid));
    }

    // group
    @ReactMethod
    public void setGroupListener() {
        Open_im_sdk.setGroupListener(new OnGroupListener(reactContext));
    }

    @ReactMethod
    public void inviteUserToGroup(String groupId, String reason,ReadableArray uidList, Promise promise) {
        Open_im_sdk.inviteUserToGroup(groupId, reason, uidList.toString(), new BaseImpl(promise));
    }

    @ReactMethod
    public void kickGroupMember(String groupId, ReadableArray uidList, String reason, Promise promise) {
        Open_im_sdk.kickGroupMember(groupId, reason, uidList.toString(), new BaseImpl(promise));
    }

    @ReactMethod
    public void getGroupMembersInfo(String groupId, ReadableArray uidList, Promise promise) {
        Open_im_sdk.getGroupMembersInfo(groupId, uidList.toString(), new BaseImpl(promise));
    }

    @ReactMethod
    public void getGroupMemberList(String groupId, Integer filter, Integer next, Promise promise) {
        Open_im_sdk.getGroupMemberList(groupId, filter, next, new BaseImpl(promise));
    }

    @ReactMethod
    public void getJoinedGroupList(Promise promise) {
        Open_im_sdk.getJoinedGroupList(new BaseImpl(promise));
    }

    @ReactMethod
    public void createGroup( ReadableMap gInfo,ReadableArray memberList,Promise promise) {
        Open_im_sdk.createGroup(readableMap2string(gInfo), memberList.toString(), new BaseImpl(promise));
    }

    @ReactMethod
    public void setGroupInfo(ReadableMap groupInfo,Promise promise) {
        Open_im_sdk.setGroupInfo(readableMap2string(groupInfo), new BaseImpl(promise));
    }

    @ReactMethod
    public void getGroupsInfo(ReadableArray gidList,Promise promise) {
        Open_im_sdk.getGroupsInfo(gidList.toString(), new BaseImpl(promise));
    }

    @ReactMethod
    public void joinGroup(String gid, String reason,Promise promise) {
        Open_im_sdk.joinGroup(gid,reason, new BaseImpl(promise));
    }

    @ReactMethod
    public void quitGroup(String gid,Promise promise) {
        Open_im_sdk.quitGroup(gid, new BaseImpl(promise));
    }

    @ReactMethod
    public void transferGroupOwner(String gid, String uid,Promise promise) {
        Open_im_sdk.transferGroupOwner(gid,uid, new BaseImpl(promise));
    }

    @ReactMethod
    public void getGroupApplicationList(Promise promise) {
        Open_im_sdk.getGroupApplicationList(new BaseImpl(promise));
    }

    @ReactMethod
    public void acceptGroupApplication(ReadableMap apInfo, String reason,Promise promise) {
        Open_im_sdk.acceptGroupApplication(readableMap2string(apInfo),reason, new BaseImpl(promise));
    }

    @ReactMethod
    public void refuseGroupApplication(ReadableMap apInfo, String reason,Promise promise) {
        Open_im_sdk.refuseGroupApplication(readableMap2string(apInfo),reason, new BaseImpl(promise));
    }

    @ReactMethod
    public void addAdvancedMsgListener(){
        Open_im_sdk.addAdvancedMsgListener(new AdvancedMsgListener(reactContext));
    }

    @ReactMethod
    public void sendMessage(String message, String receiver, String groupID, Boolean onlineUserOnly,Promise promise){
        Open_im_sdk.sendMessage(new SendMsgCallBack(reactContext,promise,message),message,receiver,groupID,onlineUserOnly);
    }

    @ReactMethod
    public void sendMessageNotOss(String message, String receiver, String groupID, Boolean onlineUserOnly,Promise promise){
        Open_im_sdk.sendMessageNotOss(new SendMsgCallBack(reactContext,promise,message),message,receiver,groupID,onlineUserOnly);
    }

    @ReactMethod
    public void getHistoryMessageList(ReadableMap options, Promise promise) {
        Open_im_sdk.getHistoryMessageList( new BaseImpl(promise),readableMap2string(options));
    }

    @ReactMethod
    public void revokeMessage(ReadableMap message, Promise promise) {
        Open_im_sdk.revokeMessage( new BaseImpl(promise),readableMap2string(message));
    }

    @ReactMethod
    public void deleteMessageFromLocalStorage(ReadableMap message, Promise promise) {
        Open_im_sdk.deleteMessageFromLocalStorage( new BaseImpl(promise),readableMap2string(message));
    }

    @ReactMethod
    public void insertSingleMessageToLocalStorage(ReadableMap message,String recv,String sender, Promise promise) {
        Open_im_sdk.insertSingleMessageToLocalStorage ( new BaseImpl(promise),readableMap2string(message),recv,sender);
    }

    @ReactMethod
    public void findMessages(ReadableArray msgIDs, Promise promise) {
        Open_im_sdk.findMessages( new BaseImpl(promise),msgIDs.toString());
    }

    @ReactMethod
    public void markC2CMessageAsRead(String uid, ReadableArray msgIDs, Promise promise) {
        Open_im_sdk.markC2CMessageAsRead( new BaseImpl(promise),uid,msgIDs.toString());
    }

    @ReactMethod
    public void typingStatusUpdate(String uid, String tip) {
        Open_im_sdk.typingStatusUpdate( uid,tip);
    }

    @ReactMethod
    public void createTextMessage(String text, Promise promise) {
        promise.resolve(Open_im_sdk.createTextMessage(text));
    }

    @ReactMethod
    public void createTextAtMessage(String text, ReadableArray ats, Promise promise) {
         promise.resolve(Open_im_sdk.createTextAtMessage( text,ats.toString()));
    }

    @ReactMethod
    public void createImageMessage(String path, Promise promise) {
         promise.resolve(Open_im_sdk.createImageMessage( path));
    }

    @ReactMethod
    public void createImageMessageByURL(ReadableMap sourceInfo,ReadableMap bigInfo,ReadableMap snaInfo, Promise promise) {
         promise.resolve(Open_im_sdk.createImageMessageByURL(readableMap2string(sourceInfo),readableMap2string(bigInfo),readableMap2string(snaInfo)));
    }

    @ReactMethod
    public void createImageMessageFromFullPath(String path, Promise promise) {
        promise.resolve(Open_im_sdk.createImageMessageFromFullPath(path));
    }

    @ReactMethod
    public void createSoundMessage(String path,Integer duration, Promise promise) {
         promise.resolve(Open_im_sdk.createSoundMessage( path,duration));
    }

    @ReactMethod
    public void createSoundMessageFromFullPath(String path,Integer duration, Promise promise) {
         promise.resolve(Open_im_sdk.createSoundMessageFromFullPath( path,duration));
    }

    @ReactMethod
    public void createSoundMessageByURL(ReadableMap info, Promise promise) {
        promise.resolve(Open_im_sdk.createSoundMessageByURL( readableMap2string(info)));
    }

    @ReactMethod
    public void createVideoMessage(String videoPath, String videoType, Integer duration, String snapshotPath, Promise promise) {
         promise.resolve(Open_im_sdk.createVideoMessage( videoPath,videoType,duration,snapshotPath));
    }

    @ReactMethod
    public void createVideoMessageFromFullPath(String videoPath, String videoType, Integer duration, String snapshotPath, Promise promise) {
         promise.resolve(Open_im_sdk.createVideoMessageFromFullPath( videoPath,videoType,duration,snapshotPath));
    }

    @ReactMethod
    public void createVideoMessageByURL(ReadableMap info, Promise promise) {
        promise.resolve(Open_im_sdk.createVideoMessageByURL(readableMap2string(info)));
    }

    @ReactMethod
    public void createFileMessage(String path,String fileName, Promise promise) {
         promise.resolve( Open_im_sdk.createFileMessage( path,fileName));
    }

    @ReactMethod
    public void createFileMessageFromFullPath(String path,String fileName, Promise promise) {
         promise.resolve(Open_im_sdk.createFileMessageFromFullPath( path,fileName));
    }

    @ReactMethod
    public void createFileMessageByURL(ReadableMap info, Promise promise) {
        promise.resolve(Open_im_sdk.createFileMessageByURL( readableMap2string(info)));
    }

    @ReactMethod
    public void createMergerMessage(ReadableArray messageList, String title, ReadableArray summaryList, Promise promise){
         promise.resolve(Open_im_sdk.createMergerMessage(messageList.toString(),title,summaryList.toString()));
    }

    @ReactMethod
    public void createForwardMessage(ReadableMap message, Promise promise) {
         promise.resolve(Open_im_sdk.createForwardMessage( readableMap2string(message)));
    }

    @ReactMethod
    public void createLocationMessage(Double latitude, Double longitude, String description, Promise promise){
         promise.resolve(Open_im_sdk.createLocationMessage(description,longitude,latitude));
    }

    @ReactMethod
    public void createCustomMessage(String data, String ex, String description, Promise promise){
         promise.resolve(Open_im_sdk.createCustomMessage(data,ex,description));
    }

    @ReactMethod
    public void createQuoteMessage(String text, ReadableMap message, Promise promise){
         promise.resolve(Open_im_sdk.createQuoteMessage(text,readableMap2string(message)));
    }

    @ReactMethod
    public void createCardMessage(String content, Promise promise){
         promise.resolve(Open_im_sdk.createCardMessage(content));
    }

    @ReactMethod
    public void forceSyncMsg(){
         Open_im_sdk.forceSyncMsg();
    }

    @ReactMethod
    public void clearC2CHistoryMessage(String uid,Promise promise){
        Open_im_sdk.clearC2CHistoryMessage(new BaseImpl(promise), uid);
    }

    @ReactMethod
    public void clearGroupHistoryMessage(String gid,Promise promise){
        Open_im_sdk.clearGroupHistoryMessage(new BaseImpl(promise), gid);
    }
}

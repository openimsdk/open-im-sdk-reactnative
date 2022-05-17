
package com.openimsdkrn;

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
import com.openimsdkrn.listener.UserListener;
import com.openimsdkrn.listener.OnSignalingListener;

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
    public void initSDK(ReadableMap options,String operationID, Promise promise) {
        boolean initialized = Open_im_sdk.initSDK(new InitSDKListener(reactContext),operationID,readableMap2string(options));
        setUserListener();
        setConversationListener();
        setFriendListener();
        setGroupListener();
        addAdvancedMsgListener();
        addSignalingListener();
        if(initialized){
            promise.resolve("init success");
        }else{
            promise.reject("-1","please check params and dir" );
        }
    }

  @ReactMethod
  public void setUserListener() {
    Open_im_sdk.setUserListener(new UserListener(reactContext));
  }

    @ReactMethod
    public void login(String uid,String token,String operationID,Promise promise) {
        Open_im_sdk.login(new BaseImpl(promise),operationID,uid,token);
    }

    @ReactMethod
    public void logout(String operationID,Promise promise) {
        Open_im_sdk.logout(new BaseImpl(promise),operationID);
    }

    @ReactMethod
    public void getLoginStatus(Promise promise) {
        long status = Open_im_sdk.getLoginStatus();
        promise.resolve((int)status);
    }

    @ReactMethod
    public void getUsersInfo(ReadableArray uidList,String operationID,Promise promise) {
        Open_im_sdk.getUsersInfo(new BaseImpl(promise),operationID,uidList.toString());
    }

    @ReactMethod
    public void setSelfInfo(ReadableMap userInfo,String operationID,Promise promise) {
        Open_im_sdk.setSelfInfo(new BaseImpl(promise),operationID,readableMap2string(userInfo));
    }

  @ReactMethod
  public void getSelfUserInfo(String operationID,Promise promise) {
    Open_im_sdk.getSelfUserInfo(new BaseImpl(promise),operationID);
  }


//    Conversation
    @ReactMethod
    public void setConversationListener() {
        Open_im_sdk.setConversationListener(new OnConversationListener(reactContext));
    }

    @ReactMethod
    public void getAllConversationList(String operationID,Promise promise) {
        Open_im_sdk.getAllConversationList(new BaseImpl(promise),operationID);
    }

    @ReactMethod
    public void getConversationListSplit(Integer offset, Integer count, String operationID, Promise promise) {
        Open_im_sdk.getConversationListSplit(new BaseImpl(promise),operationID, offset, count);
    }

    @ReactMethod
    public void markGroupMessageHasRead(String gid,String operationID, Promise promise) {
        Open_im_sdk.markGroupMessageHasRead(new BaseImpl(promise),operationID, gid);
    }

    @ReactMethod
    public void getTotalUnreadMsgCount(String operationID,Promise promise) {
        Open_im_sdk.getTotalUnreadMsgCount(new BaseImpl(promise),operationID);
    }

    @ReactMethod
    public void pinConversation(String conversationID, Boolean isPinned,String operationID,Promise promise) {
        Open_im_sdk.pinConversation(new BaseImpl(promise),operationID,conversationID, isPinned);
    }

    @ReactMethod
    public void setConversationDraft(String conversationID, String draft,String operationID, Promise promise) {
        Open_im_sdk.setConversationDraft(new BaseImpl(promise),operationID,conversationID, draft);
    }

    @ReactMethod
    public void deleteConversation(String conversationID,String operationID, Promise promise) {
        Open_im_sdk.deleteConversation(new BaseImpl(promise),operationID,conversationID);
    }

    @ReactMethod
    public void getMultipleConversation(ReadableArray conversationIDs,String operationID, Promise promise) {
        Open_im_sdk.getMultipleConversation(new BaseImpl(promise),operationID,conversationIDs.toString());
    }

    @ReactMethod
    public void getOneConversation(String sourceId, Integer sessionType,String operationID, Promise promise) {
        Open_im_sdk.getOneConversation(new BaseImpl(promise),operationID,sessionType,sourceId);
    }

    @ReactMethod
    public void getConversationIDBySessionType(String sourceId, Integer sessionType, Promise promise) {
        String id = Open_im_sdk.getConversationIDBySessionType(sourceId, sessionType);
        promise.resolve(id);
    }

    @ReactMethod
    public void setConversationRecvMessageOpt(ReadableArray conversationIDs, Integer status,String operationID, Promise promise) {
        Open_im_sdk.setConversationRecvMessageOpt(new BaseImpl(promise),operationID, conversationIDs.toString(), status);
    }

    @ReactMethod
    public void getConversationRecvMessageOpt(ReadableArray conversationIDs,String operationID, Promise promise) {
        Open_im_sdk.getConversationRecvMessageOpt(new BaseImpl(promise),operationID, conversationIDs.toString());
    }

//    friend relationship
    @ReactMethod
    public void setFriendListener() {
        Open_im_sdk.setFriendListener(new OnFriendshipListener(reactContext));
    }

  @ReactMethod
  public void getDesignatedFriendsInfo(ReadableArray userIDList,String operationID,Promise promise) {
    Open_im_sdk.getDesignatedFriendsInfo(new BaseImpl(promise),operationID,userIDList.toString());
  }

    @ReactMethod
    public void getFriendList(String operationID,Promise promise) {
        Open_im_sdk.getFriendList(new BaseImpl(promise),operationID);
    }

    @ReactMethod
    public void addFriend(ReadableMap paramsReq,String operationID, Promise promise) {
        Open_im_sdk.addFriend(new BaseImpl(promise),operationID, readableMap2string(paramsReq));
    }

    @ReactMethod
    public void setFriendRemark(String userIDRemark,String operationID, Promise promise) {
      Open_im_sdk.setFriendRemark(new BaseImpl(promise),operationID, userIDRemark);
    }

    @ReactMethod
    public void deleteFriend(String friendUserID,String operationID, Promise promise) {
      Open_im_sdk.deleteFriend(new BaseImpl(promise),operationID, friendUserID);
    }

    @ReactMethod
    public void getRecvFriendApplicationList(String operationID, Promise promise) {
      Open_im_sdk.getRecvFriendApplicationList(new BaseImpl(promise),operationID);
    }

    @ReactMethod
    public void getSendFriendApplicationList(String operationID, Promise promise) {
      Open_im_sdk.getSendFriendApplicationList(new BaseImpl(promise),operationID);
    }

    @ReactMethod
    public void refuseFriendApplication(ReadableMap userIDHandleMsg,String operationID, Promise promise) {
        Open_im_sdk.refuseFriendApplication(new BaseImpl(promise),operationID, readableMap2string(userIDHandleMsg));
    }

    @ReactMethod
    public void addBlack(String blackUserID,String operationID, Promise promise) {
      Open_im_sdk.addBlack(new BaseImpl(promise),operationID, blackUserID);
    }

    @ReactMethod
    public void acceptFriendApplication(ReadableMap userIDHandleMsg,String operationID, Promise promise) {
        Open_im_sdk.acceptFriendApplication(new BaseImpl(promise),operationID, readableMap2string(userIDHandleMsg));
    }


    @ReactMethod
    public void checkFriend(ReadableArray uidList,String operationID, Promise promise) {
        Open_im_sdk.checkFriend(new BaseImpl(promise),operationID, uidList.toString());
    }


    @ReactMethod
    public void getBlackList(String operationID,Promise promise) {
        Open_im_sdk.getBlackList(new BaseImpl(promise),operationID);
    }

    @ReactMethod
    public void removeBlack(String removeUserID,String operationID,Promise promise) {
      Open_im_sdk.removeBlack(new BaseImpl(promise),operationID,removeUserID);
    }

    // group
    @ReactMethod
    public void setGroupListener() {
        Open_im_sdk.setGroupListener(new OnGroupListener(reactContext));
    }

    @ReactMethod
    public void inviteUserToGroup(String groupId, String reason,ReadableArray uidList,String operationID, Promise promise) {
        Open_im_sdk.inviteUserToGroup(new BaseImpl(promise),operationID,groupId, reason, uidList.toString());
    }

    @ReactMethod
    public void getRecvGroupApplicationList(String operationID, Promise promise) {
      Open_im_sdk.getRecvGroupApplicationList(new BaseImpl(promise),operationID);
    }

    @ReactMethod
    public void kickGroupMember(String groupId, ReadableArray uidList, String reason,String operationID, Promise promise) {
        Open_im_sdk.kickGroupMember(new BaseImpl(promise),operationID,groupId, reason, uidList.toString());
    }

    @ReactMethod
    public void getGroupMembersInfo(String groupId, ReadableArray uidList,String operationID, Promise promise) {
        Open_im_sdk.getGroupMembersInfo(new BaseImpl(promise),operationID,groupId, uidList.toString());
    }

    @ReactMethod
    public void getGroupMemberList(String groupId, Integer filter, Integer offset,Integer count,String operationID, Promise promise) {
        Open_im_sdk.getGroupMemberList(new BaseImpl(promise),operationID,groupId, filter, offset, count);
    }

    @ReactMethod
    public void getJoinedGroupList(String operationID,Promise promise) {
        Open_im_sdk.getJoinedGroupList(new BaseImpl(promise),operationID);
    }

    @ReactMethod
    public void createGroup( ReadableMap gInfo,ReadableArray memberList,String operationID,Promise promise) {
        Open_im_sdk.createGroup(new BaseImpl(promise),operationID,readableMap2string(gInfo), memberList.toString());
    }

    @ReactMethod
    public void setGroupInfo(String groupID,ReadableMap groupInfo,String operationID,Promise promise) {
        Open_im_sdk.setGroupInfo(new BaseImpl(promise),operationID,groupID,readableMap2string(groupInfo));
    }

    @ReactMethod
    public void getGroupsInfo(ReadableArray gidList,String operationID,Promise promise) {
        Open_im_sdk.getGroupsInfo(new BaseImpl(promise),operationID,gidList.toString());
    }

    @ReactMethod
    public void joinGroup(String gid, String reason,String operationID,Promise promise) {
        Open_im_sdk.joinGroup(new BaseImpl(promise),operationID,gid,reason);
    }

    @ReactMethod
    public void quitGroup(String gid,String operationID,Promise promise) {
        Open_im_sdk.quitGroup(new BaseImpl(promise),operationID,gid);
    }

    @ReactMethod
    public void transferGroupOwner(String gid, String uid,String operationID,Promise promise) {
        Open_im_sdk.transferGroupOwner(new BaseImpl(promise),operationID,gid,uid);
    }

    @ReactMethod
    public void acceptGroupApplication(String gid,String fromUserID, String handleMsg,String operationID,Promise promise) {
        Open_im_sdk.acceptGroupApplication(new BaseImpl(promise),operationID,gid,fromUserID,handleMsg);
    }

    @ReactMethod
    public void refuseGroupApplication(String gid,String fromUserID, String handleMsg,String operationID,Promise promise) {
        Open_im_sdk.refuseGroupApplication(new BaseImpl(promise),operationID,gid,fromUserID,handleMsg);
    }

    @ReactMethod
    public void addAdvancedMsgListener(){
        Open_im_sdk.setAdvancedMsgListener(new AdvancedMsgListener(reactContext));
    }

    @ReactMethod
    public void sendMessage(String message, String receiver, String groupID, ReadableMap offlinePushInfo,String operationID,Promise promise){
        Open_im_sdk.sendMessage(new SendMsgCallBack(reactContext,promise,message),operationID,message,receiver,groupID,readableMap2string(offlinePushInfo));
    }

    @ReactMethod
    public void sendMessageNotOss(String message, String receiver, String groupID, ReadableMap offlinePushInfo,String operationID,Promise promise){
        Open_im_sdk.sendMessageNotOss(new SendMsgCallBack(reactContext,promise,message),operationID,message,receiver,groupID,readableMap2string(offlinePushInfo));
    }

    @ReactMethod
    public void getHistoryMessageList(ReadableMap options,String operationID, Promise promise) {
        Open_im_sdk.getHistoryMessageList( new BaseImpl(promise),operationID,readableMap2string(options));
    }

    @ReactMethod
    public void revokeMessage(ReadableMap message,String operationID, Promise promise) {
        Open_im_sdk.revokeMessage( new BaseImpl(promise),operationID,readableMap2string(message));
    }

    @ReactMethod
    public void deleteMessageFromLocalStorage(ReadableMap message,String operationID, Promise promise) {
        Open_im_sdk.deleteMessageFromLocalStorage( new BaseImpl(promise),operationID,readableMap2string(message));
    }

    @ReactMethod
    public void insertSingleMessageToLocalStorage(ReadableMap message,String recv,String sender,String operationID, Promise promise) {
        Open_im_sdk.insertSingleMessageToLocalStorage ( new BaseImpl(promise),operationID,readableMap2string(message),recv,sender);
    }

    @ReactMethod
    public void insertGroupMessageToLocalStorage(String message,String groupID,String sendID,String operationID, Promise promise) {
      Open_im_sdk.insertGroupMessageToLocalStorage ( new BaseImpl(promise),operationID,message,groupID,sendID);
    }

    @ReactMethod
    public void searchLocalMessages(ReadableMap searchParam,String operationID, Promise promise) {
      Open_im_sdk.searchLocalMessages ( new BaseImpl(promise),operationID,readableMap2string(searchParam));
    }

    @ReactMethod
    public void markC2CMessageAsRead(String uid, ReadableArray msgIDs,String operationID, Promise promise) {
        Open_im_sdk.markC2CMessageAsRead( new BaseImpl(promise),operationID,uid,msgIDs.toString());
    }

    @ReactMethod
    public void typingStatusUpdate(String uid, String tip,String operationID, Promise promise) {
        Open_im_sdk.typingStatusUpdate( new BaseImpl(promise),operationID,uid,tip);
    }

    @ReactMethod
    public void createTextMessage(String text, String operationID,Promise promise) {
        promise.resolve(Open_im_sdk.createTextMessage(operationID,text));
    }

    @ReactMethod
    public void createTextAtMessage(String text, ReadableArray ats,String operationID, Promise promise) {
         promise.resolve(Open_im_sdk.createTextAtMessage(operationID, text,ats.toString()));
    }

    @ReactMethod
    public void createImageMessage(String path,String operationID, Promise promise) {
         promise.resolve(Open_im_sdk.createImageMessage(operationID, path));
    }

    @ReactMethod
    public void createImageMessageByURL(ReadableMap sourceInfo,ReadableMap bigInfo,ReadableMap snaInfo,String operationID, Promise promise) {
         promise.resolve(Open_im_sdk.createImageMessageByURL(operationID,readableMap2string(sourceInfo),readableMap2string(bigInfo),readableMap2string(snaInfo)));
    }

    @ReactMethod
    public void createImageMessageFromFullPath(String path,String operationID, Promise promise) {
        promise.resolve(Open_im_sdk.createImageMessageFromFullPath(operationID,path));
    }

    @ReactMethod
    public void createSoundMessage(String path,Integer duration,String operationID, Promise promise) {
         promise.resolve(Open_im_sdk.createSoundMessage(operationID, path,duration));
    }

    @ReactMethod
    public void createSoundMessageFromFullPath(String path,Integer duration,String operationID, Promise promise) {
         promise.resolve(Open_im_sdk.createSoundMessageFromFullPath(operationID, path,duration));
    }

    @ReactMethod
    public void createSoundMessageByURL(ReadableMap info,String operationID, Promise promise) {
        promise.resolve(Open_im_sdk.createSoundMessageByURL(operationID, readableMap2string(info)));
    }

    @ReactMethod
    public void createVideoMessage(String videoPath, String videoType, Integer duration, String snapshotPath,String operationID, Promise promise) {
         promise.resolve(Open_im_sdk.createVideoMessage(operationID, videoPath,videoType,duration,snapshotPath));
    }

    @ReactMethod
    public void createVideoMessageFromFullPath(String videoPath, String videoType, Integer duration, String snapshotPath,String operationID, Promise promise) {
         promise.resolve(Open_im_sdk.createVideoMessageFromFullPath(operationID, videoPath,videoType,duration,snapshotPath));
    }

    @ReactMethod
    public void createVideoMessageByURL(ReadableMap info,String operationID, Promise promise) {
        promise.resolve(Open_im_sdk.createVideoMessageByURL(operationID,readableMap2string(info)));
    }

    @ReactMethod
    public void createFileMessage(String path,String fileName,String operationID, Promise promise) {
         promise.resolve( Open_im_sdk.createFileMessage(operationID, path,fileName));
    }

    @ReactMethod
    public void createFileMessageFromFullPath(String path,String fileName,String operationID, Promise promise) {
         promise.resolve(Open_im_sdk.createFileMessageFromFullPath(operationID, path,fileName));
    }

    @ReactMethod
    public void createFileMessageByURL(ReadableMap info,String operationID, Promise promise) {
        promise.resolve(Open_im_sdk.createFileMessageByURL(operationID, readableMap2string(info)));
    }

    @ReactMethod
    public void createMergerMessage(ReadableArray messageList, String title, ReadableArray summaryList,String operationID, Promise promise){
         promise.resolve(Open_im_sdk.createMergerMessage(operationID,messageList.toString(),title,summaryList.toString()));
    }

    @ReactMethod
    public void createForwardMessage(ReadableMap message,String operationID, Promise promise) {
         promise.resolve(Open_im_sdk.createForwardMessage(operationID, readableMap2string(message)));
    }

    @ReactMethod
    public void createLocationMessage(Double latitude, Double longitude, String description,String operationID, Promise promise){
         promise.resolve(Open_im_sdk.createLocationMessage(operationID,description,longitude,latitude));
    }

    @ReactMethod
    public void createCustomMessage(String data, String ex, String description,String operationID, Promise promise){
         promise.resolve(Open_im_sdk.createCustomMessage(operationID,data,ex,description));
    }

    @ReactMethod
    public void createQuoteMessage(String text, ReadableMap message,String operationID, Promise promise){
         promise.resolve(Open_im_sdk.createQuoteMessage(operationID,text,readableMap2string(message)));
    }

    @ReactMethod
    public void createCardMessage(String content,String operationID, Promise promise){
         promise.resolve(Open_im_sdk.createCardMessage(operationID,content));
    }

    @ReactMethod
    public void clearC2CHistoryMessage(String uid,String operationID,Promise promise){
        Open_im_sdk.clearC2CHistoryMessage(new BaseImpl(promise),operationID, uid);
    }

    @ReactMethod
    public void clearGroupHistoryMessage(String gid,String operationID,Promise promise){
        Open_im_sdk.clearGroupHistoryMessage(new BaseImpl(promise),operationID, gid);
    }

  //--------------
  @ReactMethod
  public void addSignalingListener(){
    Open_im_sdk.setSignalingListener(new OnSignalingListener(reactContext));
  }

  @ReactMethod
  public void signalingInvite(ReadableMap signalInviteReq,String operationID,Promise promise){
    Open_im_sdk.signalingInvite(new BaseImpl(promise), operationID, readableMap2string(signalInviteReq));
  }


  @ReactMethod
  public void signalingInviteInGroup(ReadableMap signalInviteInGroupReq,String operationID,Promise promise){
    Open_im_sdk.signalingInviteInGroup(new BaseImpl(promise), operationID, readableMap2string(signalInviteInGroupReq));
  }

  @ReactMethod
  public void signalingAccept(ReadableMap signalAcceptReq,String operationID,Promise promise){
    Open_im_sdk.signalingAccept(new BaseImpl(promise), operationID, readableMap2string(signalAcceptReq));
  }

  @ReactMethod
  public void signalingReject(ReadableMap signalRejectReq,String operationID,Promise promise){
    Open_im_sdk.signalingReject(new BaseImpl(promise), operationID, readableMap2string(signalRejectReq));
  }

  @ReactMethod
  public void signalingCancel(ReadableMap signalCancelReq,String operationID,Promise promise){
    Open_im_sdk.signalingCancel(new BaseImpl(promise), operationID, readableMap2string(signalCancelReq));
  }

  @ReactMethod
  public void signalingHungUp(ReadableMap signalHungUpReq,String operationID,Promise promise){
    Open_im_sdk.signalingHungUp(new BaseImpl(promise), operationID, readableMap2string(signalHungUpReq));
  }
}

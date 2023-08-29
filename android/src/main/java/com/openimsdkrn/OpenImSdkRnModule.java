
package com.openimsdkrn;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
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
import com.openimsdkrn.listener.UploadFileCallbackListener;
//import open_im_sdk_callback.OnAdvancedMsgListener;
//import open_im_sdk_callback.OnBatchMsgListener;
//import open_im_sdk_callback.OnConnListener;
//import open_im_sdk_callback.OnCustomBusinessListener;
//import open_im_sdk_callback.OnUserListener;
//import open_im_sdk_callback.SendMsgCallBack;
//import open_im_sdk_callback.UploadFileCallback;

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
//        JSONObject json = JSONObject.parseObject(map.toString());
//        String json2 = json.getString("map");

        return map.toString();
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
//        addSignalingListener();
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
    public void login(ReadableMap options,String operationID,Promise promise) {
        Open_im_sdk.login(new BaseImpl(promise),operationID,options.getString("userID"),options.getString("token"));
    }

    @ReactMethod
    public void logout(String operationID,Promise promise) {
        Open_im_sdk.logout(new BaseImpl(promise),operationID);
    }
    @ReactMethod
    public void setAppBackgroundStatus(boolean isBackground,String operationID,Promise promise){
        Open_im_sdk.setAppBackgroundStatus(new BaseImpl(promise),operationID,isBackground);
    }
    @ReactMethod
    public void networkStatusChange(String operationID,Promise promise){
        Open_im_sdk.networkStatusChanged(new BaseImpl(promise),operationID);
    }
    @ReactMethod
    public void getLoginStatus(String operationID,Promise promise) {
        long status = Open_im_sdk.getLoginStatus(operationID);
        promise.resolve((int)status);
    }
    @ReactMethod
    public void getLoginUserID(String operationID,Promise promise){
        String userID =  Open_im_sdk.getLoginUserID();
        promise.resolve(userID);

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
    public void getConversationListSplit(ReadableMap options, String operationID, Promise promise) {
        Open_im_sdk.getConversationListSplit(new BaseImpl(promise),operationID, options.getInt("offset"), options.getInt("count"));
    }//要改吗

    @ReactMethod
    public void getOneConversation(ReadableMap options,String operationID, Promise promise) {
        Open_im_sdk.getOneConversation(new BaseImpl(promise), operationID, options.getInt("sessionType"), options.getString("sourceID"));
    }

    @ReactMethod
    public void getMultipleConversation( ReadableArray conversationIDList,String operationID, Promise promise) {
        Open_im_sdk.getMultipleConversation(new BaseImpl(promise), operationID, conversationIDList.toString()); //会不会报错
    }

    @ReactMethod
    public void setGlobalRecvMessageOpt(int opt,String operationID,  Promise promise) {
        Open_im_sdk.setGlobalRecvMessageOpt(new BaseImpl(promise), operationID, opt);
    }

    @ReactMethod
    public void hideConversation( String conversationID,String operationID, Promise promise) {
        Open_im_sdk.hideConversation(new BaseImpl(promise), operationID, conversationID);
    }

    @ReactMethod
    public void getConversationRecvMessageOpt( ReadableArray conversationIDList,String operationID, Promise promise) {
        Open_im_sdk.getConversationRecvMessageOpt(new BaseImpl(promise), operationID, conversationIDList.toString());
    }

    @ReactMethod
    public void deleteAllConversationFromLocal(String operationID, Promise promise) {
        Open_im_sdk.deleteAllConversationFromLocal(new BaseImpl(promise), operationID);
    }

    @ReactMethod
    public void setConversationDraft( ReadableMap options,String operationID, Promise promise) {
        Open_im_sdk.setConversationDraft(new BaseImpl(promise), operationID, options.getString("conversationID"), options.getString("draftText"));
    }

    @ReactMethod
    public void resetConversationGroupAtType(String conversationID,String operationID,  Promise promise) {
        Open_im_sdk.resetConversationGroupAtType(new BaseImpl(promise), operationID, conversationID);
    }

    @ReactMethod
    public void pinConversation(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.pinConversation(new BaseImpl(promise), operationID, options.getString("conversationID"), options.getBoolean("isPinned"));
    }

    @ReactMethod
    public void setConversationPrivateChat(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.setConversationPrivateChat(new BaseImpl(promise), operationID, options.getString("conversationID"), options.getBoolean("isPrivate"));
    }

    @ReactMethod
    public void setConversationBurnDuration( ReadableMap options,String operationID, Promise promise) {
        Open_im_sdk.setConversationBurnDuration(new BaseImpl(promise), operationID, options.getString("conversationID"), options.getInt("burnDuration"));
    }

    @ReactMethod
    public void setConversationRecvMessageOpt(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.setConversationRecvMessageOpt(new BaseImpl(promise), operationID, options.getString("conversationID"), options.getInt("opt"));
    }

    @ReactMethod
    public void getTotalUnreadMsgCount(String operationID,Promise promise) {
        Open_im_sdk.getTotalUnreadMsgCount(new BaseImpl(promise),operationID);
    }
    @ReactMethod
    public String getAtAllTag(String OperationID) {
        return Open_im_sdk.getAtAllTag(OperationID);
    }

    @ReactMethod
    public String createAdvancedTextMessage( ReadableMap options,String OperationID) {
        return Open_im_sdk.createAdvancedTextMessage(OperationID, options.getString("text"), options.getArray("messageEntityList").toString());
    }

    @ReactMethod
    public String createTextAtMessage(ReadableMap options,String OperationID) {
        String messageJson = "";
        ReadableMap message = options.getMap("message");
        if (message != null) {
            messageJson = message.toString();
        }
        return Open_im_sdk.createTextAtMessage(OperationID, options.getString("text"), options.getArray("atUserIDList").toString(), options.getArray("atUsersInfo").toString(), messageJson);
    }

    @ReactMethod
    public void createTextMessage(String textMsg,String OperationID,Promise promise) {
        promise.resolve(Open_im_sdk.createTextMessage(OperationID, textMsg));
    }

    @ReactMethod
    public void createLocationMessage(ReadableMap options,String OperationID,Promise promise) {
        promise.resolve(Open_im_sdk.createLocationMessage(OperationID, options.getString("description"), options.getDouble("longitude"), options.getDouble("latitude")));
    }

    @ReactMethod
    public void createCustomMessage(ReadableMap options,String operationID,Promise promise) {
        promise.resolve(Open_im_sdk.createCustomMessage(operationID, options.getString("data"), options.getString("extension"), options.getString("description")));
    }
  @ReactMethod
  public void createQuoteMessage(ReadableMap options, String OperationID, Promise promise) {
    String result = Open_im_sdk.createQuoteMessage(OperationID, options.getString("text"), options.getMap("message").toString());
    promise.resolve(result);
  }

  @ReactMethod
  public void createAdvancedQuoteMessage(ReadableMap options, String OperationID, Promise promise) {
    String result = Open_im_sdk.createAdvancedQuoteMessage(OperationID, options.getString("text"), options.getMap("message").toString(), options.getArray("messageEntityList").toString());
    promise.resolve(result);
  }

  @ReactMethod
  public void createCardMessage(ReadableMap cardElem, String operationID, Promise promise) {
    String result = Open_im_sdk.createCardMessage(operationID, readableMap2string(cardElem));
    promise.resolve(result);
  }

  @ReactMethod
  public void createImageMessage(String imagePath, String OperationID, Promise promise) {
    String result = Open_im_sdk.createImageMessage(OperationID, imagePath);
    promise.resolve(result);
  }

  @ReactMethod
  public void createImageMessageFromFullPath(String imagePath, String OperationID, Promise promise) {
    String result = Open_im_sdk.createImageMessageFromFullPath(OperationID, imagePath);
    promise.resolve(result);
  }

  @ReactMethod
  public void createImageMessageByURL(ReadableMap options, String OperationID, Promise promise) {
    String jsonStr1 = options.getMap("sourcePicture").toString();
    String jsonStr2 = options.getMap("bigPicture").toString();
    String jsonStr3 = options.getMap("snapshotPicture").toString();
    String result = Open_im_sdk.createImageMessageByURL(OperationID, jsonStr1, jsonStr2, jsonStr3);
    promise.resolve(result);
  }

  @ReactMethod
  public void createSoundMessage(ReadableMap options, String OperationID, Promise promise) {
    String result = Open_im_sdk.createSoundMessage(OperationID, options.getString("soundPath"), options.getInt("duration"));
    promise.resolve(result);
  }

  @ReactMethod
  public void createSoundMessageFromFullPath(ReadableMap options, String OperationID, Promise promise) {
    String result = Open_im_sdk.createSoundMessageFromFullPath(OperationID, options.getString("soundPath"), options.getInt("duration"));
    promise.resolve(result);
  }

  @ReactMethod
  public void createSoundMessageByURL(ReadableMap soundInfo, String OperationID, Promise promise) {
    String result = Open_im_sdk.createSoundMessageByURL(OperationID, readableMap2string(soundInfo));
    promise.resolve(result);
  }

  @ReactMethod
  public void createVideoMessage(ReadableMap options, String OperationID, Promise promise) {
    String result = Open_im_sdk.createVideoMessage(OperationID, options.getString("videoPath"), options.getString("videoType"), options.getInt("duration"), options.getString("snapshotPath"));
    promise.resolve(result);
  }

  @ReactMethod
  public void createVideoMessageFromFullPath(ReadableMap options, String OperationID, Promise promise) {
    String result = Open_im_sdk.createVideoMessageFromFullPath(OperationID, options.getString("videoPath"), options.getString("videoType"), options.getInt("duration"), options.getString("snapshotPath"));
    promise.resolve(result);
  }
  @ReactMethod
  public void createVideoMessageByURL(ReadableMap videoInfo, String OperationID, Promise promise) {
    String result = Open_im_sdk.createVideoMessageByURL(OperationID, readableMap2string(videoInfo));
    promise.resolve(result);
  }

  @ReactMethod
  public void createFileMessage(ReadableMap options, String OperationID, Promise promise) {
    String result = Open_im_sdk.createFileMessage(OperationID, options.getString("filePath"), options.getString("fileName"));
    promise.resolve(result);
  }

  @ReactMethod
  public void createFileMessageFromFullPath(ReadableMap options, String OperationID, Promise promise) {
    String result = Open_im_sdk.createFileMessageFromFullPath(OperationID, options.getString("filePath"), options.getString("fileName"));
    promise.resolve(result);
  }

  @ReactMethod
  public void createFileMessageByURL(ReadableMap fileInfo, String OperationID, Promise promise) {
    String result = Open_im_sdk.createFileMessageByURL(OperationID, readableMap2string(fileInfo));
    promise.resolve(result);
  }

  @ReactMethod
  public void createMergerMessage(ReadableMap options, String operationID, Promise promise) {
    String result = Open_im_sdk.createMergerMessage(operationID, options.getArray("messageList").toString(), options.getString("title"), options.getArray("summaryList").toString());
    promise.resolve(result);
  }

  @ReactMethod
  public void createFaceMessage(ReadableMap options, String operationID, Promise promise) {
    String result = Open_im_sdk.createFaceMessage(operationID, options.getInt("index"), options.getString("dataStr"));
    promise.resolve(result);
  }

  @ReactMethod
  public void createForwardMessage(ReadableMap message, String operationID, Promise promise) {
    String result = Open_im_sdk.createForwardMessage(operationID, readableMap2string(message));
    promise.resolve(result);
  }
  @ReactMethod
  public void getConversationIDBySessionType(ReadableMap options, String operationID, Promise promise) {
    String result = Open_im_sdk.getConversationIDBySessionType(operationID, options.getString("sourceID"), options.getInt("sessionType"));
    promise.resolve(result);
  }
    @ReactMethod
    public void findMessageList( ReadableMap findOptions, String operationID,Promise promise) {
        Open_im_sdk.findMessageList(new BaseImpl(promise), operationID, readableMap2string(findOptions));
    }

    @ReactMethod
    public void getAdvancedHistoryMessageList(ReadableMap findOptions, String operationID, Promise promise) {
        Open_im_sdk.getAdvancedHistoryMessageList(new BaseImpl(promise), operationID, readableMap2string(findOptions));
    }

    @ReactMethod
    public void getAdvancedHistoryMessageListReverse(ReadableMap options, String operationID, Promise promise) {
        Open_im_sdk.getAdvancedHistoryMessageListReverse(new BaseImpl(promise), operationID, readableMap2string(options));
    }

    @ReactMethod
    public void revokeMessage(ReadableMap options, String operationID, Promise promise) {
        Open_im_sdk.revokeMessage(new BaseImpl(promise), operationID, options.getString("conversationID"), options.getString("clientMsgID"));
    }

    @ReactMethod
    public void typingStatusUpdate(ReadableMap options, String operationID, Promise promise) {
        Open_im_sdk.typingStatusUpdate(new BaseImpl(promise), operationID, options.getString("recvID"), options.getString("msgTip"));
    }
//    friend relationship
    @ReactMethod
    public void setFriendListener() {
        Open_im_sdk.setFriendListener(new OnFriendshipListener(reactContext));
    }
    public void getSpecifiedFriendsInfo(ReadableArray userIDList, String operationID, Promise promise) {
        Open_im_sdk.getSpecifiedFriendsInfo(new BaseImpl(promise), operationID, userIDList.toString());
    }

//   @ReactMethod
//   public void getDesignatedFriendsInfo(ReadableArray userIDList,String operationID,Promise promise) {
//     Open_im_sdk.getDesignatedFriendsInfo(new BaseImpl(promise),operationID,userIDList.toString());
//   }

    @ReactMethod
    public void getFriendList(String operationID,Promise promise) {
        Open_im_sdk.getFriendList(new BaseImpl(promise),operationID);
    }

    @ReactMethod
    public void getFriendListPage(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.getFriendListPage(new BaseImpl(promise), operationID, options.getInt("offset"), options.getInt("count"));
    }

    @ReactMethod
    public void searchFriends(ReadableMap options, String operationID, Promise promise) {
        Open_im_sdk.searchFriends(new BaseImpl(promise), operationID, readableMap2string(options));
    }

    @ReactMethod
    public void checkFriend(ReadableArray userIDList,String operationID,  Promise promise) {
        Open_im_sdk.checkFriend(new BaseImpl(promise), operationID, userIDList.toString());
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

    // @ReactMethod
    // public void getRecvFriendApplicationList(String operationID, Promise promise) {
    //   Open_im_sdk.getRecvFriendApplicationList(new BaseImpl(promise),operationID);
    // }

    // @ReactMethod
    // public void getSendFriendApplicationList(String operationID, Promise promise) {
    //   Open_im_sdk.getSendFriendApplicationList(new BaseImpl(promise),operationID);
    // }

    // @ReactMethod
    // public void refuseFriendApplication(ReadableMap userIDHandleMsg,String operationID, Promise promise) {
    //     Open_im_sdk.refuseFriendApplication(new BaseImpl(promise),operationID, readableMap2string(userIDHandleMsg));
    // }

    @ReactMethod
    public void getFriendApplicationListAsRecipient(String operationID, Promise promise) {
        Open_im_sdk.getFriendApplicationListAsRecipient(new BaseImpl(promise), operationID);
    }

    @ReactMethod
    public void getFriendApplicationListAsApplicant(String operationID, Promise promise) {
        Open_im_sdk.getFriendApplicationListAsApplicant(new BaseImpl(promise), operationID);
    }

    @ReactMethod
    public void acceptFriendApplication( ReadableMap userIDHandleMsg,String operationID, Promise promise) {
        Open_im_sdk.acceptFriendApplication(new BaseImpl(promise), operationID, readableMap2string(userIDHandleMsg));
    }

    @ReactMethod
    public void refuseFriendApplication(ReadableMap userIDHandleMsg,String operationID,  Promise promise) {
        Open_im_sdk.refuseFriendApplication(new BaseImpl(promise), operationID, readableMap2string(userIDHandleMsg));
    }

    @ReactMethod
    public void addBlack(String blackUserID,String operationID, Promise promise) {
      Open_im_sdk.addBlack(new BaseImpl(promise),operationID, blackUserID);
    }

    // @ReactMethod
    // public void acceptFriendApplication(ReadableMap userIDHandleMsg,String operationID, Promise promise) {
    //     Open_im_sdk.acceptFriendApplication(new BaseImpl(promise),operationID, readableMap2string(userIDHandleMsg));
    // }


    // @ReactMethod
    // public void checkFriend(ReadableArray uidList,String operationID, Promise promise) {
    //     Open_im_sdk.checkFriend(new BaseImpl(promise),operationID, uidList.toString());
    // }


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

    // @ReactMethod
    // public void inviteUserToGroup(String groupId, String reason,ReadableArray uidList,String operationID, Promise promise) {
    //     Open_im_sdk.inviteUserToGroup(new BaseImpl(promise),operationID,groupId, reason, uidList.toString());
    // }

    // @ReactMethod
    // public void getRecvGroupApplicationList(String operationID, Promise promise) {
    //   Open_im_sdk.getRecvGroupApplicationList(new BaseImpl(promise),operationID);
    // }

    // @ReactMethod
    // public void kickGroupMember(String groupId, ReadableArray uidList, String reason,String operationID, Promise promise) {
    //     Open_im_sdk.kickGroupMember(new BaseImpl(promise),operationID,groupId, reason, uidList.toString());
    // }

    // @ReactMethod
    // public void getGroupMembersInfo(String groupId, ReadableArray uidList,String operationID, Promise promise) {
    //     Open_im_sdk.getGroupMembersInfo(new BaseImpl(promise),operationID,groupId, uidList.toString());
    // }

    // @ReactMethod
    // public void getGroupMemberList(String groupId, Integer filter, Integer offset,Integer count,String operationID, Promise promise) {
    //     Open_im_sdk.getGroupMemberList(new BaseImpl(promise),operationID,groupId, filter, offset, count);
    // }

    // @ReactMethod
    // public void getJoinedGroupList(String operationID,Promise promise) {
    //     Open_im_sdk.getJoinedGroupList(new BaseImpl(promise),operationID);
    // }


    //需要添加

    @ReactMethod
    public void createGroup( ReadableMap gInfo,String operationID,Promise promise) {
        Open_im_sdk.createGroup(new BaseImpl(promise),operationID,readableMap2string(gInfo));
    }

    // @ReactMethod
    // public void setGroupInfo(String groupID,ReadableMap groupInfo,String operationID,Promise promise) {
    //     Open_im_sdk.setGroupInfo(new BaseImpl(promise),operationID,groupID,readableMap2string(groupInfo));
    // }

    // @ReactMethod
    // public void getGroupsInfo(ReadableArray gidList,String operationID,Promise promise) {
    //     Open_im_sdk.getGroupsInfo(new BaseImpl(promise),operationID,gidList.toString());
    // }

    @ReactMethod
    public void joinGroup(ReadableMap options, String operationID, Promise promise) {
      Open_im_sdk.joinGroup(new BaseImpl(promise), operationID, options.getString("groupID"), options.getString("reqMsg"),options.getInt("joinSource"));
    }

    @ReactMethod
    public void quitGroup(String gid,String operationID,Promise promise) {
        Open_im_sdk.quitGroup(new BaseImpl(promise),operationID,gid);
    }
        @ReactMethod
    public void dismissGroup(String groupID,String operationID,  Promise promise) {
        Open_im_sdk.dismissGroup(new BaseImpl(promise), operationID, groupID);
    }

    @ReactMethod
    public void changeGroupMute(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.changeGroupMute(new BaseImpl(promise), operationID,options.getString("groupID"), options.getBoolean("isMute"));
    }

    @ReactMethod
    public void changeGroupMemberMute( ReadableMap options,String operationID, Promise promise) {
        Open_im_sdk.changeGroupMemberMute(new BaseImpl(promise), operationID,  options.getString("groupID"),  options.getString("userID"), options.getInt("mutedSeconds"));
    }

    @ReactMethod
    public void setGroupMemberRoleLevel(ReadableMap options, String operationID, Promise promise) {
        Open_im_sdk.setGroupMemberRoleLevel(new BaseImpl(promise), operationID, options.getString("groupID"), options.getString("userID"), options.getInt("roleLevel"));
    }

    @ReactMethod
    public void setGroupMemberInfo(ReadableMap data,String operationID,  Promise promise) {
        Open_im_sdk.setGroupMemberInfo(new BaseImpl(promise), operationID, readableMap2string(data));
    }

    @ReactMethod
    public void getJoinedGroupList(String operationID, Promise promise) {
        Open_im_sdk.getJoinedGroupList(new BaseImpl(promise), operationID);
    }
        @ReactMethod
    public void getSpecifiedGroupsInfo(ReadableArray groupIDList,String operationID,  Promise promise) {
        Open_im_sdk.getSpecifiedGroupsInfo(new BaseImpl(promise), operationID, groupIDList.toString());
    }

    @ReactMethod
    public void searchGroups(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.searchGroups(new BaseImpl(promise), operationID, readableMap2string(options));
    }

    @ReactMethod
    public void setGroupInfo(ReadableMap jsonGroupInfo, String operationID, Promise promise) {
        Open_im_sdk.setGroupInfo(new BaseImpl(promise), operationID, readableMap2string(jsonGroupInfo));
    }

    @ReactMethod
    public void setGroupVerification(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.setGroupVerification(new BaseImpl(promise), operationID, options.getString("groupID"), options.getInt("verification"));
    }

    @ReactMethod
    public void setGroupLookMemberInfo(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.setGroupLookMemberInfo(new BaseImpl(promise), operationID, options.getString("groupID"), options.getInt("rule"));
    }

    @ReactMethod
    public void setGroupApplyMemberFriend(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.setGroupApplyMemberFriend(new BaseImpl(promise), operationID, options.getString("groupID"), options.getInt("rule"));
    }

    @ReactMethod
    public void getGroupMemberList(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.getGroupMemberList(new BaseImpl(promise), operationID, options.getString("groupID"), options.getInt("filter"), options.getInt("offset"), options.getInt("count"));
    }

    @ReactMethod
    public void getGroupMemberOwnerAndAdmin(String groupID,String operationID,  Promise promise) {
        Open_im_sdk.getGroupMemberOwnerAndAdmin(new BaseImpl(promise), operationID, groupID);
    }

    @ReactMethod
    public void getGroupMemberListByJoinTimeFilter(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.getGroupMemberListByJoinTimeFilter(new BaseImpl(promise), operationID, options.getString("groupID"), options.getInt("offset"), options.getInt("count"), options.getInt("joinTimeBegin"), options.getInt("joinTimeEnd"), options.getArray("filterUserIDList").toString());
    }

    @ReactMethod
    public void getSpecifiedGroupMembersInfo(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.getSpecifiedGroupMembersInfo(new BaseImpl(promise), operationID, options.getString("groupID"), options.getArray("userIDList").toString());
    }

    @ReactMethod
    public void kickGroupMember(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.kickGroupMember(new BaseImpl(promise), operationID, options.getString("groupID"), options.getString("reason"), options.getArray("userIDList").toString());
    }
    @ReactMethod
    public void transferGroupOwner(String gid, String uid,String operationID,Promise promise) {
        Open_im_sdk.transferGroupOwner(new BaseImpl(promise),operationID,gid,uid);
    }
    @ReactMethod
    public void inviteUserToGroup(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.inviteUserToGroup(new BaseImpl(promise), operationID, options.getString("groupID"), options.getString("reason"), options.getArray("userIDList").toString());
    }

    @ReactMethod
    public void getGroupApplicationListAsRecipient(String operationID, Promise promise) {
        Open_im_sdk.getGroupApplicationListAsRecipient(new BaseImpl(promise), operationID);
    }

    @ReactMethod
    public void getGroupApplicationListAsApplicant(String operationID, Promise promise) {
        Open_im_sdk.getGroupApplicationListAsApplicant(new BaseImpl(promise), operationID);
    }

    @ReactMethod
    public void acceptGroupApplication(ReadableMap options,String operationID,Promise promise) {
        Open_im_sdk.acceptGroupApplication(new BaseImpl(promise),operationID,options.getString("gid"),options.getString("fromUserID"),options.getString("handleMsg"));
    }

    @ReactMethod
    public void refuseGroupApplication(ReadableMap options,String operationID,Promise promise) {
        Open_im_sdk.refuseGroupApplication(new BaseImpl(promise),operationID,options.getString("gid"),options.getString("fromUserID"),options.getString("handleMsg"));
    }

    @ReactMethod
    public void setGroupMemberNickname(ReadableMap options,String operationID,  Promise promise) {
        Open_im_sdk.setGroupMemberNickname(new BaseImpl(promise), operationID,
            options.getString("groupID"),
            options.getString("userID"),
            options.getString("groupMemberNickname")
        );
    }

    @ReactMethod
    public void searchGroupMembers(ReadableMap searchOptions,String operationID,  Promise promise) {
        Open_im_sdk.searchGroupMembers(new BaseImpl(promise), operationID,
            readableMap2string(searchOptions)
        );
    }

    @ReactMethod
    public void isJoinGroup(String groupID,String operationID,  Promise promise) {
        Open_im_sdk.isJoinGroup(new BaseImpl(promise), operationID, groupID);
    }
  @ReactMethod
     public void addAdvancedMsgListener(){
         Open_im_sdk.setAdvancedMsgListener(new AdvancedMsgListener(reactContext));
     }
  @ReactMethod
    public void sendMessage( ReadableMap offlinePushInfo, String operationID,Promise promise) {
        String message = offlinePushInfo.getString("message");
        String receiver = offlinePushInfo.getString("recvID");
        String groupID = offlinePushInfo.getString("groupID");

        Open_im_sdk.sendMessage(new SendMsgCallBack(reactContext, promise, message), operationID, message, receiver, groupID, readableMap2string(offlinePushInfo));
    }

    @ReactMethod
    public void sendMessageNotOss(ReadableMap offlinePushInfo,String operationID, Promise promise) {
        String message = offlinePushInfo.getString("message");
        String receiver = offlinePushInfo.getString("recvID");
        String groupID = offlinePushInfo.getString("groupID");

        Open_im_sdk.sendMessageNotOss(new SendMsgCallBack(reactContext, promise, message), operationID, message, receiver, groupID, readableMap2string(offlinePushInfo));
    }

    // @ReactMethod
    // public void getHistoryMessageList(ReadableMap options,String operationID, Promise promise) {
    //     Open_im_sdk.getHistoryMessageList( new BaseImpl(promise),operationID,readableMap2string(options));
    // }

    // @ReactMethod
    // public void revokeMessage(ReadableMap message,String operationID, Promise promise) {
    //     Open_im_sdk.revokeMessage( new BaseImpl(promise),operationID,readableMap2string(message));
    // }

    // @ReactMethod
    // public void deleteMessageFromLocalStorage(ReadableMap message,String operationID, Promise promise) {
    //     Open_im_sdk.deleteMessageFromLocalStorage( new BaseImpl(promise),operationID,readableMap2string(message));
    // }

    // @ReactMethod
    // public void insertSingleMessageToLocalStorage(ReadableMap message,String recv,String sender,String operationID, Promise promise) {
    //     Open_im_sdk.insertSingleMessageToLocalStorage ( new BaseImpl(promise),operationID,readableMap2string(message),recv,sender);
    // }

    // @ReactMethod
    // public void insertGroupMessageToLocalStorage(String message,String groupID,String sendID,String operationID, Promise promise) {
    //   Open_im_sdk.insertGroupMessageToLocalStorage ( new BaseImpl(promise),operationID,message,groupID,sendID);
    // }

    // @ReactMethod
    // public void searchLocalMessages(ReadableMap searchParam,String operationID, Promise promise) {
    //   Open_im_sdk.searchLocalMessages ( new BaseImpl(promise),operationID,readableMap2string(searchParam));
    // }

    // @ReactMethod
    // public void markC2CMessageAsRead(String uid, ReadableArray msgIDs,String operationID, Promise promise) {
    //     Open_im_sdk.markC2CMessageAsRead( new BaseImpl(promise),operationID,uid,msgIDs.toString());
    // }

    // @ReactMethod
    // public void typingStatusUpdate(String uid, String tip,String operationID, Promise promise) {
    //     Open_im_sdk.typingStatusUpdate( new BaseImpl(promise),operationID,uid,tip);
    // }

    // @ReactMethod
    // public void createTextMessage(String text, String operationID,Promise promise) {
    //     promise.resolve(Open_im_sdk.createTextMessage(operationID,text));
    // }

    // @ReactMethod
    // public void createTextAtMessage(String text, ReadableArray atIds,ReadableArray atInfos,ReadableMap quteMsg,String operationID, Promise promise) {
    //      promise.resolve(Open_im_sdk.createTextAtMessage(operationID, text,atIds.toString(),atInfos.toString(),readableMap2string(quteMsg)));
    // }

    // @ReactMethod
    // public void createImageMessage(String path,String operationID, Promise promise) {
    //      promise.resolve(Open_im_sdk.createImageMessage(operationID, path));
    // }

    // @ReactMethod
    // public void createImageMessageByURL(ReadableMap sourceInfo,ReadableMap bigInfo,ReadableMap snaInfo,String operationID, Promise promise) {
    //      promise.resolve(Open_im_sdk.createImageMessageByURL(operationID,readableMap2string(sourceInfo),readableMap2string(bigInfo),readableMap2string(snaInfo)));
    // }

    // @ReactMethod
    // public void createImageMessageFromFullPath(String path,String operationID, Promise promise) {
    //     promise.resolve(Open_im_sdk.createImageMessageFromFullPath(operationID,path));
    // }

    // @ReactMethod
    // public void createSoundMessage(String path,Integer duration,String operationID, Promise promise) {
    //      promise.resolve(Open_im_sdk.createSoundMessage(operationID, path,duration));
    // }

    // @ReactMethod
    // public void createSoundMessageFromFullPath(String path,Integer duration,String operationID, Promise promise) {
    //      promise.resolve(Open_im_sdk.createSoundMessageFromFullPath(operationID, path,duration));
    // }

    // @ReactMethod
    // public void createSoundMessageByURL(ReadableMap info,String operationID, Promise promise) {
    //     promise.resolve(Open_im_sdk.createSoundMessageByURL(operationID, readableMap2string(info)));
    // }

    // @ReactMethod
    // public void createVideoMessage(String videoPath, String videoType, Integer duration, String snapshotPath,String operationID, Promise promise) {
    //      promise.resolve(Open_im_sdk.createVideoMessage(operationID, videoPath,videoType,duration,snapshotPath));
    // }

    // @ReactMethod
    // public void createVideoMessageFromFullPath(String videoPath, String videoType, Integer duration, String snapshotPath,String operationID, Promise promise) {
    //      promise.resolve(Open_im_sdk.createVideoMessageFromFullPath(operationID, videoPath,videoType,duration,snapshotPath));
    // }

    // @ReactMethod
    // public void createVideoMessageByURL(ReadableMap info,String operationID, Promise promise) {
    //     promise.resolve(Open_im_sdk.createVideoMessageByURL(operationID,readableMap2string(info)));
    // }

    // @ReactMethod
    // public void createFileMessage(String path,String fileName,String operationID, Promise promise) {
    //      promise.resolve( Open_im_sdk.createFileMessage(operationID, path,fileName));
    // }

    // @ReactMethod
    // public void createFileMessageFromFullPath(String path,String fileName,String operationID, Promise promise) {
    //      promise.resolve(Open_im_sdk.createFileMessageFromFullPath(operationID, path,fileName));
    // }

    // @ReactMethod
    // public void createFileMessageByURL(ReadableMap info,String operationID, Promise promise) {
    //     promise.resolve(Open_im_sdk.createFileMessageByURL(operationID, readableMap2string(info)));
    // }

    // @ReactMethod
    // public void createMergerMessage(ReadableArray messageList, String title, ReadableArray summaryList,String operationID, Promise promise){
    //      promise.resolve(Open_im_sdk.createMergerMessage(operationID,messageList.toString(),title,summaryList.toString()));
    // }

    // @ReactMethod
    // public void createForwardMessage(ReadableMap message,String operationID, Promise promise) {
    //      promise.resolve(Open_im_sdk.createForwardMessage(operationID, readableMap2string(message)));
    // }

    // @ReactMethod
    // public void createLocationMessage(Double latitude, Double longitude, String description,String operationID, Promise promise){
    //      promise.resolve(Open_im_sdk.createLocationMessage(operationID,description,longitude,latitude));
    // }

    // @ReactMethod
    // public void createCustomMessage(String data, String ex, String description,String operationID, Promise promise){
    //      promise.resolve(Open_im_sdk.createCustomMessage(operationID,data,ex,description));
    // }

//     @ReactMethod
//     public void createQuoteMessage(String text, ReadableMap message,String operationID, Promise promise){
//          promise.resolve(Open_im_sdk.createQuoteMessage(operationID,text,readableMap2string(message)));
//     }

//     @ReactMethod
//     public void createCardMessage(String content,String operationID, Promise promise){
//          promise.resolve(Open_im_sdk.createCardMessage(operationID,content));
//     }

//     @ReactMethod
//     public void clearC2CHistoryMessage(String uid,String operationID,Promise promise){
//         Open_im_sdk.clearC2CHistoryMessage(new BaseImpl(promise),operationID, uid);
//     }

//     @ReactMethod
//     public void clearGroupHistoryMessage(String gid,String operationID,Promise promise){
//         Open_im_sdk.clearGroupHistoryMessage(new BaseImpl(promise),operationID, gid);
//     }

//   //--------------
//   @ReactMethod
//   public void addSignalingListener(){
//     Open_im_sdk.setSignalingListener(new OnSignalingListener(reactContext));
//   }

//   @ReactMethod
//   public void signalingInvite(ReadableMap signalInviteReq,String operationID,Promise promise){
//     Open_im_sdk.signalingInvite(new BaseImpl(promise), operationID, readableMap2string(signalInviteReq));
//   }


//   @ReactMethod
//   public void signalingInviteInGroup(ReadableMap signalInviteInGroupReq,String operationID,Promise promise){
//     Open_im_sdk.signalingInviteInGroup(new BaseImpl(promise), operationID, readableMap2string(signalInviteInGroupReq));
//   }

//   @ReactMethod
//   public void signalingAccept(ReadableMap signalAcceptReq,String operationID,Promise promise){
//     Open_im_sdk.signalingAccept(new BaseImpl(promise), operationID, readableMap2string(signalAcceptReq));
//   }

//   @ReactMethod
//   public void signalingReject(ReadableMap signalRejectReq,String operationID,Promise promise){
//     Open_im_sdk.signalingReject(new BaseImpl(promise), operationID, readableMap2string(signalRejectReq));
//   }

//   @ReactMethod
//   public void signalingCancel(ReadableMap signalCancelReq,String operationID,Promise promise){
//     Open_im_sdk.signalingCancel(new BaseImpl(promise), operationID, readableMap2string(signalCancelReq));
//   }

//   @ReactMethod
//   public void signalingHungUp(ReadableMap signalHungUpReq,String operationID,Promise promise){
//     Open_im_sdk.signalingHungUp(new BaseImpl(promise), operationID, readableMap2string(signalHungUpReq));
//   }
    //third
    @ReactMethod
    public void updateFcmToken(ReadableArray userIDList,String operationID,  Promise promise) {
        Open_im_sdk.updateFcmToken(new BaseImpl(promise), operationID, userIDList.toString());
    }

    @ReactMethod
    public void setAppBadge( Integer appUnreadCount,String operationID, Promise promise) {
        Open_im_sdk.setAppBadge(new BaseImpl(promise), operationID, appUnreadCount);
    }

    @ReactMethod
    public String getSdkVersion() {
        return Open_im_sdk.getSdkVersion();
    }
    @ReactMethod
    public void uploadFile(ReadableMap reqData,String operationID,  Promise promise) {

        Open_im_sdk.uploadFile(new BaseImpl(promise), operationID, readableMap2string(reqData), new UploadFileCallbackListener(reactContext));
    }
    //advance
//    @ReactMethod
//    public void signalingInvite(String operationID, ReadableMap options, Promise promise) {
//        Open_im_sdk.signalingInvite(new BaseImpl(promise), operationID, options.toString());
//    }
//
//    @ReactMethod
//    public void signalingInviteInGroup(String operationID, ReadableMap options, Promise promise) {
//        Open_im_sdk.signalingInviteInGroup(new BaseImpl(promise), operationID, options.toString());
//    }
//        @ReactMethod
//    public void signalingAccept(String operationID, ReadableMap options, Promise promise) {
//        Open_im_sdk.signalingAccept(new BaseImpl(promise), operationID, options.toString());
//    }
//
//    @ReactMethod
//    public void signalingReject(String operationID, ReadableMap options, Promise promise) {
//        Open_im_sdk.signalingReject(new BaseImpl(promise), operationID, options.toString());
//    }
//
//    @ReactMethod
//    public void signalingCancel(String operationID, ReadableMap options, Promise promise) {
//        Open_im_sdk.signalingCancel(new BaseImpl(promise), operationID, options.toString());
//    }
//
//    @ReactMethod
//    public void signalingHungUp(String operationID, ReadableMap options, Promise promise) {
//        Open_im_sdk.signalingHungUp(new BaseImpl(promise), operationID, options.toString());
//    }
//
//    @ReactMethod
//    public void signalingGetRoomByGroupID(String operationID, String groupID, Promise promise) {
//        Open_im_sdk.signalingGetRoomByGroupID(new BaseImpl(promise), operationID, groupID);
//    }
//    @ReactMethod
//    public void signalingGetTokenByRoomID(String operationID, String groupID, Promise promise) {
//        Open_im_sdk.signalingGetTokenByRoomID(new BaseImpl(promise), operationID, groupID);
//    }
//
//    @ReactMethod
//    public void signalingSendCustomSignal(String operationID, ReadableMap options, Promise promise) {
//        Open_im_sdk.signalingSendCustomSignal(new BaseImpl(promise), operationID, options.getString("roomID"), options.getJSONObject("customInfo").toJSONString());
//    }
//
//    @ReactMethod
//    public void signalingCreateMeeting(String operationID, ReadableMap roomData, Promise promise) {
//        Open_im_sdk.signalingCreateMeeting(new BaseImpl(promise), operationID, roomData.toJSONString());
//    }
//
//    @ReactMethod
//    public void signalingJoinMeeting(String operationID, ReadableMap roomData, Promise promise) {
//        Open_im_sdk.signalingJoinMeeting(new BaseImpl(promise), operationID, roomData.toJSONString());
//    }
//
//    @ReactMethod
//    public void signalingUpdateMeetingInfo(String operationID, ReadableMap roomData, Promise promise) {
//        Open_im_sdk.signalingUpdateMeetingInfo(new BaseImpl(promise), operationID, roomData.toString());
//    }
//
//    @ReactMethod
//    public void signalingCloseRoom(String operationID, String roomID, Promise promise) {
//        Open_im_sdk.signalingCloseRoom(new BaseImpl(promise), operationID, roomID);
//    }
//
//    @ReactMethod
//    public void signalingGetMeetings(String operationID, Promise promise) {
//        Open_im_sdk.signalingGetMeetings(new BaseImpl(promise), operationID);
//    }
//
//    @ReactMethod
//    public void signalingOperateStream(String operationID, ReadableMap options, Promise promise) {
//        Open_im_sdk.signalingOperateStream(
//            new BaseImpl(promise),
//            operationID,
//            options.getString("streamType"),
//            options.getString("roomID"),
//            options.getString("userID"),
//            options.getBoolean("isMute"),
//            options.getBoolean("isMuteAll")
//        );
//    }
//
//    @ReactMethod
//    public void _setCustomBusinessListener() {
//        OnCustomBusinessListener onCustomBusinessListener = new OnCustomBusinessListener() {
//            @Override
//            public void onRecvCustomBusinessMessage(String s) {
//                Map<String, Object> params = new HashMap<>();
//                params.put("data", JSONObject.parseObject(s));
//                OpenIMSDK.this.mUniSDKInstance.fireGlobalEventCallback("onRecvCustomBusinessMessage", params);
//            }
//        };
//        Open_im_sdk.setCustomBusinessListener(onCustomBusinessListener);
//    }
}


package com.openimsdkrn;

import android.util.Log;

import androidx.annotation.RequiresPermission;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONException;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.openimsdkrn.listener.AdvancedMsgListener;
import com.openimsdkrn.listener.InitSDKListener;
import com.openimsdkrn.listener.OnConversationListener;
import com.openimsdkrn.listener.OnFriendshipListener;
import com.openimsdkrn.listener.OnGroupListener;
import com.openimsdkrn.listener.UploadLogProgressListener;
import com.openimsdkrn.listener.UserListener;
import com.openimsdkrn.listener.UploadFileCallbackListener;
import com.openimsdkrn.listener.BatchMsgListener;

import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Objects;
import java.util.UUID;
import java.util.HashMap;

import open_im_sdk.Open_im_sdk;
import open_im_sdk_callback.Base;
import open_im_sdk_callback.UploadLogProgress;

import com.openimsdkrn.utils.Emitter;

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

  private int listenerCount = 0;

  private String map2string(ReadableMap map) {
    return map.toString();
  }

  private Emitter emitter = new Emitter();

  @ReactMethod
  public void addListener(String eventName) {
    // Set up any upstream listeners or background tasks as necessary
    listenerCount += 1;
  }

  @ReactMethod
  public void removeListeners(Integer count) {
    listenerCount -= count;
    // Remove upstream listeners, stop unnecessary background tasks
  }

  @ReactMethod
  public void initSDK(ReadableMap options, String operationID, Promise promise) {
    WritableMap config = Arguments.createMap();
    config.merge(options);

    config.putInt("platformID", 2);

    boolean initialized = Open_im_sdk.initSDK(new InitSDKListener(reactContext), operationID, map2string(config));
    setUserListener();
    setConversationListener();
    setFriendListener();
    setGroupListener();
    setAdvancedMsgListener();
    setBatchMsgListener();

    if (initialized) {
      promise.resolve("init success");
    } else {
      promise.reject("-1", "please check params and dir");
    }
  }

  @ReactMethod
  public void setUserListener() {
    Open_im_sdk.setUserListener(new UserListener(reactContext));
  }

  @ReactMethod
  public void setBatchMsgListener() {
    Open_im_sdk.setBatchMsgListener(new BatchMsgListener(reactContext));
  }

  @ReactMethod
  public void login(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.login(new BaseImpl(promise), operationID, options.getString("userID"), options.getString("token"));
  }

  @ReactMethod
  public void logout(String operationID, Promise promise) {
    Open_im_sdk.logout(new BaseImpl(promise), operationID);
  }

  @ReactMethod
  public void setAppBackgroundStatus(boolean isBackground, String operationID, Promise promise) {
    Open_im_sdk.setAppBackgroundStatus(new BaseImpl(promise), operationID, isBackground);
  }

  @ReactMethod
  public void networkStatusChange(String operationID, Promise promise) {
    Open_im_sdk.networkStatusChanged(new BaseImpl(promise), operationID);
  }

  @ReactMethod
  public void getLoginStatus(String operationID, Promise promise) {
    long status = Open_im_sdk.getLoginStatus(operationID);
    promise.resolve((int) status);
  }

  @ReactMethod
  public void getLoginUserID(String operationID, Promise promise) {
    String userID = Open_im_sdk.getLoginUserID();
    promise.resolve(userID);
  }

  @ReactMethod
  public void getUsersInfo(ReadableArray userIDList, String operationID, Promise promise) {
    Open_im_sdk.getUsersInfo(new BaseImpl(promise), operationID, userIDList.toString());
  }

  @ReactMethod
  public void setSelfInfo(ReadableMap userInfo, String operationID, Promise promise) {
    Open_im_sdk.setSelfInfo(new BaseImpl(promise), operationID, map2string(userInfo));
  }

  @ReactMethod
  public void getSelfUserInfo(String operationID, Promise promise) {
    Open_im_sdk.getSelfUserInfo(new BaseImpl(promise), operationID);
  }

  @ReactMethod
  public void getUserStatus(ReadableArray userIDList, String operationID, Promise promise) {
    Open_im_sdk.getUserStatus(new BaseImpl(promise), operationID, userIDList.toString());
  }

  @ReactMethod
  public void subscribeUsersStatus(ReadableArray userIDList, String operationID, Promise promise) {
    Open_im_sdk.subscribeUsersStatus(new BaseImpl(promise), operationID, userIDList.toString());
  }

  @ReactMethod
  public void unsubscribeUsersStatus(ReadableArray userIDList, String operationID, Promise promise) {
    Open_im_sdk.unsubscribeUsersStatus(new BaseImpl(promise), operationID, userIDList.toString());
  }

  @ReactMethod
  public void getSubscribeUsersStatus(String operationID, Promise promise) {
    Open_im_sdk.getSubscribeUsersStatus(new BaseImpl(promise), operationID);
  }

  // Conversation & Message
  @ReactMethod
  public void setConversationListener() {
    Open_im_sdk.setConversationListener(new OnConversationListener(reactContext));
  }

  @ReactMethod
  public void getAllConversationList(String operationID, Promise promise) {
    Open_im_sdk.getAllConversationList(new BaseImpl(promise), operationID);
  }

  @ReactMethod
  public void getConversationListSplit(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.getConversationListSplit(new BaseImpl(promise), operationID, options.getInt("offset"),
      options.getInt("count"));
  }

  @ReactMethod
  public void getOneConversation(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.getOneConversation(new BaseImpl(promise), operationID, options.getInt("sessionType"),
      options.getString("sourceID"));
  }

  @ReactMethod
  public void getMultipleConversation(ReadableArray conversationIDList, String operationID, Promise promise) {
    Open_im_sdk.getMultipleConversation(new BaseImpl(promise), operationID, conversationIDList.toString());
  }

  @ReactMethod
  public void setGlobalRecvMessageOpt(int opt, String operationID, Promise promise) {
    JSONObject params = new JSONObject();
    params.put("globalRecvMsgOpt", opt);
    Open_im_sdk.setSelfInfo(new BaseImpl(promise), operationID, params.toString());
  }

  @ReactMethod
  public void hideAllConversations(String operationID, Promise promise) {
    Open_im_sdk.hideAllConversations(new BaseImpl(promise), operationID);
  }

  @ReactMethod
  public void hideConversation(String conversationID, String operationID, Promise promise) {
    Open_im_sdk.hideConversation(new BaseImpl(promise), operationID, conversationID);
  }

  @ReactMethod
  public void setConversation(ReadableMap options, String operationID, Promise promise) {
    String conversationID = options.getString("conversationID");
    String conversation = map2string(options);
    Open_im_sdk.setConversation(new BaseImpl(promise), operationID, conversationID, conversation);
  }

  @ReactMethod
  public void setConversationDraft(ReadableMap options, String operationID, Promise promise) {
    String conversationID = options.getString("conversationID");
    String draftText = options.getString("draftText");
    Open_im_sdk.setConversationDraft(new BaseImpl(promise), operationID, conversationID, draftText);
  }

  @ReactMethod
  public void resetConversationGroupAtType(String conversationID, String operationID, Promise promise) {
    JSONObject params = new JSONObject();
    params.put("groupAtType", 0);
    Open_im_sdk.setConversation(new BaseImpl(promise), operationID, conversationID, params.toString());
  }

  @ReactMethod
  public void pinConversation(ReadableMap options, String operationID, Promise promise) {
    String conversationID = options.getString("conversationID");
    JSONObject params = new JSONObject();
    params.put("isPinned", options.getBoolean("isPinned"));
    Open_im_sdk.setConversation(new BaseImpl(promise), operationID, conversationID, params.toString());
  }

  @ReactMethod
  public void setConversationPrivateChat(ReadableMap options, String operationID, Promise promise) {
    String conversationID = options.getString("conversationID");
    JSONObject params = new JSONObject();
    params.put("isPrivateChat", options.getBoolean("isPrivate"));
    Open_im_sdk.setConversation(new BaseImpl(promise), operationID, conversationID, params.toString());
  }

  @ReactMethod
  public void setConversationBurnDuration(ReadableMap options, String operationID, Promise promise) {
    String conversationID = options.getString("conversationID");
    JSONObject params = new JSONObject();
    params.put("burnDuration", options.getInt("burnDuration"));
    Open_im_sdk.setConversation(new BaseImpl(promise), operationID, conversationID, params.toString());
  }

  @ReactMethod
  public void setConversationRecvMessageOpt(ReadableMap options, String operationID, Promise promise) {
    String conversationID = options.getString("conversationID");
    JSONObject params = new JSONObject();
    params.put("recvMsgOpt", options.getInt("opt"));
    Open_im_sdk.setConversation(new BaseImpl(promise), operationID, conversationID, params.toString());
  }

  @ReactMethod
  public void getTotalUnreadMsgCount(String operationID, Promise promise) {
    Open_im_sdk.getTotalUnreadMsgCount(new BaseImpl(promise), operationID);
  }

  /**
   * @deprecated This method may lead to app crash and has been deprecated in the SDK.
   * It is not exported in the JS API.
   */
  @Deprecated
  @ReactMethod
  public void getAtAllTag(String OperationID, Promise promise) {
    promise.resolve(Open_im_sdk.getAtAllTag(OperationID));
  }

  @ReactMethod
  public void createAdvancedTextMessage(ReadableMap options, String operationID, Promise promise) {
    String messageEntityList = Objects.requireNonNull(options.getArray("messageEntityList")).toString();
    String text = options.getString("text");

    String message = Open_im_sdk.createAdvancedTextMessage(operationID, text, messageEntityList);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createTextAtMessage(ReadableMap options, String operationID, Promise promise) {
    String text = options.getString("text");
    String atUserIDList = Objects.requireNonNull(options.getArray("atUserIDList")).toString();

    ReadableArray atUsersInfoMap = options.hasKey("atUsersInfo") ? options.getArray("atUsersInfo") : null;
    String atUsersInfo = atUsersInfoMap != null ? atUsersInfoMap.toString() : null;

    ReadableMap messageMap = options.hasKey("message") ? options.getMap("message") : null;
    String quoteMessage = messageMap != null ? map2string(messageMap) : null;

    String message = Open_im_sdk.createTextAtMessage(operationID, text, atUserIDList, atUsersInfo, quoteMessage);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createTextMessage(String textMsg, String operationID, Promise promise) {
    String message = Open_im_sdk.createTextMessage(operationID, textMsg);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createLocationMessage(ReadableMap options, String operationID, Promise promise) {
    String description = options.getString("description");
    double longitude = options.getDouble("longitude");
    double latitude = options.getDouble("latitude");

    String message = Open_im_sdk.createLocationMessage(operationID, description, longitude, latitude);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createCustomMessage(ReadableMap options, String operationID, Promise promise) {
    String data = options.getString("data");
    String extension = options.getString("extension");
    String description = options.getString("description");

    String message = Open_im_sdk.createCustomMessage(operationID, data, extension, description);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createQuoteMessage(ReadableMap options, String operationID, Promise promise) {
    String text = options.getString("text");
    String quoteMessage = map2string(Objects.requireNonNull(options.getMap("message")));

    String message = Open_im_sdk.createQuoteMessage(operationID, text, quoteMessage);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createAdvancedQuoteMessage(ReadableMap options, String operationID, Promise promise) {
    String text = options.getString("text");
    String quoteMessage = map2string(Objects.requireNonNull(options.getMap("message")));
    String messageEntityList = Objects.requireNonNull(options.getArray("messageEntityList")).toString();

    String message = Open_im_sdk.createAdvancedQuoteMessage(operationID, text, quoteMessage, messageEntityList);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createCardMessage(ReadableMap cardElem, String operationID, Promise promise) {
    String card = map2string(cardElem);

    String message = Open_im_sdk.createCardMessage(operationID, card);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createImageMessage(String imagePath, String operationID, Promise promise) {
    String message = Open_im_sdk.createImageMessage(operationID, imagePath);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createImageMessageFromFullPath(String imagePath, String operationID, Promise promise) {
    String message = Open_im_sdk.createImageMessageFromFullPath(operationID, imagePath);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createImageMessageByURL(ReadableMap options, String operationID, Promise promise) {
    String sourcePicture = map2string(Objects.requireNonNull(options.getMap("sourcePicture")));
    String bigPicture = map2string(Objects.requireNonNull(options.getMap("bigPicture")));
    String snapshotPicture = map2string(Objects.requireNonNull(options.getMap("snapshotPicture")));
    String sourcePath = options.getString("sourcePath");

    String message = Open_im_sdk.createImageMessageByURL(operationID, sourcePath, sourcePicture, bigPicture, snapshotPicture);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createSoundMessage(ReadableMap options, String operationID, Promise promise) {
    String soundPath = options.getString("soundPath");
    int duration = options.getInt("duration");

    String message = Open_im_sdk.createSoundMessage(operationID, soundPath, duration);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createSoundMessageFromFullPath(ReadableMap options, String operationID, Promise promise) {
    String soundPath = options.getString("soundPath");
    int duration = options.getInt("duration");

    String message = Open_im_sdk.createSoundMessageFromFullPath(operationID, soundPath, duration);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createSoundMessageByURL(ReadableMap soundInfo, String operationID, Promise promise) {
    String sound = map2string(soundInfo);

    String message = Open_im_sdk.createSoundMessageByURL(operationID, sound);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createVideoMessage(ReadableMap options, String operationID, Promise promise) {
    String videoPath = options.getString("videoPath");
    String videoType = options.getString("videoType");
    int duration = options.getInt("duration");
    String snapshotPath = options.getString("snapshotPath");

    String message = Open_im_sdk.createVideoMessage(operationID, videoPath, videoType, duration, snapshotPath);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createVideoMessageFromFullPath(ReadableMap options, String operationID, Promise promise) {
    String videoPath = options.getString("videoPath");
    String videoType = options.getString("videoType");
    int duration = options.getInt("duration");
    String snapshotPath = options.getString("snapshotPath");

    String message = Open_im_sdk.createVideoMessageFromFullPath(operationID, videoPath, videoType, duration, snapshotPath);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createVideoMessageByURL(ReadableMap videoInfo, String operationID, Promise promise) {
    String video = map2string(videoInfo);

    String message = Open_im_sdk.createVideoMessageByURL(operationID, video);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createFileMessage(ReadableMap options, String operationID, Promise promise) {
    String filePath = options.getString("filePath");
    String fileName = options.getString("fileName");

    String message = Open_im_sdk.createFileMessage(operationID, filePath, fileName);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createFileMessageFromFullPath(ReadableMap options, String operationID, Promise promise) {
    String filePath = options.getString("filePath");
    String fileName = options.getString("fileName");

    String message = Open_im_sdk.createFileMessageFromFullPath(operationID, filePath, fileName);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createFileMessageByURL(ReadableMap fileInfo, String operationID, Promise promise) {
    String file = map2string(fileInfo);

    String message = Open_im_sdk.createFileMessageByURL(operationID, file);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createMergerMessage(ReadableMap options, String operationID, Promise promise) {
    String messageList = Objects.requireNonNull(options.getArray("messageList")).toString();
    String title = options.getString("title");
    String summaryList = Objects.requireNonNull(options.getArray("summaryList")).toString();

    String message = Open_im_sdk.createMergerMessage(operationID, messageList, title, summaryList);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createFaceMessage(ReadableMap options, String operationID, Promise promise) {
    Integer index = options.getInt("index");
    String dataStr = options.getString("dataStr");

    String message = Open_im_sdk.createFaceMessage(operationID, index, dataStr);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void createForwardMessage(ReadableMap messageList, String operationID, Promise promise) {
    String forward = map2string(messageList);

    String message = Open_im_sdk.createForwardMessage(operationID, forward);
    try {
      JSONObject obj = JSON.parseObject(message);
      promise.resolve(emitter.convertJsonToMap(obj));
    } catch (Exception e) {
      promise.resolve(message);
    }
  }

  @ReactMethod
  public void getConversationIDBySessionType(ReadableMap options, String operationID, Promise promise) {
    String result = Open_im_sdk.getConversationIDBySessionType(operationID, options.getString("sourceID"),
      options.getInt("sessionType"));
    promise.resolve(result);
  }

  @ReactMethod
  public void findMessageList(ReadableMap findOptions, String operationID, Promise promise) {
    Open_im_sdk.findMessageList(new BaseImpl(promise), operationID, map2string(findOptions));
  }

  @ReactMethod
  public void getAdvancedHistoryMessageList(ReadableMap findOptions, String operationID, Promise promise) {
    Open_im_sdk.getAdvancedHistoryMessageList(new BaseImpl(promise), operationID, map2string(findOptions));
  }

  @ReactMethod
  public void getAdvancedHistoryMessageListReverse(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.getAdvancedHistoryMessageListReverse(new BaseImpl(promise), operationID, map2string(options));
  }

  @ReactMethod
  public void revokeMessage(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.revokeMessage(new BaseImpl(promise), operationID, options.getString("conversationID"),
      options.getString("clientMsgID"));
  }

  @ReactMethod
  public void searchConversation(String searchParams, String operationID, Promise promise) {
    Open_im_sdk.searchConversation(new BaseImpl(promise), operationID, searchParams);
  }

  @ReactMethod
  public void typingStatusUpdate(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.typingStatusUpdate(new BaseImpl(promise), operationID, options.getString("recvID"),
      options.getString("msgTip"));
  }

  @ReactMethod
  public void changeInputStates(ReadableMap options, String operationID, Promise promise) {
    String conversationID = options.getString("conversationID");
    boolean focus = options.getBoolean("focus");
    Open_im_sdk.changeInputStates(new BaseImpl(promise), operationID, conversationID, focus);
  }

  @ReactMethod
  public void getInputStates(ReadableMap options, String operationID, Promise promise) {
    String conversationID = options.getString("conversationID");
    String userID = options.getString("userID");
    Open_im_sdk.getInputStates(new BaseImpl(promise), operationID, conversationID, userID);
  }

  @ReactMethod
  public void markConversationMessageAsRead(String conversationID, String operationID, Promise promise) {
    Open_im_sdk.markConversationMessageAsRead(new BaseImpl(promise), operationID, conversationID);
  }

  @ReactMethod
  public void deleteMessage(ReadableMap options, String operationID, Promise promise) {
    String conversationID = options.getString("conversationID");
    String clientMsgID = options.getString("clientMsgID");

    Open_im_sdk.deleteMessage(new BaseImpl(promise), operationID, conversationID, clientMsgID);
  }

  @ReactMethod
  public void deleteMessageFromLocalStorage(ReadableMap options, String operationID, Promise promise) {
    String conversationID = options.getString("conversationID");
    String clientMsgID = options.getString("clientMsgID");
    Open_im_sdk.deleteMessageFromLocalStorage(new BaseImpl(promise), operationID, conversationID, clientMsgID);
  }

  @ReactMethod
  public void deleteAllMsgFromLocalAndSvr(String operationID, Promise promise) {
    Open_im_sdk.deleteAllMsgFromLocalAndSvr(new BaseImpl(promise), operationID);
  }

  @ReactMethod
  public void deleteAllMsgFromLocal(String operationID, Promise promise) {
    Open_im_sdk.deleteAllMsgFromLocal(new BaseImpl(promise), operationID);
  }

  @ReactMethod
  public void clearConversationAndDeleteAllMsg(String conversationID, String operationID, Promise promise) {
    Open_im_sdk.clearConversationAndDeleteAllMsg(new BaseImpl(promise), operationID, conversationID);
  }

  @ReactMethod
  public void deleteConversationAndDeleteAllMsg(String conversationID, String operationID, Promise promise) {
    Open_im_sdk.deleteConversationAndDeleteAllMsg(new BaseImpl(promise), operationID, conversationID);
  }

  @ReactMethod
  public void insertSingleMessageToLocalStorage(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.insertSingleMessageToLocalStorage(new BaseImpl(promise), operationID,
      map2string(Objects.requireNonNull(options.getMap("message"))), options.getString("recvID"), options.getString("sendID"));
  }

  @ReactMethod
  public void insertGroupMessageToLocalStorage(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.insertGroupMessageToLocalStorage(new BaseImpl(promise), operationID,
      map2string(Objects.requireNonNull(options.getMap("message"))), options.getString("groupID"), options.getString("sendID"));
  }

  @ReactMethod
  public void searchLocalMessages(ReadableMap searchParam, String operationID, Promise promise) {
    Open_im_sdk.searchLocalMessages(new BaseImpl(promise), operationID, map2string(searchParam));
  }

  @ReactMethod
  public void setMessageLocalEx(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.setMessageLocalEx(new BaseImpl(promise), operationID, options.getString("conversationID"),
      options.getString("clientMsgID"), options.getString("localEx"));
  }

  // Friend Relationship
  @ReactMethod
  public void setFriendListener() {
    Open_im_sdk.setFriendListener(new OnFriendshipListener(reactContext));
  }

  @ReactMethod
  public void getSpecifiedFriendsInfo(ReadableMap options, String operationID, Promise promise) {
    ReadableArray userIDList = options.getArray("userIDList");
    boolean filterBlack = false;
    if (options.hasKey("filterBlack")) {
      filterBlack = options.getBoolean("filterBlack");
    }
    Open_im_sdk.getSpecifiedFriendsInfo(new BaseImpl(promise), operationID, userIDList.toString(), filterBlack);
  }

  @ReactMethod
  public void getFriendList(Boolean filterBlack, String operationID, Promise promise) {
    Open_im_sdk.getFriendList(new BaseImpl(promise), operationID, filterBlack);
  }

  @ReactMethod
  public void getFriendListPage(ReadableMap options, String operationID, Promise promise) {
    int offset = options.getInt("offset");
    int count = options.getInt("count");
    boolean filterBlack = false;
    if (options.hasKey("filterBlack")) {
      filterBlack = options.getBoolean("filterBlack");
    }
    Open_im_sdk.getFriendListPage(new BaseImpl(promise), operationID, offset, count, filterBlack);
  }

  @ReactMethod
  public void searchFriends(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.searchFriends(new BaseImpl(promise), operationID, map2string(options));
  }

  @ReactMethod
  public void checkFriend(ReadableArray userIDList, String operationID, Promise promise) {
    Open_im_sdk.checkFriend(new BaseImpl(promise), operationID, userIDList.toString());
  }

  @ReactMethod
  public void addFriend(ReadableMap params, String operationID, Promise promise) {
    Open_im_sdk.addFriend(new BaseImpl(promise), operationID, map2string(params));
  }

  public void updateFriends(ReadableMap params, String operationID, Promise promise) {
    Open_im_sdk.updateFriends(new BaseImpl(promise), operationID, map2string(params));
  }

  @ReactMethod
  public void setFriendRemark(ReadableMap options, String operationID, Promise promise) {
    ArrayList<String> toUserIDList = new ArrayList<String>();
    toUserIDList.add(options.getString("toUserID"));

    JSONObject params = new JSONObject();
    params.put("friendUserIDs", toUserIDList);
    params.put("remark", options.getString("remark"));

    Open_im_sdk.updateFriends(new BaseImpl(promise), operationID, params.toString());
  }

  @ReactMethod
  public void deleteFriend(String friendUserID, String operationID, Promise promise) {
    Open_im_sdk.deleteFriend(new BaseImpl(promise), operationID, friendUserID);
  }

  @ReactMethod
  public void getFriendApplicationListAsRecipient(String operationID, ReadableMap req, Promise promise) {
    Open_im_sdk.getFriendApplicationListAsRecipient(new BaseImpl(promise), operationID, map2string(req));
  }

  @ReactMethod
  public void getFriendApplicationListAsApplicant(String operationID, ReadableMap req, Promise promise) {
    Open_im_sdk.getFriendApplicationListAsApplicant(new BaseImpl(promise), operationID, map2string(req));
  }

  @ReactMethod
  public void getFriendApplicationUnhandledCount(ReadableMap req, String operationID, Promise promise) {
    Open_im_sdk.getFriendApplicationUnhandledCount(new BaseImpl(promise), operationID, map2string(req));
  }

  @ReactMethod
  public void acceptFriendApplication(ReadableMap userIDHandleMsg, String operationID, Promise promise) {
    Open_im_sdk.acceptFriendApplication(new BaseImpl(promise), operationID, map2string(userIDHandleMsg));
  }

  @ReactMethod
  public void refuseFriendApplication(ReadableMap userIDHandleMsg, String operationID, Promise promise) {
    Open_im_sdk.refuseFriendApplication(new BaseImpl(promise), operationID, map2string(userIDHandleMsg));
  }

  @ReactMethod
  public void addBlack(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.addBlack(new BaseImpl(promise), operationID, options.getString("toUserID"), options.getString("ex"));
  }

  @ReactMethod
  public void getBlackList(String operationID, Promise promise) {
    Open_im_sdk.getBlackList(new BaseImpl(promise), operationID);
  }

  @ReactMethod
  public void removeBlack(String removeUserID, String operationID, Promise promise) {
    Open_im_sdk.removeBlack(new BaseImpl(promise), operationID, removeUserID);
  }

  // group
  @ReactMethod
  public void setGroupListener() {
    Open_im_sdk.setGroupListener(new OnGroupListener(reactContext));
  }

  @ReactMethod
  public void createGroup(ReadableMap gInfo, String operationID, Promise promise) {
    Open_im_sdk.createGroup(new BaseImpl(promise), operationID, map2string(gInfo));
  }

  @ReactMethod
  public void joinGroup(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.joinGroup(new BaseImpl(promise), operationID, options.getString("groupID"), options.getString("reqMsg"),
      options.getInt("joinSource"), options.getString("ex"));
  }

  @ReactMethod
  public void quitGroup(String groupID, String operationID, Promise promise) {
    Open_im_sdk.quitGroup(new BaseImpl(promise), operationID, groupID);
  }

  @ReactMethod
  public void dismissGroup(String groupID, String operationID, Promise promise) {
    Open_im_sdk.dismissGroup(new BaseImpl(promise), operationID, groupID);
  }

  @ReactMethod
  public void changeGroupMute(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.changeGroupMute(new BaseImpl(promise), operationID, options.getString("groupID"),
      options.getBoolean("isMute"));
  }

  @ReactMethod
  public void changeGroupMemberMute(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.changeGroupMemberMute(new BaseImpl(promise), operationID, options.getString("groupID"),
      options.getString("userID"), (long) options.getDouble("mutedSeconds"));
  }

  @ReactMethod
  public void setGroupMemberRoleLevel(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.setGroupMemberInfo(new BaseImpl(promise), operationID, map2string(options));
  }

  @ReactMethod
  public void setGroupMemberInfo(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.setGroupMemberInfo(new BaseImpl(promise), operationID, map2string(options));
  }

  @ReactMethod
  public void getJoinedGroupList(String operationID, Promise promise) {
    Open_im_sdk.getJoinedGroupList(new BaseImpl(promise), operationID);
  }

  @ReactMethod
  public void getJoinedGroupListPage(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.getJoinedGroupListPage(new BaseImpl(promise), operationID, options.getInt("offset"),
      options.getInt("count"));
  }

  @ReactMethod
  public void getSpecifiedGroupsInfo(ReadableArray groupIDList, String operationID, Promise promise) {
    Open_im_sdk.getSpecifiedGroupsInfo(new BaseImpl(promise), operationID, groupIDList.toString());
  }

  @ReactMethod
  public void searchGroups(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.searchGroups(new BaseImpl(promise), operationID, map2string(options));
  }

  @ReactMethod
  public void setGroupInfo(ReadableMap jsonGroupInfo, String operationID, Promise promise) {
    Open_im_sdk.setGroupInfo(new BaseImpl(promise), operationID, map2string(jsonGroupInfo));
  }

  @ReactMethod
  public void setGroupVerification(ReadableMap options, String operationID, Promise promise) {
    JSONObject params = new JSONObject();
    params.put("groupID", options.getString("groupID"));
    params.put("needVerification", options.getString("verification"));
    Open_im_sdk.setGroupInfo(new BaseImpl(promise), operationID, params.toString());
  }

  @ReactMethod
  public void setGroupLookMemberInfo(ReadableMap options, String operationID, Promise promise) {
    JSONObject params = new JSONObject();
    params.put("groupID", options.getString("groupID"));
    params.put("lookMemberInfo", options.getString("rule"));
    Open_im_sdk.setGroupInfo(new BaseImpl(promise), operationID, params.toString());
  }

  @ReactMethod
  public void setGroupApplyMemberFriend(ReadableMap options, String operationID, Promise promise) {
    JSONObject params = new JSONObject();
    params.put("groupID", options.getString("groupID"));
    params.put("applyMemberFriend", options.getString("rule"));
    Open_im_sdk.setGroupInfo(new BaseImpl(promise), operationID, params.toString());
  }

  @ReactMethod
  public void getGroupMemberList(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.getGroupMemberList(new BaseImpl(promise), operationID, options.getString("groupID"),
      options.getInt("filter"), options.getInt("offset"), options.getInt("count"));
  }

  @ReactMethod
  public void getGroupMemberOwnerAndAdmin(String groupID, String operationID, Promise promise) {
    Open_im_sdk.getGroupMemberOwnerAndAdmin(new BaseImpl(promise), operationID, groupID);
  }

  @ReactMethod
  public void getGroupMemberListByJoinTimeFilter(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.getGroupMemberListByJoinTimeFilter(new BaseImpl(promise), operationID, options.getString("groupID"),
      options.getInt("offset"), options.getInt("count"), options.getInt("joinTimeBegin"),
      options.getInt("joinTimeEnd"), Objects.requireNonNull(options.getArray("filterUserIDList")).toString());
  }

  @ReactMethod
  public void getSpecifiedGroupMembersInfo(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.getSpecifiedGroupMembersInfo(new BaseImpl(promise), operationID, options.getString("groupID"),
      Objects.requireNonNull(options.getArray("userIDList")).toString());
  }

  @ReactMethod
  public void getUsersInGroup(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.getUsersInGroup(new BaseImpl(promise), operationID, options.getString("groupID"),
      Objects.requireNonNull(options.getArray("userIDList")).toString());
  }

  @ReactMethod
  public void kickGroupMember(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.kickGroupMember(new BaseImpl(promise), operationID, options.getString("groupID"),
      options.getString("reason"), Objects.requireNonNull(options.getArray("userIDList")).toString());
  }

  @ReactMethod
  public void transferGroupOwner(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.transferGroupOwner(new BaseImpl(promise), operationID, options.getString("groupID"),
      options.getString("newOwnerUserID"));
  }

  @ReactMethod
  public void inviteUserToGroup(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.inviteUserToGroup(new BaseImpl(promise), operationID, options.getString("groupID"),
      options.getString("reason"), Objects.requireNonNull(options.getArray("userIDList")).toString());
  }

  @ReactMethod
  public void getGroupApplicationListAsRecipient(String operationID, ReadableMap req, Promise promise) {
    Open_im_sdk.getGroupApplicationListAsRecipient(new BaseImpl(promise), operationID, map2string(req));
  }

  @ReactMethod
  public void getGroupApplicationListAsApplicant(String operationID, ReadableMap req, Promise promise) {
    Open_im_sdk.getGroupApplicationListAsApplicant(new BaseImpl(promise), operationID, map2string(req));
  }

  @ReactMethod
  public void getGroupApplicationUnhandledCount(ReadableMap req, String operationID, Promise promise) {
    Open_im_sdk.getGroupApplicationUnhandledCount(new BaseImpl(promise), operationID, map2string(req));
  }

  @ReactMethod
  public void acceptGroupApplication(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.acceptGroupApplication(new BaseImpl(promise), operationID, options.getString("groupID"),
      options.getString("fromUserID"), options.getString("handleMsg"));
  }

  @ReactMethod
  public void refuseGroupApplication(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.refuseGroupApplication(new BaseImpl(promise), operationID, options.getString("groupID"),
      options.getString("fromUserID"), options.getString("handleMsg"));
  }

  @ReactMethod
  public void setGroupMemberNickname(ReadableMap options, String operationID, Promise promise) {
    JSONObject params = new JSONObject();
    params.put("groupID", options.getString("groupID"));
    params.put("userID", options.getString("userID"));
    params.put("nickname", options.getString("groupMemberNickname"));
    Open_im_sdk.setGroupMemberInfo(new BaseImpl(promise), operationID, params.toString());
  }

  @ReactMethod
  public void searchGroupMembers(ReadableMap searchOptions, String operationID, Promise promise) {
    Open_im_sdk.searchGroupMembers(new BaseImpl(promise), operationID, map2string(searchOptions));
  }

  @ReactMethod
  public void isJoinGroup(String groupID, String operationID, Promise promise) {
    Open_im_sdk.isJoinGroup(new BaseImpl(promise), operationID, groupID);
  }

  @ReactMethod
  public void updateFcmToken(String fcmToken, double expireTime, String operationID, Promise promise) {
    Open_im_sdk.updateFcmToken(new BaseImpl(promise), operationID, fcmToken, (int)expireTime);
  }

  @ReactMethod
  public void setAdvancedMsgListener() {
    Open_im_sdk.setAdvancedMsgListener(new AdvancedMsgListener(reactContext));
  }

  @ReactMethod
  public void sendMessage(ReadableMap options, String operationID, Promise promise) {
    ReadableMap message = options.getMap("message");
    String receiver = options.getString("recvID");
    String groupID = options.getString("groupID");
    ReadableMap offlinePushInfo = options.getMap("offlinePushInfo");

    boolean isOnlineOnly = false;
    if (options.hasKey("isOnlineOnly")) {
      isOnlineOnly = options.getBoolean("isOnlineOnly");
    }

    if (offlinePushInfo == null) {
      WritableMap defaultOfflinePushInfo = Arguments.createMap();
      defaultOfflinePushInfo.putString("title", "you have a new message");
      defaultOfflinePushInfo.putString("desc", "new message");
      defaultOfflinePushInfo.putString("ex", "");
      defaultOfflinePushInfo.putString("iOSPushSound", "+1");
      defaultOfflinePushInfo.putBoolean("iOSBadgeCount", true);
      offlinePushInfo = defaultOfflinePushInfo;
    }

    assert message != null;
    Open_im_sdk.sendMessage(new SendMsgCallBack(reactContext, promise, message), operationID, map2string(message), receiver, groupID, map2string(offlinePushInfo), isOnlineOnly);
  }

  @ReactMethod
  public void sendMessageNotOss(ReadableMap options, String operationID, Promise promise) {
    ReadableMap message = options.getMap("message");
    String receiver = options.getString("recvID");
    String groupID = options.getString("groupID");
    ReadableMap offlinePushInfo = options.getMap("offlinePushInfo");

    boolean isOnlineOnly = false;
    if (options.hasKey("isOnlineOnly")) {
      isOnlineOnly = options.getBoolean("isOnlineOnly");
    }

    if (offlinePushInfo == null) {
      WritableMap defaultOfflinePushInfo = Arguments.createMap();
      defaultOfflinePushInfo.putString("title", "you have a new message");
      defaultOfflinePushInfo.putString("desc", "new message");
      defaultOfflinePushInfo.putString("ex", "");
      defaultOfflinePushInfo.putString("iOSPushSound", "+1");
      defaultOfflinePushInfo.putBoolean("iOSBadgeCount", true);
      offlinePushInfo = defaultOfflinePushInfo;
    }

    assert message != null;
    Open_im_sdk.sendMessageNotOss(new SendMsgCallBack(reactContext, promise, message), operationID, map2string(message), receiver, groupID, map2string(offlinePushInfo), isOnlineOnly);
  }

  @ReactMethod
  public void setAppBadge(double appUnreadCount, String operationID, Promise promise) {
    Open_im_sdk.setAppBadge(new BaseImpl(promise), operationID, (int)appUnreadCount);
  }

  @ReactMethod
  public void uploadLogs(ReadableMap options, String operationID, Promise promise) {
    Open_im_sdk.uploadLogs(new BaseImpl(promise), operationID, (long)options.getDouble("line"), options.getString("ex"), new UploadLogProgressListener(reactContext, operationID));
  }

  @ReactMethod
  public void logs(ReadableMap options, String operationID, Promise promise) {
    long logLevel = (long)options.getDouble("logLevel");
    String file = options.getString("file");
    long line = (long)options.getDouble("line");
    String msg = options.getString("msgs");
    String err = options.getString("err");
    ReadableArray keyAndValue = options.getArray("keyAndValue");
    Open_im_sdk.logs(new BaseImpl(promise), operationID, logLevel, file, line, msg, err, keyAndValue.toString());
  }

  /**
   * This method should be an async method with Promise parameter, otherwise it is incompatible with React Native 0.80+ versions.
   * Details: https://github.com/openimsdk/open-im-sdk-reactnative/issues/72
   * Note: React Native 0.82+ dropped support for the old architecture.
   */
  @ReactMethod
  public void getSdkVersion(Promise promise) {
    promise.resolve(Open_im_sdk.getSdkVersion());
  }

  @ReactMethod
  public void uploadFile(ReadableMap reqData, String operationID, Promise promise) {
    Open_im_sdk.uploadFile(new BaseImpl(promise), operationID, map2string(reqData),
      new UploadFileCallbackListener(reactContext, operationID));
  }

  @ReactMethod
  public void unInitSDK(String operationID, Promise promise) {
    Open_im_sdk.unInitSDK(operationID);
    promise.resolve(null);
  }
}

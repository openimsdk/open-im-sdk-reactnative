package com.openimsdkrn.listener;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.openimsdkrn.utils.Emitter;

import open_im_sdk_callback.OnBatchMsgListener;

public class BatchMsgListener extends Emitter implements OnBatchMsgListener {
  private final ReactApplicationContext ctx;

  public BatchMsgListener(ReactApplicationContext ctx) {
    this.ctx = ctx;
  }

  @Override
  public void onRecvNewMessages(String s) {
    send(ctx,"onRecvNewMessages",jsonStringToArray(s));
  }

  @Override
  public void onRecvOfflineNewMessages(String s) {
    send(ctx,"onRecvOfflineNewMessages",jsonStringToArray(s));
  }
}

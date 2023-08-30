package com.openimsdkrn.listener;

import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.openimsdkrn.utils.Emitter;

import open_im_sdk_callback.UploadFileCallback;

public class UploadFileCallbackListener extends Emitter implements UploadFileCallback {
  private final ReactApplicationContext ctx;
  private final String operationID;
  public UploadFileCallbackListener(ReactApplicationContext ctx,String operationID){
    this.ctx = ctx;
    this.operationID = operationID;
  }

  @Override
  public void complete(long l, String s, long l1) {

  }

  @Override
  public void hashPartComplete(String s, String s1) {

  }

  @Override
  public void hashPartProgress(long l, long l1, String s) {

  }

  @Override
  public void open(long l) {

  }

  @Override
  public void partSize(long l, long l1) {

  }

  @Override
  public void uploadComplete(long l, long l1, long l2) {
    WritableMap params = Arguments.createMap();WritableMap data = new WritableNativeMap();
    data.putInt("fileSize", (int) l);
    data.putInt("streamSize", (int) l1);
    data.putInt("storageSize", (int) l2);
    data.putString("operationID", operationID);
    params.putMap("data", data);
    send(ctx,"uploadComplete",params);
  }

  @Override
  public void uploadID(String s) {

  }

  @Override
  public void uploadPartComplete(long l, long l1, String s) {

  }
}

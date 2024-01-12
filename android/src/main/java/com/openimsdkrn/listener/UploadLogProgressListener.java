package com.openimsdkrn.listener;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;
import com.openimsdkrn.utils.Emitter;

import open_im_sdk_callback.UploadLogProgress;

public class UploadLogProgressListener extends Emitter implements UploadLogProgress {
  private final ReactApplicationContext ctx;
  private final String operationID;
  public UploadLogProgressListener(ReactApplicationContext ctx, String operationID) {
    this.ctx = ctx;
    this.operationID = operationID;
  }

  @Override
  public void onProgress(long l, long l1) {
    WritableMap params = Arguments.createMap();
    params.putInt("current", (int) l);
    params.putInt("size", (int) l1);
    params.putString("operationID", operationID);
    send(ctx,"uploadOnProgress",params);
  }
}

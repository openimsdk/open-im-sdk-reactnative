package com.openimsdkrn.listener;

import com.facebook.react.bridge.ReactApplicationContext;
import com.openimsdkrn.utils.Emitter;

import open_im_sdk_callback.OnBatchMsgListener;

public class BatchMsgListener extends Emitter implements OnBatchMsgListener {
  private final ReactApplicationContext ctx;

  public BatchMsgListener(ReactApplicationContext ctx) {
    this.ctx = ctx;
  }

  @Override
  public void onRecvNewMessages(String s) {
    send(ctx,"OnRecvNewMessages",getParamsWithObject(0,"",s));
  }

  @Override
  public void onRecvOfflineNewMessages(String s) {
    send(ctx,"OnRecvOfflineNewMessages",getParamsWithObject(0,"",s));
  }
}

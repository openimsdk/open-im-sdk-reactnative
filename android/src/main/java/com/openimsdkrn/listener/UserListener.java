package com.openimsdkrn.listener;

import com.facebook.react.bridge.ReactApplicationContext;
import com.openimsdkrn.utils.Emitter;

import open_im_sdk_callback.OnUserListener;

public class UserListener extends Emitter implements OnUserListener {
  private final ReactApplicationContext ctx;

  public UserListener(ReactApplicationContext ctx) {
    this.ctx = ctx;
  }

  @Override
  public void onSelfInfoUpdated(String s) {
    send(ctx,"onSelfInfoUpdated",getParams(0,"",s));
  }

  @Override
  public void onUserStatusChanged(String s) {

  }
}

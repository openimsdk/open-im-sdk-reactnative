package com.openimsdkrn.listener;

import com.facebook.react.bridge.ReactApplicationContext;
import com.openimsdkrn.utils.Emitter;

import open_im_sdk_callback.OnCustomBusinessListener;

public class SetCustomBusinessListener extends Emitter implements OnCustomBusinessListener {
  private final ReactApplicationContext ctx;

  public SetCustomBusinessListener(ReactApplicationContext ctx) {
    this.ctx = ctx;
  }

  @Override
  public void onRecvCustomBusinessMessage(String s) {
    send(ctx,"onRecvCustomBusinessMessage",jsonStringToMap(s));
  }
}

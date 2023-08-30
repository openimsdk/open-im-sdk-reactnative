package com.openimsdkrn.listener;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;

import com.facebook.react.bridge.WritableMap;
import com.openimsdkrn.utils.Emitter;


public class OnConversationListener extends Emitter implements open_im_sdk_callback.OnConversationListener {
    private final ReactApplicationContext ctx;

    public OnConversationListener(ReactApplicationContext ctx){
        this.ctx = ctx;
    }


  @Override
  public void onConversationChanged(String s) {
    send(ctx,"onConversationChanged",getParamsWithArray(0,"", s));
  }

  @Override
  public void onNewConversation(String s) {
    send(ctx,"onNewConversation",getParamsWithArray(0,"", s));
  }

  @Override
  public void onSyncServerFailed() {
    send(ctx,"onSyncServerFailed",getParamsWithoutData(0,""));
  }

  @Override
  public void onSyncServerFinish() {
    send(ctx,"onSyncServerFinish",getParamsWithoutData(0,""));
  }

  @Override
  public void onSyncServerStart() {
    send(ctx,"onSyncServerStart",getParamsWithoutData(0,""));
  }

  @Override
  public void onTotalUnreadMessageCountChanged(int i) {
    WritableMap params = Arguments.createMap();
    params.putInt("data", i);
    send(ctx,"onTotalUnreadMessageCountChanged",params);
  }
}

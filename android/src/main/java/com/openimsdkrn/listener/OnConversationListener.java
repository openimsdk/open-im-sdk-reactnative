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
    send(ctx,"onConversationChanged",jsonStringToArray(s));
  }

  @Override
  public void onConversationUserInputStatusChanged(String s) {
    send(ctx,"onConversationUserInputStatusChanged",jsonStringToMap(s));
  }

  @Override
  public void onNewConversation(String s) {
    send(ctx,"onNewConversation",jsonStringToArray(s));
  }

  @Override
  public void onSyncServerFailed() {
    send(ctx,"onSyncServerFailed",null);
  }

  @Override
  public void onSyncServerFinish() {
    send(ctx,"onSyncServerFinish",null);
  }

  @Override
  public void onSyncServerStart() {
    send(ctx,"onSyncServerStart",null);
  }

  @Override
  public void onTotalUnreadMessageCountChanged(int i) {
    send(ctx,"onTotalUnreadMessageCountChanged", i);
  }
}

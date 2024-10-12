package com.openimsdkrn.listener;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;

import com.facebook.react.bridge.WritableMap;
import com.openimsdkrn.utils.Emitter;


public class OnConversationListener extends Emitter implements open_im_sdk_callback.OnConversationListener {
  private final ReactApplicationContext ctx;

  public OnConversationListener(ReactApplicationContext ctx) {
    this.ctx = ctx;
  }


  @Override
  public void onConversationChanged(String s) {
    send(ctx, "onConversationChanged", jsonStringToArray(s));
  }

  @Override
  public void onConversationUserInputStatusChanged(String s) {
    send(ctx, "onInputStatusChanged", jsonStringToMap(s));
  }

  @Override
  public void onNewConversation(String s) {
    send(ctx, "onNewConversation", jsonStringToArray(s));
  }

  @Override
  public void onSyncServerFailed(boolean b) {
    send(ctx, "onSyncServerFailed", b);
  }

  @Override
  public void onSyncServerFinish(boolean b) {
    send(ctx, "onSyncServerFinish", b);
  }

  @Override
  public void onSyncServerStart(boolean b) {
    send(ctx, "onSyncServerStart", b);
  }

  @Override
  public void onSyncServerProgress(long l) {
    int intValue = (int) l;
    send(ctx, "onSyncServerProgress", intValue);
  }

  @Override
  public void onTotalUnreadMessageCountChanged(int i) {
    send(ctx, "onTotalUnreadMessageCountChanged", i);
  }
}

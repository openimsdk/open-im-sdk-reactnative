package com.openimsdkrn.listener;

import com.facebook.react.bridge.ReactApplicationContext;

import com.openimsdkrn.utils.Emitter;


public class OnConversationListener extends Emitter implements open_im_sdk_callback.OnConversationListener {
    private final ReactApplicationContext ctx;

    public OnConversationListener(ReactApplicationContext ctx){
        this.ctx = ctx;
    }


  @Override
  public void onConversationChanged(String s) {
    send(ctx,"onConversationChanged",getParams(0,"", s));
  }

  @Override
  public void onNewConversation(String s) {
    send(ctx,"onNewConversation",getParams(0,"", s));
  }

  @Override
  public void onSyncServerFailed() {
    send(ctx,"onSyncServerFailed",getParams(0,"","onSyncServerFailed"));
  }

  @Override
  public void onSyncServerFinish() {
    send(ctx,"onSyncServerFinish",getParams(0,"","onSyncServerFinish"));
  }

  @Override
  public void onSyncServerStart() {
    send(ctx,"onSyncServerStart",getParams(0,"","onSyncServerStart"));
  }

  @Override
  public void onTotalUnreadMessageCountChanged(int i) {
    send(ctx,"onSyncServerFailed",getParams(0,"",String.valueOf(i)));
  }
}

package com.openimsdkrn.listener;

import com.facebook.react.bridge.ReactApplicationContext;

import com.openimsdkrn.utils.Emitter;
import open_im_sdk_callback.OnAdvancedMsgListener;

public class AdvancedMsgListener extends Emitter implements OnAdvancedMsgListener {
    private final ReactApplicationContext ctx;
    public AdvancedMsgListener(ReactApplicationContext ctx){
        this.ctx = ctx;
    }


  @Override
  public void onMsgDeleted(String s) {
    send(ctx,"onMsgDeleted",jsonStringToMap(s));
  }

  @Override
  public void onNewRecvMessageRevoked(String s) {
    send(ctx,"onNewRecvMessageRevoked",jsonStringToMap(s));
  }

  @Override
  public void onRecvC2CReadReceipt(String s) {
    send(ctx,"onRecvC2CReadReceipt",jsonStringToArray(s));
  }

  @Override
  public void onRecvNewMessage(String s) {
    send(ctx,"onRecvNewMessage",jsonStringToMap(s));
  }

  @Override
  public void onRecvOfflineNewMessage(String s) {
    send(ctx,"onRecvOfflineNewMessage",jsonStringToMap(s));
  }

  @Override
  public void onRecvOnlineOnlyMessage(String s) {
    send(ctx,"onRecvOnlineOnlyMessage",jsonStringToMap(s));
  }
}

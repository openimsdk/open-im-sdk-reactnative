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
    send(ctx,"onMsgDeleted",getParamsWithObject(s));
  }

  @Override
  public void onNewRecvMessageRevoked(String s) {
    send(ctx,"onNewRecvMessageRevoked",getParamsWithObject(s));
  }

  @Override
  public void onRecvC2CReadReceipt(String s) {
    send(ctx,"onRecvC2CReadReceipt",getParamsWithArray(s));
  }

  @Override
  public void onRecvGroupReadReceipt(String s) {
    send(ctx,"onRecvGroupReadReceipt",getParamsWithArray(s));
  }

  @Override
  public void onRecvMessageExtensionsAdded(String s, String s1) {
    send(ctx,"onRecvMessageExtensionsAdded",getParamsWithObject(s));
  }

  @Override
  public void onRecvMessageExtensionsChanged(String s, String s1) {
    send(ctx,"onRecvMessageExtensionsChanged",getParamsWithObject(s));
  }

  @Override
  public void onRecvMessageExtensionsDeleted(String s, String s1) {
    send(ctx,"onRecvMessageExtensionsDeleted",getParamsWithObject(s));
  }

  @Override
  public void onRecvNewMessage(String s) {
    send(ctx,"onRecvNewMessage",getParamsWithObject(s));
  }

  @Override
  public void onRecvOfflineNewMessage(String s) {
    send(ctx,"onRecvOfflineNewMessage",getParamsWithObject(s));
  }

  @Override
  public void onRecvOnlineOnlyMessage(String s) {
    send(ctx,"onRecvOnlineOnlyMessage",getParamsWithObject(s));
  }
}

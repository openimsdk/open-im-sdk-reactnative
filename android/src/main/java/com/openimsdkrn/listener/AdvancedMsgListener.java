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

  }

  @Override
  public void onNewRecvMessageRevoked(String s) {

  }

  @Override
  public void onRecvC2CReadReceipt(String s) {
    send(ctx,"onRecvC2CReadReceipt",getParams(0,"",s));
  }

  @Override
  public void onRecvGroupReadReceipt(String s) {
    send(ctx,"onRecvGroupReadReceipt",getParams(0,"",s));
  }

  @Override
  public void onRecvMessageExtensionsAdded(String s, String s1) {

  }

  @Override
  public void onRecvMessageExtensionsChanged(String s, String s1) {

  }

  @Override
  public void onRecvMessageExtensionsDeleted(String s, String s1) {

  }

//  @Override
//  public void onRecvMessageRevoked(String s) {
//    send(ctx,"onRecvMessageRevoked",getParams(0,"",s));
//  }

  @Override
  public void onRecvNewMessage(String s) {
    send(ctx,"onRecvNewMessage",getParams(0,"",s));
  }

  @Override
  public void onRecvOfflineNewMessage(String s) {

  }
}

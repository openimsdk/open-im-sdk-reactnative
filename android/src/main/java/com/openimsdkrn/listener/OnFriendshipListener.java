package com.openimsdkrn.listener;

import com.facebook.react.bridge.ReactApplicationContext;

import com.openimsdkrn.utils.Emitter;

public class OnFriendshipListener extends Emitter implements open_im_sdk_callback.OnFriendshipListener {
    private final ReactApplicationContext ctx;
    public OnFriendshipListener(ReactApplicationContext ctx) {
        this.ctx = ctx;
    }


  @Override
  public void onBlackAdded(String s) {
    send(ctx,"onBlackAdded",getParams(0,"",s));
  }

  @Override
  public void onBlackDeleted(String s) {
    send(ctx,"onBlackDeleted",getParams(0,"",s));
  }

  @Override
  public void onFriendAdded(String s) {
    send(ctx,"onFriendAdded",getParams(0,"",s));
  }

  @Override
  public void onFriendApplicationAccepted(String s) {
    send(ctx,"onFriendApplicationAccepted",getParams(0,"",s));
  }

  @Override
  public void onFriendApplicationAdded(String s) {
    send(ctx,"onFriendApplicationAdded",getParams(0,"",s));
  }

  @Override
  public void onFriendApplicationDeleted(String s) {
    send(ctx,"onFriendApplicationDeleted",getParams(0,"",s));
  }

  @Override
  public void onFriendApplicationRejected(String s) {
    send(ctx,"onFriendApplicationRejected",getParams(0,"",s));
  }

  @Override
  public void onFriendDeleted(String s) {
    send(ctx,"onFriendDeleted",getParams(0,"",s));
  }

  @Override
  public void onFriendInfoChanged(String s) {
    send(ctx,"onFriendInfoChanged",getParams(0,"",s));
  }
}

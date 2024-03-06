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
    send(ctx,"onBlackAdded",getParamsWithObject(s));
  }

  @Override
  public void onBlackDeleted(String s) {
    send(ctx,"onBlackDeleted",getParamsWithObject(s));
  }

  @Override
  public void onFriendAdded(String s) {
    send(ctx,"onFriendAdded",getParamsWithObject(s));
  }

  @Override
  public void onFriendApplicationAccepted(String s) {
    send(ctx,"onFriendApplicationAccepted",getParamsWithObject(s));
  }

  @Override
  public void onFriendApplicationAdded(String s) {
    send(ctx,"onFriendApplicationAdded",getParamsWithObject(s));
  }

  @Override
  public void onFriendApplicationDeleted(String s) {
    send(ctx,"onFriendApplicationDeleted",getParamsWithObject(s));
  }

  @Override
  public void onFriendApplicationRejected(String s) {
    send(ctx,"onFriendApplicationRejected",getParamsWithObject(s));
  }

  @Override
  public void onFriendDeleted(String s) {
    send(ctx,"onFriendDeleted",getParamsWithObject(s));
  }

  @Override
  public void onFriendInfoChanged(String s) {
    send(ctx,"onFriendInfoChanged",getParamsWithObject(s));
  }
}

package com.openimsdkrn.listener;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;

import com.facebook.react.bridge.WritableNativeMap;
import com.openimsdkrn.utils.Emitter;

import open_im_sdk_callback.OnConnListener;

public class InitSDKListener extends Emitter implements OnConnListener {
  private final ReactApplicationContext ctx;

  public InitSDKListener(ReactApplicationContext ctx) {
    this.ctx = ctx;
  }

  @Override
  public void onConnectFailed(int errCode, String errMsg) {
    WritableMap params = Arguments.createMap();
    params.putInt("errCode", (int) errCode);
    params.putString("errMsg", errMsg);
    send(ctx, "onConnectFailed", params);
  }

  @Override
  public void onConnectSuccess() {
    send(ctx, "onConnectSuccess", null);
  }

  @Override
  public void onConnecting() {
    send(ctx, "onConnecting", null);
  }

  @Override
  public void onKickedOffline() {
    send(ctx, "onKickedOffline", null);
  }

  @Override
  public void onUserTokenExpired() {
    send(ctx, "onUserTokenExpired", null);
  }

  @Override
  public void onUserTokenInvalid(String s) {
    send(ctx, "onUserTokenInvalid", null);
  }
}

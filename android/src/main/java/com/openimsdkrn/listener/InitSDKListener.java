package com.openimsdkrn.listener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;

import com.openimsdkrn.utils.Emitter;
import open_im_sdk_callback.OnConnListener;

public class InitSDKListener extends Emitter implements OnConnListener {
    private final ReactApplicationContext ctx;

    public InitSDKListener(ReactApplicationContext ctx) {
        this.ctx = ctx;
    }

    @Override
    public void onConnectFailed(int l, String s) {
        send(ctx,"onConnectFailed",getParamsWithoutData(l,s));
    }

    @Override
    public void onConnectSuccess() {
        send(ctx,"onConnectSuccess",getParamsWithoutData(0,""));
    }

    @Override
    public void onConnecting() {
        send(ctx,"onConnecting",getParamsWithoutData(0,""));
    }

    @Override
    public void onKickedOffline() {
        send(ctx,"onKickedOffline",getParamsWithoutData(0,""));
    }

    @Override
    public void onUserTokenExpired() {
        send(ctx,"onUserTokenExpired",getParamsWithoutData(0,""));
    }
}

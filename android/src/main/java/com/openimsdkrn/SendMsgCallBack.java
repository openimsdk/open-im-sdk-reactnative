package com.openimsdkrn;

import com.openimsdkrn.utils.Emitter;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;

public class SendMsgCallBack extends Emitter implements open_im_sdk_callback.SendMsgCallBack {
    final ReactApplicationContext ctx;
    final private Promise promise;
    final private String msg;
    public SendMsgCallBack(ReactApplicationContext ctx,Promise promise,String msg){
        this.ctx = ctx;
        this.promise = promise;
        this.msg = msg;
    }
    @Override
    public void onError(int l, String s) {
        promise.reject(String.valueOf(l),s);
    }

    @Override
    public void onProgress(long l) {
        WritableMap params = Arguments.createMap();
        params.putInt("progress", (int)l);
        params.putString("message", msg);
        send(ctx,"SendMessageProgress",getParams(0,"",readableMap2string(params)));
    }

    @Override
    public void onSuccess(String s) {
        promise.resolve(s);
    }
}

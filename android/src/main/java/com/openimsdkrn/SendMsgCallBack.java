package com.openimsdkrn;

import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.ReadableMap;
import com.openimsdkrn.utils.Emitter;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;

public class SendMsgCallBack extends Emitter implements open_im_sdk_callback.SendMsgCallBack {
    final ReactApplicationContext ctx;
    final private Promise promise;
    final private ReadableMap message;
    public SendMsgCallBack(ReactApplicationContext ctx,Promise promise,ReadableMap message){
        this.ctx = ctx;
        this.promise = promise;
        this.message = message;
    }
    @Override
    public void onError(int ErrCode, String ErrString) {
        promise.reject(String.valueOf(ErrCode),ErrString);
    }

    @Override
    public void onProgress(long progress) {
        WritableMap params = Arguments.createMap();
        params.putInt("progress", (int)progress);
        params.putMap("message", message);
        send(ctx,"SendMessageProgress",params);
    }

    @Override
    public void onSuccess(String s) {
        promise.resolve(JSONObject.parse(s));
    }
}

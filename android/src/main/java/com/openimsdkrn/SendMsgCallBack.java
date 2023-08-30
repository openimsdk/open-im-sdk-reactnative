package com.openimsdkrn;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;
import com.openimsdkrn.utils.Emitter;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;

import java.util.Iterator;

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
    private static WritableMap convertJsonToMap(JSONObject jsonObject) throws JSONException {
        WritableMap map = new WritableNativeMap();

        Iterator<String> iterator = jsonObject.keySet().iterator();
        while (iterator.hasNext()) {
          String key = iterator.next();
          Object value = jsonObject.get(key);
          if (value instanceof JSONObject) {
            map.putMap(key, convertJsonToMap((JSONObject) value));
          } else if (value instanceof JSONArray) {
            map.putArray(key, convertJsonToArray((JSONArray) value));
          } else if (value instanceof  Boolean) {
            map.putBoolean(key, (Boolean) value);
          } else if (value instanceof  Integer) {
            map.putInt(key, (Integer) value);
          } else if (value instanceof  Double) {
            map.putDouble(key, (Double) value);
          } else if (value instanceof String)  {
            map.putString(key, (String) value);
          } else {
            map.putString(key, value.toString());
          }
        }
        return map;
      }
      private static WritableArray convertJsonToArray(JSONArray jsonArray) throws JSONException {
        WritableArray array = new WritableNativeArray();

        for (int i = 0; i < jsonArray.size(); i++) {
          Object value = jsonArray.get(i);
          if (value instanceof JSONObject) {
            array.pushMap(convertJsonToMap((JSONObject) value));
          } else if (value instanceof  JSONArray) {
            array.pushArray(convertJsonToArray((JSONArray) value));
          } else if (value instanceof  Boolean) {
            array.pushBoolean((Boolean) value);
          } else if (value instanceof  Integer) {
            array.pushInt((Integer) value);
          } else if (value instanceof  Double) {
            array.pushDouble((Double) value);
          } else if (value instanceof String)  {
            array.pushString((String) value);
          } else {
            array.pushString(value.toString());
          }
        }
        return array;
      }
    @Override
    public void onProgress(long l) {
        WritableMap params = Arguments.createMap();
        params.putInt("progress", (int)l);
        params.putString("message", msg);
        send(ctx,"SendMessageProgress",getParamsWithObject(0,"",readableMap2string(params)));
    }

    @Override
    public void onSuccess(String s) {
        promise.resolve(convertJsonToMap((JSONObject) JSONObject.parse(s)));
    }
}

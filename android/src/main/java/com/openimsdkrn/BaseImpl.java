package com.openimsdkrn;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONException;
import com.facebook.react.bridge.Promise;
import open_im_sdk_callback.Base;

public class BaseImpl implements Base {
    final private Promise promise;

    public BaseImpl(Promise promise) {
        this.promise = promise;
    }

    @Override
    public void onError(int ErrorCode, String ErrorMsg) {
        promise.reject(String.valueOf(ErrorCode), ErrorMsg);
    }

    @Override
    public void onSuccess(String s) {
      try {
        // Attempt to parse s as a JSONObject
        promise.resolve(JSON.parseObject(s)); // Resolve the promise with a WritableMap
      } catch (Exception e1) {
        try {
          // Attempt to parse s as a JSONArray if JSONObject parsing fails
          promise.resolve(JSON.parseArray(s)); // Resolve the promise with a WritableArray
        } catch (Exception e2) {
          promise.resolve(s); // Resolve the promise with the plain string
        }
      }
    }

}

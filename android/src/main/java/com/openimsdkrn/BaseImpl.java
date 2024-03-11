package com.openimsdkrn;

import com.alibaba.fastjson.JSON;
import com.facebook.react.bridge.Promise;

import open_im_sdk_callback.Base;

import com.openimsdkrn.utils.Emitter;

public class BaseImpl implements Base {
  final private Promise promise;

  private Emitter emitter = new Emitter();

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
      promise.resolve(emitter.convertJsonToMap(JSON.parseObject(s)));
    } catch (Exception e1) {
      try {
        promise.resolve(emitter.convertJsonToArray(JSON.parseArray(s)));
      } catch (Exception e2) {
        promise.resolve(s);
      }
    }
  }

}

package com.openimsdkrn;

import com.facebook.react.bridge.Promise;
import open_im_sdk_callback.Base;

public class BaseImpl implements Base {
    final private Promise promise;

    public BaseImpl(Promise promise) {
        this.promise = promise;
    }

    @Override
    public void onError(int l, String s) {
        promise.reject(String.valueOf(l), s);
    }

    @Override
    public void onSuccess(String s) {
        promise.resolve(s);
    }

}

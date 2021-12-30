package com.openimsdkrn.utils;

import androidx.annotation.Nullable;

import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.bridge.WritableMap;

import java.util.Map;

public class Emitter {

    public void send(ReactContext reactContext,String eventName,@Nullable WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    public WritableMap getParams(long errCode, String errMsg, String data){
        WritableMap params = Arguments.createMap();
        params.putInt("errCode", (int) errCode);
        params.putString("errMsg", errMsg);
        params.putString("data", data);
        return params;
    }

    public String readableMap2string(ReadableMap map){
        JSONObject json = JSONObject.parseObject(map.toString());
        JSONObject json2 = json.getJSONObject("NativeMap");
        return json2.toJSONString();
    }
}

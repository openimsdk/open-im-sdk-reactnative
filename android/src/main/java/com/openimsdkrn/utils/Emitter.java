package com.openimsdkrn.utils;

import androidx.annotation.Nullable;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.math.BigDecimal;

public class Emitter {
  public void send(ReactContext reactContext, String eventName, @Nullable Object params) {
    reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit(eventName, params);
  }

  public WritableMap jsonStringToMap(String data) {
    JSONObject parsedData = JSON.parseObject(data);
    return convertJsonToMap(parsedData);
  }

  public WritableArray jsonStringToArray(String data) {
    JSONArray parsedArray = JSON.parseArray(data);
    WritableArray dataArray = new WritableNativeArray();
    for (Object item : parsedArray) {
      dataArray.pushMap(convertJsonToMap((JSONObject) item));
    }

    return dataArray;
  }

  public WritableMap convertJsonToMap(JSONObject jsonObject) {
    WritableMap writableMap = Arguments.createMap();
    for (String key : jsonObject.keySet()) {
      Object value = jsonObject.get(key);
      if (value instanceof String) {
        writableMap.putString(key, (String) value);
      } else if (value instanceof Integer) {
        writableMap.putInt(key, (Integer) value);
      }  else if (value instanceof Long) {
        writableMap.putDouble(key, ((Long) value).doubleValue());
      } else if (value instanceof BigDecimal) {
        BigDecimal bd = (BigDecimal) value;
        try {
          writableMap.putInt(key, bd.intValueExact());
        } catch (ArithmeticException e) {
          writableMap.putDouble(key, bd.doubleValue());
        }
      } else if (value instanceof Boolean) {
        writableMap.putBoolean(key, (Boolean) value);
      } else if (value instanceof JSONObject) {
        writableMap.putMap(key, convertJsonToMap((JSONObject) value));
      } else if (value instanceof JSONArray) {
        writableMap.putArray(key, convertJsonToArray((JSONArray) value));
      } else {
        writableMap.putNull(key);
      }
    }
    return writableMap;
  }

  public WritableArray convertJsonToArray(JSONArray jsonArray) {
    WritableArray writableArray = Arguments.createArray();
    for (int i = 0; i < jsonArray.size(); i++) {
      Object item = jsonArray.get(i);
      if (item instanceof JSONObject) {
        writableArray.pushMap(convertJsonToMap((JSONObject) item));
      } else if (item instanceof JSONArray) {
        writableArray.pushArray(convertJsonToArray((JSONArray) item));
      } else if (item instanceof String) {
        writableArray.pushString((String) item);
      } else if (item instanceof Integer) {
        writableArray.pushInt((Integer) item);
      } else if (item instanceof Long) {
        writableArray.pushDouble(((Long) item).doubleValue());
      } else if (item instanceof Double) {
        writableArray.pushDouble((Double) item);
      } else if (item instanceof Boolean) {
        writableArray.pushBoolean((Boolean) item);
      } else {
        writableArray.pushNull();
      }
    }
    return writableArray;
  }
}

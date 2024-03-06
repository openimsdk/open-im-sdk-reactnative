package com.openimsdkrn.utils;

import androidx.annotation.Nullable;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.List;

public class Emitter {

  // Sends an event to the JS side with optional parameters
  public void send(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
    reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit(eventName, params);
  }

  // Creates parameters with a JSON object
  public WritableMap getParamsWithObject(String data) {
    WritableMap params = Arguments.createMap(); // Use WritableNativeMap to create a new instance
    // Parse the data string as a JSON object using FastJSON
    JSONObject parsedData = JSON.parseObject(data);

    // Convert the parsedData to a ReadableMap (WritableMap is an implementation of ReadableMap)
    ReadableMap dataMap = convertJsonToMap(parsedData);
    params.putMap("data", dataMap);

    return params;
  }

  // Creates parameters with a JSON array
  public WritableMap getParamsWithArray(String data) {
    WritableMap params = Arguments.createMap();
    // Parse the data string as a JSON array using FastJSON
    JSONArray parsedArray = JSON.parseArray(data);

    // Convert the parsedData (List) to a WritableArray
    WritableArray dataArray = new WritableNativeArray();
    for (Object item : parsedArray) {
      dataArray.pushMap(convertJsonToMap((JSONObject) item)); // Convert each item to string and push to the array
    }
    params.putArray("data", dataArray);

    return params;
  }

  // Helper method to convert JSONObject to WritableMap
  public WritableMap convertJsonToMap(JSONObject json) {
    WritableMap map = Arguments.createMap();
    for (String key : json.keySet()) {
      Object value = json.get(key);
      // Check and put value based on its type
      if (value instanceof JSONObject) {
        map.putMap(key, convertJsonToMap((JSONObject) value));
      } else if (value instanceof JSONArray) {
        map.putArray(key, convertJsonToArray((JSONArray) value));
      } else if (value instanceof Boolean) {
        map.putBoolean(key, (Boolean) value);
      } else if (value instanceof Integer) {
        map.putInt(key, (Integer) value);
      } else if (value instanceof Double) {
        map.putDouble(key, (Double) value);
      } else if (value instanceof String) {
        map.putString(key, (String) value);
      } else {
        assert value != null;
        map.putString(key, value.toString());
      }
    }
    return map;
  }

//  // Helper method to convert JSONArray to WritableArray
public WritableArray convertJsonToArray(JSONArray array) {
    WritableArray writableArray = Arguments.createArray();
    for (int i = 0; i < array.size(); i++) {
      Object value = array.get(i);
      // Check and add value based on its type
      if (value instanceof JSONObject) {
        writableArray.pushMap(convertJsonToMap((JSONObject) value));
      } else if (value instanceof JSONArray) {
        writableArray.pushArray(convertJsonToArray((JSONArray) value));
      } else if (value instanceof Boolean) {
        writableArray.pushBoolean((Boolean) value);
      } else if (value instanceof Integer) {
        writableArray.pushInt((Integer) value);
      } else if (value instanceof Double) {
        writableArray.pushDouble((Double) value);
      } else if (value instanceof String) {
        writableArray.pushString((String) value);
      } else {
        writableArray.pushString(value.toString());
      }
    }
    return writableArray;
  }
}

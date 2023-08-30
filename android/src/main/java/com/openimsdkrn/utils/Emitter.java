package com.openimsdkrn.utils;

import androidx.annotation.Nullable;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.bridge.WritableMap;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class Emitter {

    public void send(ReactContext reactContext,String eventName,@Nullable WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
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
    public WritableMap getParamsWithObject(long errCode, String errMsg, String data){
      WritableMap params = new WritableNativeMap(); // Use WritableNativeMap to create a new instance
      params.putInt("errCode", (int) errCode);
      params.putString("errMsg", errMsg);

      // Parse the data string as a JSON object using FastJSON
      JSONObject parsedData = JSON.parseObject(data);

      // Convert the parsedData to a ReadableMap (WritableMap is an implementation of ReadableMap)

      ReadableMap dataMap = convertJsonToMap(parsedData);
      params.putMap("data", dataMap);


      return params;
    }
    public WritableMap getParamsWithArray(long errCode, String errMsg, String data){
      WritableMap params = Arguments.createMap();
      params.putInt("errCode", (int) errCode);
      params.putString("errMsg", errMsg);

      // Parse the data string as a JSON array using FastJSON
      Object parsedData = JSON.parse(data);

      if (parsedData instanceof List) {
        // Convert the parsedData (List) to a WritableArray
        WritableArray dataArray = new WritableNativeArray();
        for (Object item : (List) parsedData) {
          dataArray.pushString(item.toString()); // Convert each item to string and push to the array
        }
        params.putArray("data", dataArray);
      }

      return params;
    }
    public WritableMap getParamsWithoutData(long errCode, String errMsg){
        WritableMap params = Arguments.createMap();
        params.putInt("errCode", (int) errCode);
        params.putString("errMsg", errMsg);
        return params;
    }
    public String readableMap2string(ReadableMap map){
        // JSONObject json = JSONObject.parseObject(map.toString());
        // JSONObject json2 = json.getJSONObject("NativeMap");
        return map.toString();
    }
}

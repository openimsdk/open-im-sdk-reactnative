package com.openimsdkrn.listener;

import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;

import java.util.HashMap;
import java.util.Map;

import com.openimsdkrn.utils.Emitter;

public class OnGroupListener extends Emitter implements open_im_sdk_callback.OnGroupListener {

    private final ReactApplicationContext ctx;

    public OnGroupListener(ReactApplicationContext ctx){
        this.ctx = ctx;
    }


  @Override
  public void onGroupApplicationAccepted(String s) {
    send(ctx,"onGroupApplicationAccepted",getParamsWithObject(0,"",s));
  }

  @Override
  public void onGroupApplicationAdded(String s) {
    send(ctx,"onGroupApplicationAdded",getParamsWithObject(0,"",s));
  }

  @Override
  public void onGroupApplicationDeleted(String s) {
    send(ctx,"onGroupApplicationDeleted",getParamsWithObject(0,"",s));
  }

  @Override
  public void onGroupApplicationRejected(String s) {
    send(ctx,"onGroupApplicationRejected",getParamsWithObject(0,"",s));
  }

  @Override
  public void onGroupDismissed(String s) {
    send(ctx,"onGroupDismissed",getParamsWithObject(0,"",s));
  }

  @Override
  public void onGroupInfoChanged(String s) {
    send(ctx,"onGroupInfoChanged",getParamsWithObject(0,"",s));
  }

  @Override
  public void onGroupMemberAdded(String s) {
    send(ctx,"onGroupMemberAdded",getParamsWithObject(0,"",s));
  }

  @Override
  public void onGroupMemberDeleted(String s) {
    send(ctx,"onGroupMemberDeleted",getParamsWithObject(0,"",s));
  }

  @Override
  public void onGroupMemberInfoChanged(String s) {
    send(ctx,"onGroupMemberInfoChanged",getParamsWithObject(0,"",s));
  }

  @Override
  public void onJoinedGroupAdded(String s) {
    send(ctx,"onJoinedGroupAdded",getParamsWithObject(0,"",s));
  }

  @Override
  public void onJoinedGroupDeleted(String s) {
    send(ctx,"onJoinedGroupDeleted",getParamsWithObject(0,"",s));
  }
}

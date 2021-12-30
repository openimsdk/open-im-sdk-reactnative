package com.openimsdkrn.listener;

import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;

import java.util.HashMap;
import java.util.Map;

import com.openimsdkrn.utils.Emitter;

public class OnGroupListener extends Emitter implements open_im_sdk.OnGroupListener {

    private final ReactApplicationContext ctx;

    public OnGroupListener(ReactApplicationContext ctx){
        this.ctx = ctx;
    }

    @Override
    public void onApplicationProcessed(String groupId, String opUser, int agreeOrReject, String opReason) {
        JSONObject data = new JSONObject();
        data.put("groupId",groupId);
        data.put("opUser",opUser);
        data.put("agreeOrReject",agreeOrReject);
        data.put("opReason",opReason);
        String s = data.toJSONString();
        send(ctx,"onApplicationProcessed",getParams(0,"",s));
    }

    @Override
    public void onGroupCreated(String s) {
        JSONObject data = new JSONObject();
        data.put("groupId",s);
        String dataStr = data.toJSONString();
        send(ctx,"onGroupCreated",getParams(0,"",dataStr));
    }

    @Override
    public void onGroupInfoChanged(String s, String s1) {
        JSONObject data = new JSONObject();
        data.put("groupId",s);
        data.put("groupInfo",s1);
        String dataStr = data.toJSONString();
        send(ctx,"onGroupInfoChanged",getParams(0,"",dataStr));
    }

    @Override
    public void onMemberEnter(String s, String s1) {
        JSONObject data = new JSONObject();
        data.put("groupId",s);
        data.put("memberList",s1);
        String dataStr = data.toJSONString();
        send(ctx,"onMemberEnter",getParams(0,"",dataStr));
    }

    @Override
    public void onMemberInvited(String s, String s1, String s2) {
        JSONObject data = new JSONObject();
        data.put("groupId",s);
        data.put("opUser",s1);
        data.put("memberList",s2);
        String dataStr = data.toJSONString();
        send(ctx,"onMemberInvited",getParams(0,"",dataStr));
    }

    @Override
    public void onMemberKicked(String s, String s1, String s2) {
        JSONObject data = new JSONObject();
        data.put("groupId",s);
        data.put("opUser",s1);
        data.put("memberList",s2);
        String dataStr = data.toJSONString();
        send(ctx,"onMemberKicked",getParams(0,"",dataStr));
    }

    @Override
    public void onMemberLeave(String s, String s1) {
        JSONObject data = new JSONObject();
        data.put("groupId",s);
        data.put("member",s1);
        String dataStr = data.toJSONString();
        send(ctx,"onMemberLeave",getParams(0,"",dataStr));
    }

    @Override
    public void onReceiveJoinApplication(String s, String s1, String s2) {
        JSONObject data = new JSONObject();
        data.put("groupId",s);
        data.put("member",s1);
        data.put("opReason",s1);
        String dataStr = data.toJSONString();
        send(ctx,"onReceiveJoinApplication",getParams(0,"",dataStr));
    }
}

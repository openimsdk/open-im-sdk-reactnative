package com.openimsdkrn.listener;

import com.alibaba.fastjson.JSON;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;

import com.openimsdkrn.utils.Emitter;

public class OnConversationListener extends Emitter implements open_im_sdk.OnConversationListener {
    private final ReactApplicationContext ctx;

    public OnConversationListener(ReactApplicationContext ctx){
        this.ctx = ctx;
    }

    @Override
    public void onConversationChanged(String s) {
        send(ctx,"onConversationChanged",getParams(0,"", s));
    }

    @Override
    public void onNewConversation(String s) {
        send(ctx,"onNewConversation",getParams(0,"",s));
    }

    @Override
    public void onSyncServerFailed() {
        send(ctx,"onSyncServerFailed",getParams(0,"","syncServerFailed"));
    }

    @Override
    public void onSyncServerFinish() {
        send(ctx,"onSyncServerFinish",getParams(0,"","syncServerFinish"));
    }

    @Override
    public void onSyncServerStart() {
        send(ctx,"onSyncServerStart",getParams(0,"","syncServerStart"));
    }

    @Override
    public void onTotalUnreadMessageCountChanged(int i) {
        send(ctx,"onTotalUnreadMessageCountChanged",getParams(0,"",String.valueOf(i)));
    }
}

package com.openimsdkrn.listener;

import com.facebook.react.bridge.ReactApplicationContext;

import com.openimsdkrn.utils.Emitter;

public class OnFriendshipListener extends Emitter implements open_im_sdk.OnFriendshipListener {
    private final ReactApplicationContext ctx;
    public OnFriendshipListener(ReactApplicationContext ctx) {
        this.ctx = ctx;
    }

    @Override
    public void onBlackListAdd(String s) {
        send(ctx,"onBlackListAdd",getParams(0,"",s));
    }

    @Override
    public void onBlackListDeleted(String s) {
        send(ctx,"onBlackListDeleted",getParams(0,"",s));
    }

    @Override
    public void onFriendApplicationListAccept(String s) {
        send(ctx,"onFriendApplicationListAccept",getParams(0,"",s));
    }

    @Override
    public void onFriendApplicationListAdded(String s) {
        send(ctx,"onFriendApplicationListAdded",getParams(0,"",s));
    }

    @Override
    public void onFriendApplicationListDeleted(String s) {
        send(ctx,"onFriendApplicationListDeleted",getParams(0,"",s));
    }

    @Override
    public void onFriendApplicationListReject(String s) {
        send(ctx,"onFriendApplicationListReject",getParams(0,"",s));
    }

    @Override
    public void onFriendInfoChanged(String s) {
        send(ctx,"onFriendInfoChanged",getParams(0,"",s));
    }

    @Override
    public void onFriendListAdded(String s) {
        send(ctx,"onFriendListAdded",getParams(0,"",s));
    }

    @Override
    public void onFriendListDeleted(String s) {
        send(ctx,"onFriendListDeleted",getParams(0,"",s));
    }
}

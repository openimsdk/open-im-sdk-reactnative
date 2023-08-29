package com.openimsdkrn.listener;

import com.facebook.react.bridge.ReactApplicationContext;
import com.openimsdkrn.utils.Emitter;


public class OnSignalingListener extends Emitter implements open_im_sdk_callback.OnSignalingListener {
    private final ReactApplicationContext ctx;

    public OnSignalingListener(ReactApplicationContext ctx){
        this.ctx = ctx;
    }


  @Override
  public void onHangUp(String s) {
    send(ctx,"onHangUp",getParams(0,"",s));
  }

  @Override
  public void onInvitationCancelled(String s) {
    send(ctx,"onInvitationCancelled",getParams(0,"",s));
  }

  @Override
  public void onInvitationTimeout(String s) {
    send(ctx,"onInvitationTimeout",getParams(0,"",s));
  }

  @Override
  public void onInviteeAccepted(String s) {
    send(ctx,"onInviteeAccepted",getParams(0,"",s));
  }

  @Override
  public void onInviteeAcceptedByOtherDevice(String s) {
    send(ctx,"onInviteeAcceptedByOtherDevice",getParams(0,"",s));
  }

  @Override
  public void onInviteeRejected(String s) {
    send(ctx,"onInviteeRejected",getParams(0,"",s));
  }

  @Override
  public void onInviteeRejectedByOtherDevice(String s) {
    send(ctx,"onInviteeRejectedByOtherDevice",getParams(0,"",s));
  }

  @Override
  public void onReceiveNewInvitation(String s) {
    send(ctx,"onReceiveNewInvitation",getParams(0,"",s));
  }

  @Override
  public void onRoomParticipantConnected(String s) {

  }

  @Override
  public void onRoomParticipantDisconnected(String s) {

  }
}

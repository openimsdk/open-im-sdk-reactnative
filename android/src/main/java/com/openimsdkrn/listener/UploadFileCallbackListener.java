package com.openimsdkrn.listener;

import com.facebook.react.bridge.ReactApplicationContext;
import com.openimsdkrn.utils.Emitter;

import open_im_sdk_callback.UploadFileCallback;

public class UploadFileCallbackListener extends Emitter implements UploadFileCallback {
  private final ReactApplicationContext ctx;
  public UploadFileCallbackListener(ReactApplicationContext ctx){
    this.ctx = ctx;
  }

  @Override
  public void complete(long l, String s, long l1) {

  }

  @Override
  public void hashPartComplete(String s, String s1) {

  }

  @Override
  public void hashPartProgress(long l, long l1, String s) {

  }

  @Override
  public void open(long l) {

  }

  @Override
  public void partSize(long l, long l1) {

  }

  @Override
  public void uploadComplete(long l, long l1, long l2) {

  }

  @Override
  public void uploadID(String s) {

  }

  @Override
  public void uploadPartComplete(long l, long l1, String s) {

  }
}

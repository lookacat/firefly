package com.example.fireflyapp;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

import android.Manifest;
import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.net.Uri;
import android.os.Build;
import android.os.IBinder;
import android.provider.Settings;


import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity{
  private static final String CHANNEL = "flutter.native/helper";
  private static YoutubePlayerBackground player;
  private String initalId;
  
  private final ServiceConnection mConnection = new ServiceConnection() {
    public void onServiceConnected(ComponentName className, IBinder service) {
      player = ((YoutubePlayerBackground.MyBinder) service).getService();
      player.antiAd();
      player.init(initalId);
    }

    public void onServiceDisconnected(ComponentName className) {
      player = null;

    }
  };

  Intent i;
  YoutubePlayerBackground service;
  public final static int REQUEST_CODE = -1010101;

  //@RequiresApi(api = Build.VERSION_CODES.M)
  public void checkDrawOverlayPermission() {
    /*ActivityCompat.requestPermissions(this,
            new String[]{Manifest.permission.FOREGROUND_SERVICE}, 2);*/
    if (!Settings.canDrawOverlays(this)) {

      Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
              Uri.parse("package:" + getPackageName()));
      /*Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
              Uri.parse("package:" + getPackageName()));*/
      startActivityForResult(intent, REQUEST_CODE);
    }
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    // TODO: ADD LEGAL NOTICE https://support.startapp.com/hc/en-us/articles/360002411114-Android-Standard-#GettingStarted
    UnityBanner banner = new UnityBanner();
    banner.init(this, findViewById(android.R.id.content).getRootView());
    GeneratedPluginRegistrant.registerWith(flutterEngine);
	checkDrawOverlayPermission();
    findViewById(android.R.id.content).getRootView();
	new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
        new MethodChannel.MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, MethodChannel.Result result) {
            if (call.method.equals("init")) {
              service = new YoutubePlayerBackground();
              i = new Intent(MainActivity.this, YoutubePlayerBackground.class);
              MainActivity.this.bindService(i, mConnection, MainActivity.this.BIND_AUTO_CREATE);
              MainActivity.this.startService(i);
              initalId = call.argument("id");
              result.success("hello world");
            }
            if(call.method.equals("load")) {
              String id = call.argument("id");
              player.antiAd();
              player.loadId(id);
            }
            if(call.method.equals("pause")) {
              player.pause();
            }
            if(call.method.equals("play")) {
              player.play();
            }
            if(call.method.equals("videoAd")) {
              banner.DisplayInterstitialAd();
            }
    }});
  }
}

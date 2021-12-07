package com.example.fireflyapp;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.media.session.MediaSession;
import android.os.Binder;
import android.os.IBinder;
import android.os.PowerManager;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class YoutubePlayerBackground extends Service {
    private final IBinder binder = new MyBinder();

    public class MyBinder extends Binder {
        YoutubePlayerBackground getService() {
            return YoutubePlayerBackground.this;
        }
    }
    public MediaWebView wv;
    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }
    public void antiAd() {
        wv.evaluateJavascript("document.cookie=\"VISITOR_INFO1_LIVE=oKckVSqvaGw; path=/; domain=.youtube.com\";", null);
    }
    public void init(String id) {
        wv.loadUrl("https://m.youtube.com/watch?v=" + id + "&autoplay=0");
    }
    public void loadId(String id) {
        wv.evaluateJavascript("getPlayer().cueVideoById(\"" + id + "\");", null);
        play();
    }
    public void pause() {
        wv.evaluateJavascript("getPlayer().pauseVideo();", null);
    }
    public void play() {
        wv.evaluateJavascript("getPlayer().playVideo();", null);
    }
    @Override
    public void onCreate() {

    }
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        /*PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
        PowerManager.WakeLock wl = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "myapp:locker");
        wl.acquire();*/
        Log.d("LOL","Look a turtle!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        final WindowManager windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                android.view.ViewGroup.LayoutParams.WRAP_CONTENT,
                android.view.ViewGroup.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                        | WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
                PixelFormat.TRANSLUCENT
        );
        params.gravity = Gravity.TOP | Gravity.START;
        params.x = 0;
        params.y = 0;
        params.width = 0;
        params.height = 0;

        wv = new MediaWebView(this);
        wv.setWebViewClient(new WebViewClient() {
            @Override
            public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
                Log.d("Error","loading web view: request: "+request+" error: "+error);
            }

            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
                return null;
            }

            public void onPageFinished(WebView view, String url) {
                wv.evaluateJavascript("getPlayer().unMute();getPlayer().pauseVideo();", null);
            }
        });
        wv.getSettings().setJavaScriptEnabled(true);
        wv.getSettings().setUserAgentString("Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25");
        wv.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
        wv.getSettings().setDomStorageEnabled(true);
        wv.getSettings().setMediaPlaybackRequiresUserGesture(false);
        wv.loadUrl("https://m.youtube.com/watch?v=ewFH0l2CLFo");

        windowManager.addView(wv, params);
        return Service.START_STICKY;
    }
}

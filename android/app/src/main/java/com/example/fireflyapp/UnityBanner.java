package com.example.fireflyapp;

import com.unity3d.ads.IUnityAdsListener;
import com.unity3d.ads.UnityAds;
import com.unity3d.services.banners.IUnityBannerListener;
import com.unity3d.services.banners.UnityBanners;
import com.unity3d.services.banners.view.BannerPosition;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Rect;
import android.os.Build;
import android.view.DisplayCutout;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowInsets;
import android.view.WindowManager;

import androidx.annotation.RequiresApi;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class UnityBanner {
    private String unityGameId = "3596163";
    private boolean testMode = false;
    private String placementId = "banners";
    private View bannerView;
    private Activity main;
    private UnityAdsListener adslistener;
    private View root;
    private static final String CHANNEL = "flutter.native/ads";
    

    protected void init(Activity main, View root) {
        this.main = main;
        this.root = root;
        // Declare a new banner listener, and set it as the active banner listener:
        final IUnityBannerListener myBannerListener = new UnityBannerListener(root, main);
        UnityBanners.setBannerListener (myBannerListener);
        // Initialize the Ads SDK:
        adslistener = new UnityAdsListener(this.main);
        UnityAds.initialize(main, unityGameId, adslistener, testMode);
    }
    public void DisplayInterstitialAd () {
        if (UnityAds.isReady ("video")) {
            UnityAds.show(this.main, "video");
            UnityAds
        }
    }
    private class UnityAdsListener implements IUnityAdsListener {
        Activity root;
        public UnityAdsListener(Activity root) {
            this.root = root;
        }

        @Override
        public void onUnityAdsReady (String placementId) {
            UnityBanners.setBannerPosition (BannerPosition.TOP_CENTER);
            // Request ad content for your Placement, and lad the banner:
            UnityBanners.loadBanner (this.root, "banners");
        }

        @Override
        public void onUnityAdsStart (String placementId) {
            // Implement functionality for a user starting to watch an ad.
        }

        @Override
        public void onUnityAdsFinish (String placementId, UnityAds.FinishState finishState) {
            // Implement functionality for a user finishing an ad.
        }

        @Override
        public void onUnityAdsError (UnityAds.UnityAdsError error, String message) {
            // Implement functionality for a Unity Ads service error occurring.
        }
    }
    // Implement the banner listener interface methods:
    private class UnityBannerListener implements IUnityBannerListener {
        View root;
        Activity main;
        int safeAreaTop;

        public UnityBannerListener(View root, Activity main) {
            this.root = root;
            this.main = main;
            this.safeAreaTop = this.getSafeAreaTop();
        }
        public int getSafeAreaTop() {
            int result = 0;
            int resourceId = this.main.getResources().getIdentifier("status_bar_height", "dimen", "android");
            if (resourceId > 0) {
                result = this.main.getResources().getDimensionPixelSize(resourceId);
            }
            return result;
        }
        @Override
        public void onUnityBannerLoaded (String placementId, View view) {
            // When the banner content loads, add it to the view hierarchy:
            if(bannerView == null) {
                bannerView = view;
                view.setY(safeAreaTop);
                ((ViewGroup)root).addView(view);
                view.setY(safeAreaTop);
            }

        }

        @Override
        public void onUnityBannerUnloaded (String placementId) {
            // When the banner’s no longer in use, remove it from the view hierarchy:
            bannerView = null;
        }

        @Override
        public void onUnityBannerShow (String placementId) {
            // Called when the banner is first visible to the user.
        }

        @Override
        public void onUnityBannerClick (String placementId) {
            // Called when the banner is clicked.
        }

        @Override
        public void onUnityBannerHide (String placementId) {
            // Called when the banner is hidden from the user.
        }

        @Override
        public void onUnityBannerError (String message) {
            // Called when an error occurred, and the banner failed to load or show.
        }
    }
}

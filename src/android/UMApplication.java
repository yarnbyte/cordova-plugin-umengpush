package com.yl.umeng;

import android.app.Application;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.util.Log;

import com.umeng.commonsdk.UMConfigure;
import com.umeng.message.IUmengRegisterCallback;
import com.umeng.message.PushAgent;

import org.android.agoo.huawei.HuaWeiRegister;

/**
 * Created by yl on 2018/9/7.
 */

public class UMApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        String APPKEY = "";
        String MESSAGE_SECRET = "";

        String XIAOMI_ID = "";
        String XIAOMI_KEY = "";

        String MEIZU_APPID = "";
        String MEIZU_APPKEY = "";

        try {
            ApplicationInfo appInfo = this.getPackageManager()
                    .getApplicationInfo(this.getPackageName(),PackageManager.GET_META_DATA);
            APPKEY = appInfo.metaData.getString("UM_APPKEY");
            MESSAGE_SECRET = appInfo.metaData.getString("UM_MESSAGE_SECRET");
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        UMConfigure.init(this, APPKEY, "Umeng", UMConfigure.DEVICE_TYPE_PHONE, MESSAGE_SECRET);

        PushAgent mPushAgent = PushAgent.getInstance(this);
        //注册推送服务，每次调用register方法都会回调该接口
        mPushAgent.register(new IUmengRegisterCallback() {

            @Override
            public void onSuccess(String deviceToken) {
                //注册成功会返回device token
                Log.v("my_token","推送服务注册成功");
                Log.v("my_token",deviceToken);
            }

            @Override
            public void onFailure(String s, String s1) {

            }
        });

        HuaWeiRegister.register(this);
    }


}

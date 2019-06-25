package com.yl.umeng;

import android.app.Application;
import android.app.Notification;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.util.Log;
import android.widget.Toast;

import com.umeng.commonsdk.UMConfigure;
import com.umeng.message.IUmengRegisterCallback;
import com.umeng.message.PushAgent;
import com.umeng.message.UmengMessageHandler;
import com.umeng.message.UmengNotificationClickHandler;
import com.umeng.message.entity.UMessage;

import org.android.agoo.huawei.HuaWeiRegister;
import org.android.agoo.mezu.MeizuRegister;
import org.android.agoo.xiaomi.MiPushRegistar;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

/**
 * Created by yl on 2018/9/7.
 */

public class UMApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        SharedPreferences tokenSP = getSharedPreferences("mytoken", 0);
        SharedPreferences.Editor editor = tokenSP.edit();

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

           XIAOMI_ID = appInfo.metaData.getString("XIAOMI_ID");
           XIAOMI_KEY = appInfo.metaData.getString("XIAOMI_KEY");

           MEIZU_APPID = appInfo.metaData.getString("MEIZU_APPID");
           MEIZU_APPKEY = appInfo.metaData.getString("MEIZU_APPKEY");
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
                editor.putString("token",deviceToken);
                editor.commit();
            }

            @Override
            public void onFailure(String s, String s1) {
                Log.v("my_token","推送服务注册失败");
                Log.v("my_token","s="+s);
                Log.v("my_token","s1="+s1);
            }
        });

        HuaWeiRegister.register(this);

        MiPushRegistar.register(this,XIAOMI_ID,XIAOMI_KEY);

        MeizuRegister.register(this,MEIZU_APPID,MEIZU_APPKEY);


        UmengNotificationClickHandler umengNotificationClickHandler = new UmengNotificationClickHandler(){

            @Override
            public void launchApp(Context context, UMessage msg) {
                super.launchApp(context, msg);
                sendNotification(context,msg,"background");
            }

            @Override
            public void openUrl(Context context, UMessage msg) {
                super.openUrl(context, msg);
            }

            @Override
            public void openActivity(Context context, UMessage msg) {
                super.openActivity(context, msg);
            }

            @Override
            public void dealWithCustomAction(Context context, UMessage msg) {
            }
        };

        mPushAgent.setNotificationClickHandler(umengNotificationClickHandler);


        UmengMessageHandler messageHandler = new UmengMessageHandler() {
            @Override
            public Notification getNotification(Context context, UMessage msg) {
                sendNotification(context,msg,"foreground");
                return super.getNotification(context, msg);
            }
        };
        mPushAgent.setMessageHandler(messageHandler);

    }

    private void sendNotification(Context context,UMessage uMessage,String state){
        Intent intent = new Intent("com.yl.umeng.NotificationIntentFilter");
        intent.putExtra("data",msgToJson(uMessage,state).toString());
        context.sendBroadcast(intent);
    }

    private JSONObject msgToJson(UMessage uMsg,String state){
        JSONObject jsonObject = new JSONObject();
        if(uMsg!=null){
            try {
                jsonObject.put("id",uMsg.msg_id);
                jsonObject.put("state",state);
                jsonObject.put("title",uMsg.title);
                jsonObject.put("text",uMsg.text);
                for (Map.Entry entry : uMsg.extra.entrySet()) {
                    Object key = entry.getKey();
                    Object value = entry.getValue();
                    jsonObject.put(String.valueOf(key),String.valueOf(value));
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        return jsonObject;
    }

}

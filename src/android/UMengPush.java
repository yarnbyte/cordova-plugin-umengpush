package com.yl.umeng;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.util.Log;

import com.umeng.message.PushAgent;
import com.umeng.message.UTrack;
import com.umeng.message.common.inter.ITagManager;
import com.umeng.message.tag.TagManager;


import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Method;

/**
 * This class echoes a string called from JavaScript.
 */
public class UMengPush extends CordovaPlugin {

    private static final String TAG = UMengPush.class.getSimpleName();

    private PushAgent mPushAgent;

    private CallbackContext mCallbackContext;
    public static JSONObject pendingNotification;

    SharedPreferences tokenSP;

    BroadcastReceiver uPushBroadcastReceiver;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        mPushAgent = PushAgent.getInstance(this.cordova.getActivity());

        uPushBroadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String str = intent.getStringExtra("data");
                try {
                    JSONObject jsonObject = new JSONObject(str);
                    sendNotification(jsonObject);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        };
        IntentFilter notificationIntentFilter = new IntentFilter("com.yl.umeng.NotificationIntentFilter");
        cordova.getContext().registerReceiver(uPushBroadcastReceiver,notificationIntentFilter);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if(uPushBroadcastReceiver!=null){
            cordova.getContext().unregisterReceiver(uPushBroadcastReceiver);
        }
    }

    @Override
    public boolean execute(final String action,final JSONArray args,final CallbackContext callbackContext) throws JSONException {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    Method method = UMengPush.class.getDeclaredMethod(action, JSONArray.class, CallbackContext.class);
                    method.invoke(UMengPush.this, args, callbackContext);
                } catch (Exception e) {
                    Log.e(TAG, e.toString());
                }
            }
        });
        return true;
    }

    public void init(JSONArray args, final  CallbackContext callbackContext){
        tokenSP = this.cordova.getContext().getSharedPreferences("mytoken", 0);
        if(!tokenSP.getString("token","").equals("")){
            callbackContext.success(tokenSP.getString("token",""));
        }else{
            callbackContext.error("获取token失败");
        }
    }

    //设置别名
    public void setAlias(JSONArray args, final CallbackContext callbackContext) {
        String alias = args.optString(0);
        String alias_type = args.optString(1);

        if (args != null) {
            mPushAgent.setAlias(alias, alias_type, new UTrack.ICallBack() {
                @Override
                public void onMessage(boolean b, String s) {
                    if(b){
                        callbackContext.success(s);
                    }else{
                        callbackContext.error(s);
                    }

                }
            });

        } else {
            callbackContext.error("参数不能为空.");
        }
    }

    //添加别名
    public void addAlias(JSONArray args, CallbackContext callbackContext) {
        String alias = args.optString(0);
        String alias_type = args.optString(1);
        if (args != null) {
            mPushAgent.addAlias(alias, alias_type, new UTrack.ICallBack() {
                @Override
                public void onMessage(boolean b, String s) {
                    if(b){
                        callbackContext.success(s);
                    }else{
                        callbackContext.error(s);
                    }

                }
            });
        } else {
            callbackContext.error("参数不能为空.");
        }
    }

    //删除别名
    public void deleteAlias(JSONArray args, CallbackContext callbackContext) {

        String alias = args.optString(0);
        String alias_type = args.optString(1);

        if (args != null) {
            mPushAgent.deleteAlias(alias, alias_type, new UTrack.ICallBack() {
                @Override
                public void onMessage(boolean b, String s) {
                    if(b){
                        callbackContext.success(s);
                    }else{
                        callbackContext.error(s);
                    }
                }
            });
        } else {
            callbackContext.error("参数不能为空.");
        }
    }


    //添加标签
    public void addTags(JSONArray args, CallbackContext callbackContext) {
        String tag = args.optString(0);
        if (args != null) {
            mPushAgent.getTagManager().addTags(new TagManager.TCallBack() {
                @Override
                public void onMessage(boolean b, ITagManager.Result result) {
                    if(b){
                        callbackContext.success(String.valueOf(result));
                    }else{
                        callbackContext.error(String.valueOf(result));
                    }
                }
            },tag);
        } else {
            callbackContext.error("参数不能为空.");
        }
    }


    //删除标签
    public void deleteTags(JSONArray args, CallbackContext callbackContext) {
        String tag = args.optString(0);
        if (args != null) {
            mPushAgent.getTagManager().deleteTags(new TagManager.TCallBack() {
                @Override
                public void onMessage(boolean b, ITagManager.Result result) {
                    if(b){
                        callbackContext.success(String.valueOf(result));
                    }else{
                        callbackContext.error(String.valueOf(result));
                    }
                }
            },tag);

        } else {
            callbackContext.error("参数不能为空.");
        }
    }

    public void subscribeNotification(JSONArray args, CallbackContext callbackContext) {
        mCallbackContext = callbackContext;
        if (pendingNotification != null) {
            sendNotification(pendingNotification);
        }

    }

    private void sendNotification(JSONObject json) {
        if (mCallbackContext != null) {
            PluginResult result = new PluginResult(PluginResult.Status.OK, json);
            pendingNotification = null;
            result.setKeepCallback(true);
            mCallbackContext.sendPluginResult(result);
        }

    }

}

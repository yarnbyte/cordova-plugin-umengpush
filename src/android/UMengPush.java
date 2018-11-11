package com.yl.umeng;

import android.content.Context;
import android.util.Log;

import com.umeng.message.PushAgent;
import com.umeng.message.UTrack;
import com.umeng.message.common.inter.ITagManager;
import com.umeng.message.tag.TagManager;

import org.apache.cordova.CordovaArgs;
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


    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        mPushAgent = PushAgent.getInstance(this.cordova.getActivity());
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

    public void coolMethod(JSONArray args, CallbackContext callbackContext) {


        String alias = args.optString(0);
        String alias_type = args.optString(1);

        if (args != null) {
            callbackContext.success(alias+"==="+alias_type);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    public void init(JSONArray args, final  CallbackContext callbackContext){
        tokenSP = this.cordova.getContext().getSharedPreferences("mytoken", 0);
        String token = tokenSP.getString("token","");
        if(!tokenSP.getString("token","").equals("")){
            callbackContext.success(tokenSP.getString("token",""));
        }else{
            callbackContext.error("获取token失败");
        }
    }


    //设置别名
    public void setAlias(JSONArray args, final CallbackContext callbackContext) {
        Log.v("usecordova","setAlias");

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

    protected boolean getRemoteNotification(String arg, final CallbackContext callbackContext) {
        mCallbackContext = callbackContext;
        if (pendingNotification == null) {
            try {
                pendingNotification = new JSONObject("{}");
            }
            catch (JSONException e) {
                mCallbackContext.error(e.getMessage());
            }
        }
        sendNotification(pendingNotification);
        return true;
    }

    private void sendNotification(JSONObject json) {
        if (mCallbackContext == null) {
            pendingNotification = json;
            return;
        }
        PluginResult result = new PluginResult(PluginResult.Status.OK, json);
        pendingNotification = null;
        result.setKeepCallback(true);
        mCallbackContext.sendPluginResult(result);
    }

}

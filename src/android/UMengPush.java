package com.yl.umeng;

import android.content.Context;
import android.util.Log;

import com.umeng.message.PushAgent;
import com.umeng.message.UTrack;
import com.umeng.message.common.inter.ITagManager;
import com.umeng.message.tag.TagManager;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.CordovaWebView;
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


    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        mPushAgent = PushAgent.getInstance(this.cordova.getActivity());
    }

    @Override
    public boolean execute(final String action,final String msg,final CallbackContext callbackContext) throws JSONException {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    Method method = UMengPush.class.getDeclaredMethod(action, String.class, CallbackContext.class);
                    method.invoke(UMengPush.this, msg, callbackContext);
                } catch (Exception e) {
                    Log.e(TAG, e.toString());
                }
            }
        });
        return true;
    }

    public void coolMethod(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {
            callbackContext.success(message);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }


    //设置别名
    public void setAlias(String alias, final CallbackContext callbackContext) {
        Log.v("usecordova","setAlias");
        if (alias != null && alias.length() > 0) {
            mPushAgent.setAlias(alias, "ALIAS_TYPE.DIPAI", new UTrack.ICallBack() {
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
    public void addAlias(String alias, final CallbackContext callbackContext) {
        if (alias != null && alias.length() > 0) {
            mPushAgent.addAlias(alias, "ALIAS_TYPE.DIPAI", new UTrack.ICallBack() {
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
    public void deleteAlias(String alias, final CallbackContext callbackContext) {
        if (alias != null && alias.length() > 0) {
            mPushAgent.deleteAlias(alias, "ALIAS_TYPE.DIPAI", new UTrack.ICallBack() {
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


    //设置标签
    public void addTags(String tag, final CallbackContext callbackContext) {
        if (tag != null && tag.length() > 0) {
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
    public void deleteTags(String tag, final CallbackContext callbackContext) {
        if (tag != null && tag.length() > 0) {
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

}

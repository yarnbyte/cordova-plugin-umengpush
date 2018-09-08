package com.yl.umeng;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.umeng.message.UmengNotifyClickActivity;

import org.android.agoo.common.AgooConstants;

/**
 * Created by yl on 2018/9/8.
 */

public class PushActivity extends UmengNotifyClickActivity {
    private static String TAG = PushActivity.class.getName();

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
//        setContentView(R.layout.activity_mipush);
    }

    @Override
    public void onMessage(Intent intent) {
        super.onMessage(intent);  //此方法必须调用，否则无法统计打开数
        Log.i(TAG, intent.getStringExtra(AgooConstants.MESSAGE_BODY));
    }
}

package com.example.eyepetizer_flutter

import android.content.Context
import android.util.Log
import com.iflytek.cloud.*
import com.iflytek.cloud.ui.RecognizerDialog
import com.iflytek.cloud.ui.RecognizerDialogListener
import org.json.JSONException
import org.json.JSONObject

var mIatDialog: RecognizerDialog? = null

var mResultListener: SpeechManager.RecognizerResultListener? = null

class SpeechManager private constructor() {

    private val TAG = SpeechManager::class.java.simpleName

    private val mIatResults: HashMap<String?, String> = LinkedHashMap()

    companion object {
        fun getInstance(): SpeechManager {
            return SpeechManager()
        }
    }

    fun init(context: Context?) {
        //初始化科大讯飞语音
        SpeechUtility.createUtility(context, "${SpeechConstant.APPID}=e4677e9e")
        mIatDialog = RecognizerDialog(context, mInitListener)
        Log.d(TAG, "init: $mIatDialog")
        mIatDialog!!.setListener(mRecognizerDialogListener)
    }

    private val mInitListener = InitListener { code: Int ->
        Log.d(TAG, "SpeechRecognizer init() code = $code")
    }

    fun recognize(recognizerResultListener: RecognizerResultListener?) {
        if (mResultListener == null) mResultListener = recognizerResultListener
        mIatResults.clear()
        mIatDialog!!.show()
    }

    private val mRecognizerDialogListener: RecognizerDialogListener =
        object : RecognizerDialogListener {
            override fun onResult(results: RecognizerResult, isLast: Boolean) {
                printResult(results)
            }

            /**
             * 识别回调错误.
             */
            override fun onError(error: SpeechError) {
                if (mResultListener != null) {
                    mResultListener!!.onError(error.errorDescription)
                }
            }
        }

    private fun printResult(results: RecognizerResult) {
        val text: String = JsonParser.parseIatResult(results.resultString)
        var sn: String? = null
        // 读取json结果中的sn字段
        try {
            val resultJson = JSONObject(results.resultString)
            sn = resultJson.optString("sn")
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        mIatResults[sn] = text
        val stringBuilder = StringBuilder()
        for (key in mIatResults.keys) {
            stringBuilder.append(mIatResults[key])
        }
        if (mResultListener != null) {
            mResultListener!!.onResult(stringBuilder.toString())
        }
    }


    interface RecognizerResultListener {
        fun onResult(result: String?)
        fun onError(errorMsg: String?)
    }
}
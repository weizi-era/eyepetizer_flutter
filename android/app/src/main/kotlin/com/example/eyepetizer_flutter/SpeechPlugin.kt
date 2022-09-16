package com.example.eyepetizer_flutter

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.text.TextUtils
import android.widget.Toast
import androidx.core.app.ActivityCompat
import com.example.eyepetizer_flutter.SpeechManager.RecognizerResultListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat


class SpeechPlugin(private val context: Context) : MethodChannel.MethodCallHandler, FlutterPlugin {

   companion object {
       const val RECOGNIZER_REQUEST_CODE = 0x0010
   }

    private var mResultStateful: ResultStateful? = null


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "time" -> result.success(SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(System.currentTimeMillis()))
            "toast" -> {
                if (call.hasArgument("msg") && !TextUtils.isEmpty(call.argument("msg"))) {
                    Toast.makeText(context, call.argument("msg"), Toast.LENGTH_SHORT).show()
                } else {
                    Toast.makeText(context, "msg 不能为空", Toast.LENGTH_SHORT).show()
                }
            }
            "start" -> {
                mResultStateful = ResultStateful.of(result)
                startRecognizer()
            }

            else -> result.notImplemented()
        }
    }

    // 启动识别器
    fun startRecognizer() {
        val checkResultList = checkPermissions()
        if (checkResultList.isNotEmpty()) {
            ActivityCompat.requestPermissions(
                context as Activity,
                checkResultList.toTypedArray(),
                RECOGNIZER_REQUEST_CODE
            )
        } else {
            SpeechManager.getInstance().recognize(recognizerResultListener)
        }
    }

    private val recognizerResultListener: RecognizerResultListener =
        object : RecognizerResultListener {
            override fun onResult(result: String?) {
                mResultStateful?.success(result)
            }

            override fun onError(errorMsg: String?) {
                mResultStateful?.error(errorMsg!!, null, null)
            }
        }


    private fun checkPermissions(): List<String> {
        val checkResultList: MutableList<String> = ArrayList()
        if (Build.VERSION.SDK_INT >= 23) {
            val permissions = arrayOf(
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.RECORD_AUDIO, Manifest.permission.READ_CONTACTS,
                Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION
            )
            for (permission in permissions) {
                if (ActivityCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED) {
                    checkResultList.add(permission)
                }
            }
        }
        return checkResultList
    }

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
//        val methodChannel = MethodChannel(binding.binaryMessenger, "speech_plugin")
//        methodChannel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        TODO("Not yet implemented")
    }


}
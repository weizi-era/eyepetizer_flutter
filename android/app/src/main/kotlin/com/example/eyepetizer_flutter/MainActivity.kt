package com.example.eyepetizer_flutter

import android.app.AlertDialog
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import android.text.SpannableStringBuilder
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.Window
import android.view.WindowManager
import android.widget.TextView
import com.blankj.utilcode.util.SPUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

    private lateinit var mSpeechPlugin : SpeechPlugin
    lateinit var dialog: AlertDialog

    var methodChannel: MethodChannel? = null

    private val SP_IS_FIRST_ENTER_APP = "SP_IS_FIRST_ENTER_APP"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

       // methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "openMain")

       // handleFirstEnterApp()

        initSDK()

    }

    private fun invokeFlutterMethod() {
        if (methodChannel != null) {
            methodChannel!!.invokeMethod("main", "我是原生Android，我将参数传递给Flutter里面的一个方法",
                object : MethodChannel.Result{
                    override fun success(result: Any?) {
                        Log.d("MainActivity", "成功调用flutter的main方法 ")
                    }

                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {
                        Log.d("MainActivity", "失败了 ")
                    }

                    override fun notImplemented() {
                        Log.d("MainActivity", "flutter没有这个方法 ")
                    }
                })
        }
    }

    private fun initSDK() {

       // CrashReport.initCrashReport(applicationContext, "36af0fbfd6", true)
        SpeechManager.getInstance().init(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        mSpeechPlugin = SpeechPlugin(this)
        // 通过MethodChannel与原生通信
        MethodChannel(flutterEngine.dartExecutor, "speech_plugin").setMethodCallHandler(mSpeechPlugin)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == SpeechPlugin.RECOGNIZER_REQUEST_CODE) {
            if (grantResults.isNotEmpty()) {
                var grantedSize = 0
                for (grantResult in grantResults) {
                    if (grantResult == PackageManager.PERMISSION_GRANTED) {
                        grantedSize++
                    }
                }
                if (grantedSize == grantResults.size) {
                    mSpeechPlugin.startRecognizer()
                } else {
                    showWaringDialog()
                }
            } else {
                showWaringDialog()
            }
        }
    }

    private fun showWaringDialog() {
        AlertDialog.Builder(this, android.R.style.Theme_Material_Light_Dialog_Alert)
            .setTitle(R.string.waring)
            .setMessage(R.string.permission_waring)
            .setPositiveButton(R.string.sure
            ) { _, _ -> go2AppSettings() }.setNegativeButton(R.string.cancel, null).show()
    }

    private fun go2AppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        val uri: Uri = Uri.fromParts("package", packageName, null)
        intent.data = uri
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun startDialog() {
        dialog = AlertDialog.Builder(context).create()
        dialog.show()
        //对话框弹出后点击或按返回键不消失;
        dialog.setCancelable(false)
        val window: Window? = dialog.window
        if (window != null) {
            window.setContentView(R.layout.dialog_privacy)
            window.setGravity(Gravity.CENTER)
            window.setWindowAnimations(R.style.ActivityTranslucent)
            window.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
            //设置属性
            val params: WindowManager.LayoutParams = window.attributes
            params.width = WindowManager.LayoutParams.MATCH_PARENT
            params.flags = WindowManager.LayoutParams.FLAG_DIM_BEHIND
            params.dimAmount = 0.5f
            window.attributes = params
            val textView: TextView = window.findViewById(R.id.tv_1)
            val tvCancel: TextView = window.findViewById(R.id.tv_cancel)
            val tvAgree: TextView = window.findViewById(R.id.tv_agree)
            tvCancel.setOnClickListener { finish() }
            tvAgree.setOnClickListener { enterApp() }
            val str = "感谢您选择开眼视频APP！" +
                    "我们非常重视您的个人信息和隐私保护。" +
                    "为了更好地保障您的个人权益，在您使用我们的产品前，" +
                    "请务必审慎阅读《隐私政策》和《用户协议》内的所有条款，" +
                    "尤其是:1.我们对您的个人信息的收集/保存/使用/对外提供/保护等规则条款，以及您的用户权利等条款; " +
                    "2. 约定我们的限制责任、免责条款; 3.其他以颜色或加粗进行标识的重要条款。如您对以上协议有任何疑问，" +
                    "可通过人工客服或发邮件至408689023@qq.com与我们联系。您点击“同意并继续”的行为即表示您已阅读完毕并同意以上协议的全部内容。" +
                    "如您同意以上协议内容，请点击”同意并继续”，开始使用我们的产品和服务!"
            textView.text = str
            val ssb = SpannableStringBuilder()
            ssb.append(str)
            val start = str.indexOf("《") //第一个出现的位置
            ssb.setSpan(object : ClickableSpan() {
                override fun onClick(widget: View) {
                    jumpOutsideWeb("https://www.yuque.com/docs/share/1aba81c9-dcb1-4d81-a6e3-3f1fa23c6fe6?# 《MVVM_demo 隐私政策》")
                    SPUtils.getInstance().put(SP_IS_FIRST_ENTER_APP, true)
                }

                override fun updateDrawState(ds: TextPaint) {
                    super.updateDrawState(ds)
                    ds.color = resources.getColor(R.color.text_click_red) //设置文件颜色
                    // 去掉下划线
                    ds.isUnderlineText = false
                    ds.clearShadowLayer()
                }

            }, start, start + 6, 0)
            val end = str.lastIndexOf("《") //最后一个出现的位置
            ssb.setSpan(object : ClickableSpan() {
                override  fun onClick(widget: View) {
                    jumpOutsideWeb("https://www.yuque.com/docs/share/395c6d6a-e4aa-4133-ba21-5d1b7068dd19?# 《MVVM_demo 用户协议》")
                    SPUtils.getInstance().put(SP_IS_FIRST_ENTER_APP, true)
                }

                override fun updateDrawState(ds: TextPaint) {
                    super.updateDrawState(ds)
                    ds.color = resources.getColor(R.color.text_click_red) //设置文件颜色
                    // 去掉下划线
                    ds.isUnderlineText = false
                    ds.clearShadowLayer()
                }
            }, end, end + 6, 0)
            textView.movementMethod = LinkMovementMethod.getInstance()
            textView.setText(ssb, TextView.BufferType.SPANNABLE)
        }
    }

    private fun enterApp() { //同意并继续，进入APP
        dialog.cancel()
        initSDK()
        startFlutterApp()
    }

    /**
     * 首次进入App，清除登录信息,显示隐私说明
     */
    private fun handleFirstEnterApp() {
        val firstEnterApp: Boolean = isFirstEnterApp()
        if (firstEnterApp) {
            //saveFirstEnterApp()
            startDialog()
        } else {
            startFlutterApp()
        }
    }

    /**
     * 是否是首次进入APP
     */
    private fun isFirstEnterApp(): Boolean {
        return SPUtils.getInstance().getBoolean(SP_IS_FIRST_ENTER_APP, true)
    }

    /**
     * 保存首次进入APP状态
     */
    private fun saveFirstEnterApp() {
        SPUtils.getInstance().put(SP_IS_FIRST_ENTER_APP, false)
    }

    private fun jumpOutsideWeb(url: String) {
        val intent = Intent()
        intent.action = "android.intent.action.VIEW"
        intent.data = Uri.parse(url)
        startActivity(intent)
    }

    private fun startFlutterApp() {
        invokeFlutterMethod()
    }
}

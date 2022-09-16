package com.example.eyepetizer_flutter

import io.flutter.plugin.common.MethodChannel

class ResultStateful private constructor(private var result: MethodChannel.Result) : MethodChannel.Result {

    private var called  = false

    companion object {
        fun of(result : MethodChannel.Result) : ResultStateful{
            return ResultStateful(result)
        }
    }


    override fun success(o: Any?) {
        if (called) return
        called = true
        result.success(o)
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        if (called) return
        called = true
        result.error(errorCode, errorMessage, errorDetails)
    }

    override fun notImplemented() {
        if (called) return
        called = true
        result.notImplemented()
    }
}
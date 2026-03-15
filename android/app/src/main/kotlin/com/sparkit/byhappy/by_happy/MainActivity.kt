package com.sparkit.byhappy.by_happy

import android.os.Bundle
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override protected fun onCreate(savedInstanceState: Bundle?) {
        MapKitFactory.setApiKey("a0ef1404-2650-4f28-9891-c965ecc09174")
        super.onCreate(savedInstanceState)
    }
}

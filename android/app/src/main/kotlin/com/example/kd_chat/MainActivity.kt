package com.example.kd_chat

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import androidx.core.app.ActivityCompat
import android.Manifest

class MainActivity: FlutterActivity() {
    private val PERMISSIONS = arrayOf(
        Manifest.permission.CAMERA,
        Manifest.permission.RECORD_AUDIO,
        Manifest.permission.POST_NOTIFICATIONS
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ActivityCompat.requestPermissions(this, PERMISSIONS, 0)
    }
}


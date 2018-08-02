package com.example.finalparola

import android.content.Intent
import android.util.Log
import io.flutter.app.FlutterApplication
import io.intheloup.beacons.BeaconsPlugin
import io.intheloup.beacons.data.BackgroundMonitoringEvent

class App : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        
        // Beacons setup for Android
        BeaconsPlugin.init(this, object : BeaconsPlugin.BackgroundMonitoringCallback {
            override fun onBackgroundMonitoringEvent(event: BackgroundMonitoringEvent): Boolean {
                val intent = Intent(this@App, MainActivity::class.java)
                
                startActivity(intent)
                return true
            }
        })

    }



}
package com.example.device_sensor

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.BatteryManager
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.BinaryMessenger

class MainActivity : FlutterActivity(), SensorEventListener {

    private val DEVICE_CHANNEL = "com.example.device_info/device"
    private val SENSOR_CHANNEL = "com.example.device_info/sensors"
    private val SENSOR_EVENT_CHANNEL = "com.example.device_info/sensor_stream"

    private lateinit var cameraManager: CameraManager
    private lateinit var sensorManager: SensorManager
    private var gyroscope: Sensor? = null
    private var accelerometer: Sensor? = null
    private var cameraId: String? = null

    private lateinit var binaryMessenger: BinaryMessenger
    private lateinit var sensorEventChannel: EventChannel
    private var sensorEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        binaryMessenger = flutterEngine.dartExecutor.binaryMessenger

        cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        gyroscope = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

        // Find back-facing camera with flash
        try {
            for (id in cameraManager.cameraIdList) {
                val characteristics = cameraManager.getCameraCharacteristics(id)
                val facing = characteristics.get(CameraCharacteristics.LENS_FACING)
                val hasFlash = characteristics.get(CameraCharacteristics.FLASH_INFO_AVAILABLE)
                if (facing == CameraCharacteristics.LENS_FACING_BACK && hasFlash == true) {
                    cameraId = id
                    break
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        MethodChannel(binaryMessenger, DEVICE_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceName" -> result.success(getDeviceName())
                "getOSVersion" -> result.success(getOSVersion())
                "getBatteryLevel" -> getBatteryLevel(result)
                else -> result.notImplemented()
            }
        }

        MethodChannel(binaryMessenger, SENSOR_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "toggleFlashlight" -> {
                    val status = call.argument<Boolean>("status") ?: false
                    toggleFlashlight(status, result)
                }
                "toggleAccelerometer" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    toggleAccelerometer(enabled, result)
                }
                "toggleGyroscope" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    toggleGyroscope(enabled, result)
                }
                else -> result.notImplemented()
            }
        }

        sensorEventChannel = EventChannel(binaryMessenger, SENSOR_EVENT_CHANNEL)
        sensorEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                sensorEventSink = events
                if (gyroscope != null) {
                    sensorManager.registerListener(
                        this@MainActivity,
                        gyroscope,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                }
                if (accelerometer != null) {
                    sensorManager.registerListener(
                        this@MainActivity,
                        accelerometer,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                }
                if (gyroscope == null && accelerometer == null) {
                    events?.error("UNAVAILABLE", "No sensors available", null)
                }
            }

            override fun onCancel(arguments: Any?) {
                sensorEventSink = null
                sensorManager.unregisterListener(this@MainActivity)
            }
        })
    }

    private fun getDeviceName(): String = Build.MODEL ?: "Unknown"

    private fun getOSVersion(): String = Build.VERSION.RELEASE ?: "Unknown"

    private fun getBatteryLevel(result: MethodChannel.Result) {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        result.success(batteryLevel)
    }

    private fun toggleFlashlight(status: Boolean, result: MethodChannel.Result) {
        try {
            if (cameraId != null) {
                cameraManager.setTorchMode(cameraId!!, status)
                result.success(null)
            } else {
                result.error("UNAVAILABLE", "Flashlight not available", null)
            }
        } catch (e: Exception) {
            result.error("ERROR", "Failed to toggle flashlight", e.message)
        }
    }

    private fun toggleAccelerometer(enabled: Boolean, result: MethodChannel.Result) {
        try {
            if (accelerometer != null) {
                if (enabled) {
                    sensorManager.registerListener(
                        this,
                        accelerometer,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                } else {
                    sensorManager.unregisterListener(this, accelerometer)
                }
                result.success(null)
            } else {
                result.error("UNAVAILABLE", "Accelerometer not available on this device", null)
            }
        } catch (e: Exception) {
            result.error("ERROR", "Failed to toggle accelerometer", e.message)
        }
    }

    private fun toggleGyroscope(enabled: Boolean, result: MethodChannel.Result) {
        try {
            if (gyroscope != null) {
                if (enabled) {
                    sensorManager.registerListener(
                        this,
                        gyroscope,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                } else {
                    sensorManager.unregisterListener(this, gyroscope)
                }
                result.success(null)
            } else {
                result.error("UNAVAILABLE", "Gyroscope not available on this device", null)
            }
        } catch (e: Exception) {
            result.error("ERROR", "Failed to toggle gyroscope", e.message)
        }
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type == Sensor.TYPE_GYROSCOPE || event?.sensor?.type == Sensor.TYPE_ACCELEROMETER) {
            val sensorType = when (event?.sensor?.type) {
                Sensor.TYPE_GYROSCOPE -> "gyroscope"
                Sensor.TYPE_ACCELEROMETER -> "accelerometer"
                else -> "unknown"
            }
            
            val data = mapOf(
                "sensorType" to sensorType,
                "x" to event.values[0].toDouble(),
                "y" to event.values[1].toDouble(),
                "z" to event.values[2].toDouble()
            )
            sensorEventSink?.success(data)
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Not needed
    }

    override fun onPause() {
        super.onPause()
        sensorManager.unregisterListener(this)
    }

    override fun onResume() {
        super.onResume()
        // Listener re-registered automatically when Flutter side listens to event channel
    }
}

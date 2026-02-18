package com.raidalarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.inputmethod.InputMethodManager
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import com.raidalarm.fake_call.FakeCallBroadcastReceiver
import com.raidalarm.fake_call.FakeCallNotificationManager
import com.raidalarm.AlarmSettingsHelper

class MainActivity: FlutterFragmentActivity() {
    private val ALARM_SERVICE_CHANNEL = "com.raidalarm/alarm_service"
    private val PERMISSION_CHANNEL = "com.raidalarm/permission"
    private val INTENT_CHANNEL = "com.raidalarm/intent"
    // private val GUARD_MODE_CHANNEL = "com.raidalarm/guard_mode"
    private val PLAYER_NOTIFICATION_CHANNEL = "com.raidalarm/player_notification"
    
    companion object {
        private const val ENGINE_ID = "main_engine"
        
        @JvmStatic
        var notificationMethodChannel: MethodChannel? = null
            private set
    }
    
    private var pendingOverlayPermissionResult: MethodChannel.Result? = null
    private var permissionChannel: MethodChannel? = null
    private var wasWaitingForOverlayPermission = false
    
    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        val cachedEngine = FlutterEngineCache.getInstance().get(ENGINE_ID)
        Log.d("MainActivity", "provideFlutterEngine - cached engine: ${if (cachedEngine != null) "found" else "not found"}")
        
        if (cachedEngine != null) {
            try {
                // Engine'in gerçekten kullanılabilir olduğunu kontrol et
                val dartExecutor = cachedEngine.dartExecutor
                if (dartExecutor == null) {
                    FlutterEngineCache.getInstance().remove(ENGINE_ID)
                    Log.w("MainActivity", "provideFlutterEngine - engine removed (dartExecutor is null)")
                    return null
                }
                
                try {
                    val binaryMessenger = dartExecutor.binaryMessenger
                    if (binaryMessenger == null) {
                        FlutterEngineCache.getInstance().remove(ENGINE_ID)
                        Log.w("MainActivity", "provideFlutterEngine - engine removed (binaryMessenger is null)")
                        return null
                    }
                    
                    // Engine'in lifecycle durumunu kontrol et
                    // Eğer engine kullanılamaz durumdaysa cache'den kaldır ve null döndür
                    // Bu, yeni bir engine oluşturulmasını sağlar
                    
                    Log.d("MainActivity", "provideFlutterEngine - using cached engine")
                    return cachedEngine
                } catch (e: Exception) {
                    Log.e("MainActivity", "provideFlutterEngine - error checking binaryMessenger: ${e.message}", e)
                    try {
                        FlutterEngineCache.getInstance().remove(ENGINE_ID)
                        Log.w("MainActivity", "provideFlutterEngine - engine removed (exception in binaryMessenger check)")
                    } catch (removeException: Exception) {
                        Log.e("MainActivity", "provideFlutterEngine - error removing engine from cache: ${removeException.message}", removeException)
                    }
                    return null
                }
            } catch (e: Exception) {
                Log.e("MainActivity", "provideFlutterEngine - error checking dartExecutor: ${e.message}", e)
                try {
                    FlutterEngineCache.getInstance().remove(ENGINE_ID)
                    Log.w("MainActivity", "provideFlutterEngine - engine removed (exception in dartExecutor check)")
                } catch (removeException: Exception) {
                    Log.e("MainActivity", "provideFlutterEngine - error removing engine from cache: ${removeException.message}", removeException)
                }
                return null
            }
        } else {
            Log.d("MainActivity", "provideFlutterEngine - no cached engine, will create new one")
            return null
        }
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        
        AlarmHelper.setNotificationMethodChannel(notificationMethodChannel)
        com.raidalarm.fake_call.FakeCallBroadcastReceiver.setNotificationMethodChannel(notificationMethodChannel)
        
        setupAlarmServiceChannel(flutterEngine)
        
        setupPermissionChannel(flutterEngine)
        
        setupIntentChannel(flutterEngine)
        
        // setupGuardModeChannel(flutterEngine)
        
        setupFakeCallChannel(flutterEngine)

        setupPlayerNotificationChannel(flutterEngine)
        
        setupNativeTrackingChannel(flutterEngine)
    }

    private fun setupNativeTrackingChannel(flutterEngine: FlutterEngine) {
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.raidalarm/native_tracking")
        Log.d("MainActivity", "MethodChannel() created: com.raidalarm/native_tracking")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startTracking" -> {
                    try {
                        PlayerTrackingScheduler.startTracking(this)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("TRACKING_ERROR", e.message, null)
                    }
                }
                "stopTracking" -> {
                    try {
                        PlayerTrackingScheduler.stopTracking(this)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("TRACKING_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
    
    
    private fun setupAlarmServiceChannel(flutterEngine: FlutterEngine) {
        val alarmServiceChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ALARM_SERVICE_CHANNEL)
        Log.d("MainActivity", "MethodChannel() created: $ALARM_SERVICE_CHANNEL")
        alarmServiceChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "stopAlarm" -> {
                    try {
                        AlarmHelper.stopSystemAlarm(this)
                        Log.d("MainActivity", "AlarmHelper.stopSystemAlarm() called")
                        
                        if (isPhoneLocked()) {
                            finish()
                            Log.d("MainActivity", "finish() called (phone is locked)")
                        }
                        
                        result.success(null)
                        Log.d("MainActivity", "result.success() called: stopAlarm")
                    } catch (e: Exception) {
                        result.error("STOP_ALARM_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: stopAlarm")
                    }
                }
                "startAlarm" -> {
                    try {
                        val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
                        scope.launch {
                            AlarmTriggerManager.triggerAlarm(this@MainActivity)
                        }
                        Log.d("MainActivity", "AlarmTriggerManager.triggerAlarm() called via MethodChannel")
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("START_ALARM_ERROR", e.message, null)
                    }
                }
                "dismissAlarmNotification" -> {
                    try {
                        AlarmHelper.dismissAlarmNotification(this)
                        Log.d("MainActivity", "AlarmHelper.dismissAlarmNotification() called")
                        result.success(null)
                        Log.d("MainActivity", "result.success() called: dismissAlarmNotification")
                    } catch (e: Exception) {
                        result.error("DISMISS_NOTIFICATION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: dismissAlarmNotification")
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        Log.d("MainActivity", "setMethodCallHandler() called: $ALARM_SERVICE_CHANNEL")
    }
    
    private fun isPhoneLocked(): Boolean {
        return DeviceStateHelper.isPhoneLocked(this, "MainActivity")
    }
    
    private fun setupPermissionChannel(flutterEngine: FlutterEngine) {
        permissionChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSION_CHANNEL)
        Log.d("MainActivity", "MethodChannel() created: $PERMISSION_CHANNEL")
        permissionChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkBatteryOptimization" -> {
                    try {
                        val isIgnoring = PermissionHelper.isIgnoringBatteryOptimizations(this)
                        result.success(isIgnoring)
                        Log.d("MainActivity", "result.success() called: checkBatteryOptimization = $isIgnoring")
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: checkBatteryOptimization")
                    }
                }
                "requestBatteryOptimizationExemption" -> {
                    try {
                        val isGranted = PermissionHelper.requestBatteryOptimizationExemption(this)
                        result.success(isGranted)
                        Log.d("MainActivity", "result.success() called: requestBatteryOptimizationExemption = $isGranted")
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: requestBatteryOptimizationExemption")
                    }
                }
                "checkExactAlarmPermission" -> {
                    try {
                        val canSchedule = PermissionHelper.canScheduleExactAlarms(this)
                        result.success(canSchedule)
                        Log.d("MainActivity", "result.success() called: checkExactAlarmPermission = $canSchedule")
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: checkExactAlarmPermission")
                    }
                }
                "requestExactAlarmPermission" -> {
                    try {
                        PermissionHelper.requestExactAlarmPermission(this)
                        result.success(true)
                        Log.d("MainActivity", "result.success() called: requestExactAlarmPermission = true")
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: requestExactAlarmPermission")
                    }
                }
                "checkNotificationEnabled" -> {
                    try {
                        val isEnabled = NotificationHelper.areNotificationsEnabled(this)
                        result.success(isEnabled)
                        Log.d("MainActivity", "result.success() called: checkNotificationEnabled = $isEnabled")
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: checkNotificationEnabled")
                    }
                }
                "canDrawOverlays" -> {
                    try {
                        val canDraw = PermissionHelper.canDrawOverlays(this)
                        result.success(canDraw)
                        Log.d("MainActivity", "result.success() called: canDrawOverlays = $canDraw")
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: canDrawOverlays")
                    }
                }
                "requestDisplayOverOtherAppsPermission" -> {
                    try {
                        val isGranted = PermissionHelper.requestDisplayOverOtherAppsPermission(
                            this,
                            PermissionHelper.REQUEST_CODE_OVERLAY_PERMISSION
                        )
                        if (isGranted) {
                            result.success(true)
                            Log.d("MainActivity", "result.success() called: requestDisplayOverOtherAppsPermission = true")
                        } else {
                            wasWaitingForOverlayPermission = true
                            pendingOverlayPermissionResult = result
                            Log.d("MainActivity", "wasWaitingForOverlayPermission set to true, pendingOverlayPermissionResult saved")
                        }
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: requestDisplayOverOtherAppsPermission")
                    }
                }
                "openRustPlusApp" -> {
                    try {
                        val packageName = call.argument<String>("packageName") ?: "com.facepunch.rust.companion"
                        val intent = packageManager.getLaunchIntentForPackage(packageName)
                        if (intent != null) {
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(intent)
                            result.success(true)
                            Log.d("MainActivity", "result.success() called: openRustPlusApp = true")
                        } else {
                            result.success(false)
                            Log.d("MainActivity", "result.success() called: openRustPlusApp = false (app not found)")
                        }
                    } catch (e: Exception) {
                        result.error("APP_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: openRustPlusApp")
                    }
                }
                "openRustPlusNotificationSettings" -> {
                    try {
                        val packageName = call.argument<String>("packageName") ?: "com.facepunch.rust.companion"
                        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
                                putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                            }
                        } else {
                            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                                data = Uri.parse("package:$packageName")
                            }
                        }
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                        Log.d("MainActivity", "result.success() called: openRustPlusNotificationSettings = true")
                    } catch (e: Exception) {
                        result.error("SETTINGS_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: openRustPlusNotificationSettings")
                    }
                }
                "openAppSettings" -> {
                    try {
                        PermissionHelper.openAppSettings(this)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SETTINGS_ERROR", e.message, null)
                    }
                }
                "requestNotificationPermission" -> {
                    try {
                        PermissionHelper.requestNotificationPermission(this, 1003)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                    }
                }
                "checkAutoStartPermission" -> {
                    try {
                        val isGranted = PermissionHelper.checkAutoStartPermission(this)
                        result.success(isGranted)
                        Log.d("MainActivity", "result.success() called: checkAutoStartPermission = $isGranted")
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: checkAutoStartPermission")
                    }
                }
                "requestAutoStartPermission" -> {
                    try {
                        PermissionHelper.requestAutoStartPermission(this)
                        result.success(true)
                        Log.d("MainActivity", "result.success() called: requestAutoStartPermission = true")
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: requestAutoStartPermission")
                    }
                }
                "canUseFullScreenIntent" -> {
                    try {
                        val canUse = PermissionHelper.canUseFullScreenIntent(this)
                        result.success(canUse)
                        Log.d("MainActivity", "result.success() called: canUseFullScreenIntent = $canUse")
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: canUseFullScreenIntent")
                    }
                }
                "requestFullScreenIntentPermission" -> {
                    try {
                        PermissionHelper.requestFullScreenIntentPermission(this)
                        result.success(true)
                        Log.d("MainActivity", "result.success() called: requestFullScreenIntentPermission = true")
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: requestFullScreenIntentPermission")
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        Log.d("MainActivity", "setMethodCallHandler() called: $PERMISSION_CHANNEL")
    }
    
    private fun setupIntentChannel(flutterEngine: FlutterEngine) {
        val intentChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INTENT_CHANNEL)
        Log.d("MainActivity", "MethodChannel() created: $INTENT_CHANNEL")
        intentChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getIntentAction" -> {
                    try {
                        val intent = getIntent()
                        val action = intent?.action
                        result.success(action)
                        Log.d("MainActivity", "result.success() called: getIntentAction = $action")
                    } catch (e: Exception) {
                        result.error("INTENT_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: getIntentAction")
                    }
                }
                "getIntentExtra" -> {
                    try {
                        val extraKey = call.arguments as? String
                        if (extraKey != null) {
                            val intent = getIntent()
                            val extraValue = intent?.getBooleanExtra(extraKey, false)
                            result.success(extraValue)
                            Log.d("MainActivity", "result.success() called: getIntentExtra($extraKey) = $extraValue")
                        } else {
                            result.success(null)
                            Log.d("MainActivity", "result.success() called: getIntentExtra - no key provided")
                        }
                    } catch (e: Exception) {
                        result.error("INTENT_ERROR", e.message, null)
                        Log.d("MainActivity", "result.error() called: getIntentExtra")
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        Log.d("MainActivity", "setMethodCallHandler() called: $INTENT_CHANNEL")
    }
    
    /*
    private fun setupGuardModeChannel(flutterEngine: FlutterEngine) {
      // Guard Mode Removed
    }
    */
    
    private fun setupFakeCallChannel(flutterEngine: FlutterEngine) {
        val fakeCallChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.raidalarm/fake_call")
        Log.d("MainActivity", "MethodChannel() created: com.raidalarm/fake_call")
        fakeCallChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "showFakeCall" -> {
                    try {
                        val settings = AlarmSettingsHelper.loadSettings(this@MainActivity, logTag = "MainActivity")
                        Log.d("MainActivity", "loadSettings() called for fake call")
                        
                        if (!settings.fakeCallEnabled) {
                            Log.d("MainActivity", "fakeCallEnabled is false - skipping fake call")
                            result.success(false)
                            return@setMethodCallHandler
                        }
                        
                        val args = call.arguments as? Map<*, *>
                        if (args != null) {
                            val durationFromArgs = (args["durationSeconds"] as? Int ?: 0)
                            val effectiveDuration = if (durationFromArgs > 0) {
                                val clampedDuration = durationFromArgs.coerceIn(30, 120)
                                (clampedDuration * 1000L)
                            } else {
                                settings.getEffectiveFakeCallDuration()
                            }
                            Log.d("MainActivity", "Effective fake call duration: $effectiveDuration ms")
                            
                            val data = android.os.Bundle().apply {
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_ID, args["id"] as? String ?: "")
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_NAME_CALLER, args["callerName"] as? String ?: "")
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_AVATAR, args["avatar"] as? String ?: "")
                                putLong(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_DURATION, effectiveDuration)
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_TEXT_ACCEPT, args["acceptText"] as? String ?: getString(R.string.text_accept))
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_TEXT_DECLINE, args["declineText"] as? String ?: getString(R.string.text_decline))
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_SUBTITLE, args["subtitle"] as? String ?: "")
                                // Ses seçimi: args'tan gelirse onu kullan, yoksa settings'ten al, yoksa sistem varsayılanı
                                val ringtonePathFromArgs = args["ringtonePath"] as? String
                                val ringtonePath = ringtonePathFromArgs ?: settings.fakeCallSound ?: "system_ringtone_default"
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_RINGTONE_PATH, ringtonePath)
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_BACKGROUND_COLOR, args["backgroundColor"] as? String ?: "#1E1E1E")
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_ACTION_COLOR, args["actionColor"] as? String ?: "#4CAF50")
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_TEXT_COLOR, args["textColor"] as? String ?: "#ffffff")
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_APP_NAME, args["appName"] as? String ?: "Raid Alarm")
                            }
                            
                            this@MainActivity.sendBroadcast(
                                com.raidalarm.fake_call.FakeCallBroadcastReceiver.getIntentIncoming(
                                    this@MainActivity,
                                    data
                                )
                            )
                            Log.d("MainActivity", "Fake call incoming broadcast sent - duration: $effectiveDuration ms")
                        }
                        result.success(true)
                    } catch (e: Exception) {
                        Log.d("MainActivity", "Error showing fake call: ${e.message}")
                        result.error("ERROR", e.message, null)
                    }
                }
                "dismissFakeCall" -> {
                    try {
                        val args = call.arguments as? Map<*, *>
                        val data = android.os.Bundle().apply {
                            if (args != null) {
                                putString(com.raidalarm.fake_call.FakeCallConstants.EXTRA_FAKE_CALL_ID, args["id"] as? String ?: "")
                            }
                        }
                        com.raidalarm.fake_call.FakeCallNotificationManager.clearIncomingNotification(
                            this@MainActivity,
                            data,
                            false
                        )
                        Log.d("MainActivity", "Fake call dismissed")
                        result.success(true)
                    } catch (e: Exception) {
                        Log.d("MainActivity", "Error dismissing fake call: ${e.message}")
                        result.error("ERROR", e.message, null)
                    }
                }
                "endAllCalls" -> {
                    try {
                        com.raidalarm.fake_call.FakeCallNotificationManager.clearIncomingNotification(
                            this@MainActivity,
                            android.os.Bundle(),
                            false
                        )
                        Log.d("MainActivity", "All fake calls ended")
                        result.success(true)
                    } catch (e: Exception) {
                        Log.d("MainActivity", "Error ending all calls: ${e.message}")
                        result.error("ERROR", e.message, null)
                    }
                }
                "getActiveCalls" -> {
                    result.success(emptyList<Map<String, Any>>())
                    Log.d("MainActivity", "getActiveCalls() called - returning empty list")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        Log.d("MainActivity", "setMethodCallHandler() called: com.raidalarm/fake_call")
        Log.d("MainActivity", "setMethodCallHandler() called: com.raidalarm/fake_call")
    }

    private fun setupPlayerNotificationChannel(flutterEngine: FlutterEngine) {
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PLAYER_NOTIFICATION_CHANNEL)
        Log.d("MainActivity", "MethodChannel() created: $PLAYER_NOTIFICATION_CHANNEL")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "showNotification" -> {
                    try {
                        val playerName = call.argument<String>("playerName") ?: ""
                        val serverName = call.argument<String>("serverName") ?: ""
                        val isOnline = call.argument<Boolean>("isOnline") ?: false
                        
                        PlayerNotificationManager.showPlayerStatusNotification(
                            this@MainActivity,
                            playerName,
                            serverName,
                            isOnline
                        )
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("NOTIFICATION_ERROR", e.message, null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Android 15 (SDK 35) için edge-to-edge desteği
        enableEdgeToEdge()
        Log.d("MainActivity", "enableEdgeToEdge() called")

        // NOT: setShowWhenLocked(false) - Normal durumda keyguard (pincode) gösterilmeli
        // Sadece alarm durumunda (TRIGGER_ALARM intent'i geldiğinde) setShowWhenLocked(true) yapılacak
        // Bu, uygulama açıkken telefon kitlenirse pincode'un gösterilmesini sağlar
        setShowWhenLocked(false)
        Log.d("MainActivity", "setShowWhenLocked(false) called - keyguard will be shown when phone is locked")
        
        // Engine cache'i kontrol et ve geçersizse temizle
        // Bu, uygulama kapatılıp açıldığında veya telefon kilitliyken açıldığında
        // geçersiz engine cache'in kullanılmasını önler
        validateAndCleanEngineCache()
        
        val intent = getIntent()

        // GO_TO_HOME intent'i geldiğinde engine cache'i temizleme
        // Bu, yeni bir engine oluşturulmasını sağlar ve lifecycle sorunlarını önler
        if (intent?.action == "com.raidalarm.GO_TO_HOME") {
            try {
                val cachedEngine = FlutterEngineCache.getInstance().get(ENGINE_ID)
                if (cachedEngine != null) {
                    // Engine'i cache'den kaldırmadan önce, engine'in durumunu kontrol et
                    // Eğer engine kullanılamaz durumdaysa cache'den kaldır
                    try {
                        if (cachedEngine.dartExecutor == null) {
                            FlutterEngineCache.getInstance().remove(ENGINE_ID)
                            Log.d("MainActivity", "FlutterEngineCache.getInstance().remove() called (GO_TO_HOME - dartExecutor is null)")
                        }
                    } catch (e: Exception) {
                        // Engine durumu kontrol edilemezse cache'den kaldır
                        FlutterEngineCache.getInstance().remove(ENGINE_ID)
                        Log.d("MainActivity", "FlutterEngineCache.getInstance().remove() called (GO_TO_HOME - exception checking engine)")
                    }
                }
            } catch (e: Exception) {
                Log.e("MainActivity", "Error handling GO_TO_HOME intent: ${e.message}", e)
            }
        }

        IntentHandler.handleIntent(
            activity = this,
            intent = getIntent(),
            lifecycleState = IntentHandler.LifecycleState.CREATE,
            notificationMethodChannel = null
        )
        Log.d("MainActivity", "IntentHandler.handleIntent() called (CREATE)")
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        
        if (intent.action == "com.raidalarm.GO_TO_HOME") {
            try {
                notificationMethodChannel?.invokeMethod("goToHome", null)
                Log.d("MainActivity", "invokeMethod() called: goToHome")
            } catch (e: Exception) {
                Log.e("MainActivity", "Error invoking goToHome: ${e.message}", e)
            }
            return
        }
        
        IntentHandler.handleIntent(
            activity = this,
            intent = intent,
            lifecycleState = IntentHandler.LifecycleState.NEW_INTENT,
            notificationMethodChannel = notificationMethodChannel
        )
        Log.d("MainActivity", "IntentHandler.handleIntent() called (NEW_INTENT)")
    }
    
    override fun onResume() {
        super.onResume()
        
        checkPendingPermissionResults()
        
        IntentHandler.checkAndProcessPendingIntent(this, notificationMethodChannel)
        Log.d("MainActivity", "IntentHandler.checkAndProcessPendingIntent() called")
        
        val intent = getIntent()
        if (intent?.action == "com.raidalarm.TRIGGER_ALARM") {
            WindowFlagsManager.setWindowFlagsForLockedScreen(this)
            Log.d("MainActivity", "WindowFlagsManager.setWindowFlagsForLockedScreen() called")
            hideSoftKeyboard()
        }
        if (intent?.action == "com.raidalarm.GO_TO_HOME") {
            try {
                notificationMethodChannel?.invokeMethod("goToHome", null)
                Log.d("MainActivity", "invokeMethod() called: goToHome")
                // CRITICAL FIX: Consume the action so it doesn't trigger again on next onResume (e.g. back from image picker)
                intent.action = android.content.Intent.ACTION_MAIN
            } catch (e: Exception) {
                Log.e("MainActivity", "Error invoking goToHome: ${e.message}", e)
            }
        }
        
        if (intent?.action == "com.raidalarm.TRIGGER_ALARM" || 
            intent?.action == "com.raidalarm.DISMISS_ALARM") {
            IntentHandler.handleIntentOnResume(
                activity = this,
                intent = intent,
                notificationMethodChannel = notificationMethodChannel
            )
            Log.d("MainActivity", "IntentHandler.handleIntentOnResume() called")
        }
    }
    
    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        getIntent()?.action?.let { action ->
            outState.putString("saved_intent_action", action)
            Log.d("MainActivity", "outState.putString() called: saved_intent_action = $action")
        }
    }
    
    override fun onRestoreInstanceState(savedInstanceState: Bundle) {
        super.onRestoreInstanceState(savedInstanceState)
    }
    
    override fun onStart() {
        super.onStart()
        IntentHandler.checkAndProcessPendingIntent(this, notificationMethodChannel)
        Log.d("MainActivity", "IntentHandler.checkAndProcessPendingIntent() called (onStart)")
    }
    
    override fun onRestart() {
        super.onRestart()
        IntentHandler.checkAndProcessPendingIntent(this, notificationMethodChannel)
        Log.d("MainActivity", "IntentHandler.checkAndProcessPendingIntent() called (onRestart)")
    }
    
    override fun onDestroy() {
        super.onDestroy()
        
        // Activity destroy edildiğinde engine cache'i temizle
        // Bu, uygulama kapatıldığında veya activity değiştiğinde
        // geçersiz engine cache'in kullanılmasını önler
        // Not: isFinishing() kontrolü yapmıyoruz çünkü configuration change'de
        // de onDestroy çağrılır, ama bu durumda engine cache'i korumak isteyebiliriz
        // Ancak güvenlik için her durumda temizliyoruz
        try {
            val cachedEngine = FlutterEngineCache.getInstance().get(ENGINE_ID)
            if (cachedEngine != null && isFinishing()) {
                // Activity gerçekten bitiyorsa engine cache'i temizle
                FlutterEngineCache.getInstance().remove(ENGINE_ID)
                Log.d("MainActivity", "FlutterEngineCache.getInstance().remove() called (onDestroy - isFinishing)")
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "Error cleaning engine cache in onDestroy: ${e.message}", e)
        }
    }
    
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            IntentHandler.checkAndProcessPendingIntent(this, notificationMethodChannel)
            Log.d("MainActivity", "IntentHandler.checkAndProcessPendingIntent() called (onWindowFocusChanged)")
        }
    }
    
    private fun checkPendingPermissionResults() {
        Log.d("MainActivity", "checkPendingPermissionResults() called")
        // Overlay permission kontrolü
        if (wasWaitingForOverlayPermission || pendingOverlayPermissionResult != null) {
            val isGranted = PermissionHelper.canDrawOverlays(this)
            Log.d("MainActivity", "checkPendingPermissionResults - overlay: wasWaiting=$wasWaitingForOverlayPermission, pendingResult=${pendingOverlayPermissionResult != null}, isGranted=$isGranted")
            
            pendingOverlayPermissionResult?.let { result ->
            result.success(isGranted)
            Log.d("MainActivity", "result.success() called: overlay permission = $isGranted")
            pendingOverlayPermissionResult = null
            }
            
            if (wasWaitingForOverlayPermission) {
            sendPermissionChangedEvent("overlay", isGranted)
                wasWaitingForOverlayPermission = false
                Log.d("MainActivity", "sendPermissionChangedEvent() called: overlay = $isGranted, flag reset to false")
            }
        }
        
        
        // Notification listener permission check removed
        /*
        if (wasWaitingForNotificationListener || pendingNotificationListenerResult != null) {
            // ... removed ...
        }
        */
    }
    
    private fun sendPermissionChangedEvent(permissionType: String, isGranted: Boolean) {
        try {
            val arguments = mapOf(
                "permissionType" to permissionType,
                "isGranted" to isGranted
            )
            permissionChannel?.invokeMethod("onPermissionChanged", arguments)
            Log.d("MainActivity", "invokeMethod() called: onPermissionChanged")
        } catch (e: Exception) {
            Log.e("MainActivity", "Error sending permission changed event: ${e.message}", e)
        }
    }
    
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
    }
    
    private fun hideSoftKeyboard() {
        try {
            val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            val view = currentFocus
            if (view != null) {
                imm.hideSoftInputFromWindow(view.windowToken, 0)
                Log.d("MainActivity", "hideSoftInputFromWindow() called (from focused view)")
            } else {
                val windowToken = window.decorView.rootView.windowToken
                if (windowToken != null) {
                    imm.hideSoftInputFromWindow(windowToken, 0)
                    Log.d("MainActivity", "hideSoftInputFromWindow() called (from window token)")
                }
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "Error hiding soft keyboard: ${e.message}", e)
        }
    }
    
    /// Engine cache'i kontrol et ve geçersizse temizle
    /// Bu metod, uygulama kapatılıp açıldığında veya telefon kilitliyken açıldığında
    /// geçersiz engine cache'in kullanılmasını önler
    private fun validateAndCleanEngineCache() {
        try {
            val cachedEngine = FlutterEngineCache.getInstance().get(ENGINE_ID)
            if (cachedEngine != null) {
                // Engine'in gerçekten kullanılabilir olduğunu kontrol et
                try {
                    val dartExecutor = cachedEngine.dartExecutor
                    if (dartExecutor == null) {
                        FlutterEngineCache.getInstance().remove(ENGINE_ID)
                        Log.d("MainActivity", "validateAndCleanEngineCache - engine removed (dartExecutor is null)")
                        return
                    }
                    
                    val binaryMessenger = dartExecutor.binaryMessenger
                    if (binaryMessenger == null) {
                        FlutterEngineCache.getInstance().remove(ENGINE_ID)
                        Log.d("MainActivity", "validateAndCleanEngineCache - engine removed (binaryMessenger is null)")
                        return
                    }
                    
                    Log.d("MainActivity", "validateAndCleanEngineCache - engine is valid")
                } catch (e: Exception) {
                    // Engine durumu kontrol edilemezse cache'den kaldır
                    FlutterEngineCache.getInstance().remove(ENGINE_ID)
                    Log.e("MainActivity", "validateAndCleanEngineCache - engine removed (exception: ${e.message})", e)
                }
            } else {
                Log.d("MainActivity", "validateAndCleanEngineCache - no cached engine found")
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "validateAndCleanEngineCache - error: ${e.message}", e)
        }
    }
    
}

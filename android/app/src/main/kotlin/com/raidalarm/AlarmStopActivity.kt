package com.raidalarm

import android.app.Activity
import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.WindowManager
import android.view.WindowInsetsController
import android.view.WindowInsets
import android.view.inputmethod.InputMethodManager
import android.widget.Button
import android.widget.TextView
import android.util.Log
import com.raidalarm.ActivityUtils
import java.text.SimpleDateFormat
import java.util.*

class AlarmStopActivity : Activity() {
    private var timeHandler: Handler? = null
    private var timeRunnable: Runnable? = null
    
    private lateinit var dateText: TextView
    private lateinit var timeText: TextView
    private lateinit var stopButton: Button
    
    private val alarmDurationFinishedReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            Log.d("AlarmStopActivity", "onReceive() called - action: ${intent?.action}")
            if (intent?.action == "com.raidalarm.ALARM_DURATION_FINISHED") {
                try {
                    val mainIntent = Intent(this@AlarmStopActivity, MainActivity::class.java).apply {
                        action = "com.raidalarm.GO_TO_HOME"
                        putExtra("from_alarm_dismiss", true)
                        flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or
                                Intent.FLAG_ACTIVITY_SINGLE_TOP or
                                Intent.FLAG_ACTIVITY_NEW_TASK or
                                Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
                    }
                    Log.d("AlarmStopActivity", "Intent created - GO_TO_HOME")
                    startActivity(mainIntent)
                    Log.d("AlarmStopActivity", "startActivity() called")
                    finish()
                    Log.d("AlarmStopActivity", "finish() called")
                } catch (e: Exception) {
                    finish()
                }
            }
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setupWindowFlags()
        hideSoftKeyboard()
        
        setContentView(R.layout.activity_alarm_stop)
        Log.d("AlarmStopActivity", "setContentView() called")
        
        dateText = findViewById(R.id.dateText)
        timeText = findViewById(R.id.timeText)
        stopButton = findViewById(R.id.stopButton)
        Log.d("AlarmStopActivity", "findViewById() called for all views")
        
        stopButton.text = getString(R.string.alarm_stop_button_full)
        Log.d("AlarmStopActivity", "getString() called for title and button")
        
        stopButton.setOnClickListener {
            stopAlarm()
        }
        Log.d("AlarmStopActivity", "setOnClickListener() called")
        
        updateTime()
        
        timeHandler = Handler(Looper.getMainLooper())
        Log.d("AlarmStopActivity", "Handler created")
        timeRunnable = object : Runnable {
            override fun run() {
                updateTime()
                timeHandler?.postDelayed(this, 1000)
            }
        }
        timeHandler?.postDelayed(timeRunnable!!, 1000)
        Log.d("AlarmStopActivity", "postDelayed() called - time update handler")
        
        val filter = IntentFilter("com.raidalarm.ALARM_DURATION_FINISHED")
        try {
            // RECEIVER_NOT_EXPORTED: API 33+ için zorunlu, MinSdk 28 olduğu için kontrol gerekli
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(alarmDurationFinishedReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
                Log.d("AlarmStopActivity", "registerReceiver() called - RECEIVER_NOT_EXPORTED")
            } else {
                registerReceiver(alarmDurationFinishedReceiver, filter)
                Log.d("AlarmStopActivity", "registerReceiver() called - legacy")
            }
        } catch (e: Exception) {
            Log.e("AlarmStopActivity", "Error registering receiver: ${e.message}", e)
        }
        
        // Alarm stop screen açıldığında bildirimi heads-up olarak göster
        // Tam ekran aktivitelerde bile heads-up bildirimler gözükmeli
        NotificationHelper.showAttackDetectedNotificationForFullScreenActivity(this, delayMs = 0)
        
        // setShowWhenLocked(true) should be enough - no need to call requestDismissKeyguard()
        // which would show PIN code. Window flags handle keyguard dismissal automatically.
        Log.d("AlarmStopActivity", "Window flags set - keyguard should be dismissed automatically")
    }
    
    override fun onResume() {
        super.onResume()
        
        setupWindowFlags()
        // setShowWhenLocked(true) handles keyguard - no need for requestDismissKeyguard()

        hideSoftKeyboard()
        ActivityUtils.moveActivityToFront(this, delayMs = 100, logTag = "AlarmStopActivity")
        Log.d("AlarmStopActivity", "ActivityUtils.moveActivityToFront() called")
    }
    
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            // window.addFlags(android.view.WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD)
            Log.d("AlarmStopActivity", "onWindowFocusChanged - window flags refreshed")
        } else {
            // KRİTİK: Focus kaybedildiğinde (başka uygulama açıldığında) activity'yi tekrar ön plana getir
            // HyperOS'ta kilit ekranı açıkken bu çakışmalara neden olabilir, sadece kilitli değilken veya uygulama bitmiyorsa yapalım
            Handler(Looper.getMainLooper()).postDelayed({
                if (!isFinishing && !isDestroyed && !DeviceStateHelper.isPhoneLocked(this, "AlarmStopActivity")) {
                    ActivityUtils.moveActivityToFront(this, delayMs = 0, logTag = "AlarmStopActivity")
                    Log.d("AlarmStopActivity", "onWindowFocusChanged - activity moved to front (focus lost)")
                }
            }, 100)
        }
    }
    
    override fun onPause() {
        super.onPause()
        // KRİTİK: Activity pause olduğunda (başka uygulama açıldığında) tekrar ön plana getir
        // Bu sayede Rust+ bildirimine basılsa bile ekran kapanmaz
        Handler(Looper.getMainLooper()).postDelayed({
            if (!isFinishing && !isDestroyed) {
                ActivityUtils.moveActivityToFront(this, delayMs = 0, logTag = "AlarmStopActivity")
                Log.d("AlarmStopActivity", "onPause - activity moved to front")
            }
        }, 100)
    }
    
    override fun onBackPressed() {
        // Geri tuşuna basıldığında alarm'ı durdur (Stop butonu gibi)
        stopAlarm()
        Log.d("AlarmStopActivity", "onBackPressed() called - stopAlarm() triggered")
    }
    
    override fun onUserLeaveHint() {
        // Ana Ekran veya Son Uygulamalar tuşuna basıldığında alarm'ı durdur
        super.onUserLeaveHint()
        stopAlarm()
        Log.d("AlarmStopActivity", "onUserLeaveHint() called - stopAlarm() triggered (Home/Recent Apps)")
    }
    
    override fun onDestroy() {
        super.onDestroy()
        
        timeRunnable?.let { timeHandler?.removeCallbacks(it) }
        Log.d("AlarmStopActivity", "removeCallbacks() called")
        timeHandler = null
        timeRunnable = null
        
        try {
            unregisterReceiver(alarmDurationFinishedReceiver)
            Log.d("AlarmStopActivity", "unregisterReceiver() called")
        } catch (e: Exception) {
            Log.e("AlarmStopActivity", "Error in alarmDurationFinishedReceiver: ${e.message}", e)
        }
    }
    
    private fun setupWindowFlags() {
        WindowFlagsManager.setWindowFlagsForLockedScreen(this)
        Log.d("AlarmStopActivity", "WindowFlagsManager.setWindowFlagsForLockedScreen() called")
        
        // Status bar'ı görünür yap - tam ekran kalacak ama status bar gözükecek
        setupStatusBar()
    }
    
    private fun setupStatusBar() {
        try {
            // Edge-to-edge için: Status bar şeffaf olmalı ve içerik status bar'ın altına kadar uzanmalı
            // FLAG_FULLSCREEN'i kaldır - status bar görünsün
            window.clearFlags(android.view.WindowManager.LayoutParams.FLAG_FULLSCREEN)
            Log.d("AlarmStopActivity", "FLAG_FULLSCREEN cleared")
            
            // WindowInsetsController: API 30+ için mevcut, MinSdk 28 olduğu için kontrol gerekli
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                val windowInsetsController = window.insetsController
                if (windowInsetsController != null) {
                    // Status bar ve navigation bar'ı görünür yap (edge-to-edge için)
                    windowInsetsController.show(WindowInsets.Type.statusBars() or WindowInsets.Type.navigationBars())
                    // Siyah arka plan için açık renk ikonlar (beyaz)
                    windowInsetsController.setSystemBarsAppearance(
                        0, // Açık renk ikonlar (siyah arka plan için)
                        WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS or WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS
                    )
                    Log.d("AlarmStopActivity", "Status bar configured with WindowInsetsController")
                }
                // Edge-to-edge için status bar şeffaf yap
                window.statusBarColor = android.graphics.Color.TRANSPARENT
                window.navigationBarColor = android.graphics.Color.TRANSPARENT
            } else {
                // API 28-29 için fallback
                window.statusBarColor = android.graphics.Color.TRANSPARENT
                window.navigationBarColor = android.graphics.Color.TRANSPARENT
                Log.d("AlarmStopActivity", "Status bar configured (API 28-29 fallback)")
            }
        } catch (e: Exception) {
            Log.e("AlarmStopActivity", "Error setting up status bar: ${e.message}", e)
        }
    }
    
    private fun hideSoftKeyboard() {
        try {
            val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            Log.d("AlarmStopActivity", "getSystemService(INPUT_METHOD_SERVICE) called")
            val view = currentFocus
            if (view != null) {
                imm.hideSoftInputFromWindow(view.windowToken, 0)
                Log.d("AlarmStopActivity", "hideSoftInputFromWindow() called - from focused view")
            } else {
                val windowToken = window.decorView.rootView.windowToken
                if (windowToken != null) {
                    imm.hideSoftInputFromWindow(windowToken, 0)
                    Log.d("AlarmStopActivity", "hideSoftInputFromWindow() called - from window token")
                }
            }
        } catch (e: Exception) {
            Log.e("AlarmStopActivity", "Error in alarmDurationFinishedReceiver: ${e.message}", e)
        }
    }
    
    private fun updateTime() {
        try {
            val now = Calendar.getInstance()
            Log.d("AlarmStopActivity", "Calendar.getInstance() called")
            
            // Use getBestDateTimePattern for locale-aware skeleton (e.g. "Monday, January 1" vs "Monday, 1 January")
            val bestDatePattern = android.text.format.DateFormat.getBestDateTimePattern(Locale.getDefault(), "EEEEMMMMd")
            val dateFormat = SimpleDateFormat(bestDatePattern, Locale.getDefault())
            val dateString = dateFormat.format(now.time)
            dateText.text = dateString.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
            Log.d("AlarmStopActivity", "dateText.text set: $dateString")
            
            // Use system time format (12h/24h) preference
            val is24Hour = android.text.format.DateFormat.is24HourFormat(this)
            val timePattern = if (is24Hour) "H:mm" else "h:mm aa"
            val timeFormat = SimpleDateFormat(timePattern, Locale.getDefault())
            val timeString = timeFormat.format(now.time)
            timeText.text = timeString
            Log.d("AlarmStopActivity", "timeText.text set: $timeString")
        } catch (e: Exception) {
            Log.e("AlarmStopActivity", "Error updating time: ${e.message}", e)
        }
    }
    
    private fun stopAlarm() {
        try {
            AlarmHelper.stopSystemAlarm(this)
            Log.d("AlarmStopActivity", "AlarmHelper.stopSystemAlarm() called")
            
            // Keyguard'ı tekrar aktif et - PIN code ekranını göster
            // Kullanıcı PIN'i girdikten sonra MainActivity'ye geçecek
            restoreKeyguardAndNavigateToHome()
            Log.d("AlarmStopActivity", "restoreKeyguardAndNavigateToHome() called")
        } catch (e: Exception) {
            Log.e("AlarmStopActivity", "Error stopping alarm: ${e.message}", e)
            restoreKeyguard()
            finish()
        }
    }
    
    private fun restoreKeyguardAndNavigateToHome() {
        try {
            // setShowWhenLocked'ı false yap - keyguard'ı tekrar aktif et
            setShowWhenLocked(false)
            Log.d("AlarmStopActivity", "setShowWhenLocked(false) called")
            
            // Window flag'lerini temizle
            window.clearFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD)
            Log.d("AlarmStopActivity", "FLAG_DISMISS_KEYGUARD cleared")
            
            // Telefon kilitli mi kontrol et
            val isLocked = DeviceStateHelper.isPhoneLocked(this, "AlarmStopActivity")
            Log.d("AlarmStopActivity", "isPhoneLocked() called: $isLocked")
            
            if (isLocked) {
                // Telefon kilitli - PIN code ekranını göster
                // PIN girildikten sonra MainActivity'yi açacağız
                val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
                keyguardManager.requestDismissKeyguard(this, object : KeyguardManager.KeyguardDismissCallback() {
                    override fun onDismissError() {
                        Log.d("AlarmStopActivity", "KeyguardDismissCallback.onDismissError() called")
                        navigateToHomeAndFinish()
                    }
                    
                    override fun onDismissSucceeded() {
                        Log.d("AlarmStopActivity", "KeyguardDismissCallback.onDismissSucceeded() called - PIN entered successfully")
                        navigateToHomeAndFinish()
                    }
                    
                    override fun onDismissCancelled() {
                        Log.d("AlarmStopActivity", "KeyguardDismissCallback.onDismissCancelled() called - user cancelled PIN entry")
                        navigateToHomeAndFinish()
                    }
                })
                Log.d("AlarmStopActivity", "requestDismissKeyguard() called - PIN code screen will be shown")
            } else {
                // Telefon kilitli değil - direkt MainActivity'ye git
                Log.d("AlarmStopActivity", "Phone is not locked - navigating to home")
                navigateToHomeAndFinish()
            }
        } catch (e: Exception) {
            Log.e("AlarmStopActivity", "Error in restoreKeyguardAndNavigateToHome: ${e.message}", e)
            // Hata durumunda da MainActivity'ye git
            navigateToHomeAndFinish()
        }
    }
    
    private fun navigateToHomeAndFinish() {
        try {
            // Tüm durumlar için: MainActivity'yi GO_TO_HOME intent'i ile aç
            // Bu, uygulama açık/kapalı/minimize durumlarını otomatik olarak ele alır
            val mainIntent = Intent(this, MainActivity::class.java).apply {
                action = "com.raidalarm.GO_TO_HOME"
                putExtra("from_alarm_dismiss", true)
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
            }
            Log.d("AlarmStopActivity", "MainActivity intent created - GO_TO_HOME")
            startActivity(mainIntent)
            Log.d("AlarmStopActivity", "startActivity() called - navigating to home")
            
            // AlarmStopActivity'yi kapat
            finish()
            Log.d("AlarmStopActivity", "finish() called - AlarmStopActivity closed")
        } catch (e: Exception) {
            Log.e("AlarmStopActivity", "Error navigating to home: ${e.message}", e)
            // Hata durumunda activity'yi kapat
            finish()
        }
    }
    
    private fun restoreKeyguard() {
        try {
            // setShowWhenLocked'ı false yap - keyguard'ı tekrar aktif et
            setShowWhenLocked(false)
            Log.d("AlarmStopActivity", "setShowWhenLocked(false) called")

            // Window flag'lerini temizle
            window.clearFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD)
            Log.d("AlarmStopActivity", "FLAG_DISMISS_KEYGUARD cleared")
        } catch (e: Exception) {
            Log.e("AlarmStopActivity", "Error restoring keyguard: ${e.message}", e)
        }
    }

    private fun finishTask() {
        // MinSdk 28 olduğu için finishAndRemoveTask() direkt kullanılabilir
        finishAndRemoveTask()
        Log.d("AlarmStopActivity", "finishAndRemoveTask() called")
    }
}

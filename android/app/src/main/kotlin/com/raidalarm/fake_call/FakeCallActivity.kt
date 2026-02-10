package com.raidalarm.fake_call

import android.app.Activity
import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.Typeface
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.text.TextUtils
import android.util.Log
import android.view.View
import android.view.Window
import android.view.WindowInsetsController
import android.view.WindowInsets
import android.view.WindowManager
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.raidalarm.ActivityUtils
import com.raidalarm.AudioSettingsManager
import com.raidalarm.NotificationHelper
import com.raidalarm.DeviceStateHelper
import com.raidalarm.WindowFlagsManager
import com.raidalarm.R
import com.raidalarm.MainActivity
import android.media.AudioManager
import kotlinx.coroutines.*
import kotlin.math.abs
import java.io.InputStream

class FakeCallActivity : Activity() {
    
    companion object {
        private const val ACTION_ENDED_FAKE_CALL = "com.raidalarm.ACTION_ENDED_FAKE_CALL"
        
        fun getIntent(context: Context, data: Bundle): Intent {
            return Intent(context, FakeCallActivity::class.java).apply {
                action = "${context.packageName}.${FakeCallConstants.ACTION_FAKE_CALL_INCOMING}"
                putExtra(FakeCallConstants.EXTRA_FAKE_CALL_DATA, data)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS
            }
        }
        
        fun getIntentEnded(context: Context, isAccepted: Boolean): Intent {
            val intent = Intent("${context.packageName}.$ACTION_ENDED_FAKE_CALL")
            intent.putExtra("ACCEPTED", isAccepted)
            return intent
        }
    }
    
    inner class EndedFakeCallBroadcastReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (!isFinishing) {
                val action = intent?.action ?: return
                Log.d("FakeCallActivity", "EndedFakeCallBroadcastReceiver.onReceive() - action: $action")
                
                when {
                    action.endsWith("ACTION_ENDED_FAKE_CALL") -> {
                        val isAccepted = intent.getBooleanExtra("ACCEPTED", false)
                        Log.d("FakeCallActivity", "Fake call ended - accepted: $isAccepted")
                        restoreKeyguardAndNavigateToHome()
                    }
                    action == "com.raidalarm.FAKE_CALL_DURATION_FINISHED" -> {
                        Log.d("FakeCallActivity", "Fake call duration finished")
                        soundPlayer?.stop()
                        try {
                            val mainIntent = Intent(this@FakeCallActivity, MainActivity::class.java).apply {
                                this.action = "com.raidalarm.GO_TO_HOME"
                                this.putExtra("from_alarm_dismiss", true)
                                this.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or
                                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                                        Intent.FLAG_ACTIVITY_NEW_TASK or
                                        Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
                            }
                            Log.d("FakeCallActivity", "Intent created - GO_TO_HOME")
                            startActivity(mainIntent)
                            Log.d("FakeCallActivity", "startActivity() called")
                            finish()
                            Log.d("FakeCallActivity", "finish() called")
                        } catch (e: Exception) {
                            finish()
                        }
                    }
                }
            }
        }
    }
    
    private var endedReceiver = EndedFakeCallBroadcastReceiver()
    
    private lateinit var ivBackground: ImageView
    private lateinit var tvNameCaller: TextView
    private lateinit var tvCallerNumber: TextView
    private lateinit var ivAvatar: ImageView
    private lateinit var llAction: LinearLayout
    private lateinit var ivAcceptCall: ImageView
    private lateinit var tvAccept: TextView
    private lateinit var ivDeclineCall: ImageView
    private lateinit var tvDecline: TextView
    
    private var soundPlayer: FakeCallSoundPlayer? = null
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setupWindowFlags()
        setContentView(R.layout.activity_fake_call)
        Log.d("FakeCallActivity", "setContentView() called")
        
        initView()
        
        // ÖNEMLİ: Ses ayarlarını ÖNCE yap, sonra fake call başlat
        // Bu sayede telefon titreşimde/sessizde/kısık seste olsa bile
        // ses %100 seviyesine çıkar ve fake call çalmaya başlar
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        CoroutineScope(Dispatchers.Main + SupervisorJob()).launch {
            // Ses ayarlarını yap: Ringer mode NORMAL, tüm stream'ler maksimum
            // await kullanarak ses ayarlarının tamamlanmasını bekliyoruz
            AudioSettingsManager.setupAlarmSettings(audioManager)
            Log.d("FakeCallActivity", "AudioSettingsManager.setupAlarmSettings() completed - audio settings configured")
            // Ses ayarları tamamlandıktan sonra fake call başlat
            incomingData(intent)
        }
        
        val filter = IntentFilter()
        filter.addAction("${packageName}.$ACTION_ENDED_FAKE_CALL")
        filter.addAction("com.raidalarm.FAKE_CALL_DURATION_FINISHED")
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(endedReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
                Log.d("FakeCallActivity", "registerReceiver() called - RECEIVER_NOT_EXPORTED")
            } else {
                registerReceiver(endedReceiver, filter)
                Log.d("FakeCallActivity", "registerReceiver() called - legacy")
            }
        } catch (e: Exception) {
            Log.e("FakeCallActivity", "Failed to register receiver: ${e.message}", e)
        }
        
        // Fake call açıldığında bildirimi heads-up olarak göster
        // Tam ekran aktivitelerde bile heads-up bildirimler gözükmeli
        NotificationHelper.showAttackDetectedNotificationForFullScreenActivity(this, delayMs = 0)
        
        // setShowWhenLocked(true) should be enough - no need to call requestDismissKeyguard()
        // which would show PIN code. Window flags handle keyguard dismissal automatically.
        Log.d("FakeCallActivity", "Window flags set - keyguard should be dismissed automatically")
    }
    
    private fun setupWindowFlags() {
        WindowFlagsManager.setWindowFlagsForLockedScreen(this)
        Log.d("FakeCallActivity", "WindowFlagsManager.setWindowFlagsForLockedScreen() called")
        
        // Status bar'ı görünür yap - tam ekran kalacak ama status bar gözükecek
        setupStatusBar()
    }
    
    private fun setupStatusBar() {
        try {
            window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
            Log.d("FakeCallActivity", "FLAG_FULLSCREEN cleared")
            
            // WindowInsetsController: API 30+ için gerekli
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val windowInsetsController = window.insetsController
                if (windowInsetsController != null) {
                    windowInsetsController.show(WindowInsets.Type.statusBars() or WindowInsets.Type.navigationBars())
                    windowInsetsController.setSystemBarsAppearance(
                        0,
                        WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS or WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS
                    )
                    Log.d("FakeCallActivity", "Status bar configured with WindowInsetsController - edge-to-edge with dark background, white icons")
                }
                window.statusBarColor = Color.TRANSPARENT
                window.navigationBarColor = Color.TRANSPARENT
            } else {
                // API 28-29 fallback
                window.statusBarColor = Color.TRANSPARENT
                window.navigationBarColor = Color.TRANSPARENT
                Log.d("FakeCallActivity", "Status bar configured - edge-to-edge (API 28-29 fallback)")
            }
        } catch (e: Exception) {
            Log.e("FakeCallActivity", "Failed to setup status bar: ${e.message}", e)
        }
    }
    
    /**
     * Ekranı açmak için WakeLock alır.
     * FLAG_KEEP_SCREEN_ON window flag'i zaten ekranı açık tutuyor.
     * 
     * @param duration WakeLock süresi (ms). Maksimum 2 dakika ile sınırlandırılır.
     */
    private fun wakeLockRequest(duration: Long) {
        try {
            val pm = applicationContext.getSystemService(Context.POWER_SERVICE) as PowerManager
            val wakeLock = pm.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                "FakeCall:PowerManager"
            )
            val optimizedDuration = minOf(duration, 2 * 60 * 1000L)
            wakeLock.acquire(optimizedDuration)
            Log.d("FakeCallActivity", "WakeLock acquired for duration: $optimizedDuration ms")
        } catch (e: Exception) {
            Log.e("FakeCallActivity", "Error acquiring wake lock: ${e.message}", e)
        }
    }
    
    private fun incomingData(intent: Intent) {
        val data = intent.extras?.getBundle(FakeCallConstants.EXTRA_FAKE_CALL_DATA)
        if (data == null) {
            Log.d("FakeCallActivity", "No data bundle found - finishing")
            finish()
            return
        }
        
        val textColor = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_TEXT_COLOR, "#ffffff")
        
        tvNameCaller.text = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_NAME_CALLER, "Raid Alarm")
        
        // Show/Hide Number
        val callerNumber = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_NUMBER, "")
        if (callerNumber.isNotEmpty()) {
            tvCallerNumber.text = callerNumber
            tvCallerNumber.visibility = View.VISIBLE
        } else {
             tvCallerNumber.visibility = View.GONE
        }
        
        // Set Geist font (Medium or Bold)
        try {
            val geistFont = Typeface.createFromAsset(assets, "flutter_assets/assets/fonts/Geist-Medium.ttf")
            tvNameCaller.typeface = geistFont
            Log.d("FakeCallActivity", "Geist Medium font loaded")
        } catch (e: Exception) {
            try {
                // Try alternative path
                val geistFont = Typeface.createFromAsset(assets, "assets/fonts/Geist-Medium.ttf")
                tvNameCaller.typeface = geistFont
                Log.d("FakeCallActivity", "Geist Medium font loaded from alternative path")
            } catch (e2: Exception) {
                // Fallback to bold system font
                tvNameCaller.setTypeface(null, Typeface.BOLD)
                Log.e("FakeCallActivity", "Failed to load Geist font: ${e2.message}", e2)
            }
        }
        
        Log.d("FakeCallActivity", "Caller name: ${tvNameCaller.text}")
        
        try {
            tvNameCaller.setTextColor(Color.parseColor(textColor))
        } catch (e: Exception) {
            Log.d("FakeCallActivity", "Failed to parse text color: ${e.message}")
        }
        
        // Set dark background color (matching the design)
        // Set dark background color (matching the design) or Image
        val backgroundColor = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_BACKGROUND_COLOR, "#1E1E1E")
        val backgroundImagePath = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_BACKGROUND_IMAGE, "")
        
        var isCustomBackground = false
        
        try {
            if (backgroundImagePath.isNotEmpty() && backgroundImagePath != "Default Dark") {
                 val bitmap = BitmapFactory.decodeFile(backgroundImagePath)
                 if (bitmap != null) {
                     ivBackground.setImageBitmap(bitmap)
                     // Ensure scale type is center crop
                     ivBackground.scaleType = ImageView.ScaleType.CENTER_CROP
                     isCustomBackground = true
                     Log.d("FakeCallActivity", "Background image loaded from file: $backgroundImagePath")
                 } else {
                     // Fallback to color if decode fails
                     ivBackground.setBackgroundColor(Color.parseColor(backgroundColor))
                     Log.d("FakeCallActivity", "Failed to decode background image, using color")
                 }
            } else {
                 ivBackground.setBackgroundColor(Color.parseColor(backgroundColor))
                 Log.d("FakeCallActivity", "Using background color: $backgroundColor")
            }
        } catch (e: Exception) {
            // Fallback to dark gray
            ivBackground.setBackgroundColor(Color.parseColor("#1E1E1E"))
            Log.d("FakeCallActivity", "Failed to parse background, using default: ${e.message}")
        }
        
        // Load avatar/logo from Flutter assets
        // Flutter assets path: flutter_assets/assets/logo/raidalarm-logo.png
        // ONLY if not using a custom background
        if (!isCustomBackground) {
            try {
                val inputStream: InputStream = assets.open("flutter_assets/assets/logo/raidalarm-logo.png")
                val bitmap = BitmapFactory.decodeStream(inputStream)
                inputStream.close()
                
                if (bitmap != null && !bitmap.isRecycled) {
                    // Get avatar size from resources (120dp)
                    val avatarSizePx = resources.getDimensionPixelSize(R.dimen.size_avatar)
                    // Make it circular with proper size
                    val circularBitmap = createCircularBitmap(bitmap, avatarSizePx)
                    ivAvatar.setImageBitmap(circularBitmap)
                    ivAvatar.visibility = View.VISIBLE
                    Log.d("FakeCallActivity", "Logo loaded successfully from flutter_assets/assets/logo/raidalarm-logo.png")
                } else {
                    Log.e("FakeCallActivity", "Bitmap is null or recycled")
                    ivAvatar.visibility = View.INVISIBLE
                }
            } catch (e: Exception) {
                Log.e("FakeCallActivity", "Failed to load logo: ${e.message}", e)
                ivAvatar.visibility = View.INVISIBLE
            }
        } else {
            // Hide avatar for custom backgrounds
            ivAvatar.visibility = View.GONE
            Log.d("FakeCallActivity", "Custom background detected - hiding logo")
        }
        
        // Sound player is started in FakeCallBroadcastReceiver
        // Just get reference if already exists
        soundPlayer = FakeCallNotificationManager.setSoundPlayer(null)
        if (soundPlayer == null) {
            soundPlayer = FakeCallSoundPlayer(this)
            soundPlayer?.play(data)
            FakeCallNotificationManager.setSoundPlayer(soundPlayer)
            Log.d("FakeCallActivity", "Sound player started")
        } else {
            Log.d("FakeCallActivity", "Sound player already exists")
        }
    }
    

    
    private fun initView() {
        ivBackground = findViewById(R.id.ivBackground)
        tvNameCaller = findViewById(R.id.tvNameCaller)
        tvCallerNumber = findViewById(R.id.tvCallerNumber)
        ivAvatar = findViewById(R.id.ivAvatar)
        llAction = findViewById(R.id.llAction)
        ivAcceptCall = findViewById(R.id.ivAcceptCall)
        tvAccept = findViewById(R.id.tvAccept)
        ivDeclineCall = findViewById(R.id.ivDeclineCall)
        tvDecline = findViewById(R.id.tvDecline)
        Log.d("FakeCallActivity", "All views initialized")
        
        // No need for OnTouchListener - setShowWhenLocked(true) handles keyguard
        ivAcceptCall.setOnClickListener {
            onAcceptClick()
        }
        
        ivDeclineCall.setOnClickListener {
            onDeclineClick()
        }
        Log.d("FakeCallActivity", "Click listeners set")
    }
    
    private fun onAcceptClick() {
        Log.d("FakeCallActivity", "onAcceptClick() called")
        
        val data = intent.extras?.getBundle(FakeCallConstants.EXTRA_FAKE_CALL_DATA)
        
        soundPlayer?.stop()
        
        val acceptIntent = FakeCallBroadcastReceiver.getIntentAccept(this, data ?: Bundle())
        sendBroadcast(acceptIntent)
        Log.d("FakeCallActivity", "Accept broadcast sent")
        
        // Keyguard'ı tekrar aktif et - PIN code ekranını göster
        restoreKeyguardAndNavigateToHome()
        Log.d("FakeCallActivity", "restoreKeyguardAndNavigateToHome() called")
    }
    
    private fun onDeclineClick() {
        Log.d("FakeCallActivity", "onDeclineClick() called")
        
        val data = intent.extras?.getBundle(FakeCallConstants.EXTRA_FAKE_CALL_DATA)
        
        soundPlayer?.stop()
        
        val declineIntent = FakeCallBroadcastReceiver.getIntentDecline(this, data ?: Bundle())
        sendBroadcast(declineIntent)
        Log.d("FakeCallActivity", "Decline broadcast sent")
        
        // Keyguard'ı tekrar aktif et - PIN code ekranını göster
        restoreKeyguardAndNavigateToHome()
        Log.d("FakeCallActivity", "restoreKeyguardAndNavigateToHome() called")
    }
    
    private fun restoreKeyguardAndNavigateToHome() {
        try {
            // setShowWhenLocked'ı false yap - keyguard'ı tekrar aktif et
            setShowWhenLocked(false)
            Log.d("FakeCallActivity", "setShowWhenLocked(false) called")
            
            // Window flag'lerini temizle
            window.clearFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD)
            Log.d("FakeCallActivity", "FLAG_DISMISS_KEYGUARD cleared")
            
            // Telefon kilitli mi kontrol et
            val isLocked = DeviceStateHelper.isPhoneLocked(this, "FakeCallActivity")
            Log.d("FakeCallActivity", "isPhoneLocked() called: $isLocked")
            
            if (isLocked) {
                // Telefon kilitli - PIN code ekranını göster
                // PIN girildikten sonra MainActivity'yi açacağız
                val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
                keyguardManager.requestDismissKeyguard(this, object : KeyguardManager.KeyguardDismissCallback() {
                    override fun onDismissError() {
                        Log.d("FakeCallActivity", "KeyguardDismissCallback.onDismissError() called")
                        navigateToHomeAndFinish()
                    }
                    
                    override fun onDismissSucceeded() {
                        Log.d("FakeCallActivity", "KeyguardDismissCallback.onDismissSucceeded() called - PIN entered successfully")
                        navigateToHomeAndFinish()
                    }
                    
                    override fun onDismissCancelled() {
                        Log.d("FakeCallActivity", "KeyguardDismissCallback.onDismissCancelled() called - user cancelled PIN entry")
                        navigateToHomeAndFinish()
                    }
                })
                Log.d("FakeCallActivity", "requestDismissKeyguard() called - PIN code screen will be shown")
            } else {
                // Telefon kilitli değil - direkt MainActivity'ye git
                Log.d("FakeCallActivity", "Phone is not locked - navigating to home")
                navigateToHomeAndFinish()
            }
        } catch (e: Exception) {
            Log.e("FakeCallActivity", "Error in restoreKeyguardAndNavigateToHome: ${e.message}", e)
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
            Log.d("FakeCallActivity", "MainActivity intent created - GO_TO_HOME")
            startActivity(mainIntent)
            Log.d("FakeCallActivity", "startActivity() called - navigating to home")
            
            // FakeCallActivity'yi kapat
            finish()
            Log.d("FakeCallActivity", "finish() called - FakeCallActivity closed")
        } catch (e: Exception) {
            Log.e("FakeCallActivity", "Error navigating to home: ${e.message}", e)
            // Hata durumunda activity'yi kapat
            finish()
        }
    }
    
    private fun restoreKeyguard() {
        try {
            // setShowWhenLocked'ı false yap - keyguard'ı tekrar aktif et
            setShowWhenLocked(false)
            Log.d("FakeCallActivity", "setShowWhenLocked(false) called")
            
            // Window flag'lerini temizle
            window.clearFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD)
            Log.d("FakeCallActivity", "FLAG_DISMISS_KEYGUARD cleared")
        } catch (e: Exception) {
            Log.e("FakeCallActivity", "Failed to restore keyguard: ${e.message}", e)
        }
    }
    
    override fun onResume() {
        super.onResume()
        
        setupWindowFlags()
        // setShowWhenLocked(true) handles keyguard - no need for requestDismissKeyguard()

        ActivityUtils.moveActivityToFront(this, delayMs = 100, logTag = "FakeCallActivity")
        Log.d("FakeCallActivity", "ActivityUtils.moveActivityToFront() called")
    }
    
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            // window.addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD)
            Log.d("FakeCallActivity", "onWindowFocusChanged - window flags refreshed")
        } else {
            // KRİTİK: Focus kaybedildiğinde (başka uygulama açıldığında) activity'yi tekrar ön plana getir
            // HyperOS'ta kilit ekranı açıkken bu çakışmalara neden olabilir, sadece kilitli değilken veya uygulama bitmiyorsa yapalım
            Handler(Looper.getMainLooper()).postDelayed({
                if (!isFinishing && !isDestroyed && !DeviceStateHelper.isPhoneLocked(this, "FakeCallActivity")) {
                    ActivityUtils.moveActivityToFront(this, delayMs = 0, logTag = "FakeCallActivity")
                    Log.d("FakeCallActivity", "onWindowFocusChanged - activity moved to front (focus lost)")
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
                ActivityUtils.moveActivityToFront(this, delayMs = 0, logTag = "FakeCallActivity")
                Log.d("FakeCallActivity", "onPause - activity moved to front")
            }
        }, 100)
    }
    
    override fun onDestroy() {
        super.onDestroy()
        
        soundPlayer?.stop()
        soundPlayer = null
        
        // End fake call state
        FakeCallNotificationManager.endFakeCall(this)
        
        // Unregister broadcast receiver to prevent memory leak
        try {
            unregisterReceiver(endedReceiver)
            Log.d("FakeCallActivity", "unregisterReceiver() called")
        } catch (e: Exception) {
            Log.e("FakeCallActivity", "Error unregistering receiver: ${e.message}", e)
        }
    }
    
    override fun onBackPressed() {
        // Geri tuşuna basıldığında fake call'ı durdur (Stop butonu gibi)
        soundPlayer?.stop()
        restoreKeyguardAndNavigateToHome()
        Log.d("FakeCallActivity", "onBackPressed() called - restoreKeyguardAndNavigateToHome() triggered")
    }
    
    override fun onUserLeaveHint() {
        // Ana Ekran veya Son Uygulamalar tuşuna basıldığında fake call'ı durdur
        super.onUserLeaveHint()
        soundPlayer?.stop()
        restoreKeyguardAndNavigateToHome()
        Log.d("FakeCallActivity", "onUserLeaveHint() called - restoreKeyguardAndNavigateToHome() triggered (Home/Recent Apps)")
    }
    
    private fun createCircularBitmap(bitmap: Bitmap, targetSize: Int): Bitmap {
        // Use target size (avatar size) instead of bitmap's min dimension
        // This ensures the circular bitmap matches the ImageView size exactly
        val size = targetSize
        val output = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = android.graphics.Canvas(output)
        val paint = android.graphics.Paint()
        
        paint.isAntiAlias = true
        paint.isFilterBitmap = true
        paint.isDither = true
        
        // Clear canvas with transparent background
        canvas.drawARGB(0, 0, 0, 0)
        
        // Draw white circle as mask
        paint.color = Color.WHITE
        val radius = size / 2f
        canvas.drawCircle(radius, radius, radius, paint)
        
        // Use SRC_IN to clip bitmap to circle shape
        paint.xfermode = android.graphics.PorterDuffXfermode(android.graphics.PorterDuff.Mode.SRC_IN)
        
        // Scale bitmap to fit the circle (maintain aspect ratio)
        val sourceSize = minOf(bitmap.width, bitmap.height)
        val scaledBitmap = if (bitmap.width != bitmap.height) {
            // Crop to square first, then scale
            val cropSize = minOf(bitmap.width, bitmap.height)
            val x = (bitmap.width - cropSize) / 2
            val y = (bitmap.height - cropSize) / 2
            Bitmap.createBitmap(bitmap, x, y, cropSize, cropSize)
        } else {
            bitmap
        }
        
        val finalBitmap = Bitmap.createScaledBitmap(scaledBitmap, size, size, true)
        val rect = android.graphics.Rect(0, 0, size, size)
        canvas.drawBitmap(finalBitmap, rect, rect, paint)
        
        // Clean up if we created a new bitmap
        if (scaledBitmap != bitmap && scaledBitmap != finalBitmap) {
            scaledBitmap.recycle()
        }
        
        return output
    }
}

# Flutter Callkit Incoming
-keep class com.hiennv.flutter_callkit_incoming.** { *; }

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Core (Flutter deferred components için)
# Flutter engine bu sınıfları referans ediyor ama kullanmıyoruz
# SDK 34 ile uyumlu değil, dependency eklemeden ProGuard ile ignore ediyoruz
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Release build'de log'ları kaldır (performans optimizasyonu)
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Kotlin coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembers class kotlinx.** {
    volatile <fields>;
}

# SQLite
-keep class com.raidalarm.DatabaseHelper { *; }
-keep class com.raidalarm.NotificationDatabaseSaver { *; }

# NotificationListenerService (system service)
-keep class com.raidalarm.NotificationListenerService { *; }

# Keep all native classes (Kotlin)
-keep class com.raidalarm.** { *; }


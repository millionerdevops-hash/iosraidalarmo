import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.raidalarm"
    compileSdk = 36
    // NDK kullanmıyoruz, CMake hatasını önlemek için kaldırıyoruz
    // ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_callkit_incoming v3.0.0+ requires Java 17+
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // flutter_local_notifications requires core library desugaring
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.raidalarm"
        minSdk = 26  // Android 8.0 (Oreo) - NotificationListenerService ve tüm paketler uyumlu
        targetSdk = 35  // Android 15 (Google Play gereksinimi)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    
    buildFeatures {
        buildConfig = true
    }
    
    // CMake hatasını önlemek için externalNativeBuild'i devre dışı bırak
    // Native C++ kodu kullanmıyoruz, sadece Kotlin
    packaging {
        jniLibs {
            useLegacyPackaging = false
        }
    }

    // Keystore properties dosyasını oku
    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = Properties()
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(keystorePropertiesFile.inputStream())
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Release signing config kullan (eğer key.properties varsa)
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // Eğer key.properties yoksa debug signing kullan (test için)
                signingConfig = signingConfigs.getByName("debug")
            }
            // Code shrinking ve obfuscation (Google Play için önerilir)
            isMinifyEnabled = true
            isShrinkResources = true
            // Proguard rules for flutter_callkit_incoming
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Play Core kütüphaneleri SDK 34 ile uyumlu değil, kaldırıldı
    // Flutter engine deferred components kullanmıyorsa gerekli değil
    // Eğer R8 hatası alırsan, ProGuard rules ile çöz (proguard-rules.pro)
    
    // Core library desugaring for flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    
    // Android 15 (SDK 35) edge-to-edge desteği için
    implementation("androidx.activity:activity-ktx:1.9.2")

    // ConstraintLayout (Alarm UI için gerekli)
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
}

// CMake hatasını önlemek için CMake task'larını tamamen devre dışı bırak
// Flutter otomatik olarak CMake yapılandırması yapıyor, bunu atlamak için
afterEvaluate {
    tasks.matching { 
        it.name.contains("CMake", ignoreCase = true) || 
        it.name.contains("cmake", ignoreCase = true) ||
        it.name.contains("externalNativeBuild", ignoreCase = true) ||
        it.name.contains("configureCMake", ignoreCase = true) ||
        it.name.contains("buildCMake", ignoreCase = true)
    }.configureEach {
        enabled = false
        // Task'ı tamamen atla - hiçbir şey yapma
        actions.clear()
        doFirst {
            println("⚠️ CMake task '${name}' skipped (no native C++ code)")
        }
        // Task başarılı olsun (hata vermesin)
        doLast {
            println("✅ CMake task '${name}' completed (skipped)")
        }
    }
}

// CMake task'ları çalışmadan önce gerekli klasörleri oluştur (hata önleme)
tasks.register("createCxxDirs") {
    doLast {
        val cxxDir = file("${project.rootDir}/../build/.cxx")
        if (!cxxDir.exists()) {
            cxxDir.mkdirs()
            println("✅ Created .cxx directory")
        }
    }
}

// CMake task'larından önce klasör oluşturma task'ını çalıştır
afterEvaluate {
    tasks.matching { 
        it.name.contains("CMake", ignoreCase = true) || 
        it.name.contains("cmake", ignoreCase = true)
    }.configureEach {
        dependsOn("createCxxDirs")
    }
}

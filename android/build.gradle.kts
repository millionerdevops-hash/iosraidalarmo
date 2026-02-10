buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // Tüm projeler (external dependency'ler dahil) için Java 17 zorla
    afterEvaluate {
        tasks.withType<JavaCompile>().configureEach {
            sourceCompatibility = JavaVersion.VERSION_17.toString()
            targetCompatibility = JavaVersion.VERSION_17.toString()
            options.compilerArgs.add("-Xlint:-options") // Java 8 uyarılarını bastır
        }
        
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            kotlinOptions {
                jvmTarget = "17"
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Tüm alt projeler için Java 17 zorla (Java 8 uyarılarını önlemek için)
subprojects {
    // Task'lar eklendiğinde kontrol et
    tasks.whenTaskAdded {
        if (this is JavaCompile) {
            sourceCompatibility = JavaVersion.VERSION_17.toString()
            targetCompatibility = JavaVersion.VERSION_17.toString()
            options.compilerArgs.add("-Xlint:-options")
        }
        if (this is org.jetbrains.kotlin.gradle.tasks.KotlinCompile) {
            kotlinOptions {
                jvmTarget = "17"
            }
        }
    }
    
    // Mevcut task'lar için de konfigürasyon yap
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = JavaVersion.VERSION_17.toString()
        targetCompatibility = JavaVersion.VERSION_17.toString()
        options.compilerArgs.add("-Xlint:-options") // Java 8 uyarılarını bastır
    }
    
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = "17"
        }
    }

    // Force specific versions of AndroidX libraries to avoid conflict with AGP 8.6.1
    // The newer versions (core 1.17.0, activity 1.11.0) require AGP 8.9.1+
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core-ktx:1.15.0")
            force("androidx.core:core:1.15.0")
            force("androidx.activity:activity-ktx:1.9.3")
            force("androidx.activity:activity:1.9.3")
            force("androidx.browser:browser:1.8.0")
        }
    }

    // Fix for isar_flutter_libs missing namespace in AGP 8.0+
    // Fix for isar_flutter_libs missing namespace in AGP 8.0+
    plugins.withId("com.android.library") {
        if (project.name == "isar_flutter_libs") {
            try {
                 project.extensions.configure<com.android.build.gradle.LibraryExtension> {
                    if (namespace == null) {
                        println("Injecting namespace for isar_flutter_libs")
                        namespace = "dev.isar.isar_flutter_libs"
                    }
                }
            } catch (e: Exception) {
                 println("Failed to inject namespace for isar_flutter_libs: ${e.message}")
            }
        }
    }


}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

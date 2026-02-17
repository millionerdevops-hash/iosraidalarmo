allprojects {
    repositories {
        google()
        mavenCentral()
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    if (project.name == "isar_flutter_libs") {
        val setNamespace = {
            val android = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
            android?.namespace = "dev.isar.isar_flutter_libs"
        }
        if (project.state.executed) {
            setNamespace()
        } else {
            project.afterEvaluate { setNamespace() }
        }
    }
    
    // Suppress warnings about obsolete Java versions
    tasks.withType<JavaCompile> {
        options.compilerArgs.add("-Xlint:-options")
    }
}

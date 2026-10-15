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
    project.afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                for (method in android.javaClass.methods) {
                    if (method.name == "setCompileSdkVersion" && method.parameterCount == 1) {
                        try { method.invoke(android, 36) } catch (_: Exception) {}
                    }
                    if (method.name == "setCompileSdk" && method.parameterCount == 1) {
                        try { method.invoke(android, 36) } catch (_: Exception) {}
                    }
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.pingpal"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "26.3.11579264" // Use the available NDK version

    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.pingpal"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        
        // Add the following lines for debug builds
        resValue("string", "server_client_id", "801373348761-9br5ei64qv6reu56ia5s96guu3im9mim.apps.googleusercontent.com")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
            
            // Keep consistent configurations between debug and release
            resValue("string", "server_client_id", "801373348761-9br5ei64qv6reu56ia5s96guu3im9mim.apps.googleusercontent.com")
        }
        debug {
            isMinifyEnabled = false
            
            // Add additional debugging flags if needed
            buildConfigField("boolean", "DEBUG_AUTH", "true")
        }
    }

    packagingOptions {
        resources {
            excludes += listOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/license.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt",
                "META-INF/notice.txt",
                "META-INF/services/javax.annotation.processing.Processor"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.0")
    implementation(platform("com.google.firebase:firebase-bom:32.7.4"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("androidx.security:security-crypto:1.1.0-alpha06")
    
    // Add explicit dependency for Google Sign-In
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}

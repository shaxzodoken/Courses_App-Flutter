plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plagini
    id("dev.flutter.flutter-gradle-plugin")
    // Google Services (Firebase uchun) - Faqat bir marta va versiyasiz yoziladi
    id("com.google.gms.google-services")
}

dependencies {
    // Firebase BoM (Versiyalarni boshqarish uchun)
    implementation(platform("com.google.firebase:firebase-bom:34.6.0"))

    // Firebase Analytics
    implementation("com.google.firebase:firebase-analytics")

    // Agar Authentication yoki Firestore kerak bo'lsa, ularni ham shu yerga qo'shasiz:
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
}

android {
    namespace = "com.example.project" // DIQQAT: Bu yerni o'zgartirmang agar xato bermasa
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // DIQQAT: Bu yerda Firebasega yozgan Package Name bo'lishi SHART!
        // Masalan: "com.sizning.loyihangiz"
        applicationId = "com.example.project" 
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
# Add rules for keeping Supabase and Flutter classes
-keep class io.supabase.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

# Keep R
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Don't warn about missing classes
-dontwarn javax.annotation.**
-dontwarn kotlin.Unit

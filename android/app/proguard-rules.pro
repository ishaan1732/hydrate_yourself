# flutter_local_notifications — keep all classes used for
# scheduling, channel management, and reading back saved
# notification data. Required because R8 cannot trace generic
# type parameters through this plugin's internal serialization.
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Gson, used internally by the plugin for serializing scheduled
# notification data — also needs broad keep rules under R8
# since it relies on reflection.
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepattributes Signature
-keepattributes *Annotation*

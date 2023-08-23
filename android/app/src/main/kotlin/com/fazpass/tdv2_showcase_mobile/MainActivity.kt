package com.fazpass.tdv2_showcase_mobile

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import java.security.MessageDigest

class MainActivity: FlutterFragmentActivity() {

    override fun onStart() {
        super.onStart()
        val signatures = getSignatures(applicationContext)
        Log.i("SIGNATURES", signatures.toString())
    }

    private fun getSignatures(context: Context) : List<String> {
        return try {
            val packageManager = context.packageManager

            val signatures = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val signingInfo = packageManager.getPackageInfo(context.packageName, PackageManager.GET_SIGNING_CERTIFICATES).signingInfo

                if (signingInfo.hasMultipleSigners()) {
                    signingInfo.apkContentsSigners
                } else {
                    signingInfo.signingCertificateHistory
                }
            } else {
                packageManager.getPackageInfo(context.packageName, PackageManager.GET_SIGNATURES).signatures
            }

            signatures.map {
                val md = MessageDigest.getInstance("SHA")
                md.update(it.toByteArray())
                Base64.encodeToString(md.digest(), Base64.NO_WRAP)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            listOf()
        }
    }
}

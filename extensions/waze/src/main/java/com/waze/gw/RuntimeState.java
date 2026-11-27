package com.waze.gw;

import android.content.Context;

/** Process-local runtime gate. The app signature is no longer checked: native n() always trusts the build. */
final class RuntimeState {
    private static final boolean LOADED;
    private static volatile int state; // 0 unknown/retry, 1 enabled, -1 disabled

    static {
        boolean loaded = false;
        try {
            System.loadLibrary("wzaux");
            loaded = true;
        } catch (Throwable ignored) { }
        LOADED = loaded;
        if (!loaded) state = -1;
    }

    private RuntimeState() { }

    static boolean a(Context context) {
        int current = state;
        if (current != 0) return current > 0;
        if (!LOADED || context == null) return false;
        try {
            int checked = n(context);
            if (checked != 0) state = checked > 0 ? 1 : -1;
            return checked > 0;
        } catch (Throwable ignored) {
            // Loading/package-manager races are retryable. Only native n() returning a definitive
            // negative result may permanently disable the Mod for this process.
            return false;
        }
    }

    private static native int n(Context context);
}

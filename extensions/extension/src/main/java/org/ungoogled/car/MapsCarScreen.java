package org.ungoogled.car;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Rect;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.car.app.AppManager;
import androidx.car.app.CarContext;
import androidx.car.app.CarToast;
import androidx.car.app.Screen;
import androidx.car.app.SurfaceCallback;
import androidx.car.app.SurfaceContainer;
import androidx.car.app.model.Action;
import androidx.car.app.model.ActionStrip;
import androidx.car.app.model.Template;
import androidx.car.app.navigation.model.NavigationTemplate;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.LifecycleOwner;

/**
 * A navigation template whose Surface shows Maps' own car UI: the Surface goes to Maps' car projection
 * ({@link ProjectionHost}), which draws on it.
 */
final class MapsCarScreen extends Screen {
    private static final String TAG = "UA-CAR";

    private static final String ACCESS_CHANNEL = "waze_mod_access";
    private static final int ACCESS_NOTIFICATION = 0x57A2E;

    private final ProjectionHost maps;
    private final WazeModClient waze;
    private final OverlaySettings settings;
    private final WazeOverlay overlay;
    private final Handler main = new Handler(Looper.getMainLooper());

    private final SurfaceCallback callback = new SurfaceCallback() {
        @Override
        public void onSurfaceAvailable(@NonNull SurfaceContainer container) {
            Log.i(TAG, "surface available " + container.getWidth() + "x" + container.getHeight() + " dpi " + container.getDpi());
            maps.attach(container);
        }

        @Override
        public void onVisibleAreaChanged(@NonNull Rect visibleArea) {
            Log.i(TAG, "visible area " + visibleArea);
            maps.visibleArea(visibleArea);
        }

        @Override
        public void onSurfaceDestroyed(@NonNull SurfaceContainer container) {
            Log.i(TAG, "surface destroyed");
            maps.detach();
        }

        @Override
        public void onClick(float x, float y) {
            maps.click(x, y);
        }

        @Override
        public void onScroll(float distanceX, float distanceY) {
            maps.scroll(distanceX, distanceY);
        }

        @Override
        public void onScale(float focusX, float focusY, float scaleFactor) {
            maps.scale(focusX, focusY, scaleFactor);
        }
    };

    MapsCarScreen(@NonNull CarContext context) {
        super(context);
        maps = new ProjectionHost(context);
        settings = new OverlaySettings(context, () -> maps.redraw());
        overlay = new WazeOverlay(context.getAssets(), settings);
        maps.overlay(overlay);
        waze = new WazeModClient(context, new WazeModClient.Listener() {
            @Override
            public void onData(WazeData data) {
                overlay.set(data);
                maps.redraw();
            }

            @Override
            public void onAccessNeeded(Intent request) {
                main.post(() -> askAccess(request));
            }
        });
        maps.setKeyboard((field, info) -> {
            // One keyboard at a time, over the map.
            if (getScreenManager().getTop() != this) return;
            getScreenManager().push(new MapsSearchScreen(getCarContext(), field, info));
        });
        getLifecycle().addObserver(new DefaultLifecycleObserver() {
            @Override
            public void onCreate(@NonNull LifecycleOwner owner) {
                Log.i(TAG, "screen created, registering the surface callback");
                getCarContext().getCarService(AppManager.class).setSurfaceCallback(callback);
                WazeModAccessActivity.onGranted = waze::connect;
                waze.connect();
            }

            @Override
            public void onDestroy(@NonNull LifecycleOwner owner) {
                Log.i(TAG, "screen destroyed");
                WazeModAccessActivity.onGranted = null;
                waze.close();
                settings.close();
                maps.close();
            }
        });
    }

    /**
     * Waze Mod asks the user, on the phone, to let Maps read its data: a notification opens its screen (an app
     * cannot open a phone screen from Android Auto itself).
     */
    private void askAccess(Intent request) {
        Context app = getCarContext().getApplicationContext();
        NotificationManager notifications = app.getSystemService(NotificationManager.class);
        notifications.createNotificationChannel(new NotificationChannel(
                ACCESS_CHANNEL, "Waze Mod", NotificationManager.IMPORTANCE_HIGH));
        PendingIntent open = PendingIntent.getActivity(app, 0,
                new Intent(app, WazeModAccessActivity.class)
                        .putExtra(WazeModAccessActivity.EXTRA_REQUEST, request)
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
                PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT);
        notifications.notify(ACCESS_NOTIFICATION, new Notification.Builder(app, ACCESS_CHANNEL)
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentTitle("Cho phép Maps đọc dữ liệu Waze Mod")
                .setContentText("Chạm để mở màn hình cấp quyền của Waze Mod")
                .setContentIntent(open)
                .setAutoCancel(true)
                .build());
        CarToast.makeText(getCarContext(), "Mở điện thoại để cho phép Maps đọc dữ liệu Waze Mod",
                CarToast.LENGTH_LONG).show();
    }

    @NonNull
    @Override
    public Template onGetTemplate() {
        // The overlay is set on the phone (Customization > Android Auto), and changes there show at once.
        return new NavigationTemplate.Builder()
                .setActionStrip(new ActionStrip.Builder().addAction(Action.PAN).build())
                .setMapActionStrip(new ActionStrip.Builder().addAction(Action.PAN).build())
                .build();
    }
}

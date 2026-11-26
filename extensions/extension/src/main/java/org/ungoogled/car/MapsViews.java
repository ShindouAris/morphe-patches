package org.ungoogled.car;

import android.graphics.Rect;
import android.os.Binder;
import android.view.View;
import android.view.ViewGroup;

import java.lang.ref.Reference;
import java.lang.reflect.Field;

/**
 * Looks into Maps' car UI, which runs in this process. Maps' classes are obfuscated, so their fields are found by
 * type, not by name.
 */
final class MapsViews {
    private MapsViews() {
    }

    /** The first non-null field of [owner] (or its superclasses below Binder) of the given type. */
    static <T> T field(Object owner, Class<T> type) {
        for (Class<?> c = owner.getClass(); c != null && c != Binder.class && c != Object.class; c = c.getSuperclass()) {
            for (Field f : c.getDeclaredFields()) {
                if (!type.isAssignableFrom(f.getType())) continue;
                try {
                    f.setAccessible(true);
                    Object value = f.get(owner);
                    if (value != null) return type.cast(value);
                } catch (ReflectiveOperationException | RuntimeException ignored) {
                }
            }
        }
        return null;
    }

    /**
     * The root view of the car UI's window. The projection binder holds (weakly) the car activity's host, which
     * holds the activity's content view.
     */
    static View root(Object projection) {
        Reference<?> reference = field(projection, Reference.class);
        Object host = reference == null ? null : reference.get();
        if (host == null) return null;
        for (Class<?> c = host.getClass(); c != null && c != Object.class; c = c.getSuperclass()) {
            for (Field f : c.getDeclaredFields()) {
                if (!View.class.isAssignableFrom(f.getType())) continue;
                try {
                    f.setAccessible(true);
                    View view = (View) f.get(host);
                    if (view != null && view.isAttachedToWindow()) return view.getRootView();
                } catch (ReflectiveOperationException | RuntimeException ignored) {
                }
            }
        }
        return null;
    }

    /**
     * The largest list on screen that can scroll up or down, in window coordinates; null if there is none. Views
     * that cover most of the window (the map's containers, which say they scroll) are not lists.
     */
    static Rect verticalList(View root) {
        if (root == null || root.getWidth() == 0 || root.getHeight() == 0) return null;
        Rect[] best = {null};
        find(root, (long) root.getWidth() * root.getHeight() * 7 / 10, best);
        return best[0];
    }

    private static void find(View view, long maxArea, Rect[] best) {
        if (!view.isShown()) return;
        Rect rect = new Rect();
        if (!view.getGlobalVisibleRect(rect)) return;
        long area = (long) rect.width() * rect.height();
        if (area <= maxArea && rect.width() > 50 && rect.height() > 100
                && (view.canScrollVertically(1) || view.canScrollVertically(-1))) {
            if (best[0] == null || area > (long) best[0].width() * best[0].height()) best[0] = rect;
            return;   // a list inside a list scrolls with it
        }
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) find(group.getChildAt(i), maxArea, best);
        }
    }
}

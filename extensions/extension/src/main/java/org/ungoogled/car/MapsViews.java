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

    /** [dodge]'s answer when there is no room: the overlay is not drawn. */
    static final int HIDE = -1;

    /**
     * How far down [rect] (the overlay, window coordinates) must move to clear the cards and panels of the car UI
     * in its column: below those in the top half (the search bar, the turn card and its "then" line, a place card),
     * and above those in the bottom half (the trip card). [HIDE] when it does not fit, as under the search screen.
     * Cards are views with a background of their own, short of the whole window; the map is drawn by GL.
     */
    static int dodge(View root, Rect rect, int gap) {
        if (root == null || rect == null || root.getWidth() == 0 || root.getHeight() == 0) return 0;
        long rootArea = (long) root.getWidth() * root.getHeight();
        java.util.List<Rect> cards = new java.util.ArrayList<>();
        cards(root, rect, rootArea / 200, rootArea * 98 / 100, cards);
        int half = root.getHeight() / 2;
        int top = rect.top, floor = root.getHeight();
        for (Rect card : cards) {
            if (card.top < half) top = Math.max(top, card.bottom + gap);
            else floor = Math.min(floor, card.top - gap);
        }
        if (top + rect.height() > floor) return HIDE;
        Rect moved = new Rect(rect);
        moved.offsetTo(rect.left, top);
        for (Rect card : cards) {
            if (Rect.intersects(card, moved)) return HIDE;
        }
        return top - rect.top;
    }

    /** The cards whose columns meet [rect]'s. */
    private static void cards(View view, Rect rect, long minArea, long maxArea, java.util.List<Rect> out) {
        if (!view.isShown() || view instanceof android.view.SurfaceView || view instanceof android.view.TextureView) {
            return;
        }
        Rect visible = new Rect();
        if (!view.getGlobalVisibleRect(visible)) return;
        if (visible.right <= rect.left || visible.left >= rect.right) return;
        long area = (long) visible.width() * visible.height();
        if (area >= minArea && area <= maxArea && painted(view)) {
            out.add(visible);
            return;   // what is inside a card goes with it
        }
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) cards(group.getChildAt(i), rect, minArea, maxArea, out);
        }
    }

    /** Whether [view] paints a background of its own (not a transparent colour). */
    private static boolean painted(View view) {
        android.graphics.drawable.Drawable background = view.getBackground();
        if (background == null || !background.isVisible()) return false;
        if (background instanceof android.graphics.drawable.ColorDrawable) {
            return ((android.graphics.drawable.ColorDrawable) background).getAlpha() > 0x40;
        }
        return background.getAlpha() > 0x40;
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

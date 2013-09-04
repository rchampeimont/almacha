/* I, Raphael Champeimont, the author of this program,
 * hereby release it into the public domain.
 * This applies worldwide.
 * 
 * In case this is not legally possible:
 * I grant anyone the right to use this work for any purpose,
 * without any conditions, unless such conditions are required by law.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

class Point {
    /* This class implements a point in R^2 (with doubles as reals) */

    private double x = 0.;
    private double y = 0.;

    public Point(final double x, final double y) {
        this.x = x;
        this.y = y;
    }

    public Point() {
        this(0,0);
    }

    public void set(final double x, final double y) {
        this.x = x;
        this.y = y;
    }

    public Point opposite() {
        Point np = new Point();
        np.x = -x;
        np.y = -y;
        return np;
    }

    public static Point plus(final Point a, final Point b) {
        Point np = new Point();
        np.x = a.x + b.x;
        np.y = a.y + b.y;
        return np;
    }

    public void add(final Point b) {
        x += b.x;
        y += b.y;
    }

    public static Point minus(final Point a, final Point b) {
        Point np = new Point();
        np.x = a.x - b.x;
        np.y = a.y - b.y;
        return np;
    }

    public double norm() {
        return Math.sqrt(x*x + y*y);
    }

    public static double dist(final Point a, final Point b) {
        return minus(a, b).norm();
    }
}

public class AchaHello {
    public static void main(String[] args) {
        System.out.println("aaaaaaaaa");
        Point a = new Point();
        a.set(4,7);
        a.add(new Point(-4,0));
        System.out.println(a.norm());
        System.out.println(Point.dist(a, new Point(0,0)));



    }
}

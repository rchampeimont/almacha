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
public class AchaFloat {
    public static void main(String[] args) {
	{
	    int n = 10000;
	    double sum;
	    int i;

	    for (i=1, sum=0.0; i<=n; i++) {
		sum += 1.0/i;
	    }
	    System.out.println(sum);

	    for (i=n, sum=0.0; i>=1; i--) {
		sum += 1.0/i;
	    }
	    System.out.println(sum);
	}
	System.out.println("--------------------------------");
	{
	    double e = 2.718281828459045;
	    double u = e;
	    final int N = 100;
	    int n = 0;
	    System.out.println(u);
	    while (n<N) {
		n++;
		u = n * (u - 1.0);
		System.out.println(u);
	    }
	}
    }
}

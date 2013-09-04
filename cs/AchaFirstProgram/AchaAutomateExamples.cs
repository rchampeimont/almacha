/* I, Raphael Champeimont, the author of this work,
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

using System;

namespace AchaAutomates
{
	
	public class AchaAutomateExamples
	{

		public static void NombreImpairEnBinaire() {
			uint[,] S = {{0,1}, {0,1}};
			bool[] F = {false, true};
			/* L'automate A dit si le nombre écrit en binaire est impair. */
			AchaAutomateDeterministe A = new AchaAutomateDeterministe(2, 2, 0, F, S);
			uint[] Word;
			
			Word = new uint[4];
			Word[0] = 1;
			Word[1] = 0;
			Word[2] = 0;
			Word[3] = 1;
			Console.WriteLine("9 : 1001 : {0}", A.RunOnWordAndGetIfFinal(Word));
			
			Word = new uint[4];
			Word[0] = 1;
			Word[1] = 0;
			Word[2] = 0;
			Word[3] = 0;
			Console.WriteLine("8 : 1000 : {0}", A.RunOnWordAndGetIfFinal(Word));
			
			Word = new uint[2];
			Word[0] = 1;
			Word[1] = 1;
			Console.WriteLine("3 : 11 : {0}", A.RunOnWordAndGetIfFinal(Word));
			
			Word = new uint[0];
			Console.WriteLine("0 : [empty word] : {0}", A.RunOnWordAndGetIfFinal(Word));
		}

	}
}

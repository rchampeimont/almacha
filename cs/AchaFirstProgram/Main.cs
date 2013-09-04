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

/* Naming conventions:
 * camelCase for variables, member variables
 * PascalCase for constants, methods, classes
 */


using System;
using AchaAutomates;

namespace AchaFirstProgram
{
	
	class MainClass
	{

		enum Animals {
			Cat = 4,
			Fish = 7,
			Monkey = 10,
		}
		
		
		public static void Main(string[] args)
		{
			Console.WriteLine("The program begins.");

			//AchaAutomateExamples.NombreImpairEnBinaire();
			

			Console.WriteLine("The {0} number is {1}", Animals.Cat, (int) Animals.Cat);
			
			Console.WriteLine(">>> {0}", 4 | 177);
			
			string s;
			Console.Write("Enter something: ");
			s = Console.ReadLine();
			Console.WriteLine("Line: >>>{0}<<< (len={1})", s, s != null ? s.Length.ToString() : "null");
			int n = Convert.ToInt32(s);
			Console.WriteLine("Int value: {0}", n);
			
			
			
			
			Console.WriteLine("The program ends.");
		}
	}
}
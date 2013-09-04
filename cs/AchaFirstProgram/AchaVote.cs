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
using System.Collections.Generic;

namespace AchaVote {

	public class AchaVoteException : Exception {
	    public AchaVoteException(string message): base(message) {}
	}

	public class AchaVoteBadArgument : AchaVoteException {
	    public AchaVoteBadArgument(string message): base(message) {}
	}
	
	public class AchaVoteMatrix {
		// TODOs:
		// put a private attribute with the matrix
		// write a constructor which creates a neutral matrix
		// write a method which adds a vote to the matrix
		// wirte a constructor MatrixFromRawMatrix which takes long[,] and checks it is ok and builds an AchaVoteMatrix with it
		// write a method to get a long[,] from the matrix
		// write a method to compute the winner list
	}

}
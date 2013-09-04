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
	public class AchaAutomateException : Exception {
	    public AchaAutomateException(string message): base(message) {}
	}
	
	public class AchaAutomateDeterministe
	{
		private uint AlphabetSize = 0;
		private uint States = 1;
		private uint InitialState = 0;
		private bool[] FinalStates; 
		private uint[,] Transitions;

		
		public AchaAutomateDeterministe(uint A, uint S, uint I, bool[] F, uint[,] T) {
			/* An object from this class is an automaton definition.
			 * A: Alphabet size (>= 0)
			 * S: Number of states (>=1)
			 * I: Initial state (>=0)
			 * F: Says which states are final (length = S)
			 * T: Transition function, lines are states (S lines), columns are letters (A columns).
			 */
			AlphabetSize = A;
			States = S;
			InitialState = I;
			FinalStates = F;
			Transitions = T;
			if (InitialState >= States) {
				throw new AchaAutomateException("initalState => S");
			}
			if (FinalStates.Length != States) {
				throw new AchaAutomateException("F.Length != States");
			}
			if (Transitions.GetLength(0) != States || Transitions.GetLength(1) != AlphabetSize) {
				throw new AchaAutomateException("There exists k such that T.GetLength(k) != States");
			}
			for (uint i=0; i<Transitions.GetLength(0); i++) {
				for (uint j=0; j<Transitions.GetLength(1); j++) {
					if (Transitions[i,j] >= States) {
						// FIXME: Do the thing I wanted to do at the next line, when I'll know enough to do it.
						// throw new AchaAutomateException("Transitions from state {0} with letter {1} gives invalid state: {2}", i, j, Transitions[i,j]);
						throw new AchaAutomateException("Invalid transition");
					}
				}
			}
		}
		
		public AchaAutomateDeterministeWithState MakeMachineWithState() {
			AchaAutomateDeterministeWithState MyStateMachine = new AchaAutomateDeterministeWithState(this);
			return MyStateMachine;
		}

		public uint RunOnWordAndGetState(uint[] W) {
			AchaAutomateDeterministeWithState MyStateMachine = MakeMachineWithState();
			for (uint i=0; i<W.Length; i++) {
				MyStateMachine.EatLetterAndReturnState(W[i]);
			}
			return MyStateMachine.GetState();
		}
		
		public bool RunOnWordAndGetIfFinal(uint[] W) {
			return FinalStates[RunOnWordAndGetState(W)];
		}
		
		public uint GetAlphabetSize() {
			return AlphabetSize;
		}
		public uint GetStates() {
			return States;
		}
		public uint GetInitialState() {
			return InitialState;
		}
		public bool[] GetFinalStates() {
			return FinalStates;
		}
		public uint[,] GetTransitions() {
			return Transitions;
		}
		

			
	}
	
	public class AchaAutomateDeterministeWithState {
		/* An object from this class is an automaton, definition and state. */
		private uint State;
		private AchaAutomateDeterministe Definition;
		
		private void InitState() {
			State = Definition.GetInitialState();
		}
		
		public AchaAutomateDeterministeWithState(AchaAutomateDeterministe Definition) {
			/* Builds an automata with state from an automaton definition. */
			this.Definition = Definition;
			InitState();
		}
		
		public uint EatLetterAndReturnState(uint L) {
			State = Definition.GetTransitions()[State, L];
			return State;
		}
		
		public bool EatLetterAndReturnIfFinal(uint L) {
			State = Definition.GetTransitions()[State, L];
			return IsInFinalState();
		}
		
		public bool IsInFinalState() {
			return Definition.GetFinalStates()[State];
		}
		
		public uint GetState() {
			return State;
		}
	}
		
	

}
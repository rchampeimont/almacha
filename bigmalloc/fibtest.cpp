#include <iostream>
#include <cstdio>
#include <cstdlib>

using namespace std;

int main(int argc, char** argv) {
	int n = 128*1024*1024;
	cout << "Size of long: " << sizeof(long) << endl;
	cout << "Allocating...";
	fflush(stdout);
	long *A = (long*) calloc(n, sizeof(long));
	cout << " done." << endl;

	long nc = 0;
	while (true) {
		cout << "Cycle " << nc << ": ";
		cout << "Compute... ";
		fflush(stdout);
		// compute
		A[0] = 1;
		A[1] = 1;
		for (int i=2; i<n; i++) {
			A[i] = A[i-1] + A[i-2];
		}

		// check
		cout << " Check...";
		fflush(stdout);
		long a, b, c;
		a = 1;
		b = 1;
		for (int i=2; i<n; i++) {
			c = a + b;
			if (A[i] != c) {
				cerr << "A[" << i <<"] = " << A[i] << " while it should be " << c << endl;
				exit(1);
			}
			// delete
			A[i] = 0;
			a = b;
			b = c;
		}

		nc++;
		cout << " done." << endl;
	}
}

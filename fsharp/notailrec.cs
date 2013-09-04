class A {
	public static int f(int x) {
		if (x == 2000000000) {
			return x;
		} else {
			return f(x+1);
		}
	}

	public static void Main(string[] args) {
		System.Console.WriteLine(f(0));
	}
}

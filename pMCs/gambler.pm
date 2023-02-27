// Gambler
dtmc

const double pL; // probability of losing money
const int N; // initial wealth
const int W = N / 10; // N*10%

module gambler
	// local state
	s : [0..N+W+1] init 2;

	[] (s>0) & (s<(N+W)) -> pL : (s'=s+1) + (1-pL) : (s'=s-1);
endmodule


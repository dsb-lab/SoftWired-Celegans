function X = simulation(time,W)

	N = length(W);
	X = zeros(N,time+1);
	X(:,1) = rand(1,N)*2-1; %initial conditions between -1 and 1

	for t = 1:time
	    X(:,t+1) = tanh(W*X(:,t));
	end

end


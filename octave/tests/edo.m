function r = edo()
    [T,X] = ode45(@f, [0 10], [1;1]);
    plot(X(:,1), X(:,2));
end

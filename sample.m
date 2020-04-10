function output = sample(signal, n, dt)
    output = zeros(1, n);
    for i = 1:n
        output(i) = signal(i/dt);
    end
end


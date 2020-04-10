function signal = pulse_shape(bits, n,dt)
signal = zeros(1, n/dt);
for i = 0:n-1
    if bits(i+1) == 0
        signal(i/dt+1:(i+1)/dt) = -1.*rect(0:dt:1-dt);
    else
        signal(i/dt+1:(i+1)/dt) = rect(0:dt:1-dt);
    end
end
end


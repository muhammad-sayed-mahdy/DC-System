%Plot the output of the receiving filters without noise
n = 5;
random_bits = randi([0, 1], 1, n);
dt = 0.01;
signal = pulse_shape(random_bits, n, dt);
filter_t = 0:dt:1-dt;

%rect(1-t) = rect(t) also
matched_filter = rect(1-filter_t);
matched_conv = conv(signal, matched_filter)*dt;
t2 = 0:dt:length(matched_conv)*dt-dt;
figure('Name', 'Output of Receiving Filters without Noise');
subplot(3, 1, 1);
plot(t2, matched_conv);
title("Matched Filter");
xlabel('t');
ylabel('g(t)*h(t)');

t = 0:dt:n-dt;
subplot(3, 1, 2);
plot(t, signal);
title("No Filter");
xlabel('t');
ylabel('g(t)*h(t)');

convolved_signal = conv(signal, givenFilter(filter_t))*dt;
subplot(3, 1, 3);
plot(t2, convolved_signal);
title("Given Filter");
xlabel('t');
ylabel('g(t)*h(t)');

n = 10000;
t = 0:dt:n-dt;
random_bits = randi([0, 1], 1, n);
signal = pulse_shape(random_bits, n, dt);

EoverN0 = -20:2:20;
BER1 = zeros(size(EoverN0));
BER2 = zeros(size(EoverN0));
BER3 = zeros(size(EoverN0));
Pe = zeros(size(EoverN0));

i = 1;
for EoverN0 = -20:2:20
    N0 = 1/power(10, 0.1*EoverN0);   %N0 = E/(E/N0) after converting from dB
    w = sqrt(N0/2)*randn(size(signal));
    noisy_signal = signal + w;

    matched_filter = rect(1-filter_t);
    matched_conv = conv(noisy_signal, matched_filter)*dt;
    t2 = 0:dt:length(matched_conv)*dt-dt;

    matched_filter_output = decode(sample(matched_conv, n, dt));
    BER1(i) = BER(random_bits, matched_filter_output);
    Pe(i) = 0.5*erfc(sqrt(power(10, 0.1*EoverN0)));
    
    output = decode(sample(noisy_signal, n, dt));
    BER2(i) = BER(random_bits, output);
    
    convolved_signal = conv(noisy_signal, givenFilter(filter_t))*dt;
    output2 = decode(sample(convolved_signal, n, dt));
    BER3(i) = BER(random_bits, output2);
    
    i = i+1;
end

figure("Name", "BER");
EoverN0 = -20:2:20;
semilogy(EoverN0, BER1, '-', EoverN0, BER2, '-', EoverN0, BER3, '-');

legend("Matched Filter BER", "No Filter BER", "Giver Filter BER");
xlabel('E/N_0 (dB)');
ylabel('BER');

% BER is decreasing function of E/N_0 because when E/N_0 increase, 
% this means that the SNR increase, and the noise has lower impact on the
% signal, so the bit error rate decreases

% The matched filter has the lowest BER because it's the optimal filter as proved
% in the lectures, and it makes the SNR = E/(N_0/2) which is maximum

figure("Name", "Probability of Error");
semilogy(EoverN0, Pe);
title("Matched Filter Pe");
xlabel("E/N_0");
ylabel("Pe");

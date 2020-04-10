function y = BER(input,output)
    wrong_bits = 0;
    for i = 1:length(input)
        if (output(i) ~= input(i))
            wrong_bits = wrong_bits + 1;
        end
    end
    y = wrong_bits/length(input);
end


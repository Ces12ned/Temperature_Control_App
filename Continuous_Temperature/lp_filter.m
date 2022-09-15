function y = lp_filter(x) %#codegen
% This function uses a persistent variable named 
% 'buffer' that represents a sliding window of
% 100 samples at a time.
persistent buffer;
if isempty(buffer)
    buffer = ones(50,1)*x;
end

%y = zeros(size(x), class(x));

% Scroll the buffer
buffer(2:end) = buffer(1:end-1);
% Add a new sample value to the buffer
buffer(1) = x;
% Compute the current average value of the window and
% write result
y = sum(buffer)/numel(buffer);


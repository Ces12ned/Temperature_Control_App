function y = lp_filter(x) 

% This function uses a persistent variable named 'buffer' that represents a sliding window of
% 50 samples at a time.

persistent buffer;
if isempty(buffer)
    buffer = ones(50,1)*25;
end


buffer(2:end) = buffer(1:end-1);  % Scroll the buffer

buffer(1) = x;                    % Add a new sample value to the buffer

% Compute the current average value of the window and
% write result

y = sum(buffer)/numel(buffer);

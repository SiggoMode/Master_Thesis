function [A, B, C] = parseUDP(u)

A = NaN; B = NaN; C = NaN;

u = char(u);
n = length(u);

currentAngle = '';
buffer = '';
newData = false;

for i = 1:n
    c = u(i);
    display(c)
    buffer = [buffer, c];
    switch c
        case 'A'
            currentAngle = 'A';
            newData = true;
        case 'B'
            currentAngle = 'B';
            newData = true;
        case 'C'
            currentAngle = 'C';
            newData = true;
        otherwise
            newData = false;
    end
    
    if (buffer(1) ~= currentAngle) && newData
        switch buffer(1)
            case 'A'
                A = str2double(buffer(3:end-1));
            case 'B'
                B = str2double(buffer(3:end-1));
            case 'C'
                C = str2double(buffer(3:end-1));
        end
    buffer = currentAngle;
    end
end
switch currentAngle
    case 'A'
        A = str2double(buffer(3:end-1));
    case 'B'
        B = str2double(buffer(3:end-1));
    case 'C'
        C = str2double(buffer(3:end-1));
end

function [IDs, rvecs, tvecs] = parse_sensor_data(data)

%rvecs = zeros(3,1, 'double');
%tvecs = zeros(3,1, 'double');
%IDs = 999;
IDs = [];
rvecs = [];
tvecs = [];

ID = 0;
r1 = 0.0; r2 = 0.0; r3 = 0.0;
x = 0.0; y = 0.0; z = 0.0;

data = char(data);
n = length(data);

current_key = '';
new_id = false;
new_key = false;
buffer = '';
end_of_measurement = false;

for i = 1:n
    c = data(i);
    switch c
        case ';'
            end_of_measurement = true;
            %disp(' ')
        case 'I'
            current_key = 'I';
            new_key = true;
            new_id = true;
        case 'q'
            current_key = 'q';
            new_key = true;
        case 'r'
            current_key = 'r';
            new_key = true;
        case 's'
            current_key = 's';
            new_key = true;
        case 'x'
            current_key = 'x';
            new_key = true;
        case 'y'
            current_key = 'y';
            new_key = true;
        case 'z'
            current_key = 'z';
            new_key = true;
        otherwise
            new_key = false;
    end

    buffer = [buffer, c];

    if end_of_measurement && new_id
        IDs = [IDs, ID];
        rvecs = [rvecs; [r1;r2;r3]];
        tvecs = [tvecs; [x;y;z]];
        % IDs = ID;
        % rvecs = [r1;r2;r3];
        % tvecs = [x;y;z];
        
        buffer = '';
        current_key = '';
        end_of_measurement = false;
    end
    
    if ~isempty(current_key) && new_id && (buffer(1) ~= current_key(1)) && new_key
        switch buffer(1)
            case 'I'
                ID = real(str2double(buffer(3:end-1)));
            case 'q'
                r1 = real(str2double(buffer(3:end-1)));
            case 'r'
                r2 = real(str2double(buffer(3:end-1)));
            case 's'
                r3 = real(str2double(buffer(3:end-1)));
            case 'x'
                x = real(str2double(buffer(3:end-1)));
            case 'y'
                y = real(str2double(buffer(3:end-1)));
            case 'z'
                z = real(str2double(buffer(3:end-1)));
        end
        buffer = current_key;
    end
end
end

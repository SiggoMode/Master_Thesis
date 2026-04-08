function q = euler_to_quaternion(theta)
% theta = [A; B; C] (roll, pitch, yaw)

A = theta(1);
B  = theta(2);
C = theta(3);

c1 = cos(A/2); s1 = sin(A/2);
c2 = cos(B/2);  s2 = sin(B/2);
c3 = cos(C/2); s3 = sin(C/2);

q0 = c1*c2*c3 + s1*s2*s3;
q1 = s1*c2*c3 - c1*s2*s3;
q2 = c1*s2*c3 + s1*c2*s3;
q3 = c1*c2*s3 - s1*s2*c3;

q = [q0; q1; q2; q3];
q = q / norm(q);
end
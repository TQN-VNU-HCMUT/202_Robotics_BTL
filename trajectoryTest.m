clear
close all

qMax = 100;
vMax = 20;
aMax = 5;

t1   = vMax/aMax;
tm   = (qMax - aMax*t1^2)/vMax;
tmax = 2*t1 + tm;
t2   = tmax - t1;

t       = 0:0.1:tmax;
lengthT = length(t);
a       = zeros(lengthT,1);
% v       = zeros(lengthT,1);
% q       = zeros(lengthT,1);

for i = 1:1:lengthT
    if (t(i) < t1)
        a(i) = aMax;
%         v(i) = aMax*t(i);
%         q(i) = 0.5*aMax*t(i)^2;
    elseif (t(i) < t2)
        a(i) = 0;
%         v(i) = vMax;
%         q(i) = 0.5*aMax*t1^2 + vMax*(t(i)-t1);
    else
        a(i) = -aMax;
%         v(i) = vMax - aMax*(t(i)-t2);
%         q(i) = qMax - 0.5*aMax*(tmax-t(i))^2;
    end
end

% a = (gaussmf(t,[t1/8 t1/2]) - gaussmf(t,[t1/8 t2+t1/2]))*aMax;
v = cumtrapz(t,a);
q = cumtrapz(t,v);

figure(1)
subplot(3,1,1)
hold on
grid on
plot(t,q,'LineWidth',2);
legend('q(t)');

subplot(3,1,2)
hold on
grid on
plot(t,v,'LineWidth',2);
legend('v(t)');

subplot(3,1,3)
hold on
grid on
plot(t,a,'LineWidth',2);
legend('a(t)');
    
% for i = 2:1:lengthT
%     subplot(3,1,1)
%     hold on
%     grid on
%     plot(t(i-1:i),q(i-1:i),'LineWidth',2);
%     legend('q(t)');
% 
%     subplot(3,1,2)
%     hold on
%     grid on
%     plot(t(i-1:i),v(i-1:i),'LineWidth',2);
%     legend('v(t)');
% 
%     subplot(3,1,3)
%     hold on
%     grid on
%     plot(t(i-1:i),a(i-1:i),'LineWidth',2);
%     legend('a(t)');
%     
%     pause(0.001)
% end


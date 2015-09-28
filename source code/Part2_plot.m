CWN_L5 = part2(5);
CWN_L10 = part2(10);

plot(N_array, CWN_L5, 'o-r');
hold on;
plot(N_array, CWN_L10, 'o-b');
hold on;

xlabel('number of nodes, N');
ylabel('optimum CW, CW*(N)');
set(gca,'YTick',[0:250:3000])

legend('L=5','L=10',0)
print -depsc2 p2_L.eps
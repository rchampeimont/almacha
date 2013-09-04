% M = load('log.txt')
[x, y1] = stairs(M(:,1), M(:,2), 'g');
[~, y2] = stairs(M(:,1), M(:,3), 'y');
[~, y3] = stairs(M(:,1), M(:,4), 'r');
hold on;
h = area(x, [y1, y2, y3]);
set(h(1),'FaceColor','green');
set(h(2),'FaceColor','yellow');
set(h(3),'FaceColor','red');
hold off;

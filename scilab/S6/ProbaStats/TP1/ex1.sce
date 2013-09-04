// Public domain script.
loi_de_X = 1/6*ones(1,6);
loi_de_Y = loi_de_X;
subplot(2,1,1);
bar(1:6, loi_de_X);
loi_de_2_des = convol(loi_de_X, loi_de_Y);
subplot(2,1,2);
bar(2:12, loi_de_2_des);

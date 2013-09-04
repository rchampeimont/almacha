% Public domain.
loi_de_X = 1/6*ones(1,6);
loi_de_Y = loi_de_X;
loi_des_deux = conv(loi_de_X, loi_de_Y);
bar(2:12, loi_des_deux);

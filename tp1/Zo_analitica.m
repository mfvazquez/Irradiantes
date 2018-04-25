No = 377;
k = 0.66;

Zo = @(a,b,k) ((No*k)/(2*pi))*log(b/a);

disp(['RG-123 Zo = ' num2str(Zo(2.29, 7.98,k))])
disp(['RG-58 Zo = ' num2str(Zo(0.91, 3.51,k))])
close all
clear

vp = 0.66*3e8;
Zo = 50;
l = 1:0.0001:1.056;
f = 1e9;

Beta = @(f) ((f*2*pi) ./vp);

carga = @(R,C,f)(1./R - 1i./(2.*pi.*f.*C)).^-1;

Zin = @(Zl)(Zo * (Zl + 1i .* Zo .* tan(Beta(f) .* l))./(Zo + 1i .* Zl .* tan(Beta(f) .* l)));


figure
plot(Zin(carga(100,3.9e-9,f)));
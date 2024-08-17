vspd += gravity;
vspd *= friction;

if (abs(vspd) < 0.01) vspd = 0;
if (abs(hspd) < 0.01) hspd = 0;

x += hspd;
y += vspd;
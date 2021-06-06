close all
clear all

R1=1000
R2=1000
R3=1000
R4=100e3
C1=220e-9
C2=110e-9


%w=2*pi*1000

f=logspace(1,7,10000);
n=columns(f)
for i=1:n
	w(i)=2*pi*f(i);
	gain(i)=(1/(j*w(i)*C2)) / ( 1/(j*w(i)*C2) + R2) *  (R1 / (R1+ 1/(j*w(i)*C1)) ) *(1+R4/R3);
	ganho_modulo(i)=abs(gain(i));
endfor;

hf = figure ();
semilogx(f, 20*log10(ganho_modulo), "g;Voltage source;");
grid on;
xlabel("t[s]");
ylabel("Voltage [V]");
print(hf, "ganho.eps", "-depsc");

indice=find(ganho_modulo==max(ganho_modulo))
%wf=w(indice)

wf=1000*2*pi

Zi=abs(1/(j*wf*C1)+R1)
Zout=abs(1/( 1/(R2+R3) + j*wf*C2 ))
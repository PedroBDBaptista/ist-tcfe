close all
clear all

R1=1000
R2=1000
R3=1000
R4=100e3
C1=220e-9
C2=110e-9



f=logspace(1,7,10000);
n=columns(f);


for i=1:n
	w(i)=2*pi*f(i);
	gain(i)=(1/(j*w(i)*C2)) / ( 1/(j*w(i)*C2) + R2) *  (R1 / (R1+ 1/(j*w(i)*C1)) ) *(1+R4/R3);
	ganho_modulo(i)=abs(gain(i));
endfor;

ganho_maximo=max(ganho_modulo);


LCF_indice=1;
HCF_indice=1;


for i=1:n
	if(LCF_indice==1 && ganho_modulo(i)>(ganho_maximo/sqrt(2)) )
		LCF_indice=i;
	endif;

	if(LCF_indice!=1 && HCF_indice==1 && ganho_modulo(i)<ganho_maximo/sqrt(2))
		HCF_indice=i;
	endif;
endfor;




hf = figure ();
semilogx(f, 20*log10(ganho_modulo), "-b");
grid on;
xlabel("f[Hz]");
ylabel("Gain");
print(hf, "ganho.eps", "-depsc");



%IMPEDANCIAS
wf=2*pi*1000;

Zi=(1/(j*wf*C1)+R1)
Zout=(1 / ( 1/(R2) + j*wf*C2 ))

Zi_abs=abs((1/(j*wf*C1)+R1))
Zout_abs=abs((1/( 1/(R2) + j*wf*C2 )))


%IMPRESSAO VALORES

%printf("\n\nLCF_indice %f\n",LCF_indice );
%printf("HCF_indice %f\n",HCF_indice);


printf("\n\nLCF %f\n",f(LCF_indice) );
printf("HCF %f\n",f(HCF_indice) );
printf("central frequency %f\n",sqrt(f(HCF_indice)*f(LCF_indice)) );

lower_TEO=1/(2*pi*C1*R1)
upper_TEO=1/(2*pi*C2*R2)
central_TEO=sqrt(lower_TEO*upper_TEO)

w_central=2*pi*sqrt(f(HCF_indice)*f(LCF_indice));
gain_fin_db=20*log10(abs((1/(j*w_central*C2)) / ( 1/(j*w_central*C2) + R2) *  (R1 / (R1+ 1/(j*w_central*C1)) ) *(1+R4/R3)))

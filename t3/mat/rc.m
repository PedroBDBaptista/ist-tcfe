close all
clear all

dt=1e-5
tmax=1e4
freq=2*pi*50.;
period=1./50.
A=230./10.;


%envelope
R1=300e3;
C1=300e-6;



% T off
toff=(1/freq)*atan(R1*C1*freq)


j=1;

for i=1:tmax

	t(i)=i*dt;
	v2(i)=A*sin(freq*t(i));

	if(v2(i)>0)
		v3(i)=v2(i);
	else
		v3(i)=0.;
	endif;

	if(t(i)>toff &&    A * sin(freq*toff) * exp(-(t(i)-toff)/(R1*C1)) > v3(i))
		vo(i)=A * sin(freq*toff) * exp(-(t(i)-toff)/(R1*C1));
	else
		vo(i)=0.;
	endif;

	if(A * sin(freq*toff) * exp(-(t(i)-toff)/(R1*C1)) < v3(i)    &&   t(i)>toff+period)
		toff=toff+period;
	endif;

	%voltagem envelope
	venvelope(i)=v3(i);
	if(vo(i)>v3(i))
		venvelope(i)=vo(i);
	endif;


endfor;




%GRAFICOS

hf = figure ();
plot (t, v2, "g");
hold on;
plot (t, v3, "r");
hold on;
plot (t, vo, "b");
hold on;
plot (t, venvelope, "-k");


xlabel ("t[s]");
ylabel ("v2(t) [V]");
print (hf, "v2.eps", "-depsc");

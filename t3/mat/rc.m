close all
clear all

dt=1e-5
tmax=1e4
freq=2*pi*50.;
period=1./50.
A=230./10.;

%envelope
R1=5e3;
C1=1;



% T off
toff=(1/freq)*atan(R1*C1*freq)


% T on
f=@(x) sin(freq*x)-sin(freq*toff)*exp(-(x-toff)/(R1*C1));
x0=toff;
ton=fzero(f,x0)

condition=1;


for i=1:tmax
	t(i)=i*dt;
	v2(i)=A*sin(freq*t(i));

	if(v2(i)>0)
		v3(i)=v2(i);
	else
		v3(i)=0.;
	endif;

	if(t(i)>toff && t(i)<ton)
		vo(i)=A * sin(freq*toff) * exp(-(t(i)-toff)/(R1*C1));
		condition=0;
	else
		vo(i)=0.;
	endif;

	if(condition==0)
		toff=toff+period;
		ton=ton+period;
		condition=1;
	endif;

endfor;






hf = figure ();
plot (t, v2, "g");
hold on;
plot (t, v3, "r");
hold on;
plot (t, vo, "b");


xlabel ("t[s]");
ylabel ("v2(t) [V]");
print (hf, "v2.eps", "-depsc");

% Simple Demo that needs lots of cleaning up, lots of adding things to get
% a good grade, and lots of automation.
c = 440*(2^((40-49)/12));
g = 440*(2^((47-49)/12));
a = 440;
t = linspace(0,2,20000);
wt = sin(2*pi*c*t).*(heaviside(t)-heaviside(t-0.20));
wt = wt + sin(2*pi*c*t-0.25).*(heaviside(t-0.25)-heaviside(t-0.25-0.20));
wt = wt + sin(2*pi*g*t-0.5).*(heaviside(t-0.5)-heaviside(t-0.5-0.20));
wt = wt + sin(2*pi*g*t-0.75).*(heaviside(t-0.75)-heaviside(t-0.75-0.20));
wt = wt + sin(2*pi*a*t-1).*(heaviside(t-1)-heaviside(t-1-0.20));
wt = wt + sin(2*pi*a*t-1.25).*(heaviside(t-1.25)-heaviside(t-1.25-0.20));
wt = wt + sin(2*pi*g*t-1.5).*(heaviside(t-1.5)-heaviside(t-1.5-0.45));
sound(wt, 10000);
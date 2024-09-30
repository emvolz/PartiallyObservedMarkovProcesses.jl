using POMP
using DataFrames
using Distributions
using Random
using RCall
using Test

Random.seed!(263260083)

k = systematic_resample(10,[3.1;3;1;;0;0;1]);
@test length(k)==10
@test all(k.!=4) && all(k.!=5)

rin = function(;x₀,_...)
    d = Poisson(x₀)
    (x=rand(d),)
end

rlin = function (;t,a,x,_...)
    d = Poisson(a*x)
    (t=t+1,x=rand(d))
end

rmeas = function (;x,k,_...)
    d = NegativeBinomial(k,k/(k+x))
    (y=rand(d),)
end

dmeas = function (;x,y,k,give_log,_...)
    d = NegativeBinomial(k,k/(k+x))
    if give_log
        logpdf(d,y)
    else
        pdf(d,y)
    end
end

p1 = (a=1.5,k=7.0,x₀=5.0);

P = simulate(
    t0=0,
    times=[i for i=0:20],
    params=p1,
    rinit=rin,
    rprocess=rlin,
    rmeasure=rmeas,
    dmeasure=dmeas
)

P = pomp(
    obs(P)[1,1,:],
    times=times(P),
    t0=0,
    rinit=rin,
    rprocess=rlin,
    rmeasure=rmeas,
    dmeasure=dmeas
)
@test isa(P,POMP.PompObject)

x0 = rinit(P,params=p1,nsim=10)
y = obs(P);
t = times(P);
x = Array{eltype(x0)}(undef,size(x0,1),1,1);
rprocess!(P,x,x0=x0,times=t[1:1],params=[p1])
@test x0==x[:,:,1]

@time Q = pfilter(P,Np=1000,params=p1)
@time Q = pfilter(P,Np=1000,params=p1)
@time Q = pfilter(Q)
@test isa(Q,POMP.PfilterdPompObject)

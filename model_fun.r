
# Simulate Phyto-zooplankton-irradiation-mixin layer model
# Process error with lognormal noise
#
# The parameter p is a list with the follow components
#
# tt:     Simulation time
# Aini:    Phytoplankton initial value
# Hini:    Zooplankton initial value
# Pm:   Max photosynthetic rate 
# dt:   Time interval for integration
# 
# alfa: rate of photosynthesis per mol of PAR 
# Im:   Average light intensity (PAR)
# R:    Phyto Respiration rate
# c:    Sinking velocity
# b:    Resuspention rate
# Zm:   Mixing depth
# q:    Predation eficience
# mu:   Mortality rate Zoo
# et:   Transformation efficiency Zoo
# errm: Process error (in decimal scale)

plank_zoo_rad<-function(p)
{
  A <-double(p$tt)
  H <-double(p$tt)
  AA <-double(1/p$dt)
  HH <-double(1/p$dt)
  A[1]<-p$Aini
  H[1]<-p$Hini
  
  #rtime<-0  
  
  for(t in 2:p$tt){
    stp <-round(1/p$dt)+1
    AA[1]<-A[t-1]
    HH[1]<-H[t-1]
    for(i in 2:stp){
      AA[i] <- (AA[i-1] + p$dt*(AA[i-1]*p$Pm * tanh(p$alfa*p$Im/p$Pm)- p$R*AA[i-1] - (p$c-p$b*p$Zm) - AA[i-1]*HH[i-1]*p$q))*rlnorm(1,sdlog=p$errm)
      if(AA[i]<0){ AA[i]<-0}
      HH[i] <- (HH[i-1] + p$dt*(-p$mu*HH[i-1]+p$q*HH[i-1]*AA[i-1]*p$et))*rlnorm(1,sdlog=p$errm)
      #rtime<-rtime+dt
    }
    A[t]<-AA[stp]
    H[t]<-HH[stp]
    #cat(rtime,A[t],H[t],"\n")
  }
  
  return(list(A=A,H=H))
}

plank_zoo_rad_eq<-function(p)
{
  W <- (p$alfa*p$Im)/p$Pm
  Ae1<-(p$c-p$b*p$Zm)/(p$Pm*tanh(W)-p$R)
  Ae1 <-ifelse(Ae1<0,0,Ae1)
  Ae2<- p$mu/(p$q*p$et)
  He2<- 1/p$q*(p$Pm*tanh(W)-p$R-(p$c-p$b*p$Zm)*p$q*p$et/p$mu)
  return(list(Ae1=Ae1,Ae2=Ae2,He2=He2))
}
  

# Estimacion de parametros usando Aproximate Bayesian computation 
# 
#
estima_ABC <- function(dat,p,dlim,sim=1000)
{
  # We will estimate only the following parameters
  
  # c
  # b
  # R
  # q
  # mu

  da <- data.frame(matrix(, nrow = p$tt, ncol = 5))
  
  names(da) <- c("c","b","R","q","mu")  
  j <-1
  
  for(i in 1:sim){
    # calcula parametros
    ms <- runif(1,m[1],m[2])
    gs <- runif(1,g[1],g[2])
    vs <- trunc(runif(1,v[1],v[2]))
    nini <- (1 - gs/ms)*vs
    
    # Corre el modelo
    out <- levins_pro(time,nini,ms,gs,vs)
    
    # selecciona la ultima parte
    out <- out[501:(500+lendat)]
    
    dis <- sum((dat-out)^2)
    if(dis <= dlim){
      da[j,]<-c(ms,gs,vs,dis)
      j <- j + 1
    }
    
  }
  return(na.omit(da))
}

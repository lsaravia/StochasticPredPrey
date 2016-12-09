
# Stochastic predator-prey model shiny application

* The model was formulated in [1]. I added stochastic process error in logaritmic scale. These are the equations: 


![](http://latex.codecogs.com/gif.latex?\frac{dA}{dt}=A P_m tanh(\frac{\alpha I_m}{P_m})- R A - (c - b Z_m)- A H q)   

$$\frac{dH}{dt}=-\mu H + q H A e_{\tau}$$   

* The parameters with units are: 

    $A$: *Phythoplankton biomass* [mg chl-a m^-3^] 
    
    $H$: *Zooplankton biomass* [mg m^-3^]
    
    $P_m$: *Max photosynthetic rate* [day^-1^]
    
    $\alpha$: *Rate of photosynthesis per mol of PAR* [mol^-1^ m^2^]  
    
    $I_m$: *Average light intensity (PAR)* [mol^-1^ m^2^ day^-1^]
    
    $R$:  *Phytoplankton Respiration rate* [day^-1^]
    
    $c$:  *Sinking velocity* [mg chl-a m^-3^ day^-1^]
    
    $b$:  *Resuspention rate* [mg chl-a m^-4^ day^-1^]
    
    $Z_m$: *Mixing depth* [m]
    
    $q$:  *Predation eficience* [nondimentional]
    
    $\mu$: *Mortality rate Zooplankton* [day^-1^]
    
    $e_{\tau}$: *Transformation efficiency Zooplankton* [nondimentional]

* The model was simulated with an integration step of $h=0.01$, and the process error was added as follows, see [2]:

$$log[A(t+h)]=log[A(t) +h f(A)] + Z$$

* where $Z$ is a normal random variable with mean cero and standar deviation $SD$, then fluctuations have a lognormal distribution:

$$A(t+h)=[A(t) +h f(A) ] e^Z$$
    
$$H(t+h)=[H(t) +h f(H) ] e^Z$$


* You could find the application working at <https://phyzoo.shinyapps.io/ModelApp/>


## References

1. Ferrero, E., Eöry, M., Ferreyra, G., Schloss, I., Zagarese, H., Vernet, M., & Momo, F. (2006). Vertical mixing and ecological effects of ultraviolet radiation in planktonic communities. Photochemistry and Photobiology, 82(4), 898–902. 

1. Hilborn, R. & Mangel, M. (1997). The ecological detective. Princeton University Press
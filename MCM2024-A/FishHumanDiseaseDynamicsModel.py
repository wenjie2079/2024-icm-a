def fun3(x, t):
    beta1 = 0.5  # Infection rates in salmonids
    beta2 = 0.1  # Infection rate of seven-gill eels
    gamma1 = 0.8  # Salmon recovery rate
    gamma2 = 0.01  # Recovery rate of seven-gill eels
    alpha= 0.5 # Replenishment rates for salmon and sevengill eel stocks
    sigma1=0.2 # Human predation rates on salmonids
    sigma2=0.9 # Human predation rates on sevengill eels
    u1=0.2 # Salmon natural mortality
    u2 = 0.5  # Natural mortality of seven-gill eel (Anguilla anguilla)
    u3 = 0.00001 # Human natural mortality rate
    dx = np.zeros(3)  # x[0] denotes S, x[1] denotes I, x[2] denotes R
    
    dx[0] = alpha-u1*x[0]-beta1 * x[0] * x[1] +gamma1*0-sigma1*x[2]*x[0]/(1+x[0])
    dx[1] = beta1 * x[0] * x[1] -u2*x[1] - gamma1 * x[1]*0-sigma2*x[2]*x[1]/(1+x[1])
    dx[2] =sigma1*x[2]*x[1]/(1+x[1])+ sigma2*x[2]*x[1]/(1+x[1])-u3*x[2]
    return dx
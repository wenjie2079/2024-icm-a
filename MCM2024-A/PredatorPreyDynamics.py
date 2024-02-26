def fun1(x, t):

    r1 = 0.2 #Fish growth rate, mortality rate = 0.8
    r2 = 0.2 #Mortality rate of seven-gill eels, growth rate of seven-gill eels = 0.2 per cent.
    if t>10:
        r1=1
    N1 = 200 #Maximum 2 number of A and B
    N2 = 500
    sigma1 = 0.5  # The amount of food provided by a unit number of population B (relative to N2) to feed A is a multiple of the amount of food consumed by a unit number of A (relative to N1) to feed A.
    sigma2 = 5# The amount of food provided by a unit number of population A (relative to N1) to feed B is a multiple of the amount of food consumed by a unit number of population B (relative to N2) to feed B
    # Note: When sigma1*sigma2>1, the differential equation is unstable and matlab may report an error when calculating the numerical solution.

    dx1 = -2*r1 * x[0] * (1 - x[0] / N1 + sigma1 * x[1] / N2)
    dx2 = r2 * x[1] * (-1 - x[1] / N2 + sigma2 * x[0] / N1)
    return [dx1, dx2]
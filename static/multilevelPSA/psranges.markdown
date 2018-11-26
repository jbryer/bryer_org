---
layout: default	
title: multilevelPSA
subtitle: Evaluate the overlap and ranges of propensity scores.
published: true
status: publish
submenu: multilevelPSA
---
 
 
 


 
This function will create a data frame with three variables (a, b, c) for two groups.
 

    getSimulatedData <- function(nvars = 3, ntreat = 100, treat.mean = 0.6, treat.sd = 0.5, 
        ncontrol = 1000, control.mean = 0.4, control.sd = 0.5) {
        if (length(treat.mean) == 1) {
            treat.mean = rep(treat.mean, nvars)
        }
        if (length(treat.sd) == 1) {
            treat.sd = rep(treat.sd, nvars)
        }
        if (length(control.mean) == 1) {
            control.mean = rep(control.mean, nvars)
        }
        if (length(control.sd) == 1) {
            control.sd = rep(control.sd, nvars)
        }
        
        df <- c(rep(0, ncontrol), rep(1, ntreat))
        for (i in 1:nvars) {
            df <- cbind(df, c(rnorm(ncontrol, mean = control.mean[1], sd = control.sd[1]), 
                rnorm(ntreat, mean = treat.mean[1], sd = treat.sd[1])))
        }
        df <- as.data.frame(df)
        names(df) <- c("treat", letters[1:nvars])
        return(df)
    }

 
##### 1:10 (100 treatments, 1000 control units)
 

    test.df1 <- getSimulatedData(ntreat = 100, ncontrol = 1000)
    psranges1 <- psrange(test.df1, test.df1$treat, treat ~ ., samples = seq(100, 
        1000, by = 100), nboot = 20)
    (p1 <- plot(psranges1))

![plot of chunk psrange1](/images/figure/psrange1.png) 

    summary(psranges1)

 
##### 1:20 (100 treatments, 2000 control units)
 

    test.df2 <- getSimulatedData(ncontrol = 2000)
    psranges2 <- psrange(test.df2, test.df2$treat, treat ~ ., samples = seq(100, 
        2000, by = 100), nboot = 20)
    (p2 <- plot(psranges2))

![plot of chunk psrange2](/images/figure/psrange2.png) 

    summary(psranges2)

 
##### 100 treatments, 1000 control units, equal means and standard deviations
 

    test.df3 <- getSimulatedData(ncontrol = 1000, treat.mean = 0.5, control.mean = 0.5)
    psranges3 <- psrange(test.df3, test.df3$treat, treat ~ ., samples = seq(100, 
        1000, by = 100), nboot = 20)
    (p3 <- plot(psranges3))

![plot of chunk psrange3](/images/figure/psrange3.png) 

    summary(psrnages3)

    ## Error: error in evaluating the argument 'object' in selecting a method for
    ## function 'summary': Error: object 'psrnages3' not found

 
##### 100 treatments, 1000 control units, very little overlap
 

    test.df4 <- getSimulatedData(ncontrol = 1000, treat.mean = 0.25, treat.sd = 0.3, 
        control.mean = 0.75, control.sd = 0.3)
    psranges4 <- psrange(test.df4, test.df4$treat, treat ~ ., samples = seq(100, 
        1000, by = 100), nboot = 20)
    (p4 <- plot(psranges4))

![plot of chunk psrange4](/images/figure/psrange4.png) 

    summary(psranges4)

 
##### 100 treat, 1000 control, 10 covariates
 

    test.df5 <- getSimulatedData(nvars = 10, ntreat = 100, ncontrol = 1000)
    psranges5 <- psrange(test.df5, test.df5$treat, treat ~ ., samples = seq(100, 
        1000, by = 100), nboot = 20)
    (p5 <- plot(psranges5))

![plot of chunk psrange5](/images/figure/psrange5.png) 

    summary(psranges5)

 
 

---
layout: default	
title: multilevelPSA
subtitle: Propensity Score Ranges
published: true
status: publish
submenu: multilevelPSA
---
 
Note: The following is included as a demo in the `multilevelPSA` package. Type `demo(pisa)` to start.
 
In this example we will explore the differences between private and public schools using the Programme of International Student Assessment (PISA). Since there are international differences in how private and public schools operate, propensity scores will be estimated separately for each country.
 

    require(multilevelPSA)
    require(party)
    data(pisana)
    data(pisa.colnames)
    data(pisa.psa.cols)

 
Proportion of private and public school students in each country.
 

    prop.table(table(pisana$CNT, pisana$PUBPRIV, useNA = "ifany"), 1) * 100

    ##      
    ##       Private Public
    ##   CAN   7.112 92.888
    ##   MEX  10.601 89.399
    ##   USA   6.593 93.407

 
### Phase I: Estimate Propensity Scores
 
We will use the `ctree` function in the `party` package to stratify students.
 

    mlctree = mlpsa.ctree(pisana[, c("CNT", "PUBPRIV", pisa.psa.cols)], formula = PUBPRIV ~ 
        ., level2 = "CNT")

    ##   |                                                                         |                                                                 |   0%  |                                                                         |======================                                           |  33%  |                                                                         |===========================================                      |  67%  |                                                                         |=================================================================| 100%

    student.party = getStrata(mlctree, pisana, level2 = "CNT")

 

    tree.plot(mlctree, level2Col = pisana$CNT)

![plot of chunk treeplot](/images/figure/treeplot.png) 

 

    # NOTE: This is not entirely correct but is sufficient for visualization
    # purposes. See mitools package for combining multiple plausible values.
    student.party$mathscore = apply(student.party[, paste0("PV", 1:5, "MATH")], 
        1, sum)/5

 
### Phase II: Estimate effects of math score
 

    results.psa.math = mlpsa(response = student.party$mathscore, treatment = student.party$PUBPRIV, 
        strata = student.party$strata, level2 = student.party$CNT, minN = 5)

    ## Warning: Removed 463 (0.696%) rows due to strata size being less than 5

    summary(results.psa.math)

    ## Multilevel PSA Model of 85 strata for 3 levels. Approx t: 10.8 Confidence
    ## Interval: 24.75, 31.3

    ##    level2  strata Treat Treat.n Control Control.n ci.min ci.max
    ## 1     CAN Overall 512.8   21093   578.6      1625 59.573  72.08
    ## 2    <NA>       1 491.6    1128   580.0        28     NA     NA
    ## 3    <NA>       2 476.3    1326   599.9         9     NA     NA
    ## 4    <NA>       3 512.7     630   585.3        11     NA     NA
    ## 5    <NA>       4 508.2    2240   570.6       140     NA     NA
    ## 6    <NA>       5 470.1     179   578.2         8     NA     NA
    ## 7    <NA>       6 447.4     310   500.0        19     NA     NA
    ## 8    <NA>       7 503.0    3276   584.4        83     NA     NA
    ## 9    <NA>       8 464.1     120   471.1         5     NA     NA
    ## 10   <NA>       9 526.0     190   559.6        41     NA     NA
    ## 11   <NA>      10 463.2      91   501.8        20     NA     NA
    ## 12   <NA>      11 516.7     750   556.9        44     NA     NA
    ## 13   <NA>      12 520.6     292   559.3        34     NA     NA
    ## 14   <NA>      13 489.1     475   562.0         8     NA     NA
    ## 15   <NA>      14 463.1     151   533.7        21     NA     NA
    ## 16   <NA>      15 519.8    2134   584.7       126     NA     NA
    ## 17   <NA>      16 532.7     245   566.0        25     NA     NA
    ## 18   <NA>      17 576.1     137   613.4        49     NA     NA
    ## 19   <NA>      18 526.9     659   563.2        57     NA     NA
    ## 20   <NA>      19 542.0     318   598.0       113     NA     NA
    ## 21   <NA>      20 561.8     143   629.2        15     NA     NA
    ## 22   <NA>      21 522.6     398   588.7        46     NA     NA
    ## 23   <NA>      22 548.1     194   594.4        99     NA     NA
    ## 24   <NA>      23 542.3     183   579.9        40     NA     NA
    ## 25   <NA>      24 539.2     342   581.5        52     NA     NA
    ## 26   <NA>      25 525.7    1219   582.2       103     NA     NA
    ## 27   <NA>      26 525.3     113   625.8        11     NA     NA
    ## 28   <NA>      27 516.2     804   589.4        35     NA     NA
    ## 29   <NA>      28 482.3      15   524.2         5     NA     NA
    ## 30   <NA>      29 526.9     348   551.2        12     NA     NA
    ## 31   <NA>      30 526.4    1195   588.0       145     NA     NA
    ## 32   <NA>      31 545.3     822   603.0       147     NA     NA
    ## 33   <NA>      32 528.4       7   528.0        27     NA     NA
    ## 34   <NA>      33 510.4     659   552.1        47     NA     NA
    ## 35    MEX Overall 423.0   34090   429.5      4044  3.057  10.04
    ## 36   <NA>       1 485.4      13   516.5        83     NA     NA
    ## 37   <NA>       2 447.7      89   491.5       145     NA     NA
    ## 38   <NA>       3 475.4     178   494.1       151     NA     NA
    ## 39   <NA>       4 415.7     154   418.0        14     NA     NA
    ## 40   <NA>       5 438.1     484   453.9       127     NA     NA
    ## 41   <NA>       6 431.0     635   452.5        58     NA     NA
    ## 42   <NA>       7 486.7     293   496.5       247     NA     NA
    ## 43   <NA>       8 461.4     871   483.2       431     NA     NA
    ## 44   <NA>       9 466.7     110   472.4         6     NA     NA
    ## 45   <NA>      10 449.7     121   460.6        16     NA     NA
    ## 46   <NA>      11 470.4     696   481.5       285     NA     NA
    ## 47   <NA>      12 442.8     112   474.1        16     NA     NA
    ## 48   <NA>      13 413.1     943   405.4        33     NA     NA
    ## 49   <NA>      14 429.0    1484   431.6       138     NA     NA
    ## 50   <NA>      15 459.7     619   472.4        99     NA     NA
    ## 51   <NA>      16 437.9     898   445.4        78     NA     NA
    ## 52   <NA>      17 461.2     262   460.5        34     NA     NA
    ## 53   <NA>      18 454.9     367   460.1       113     NA     NA
    ## 54   <NA>      19 445.0     454   433.8        53     NA     NA
    ## 55   <NA>      20 445.8     367   458.0        69     NA     NA
    ## 56   <NA>      21 457.1     217   461.8        76     NA     NA
    ## 57   <NA>      22 452.4     150   477.2        93     NA     NA
    ## 58   <NA>      23 459.6     547   475.5       186     NA     NA
    ## 59   <NA>      24 437.3     130   476.9        10     NA     NA
    ## 60   <NA>      25 441.8     159   475.6        80     NA     NA
    ## 61   <NA>      26 427.8    1040   436.7       167     NA     NA
    ## 62   <NA>      27 434.9    1175   436.4       146     NA     NA
    ## 63   <NA>      28 429.0     406   442.0        45     NA     NA
    ## 64   <NA>      29 428.1    1963   424.4        80     NA     NA
    ## 65   <NA>      30 426.6     787   436.0        61     NA     NA
    ## 66   <NA>      31 427.7     645   426.3        48     NA     NA
    ## 67   <NA>      32 409.2    4314   400.6       231     NA     NA
    ## 68   <NA>      33 437.7     279   442.2        28     NA     NA
    ## 69   <NA>      34 426.4    1013   423.5        34     NA     NA
    ## 70   <NA>      35 427.4    2364   419.9        63     NA     NA
    ## 71   <NA>      36 400.4     234   408.3        18     NA     NA
    ## 72   <NA>      37 397.2    3632   406.5       107     NA     NA
    ## 73   <NA>      38 411.7    2434   424.6        25     NA     NA
    ## 74   <NA>      39 431.5     342   448.7        15     NA     NA
    ## 75   <NA>      40 348.5    1959   362.4         7     NA     NA
    ## 76   <NA>      41 346.2    1004   381.2        15     NA     NA
    ## 77   <NA>      42 487.5     146   510.3       313     NA     NA
    ## 78    USA Overall 484.8    4888   505.2       345  8.756  32.04
    ## 79   <NA>       1 475.0    1219   479.2        50     NA     NA
    ## 80   <NA>       2 447.6    1323   490.4        16     NA     NA
    ## 81   <NA>       3 487.6     462   501.7        34     NA     NA
    ## 82   <NA>       4 506.8     263   528.2        42     NA     NA
    ## 83   <NA>       5 502.9     335   511.9        42     NA     NA
    ## 84   <NA>       6 476.7     526   519.6        21     NA     NA
    ## 85   <NA>       7 558.6     278   565.5        80     NA     NA
    ## 86   <NA>       8 541.0     207   560.4        41     NA     NA
    ## 87   <NA>       9 528.7     259   511.0        14     NA     NA
    ## 88   <NA>      10 460.7      16   522.3         5     NA     NA

 
#### Multilevel PSA Assessment Plot
 

    plot(results.psa.math)

![plot of chunk pisapsaplot](/images/figure/pisapsaplot.png) 

 
#### Multilevel Difference Plot
 

    mlpsa.difference.plot(results.psa.math, sd = mean(student.party$mathscore, na.rm = TRUE))

![plot of chunk diffplot](/images/figure/diffplot.png) 

 
 

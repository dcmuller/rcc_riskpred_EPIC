## Functions to make RCC predictions based on the EPIC model
## Copyright David C Muller (david.muller@imperial.ac.uk)
## License: BSD-3

## function to return restricted cubic spline basis
rcs <- function(x, knts) {
  basis <- matrix(NA, nrow=length(x), ncol=(length(knts)-1))
  knts <- knts[order(knts)]
  basis[,1] <- x
  for (i in 2:(length(knts)-1)) {
    lambda <- (knts[length(knts)] - knts[i])/(knts[length(knts)]-knts[1])
    basis[, i] <- (x>knts[i])*((x-knts[i])^3) - 
                  lambda*(x>knts[1])*((x-knts[1])^3) -
                  (1-lambda)*(x>knts[length(knts)])*((x-knts[length(knts)])^3)
  }
  return(basis)
}


rcc_predict <- function(data="./input.csv", output="./output.csv") {
  ### Parameters
  ## age knots
  aknots <- c(40,50,60,70)
  
  ## time knots
  tknots <- log(c(0.05,9,15))
  
  ## regression coefficients
  coef <- c(5.238609e-02,-2.414945e-04,2.936269e-04,-7.087171e-01,
            4.102400e-02,5.345680e-02,4.068892e-01,2.495118e-01,
            4.066296e-03,1.169615e-02,7.825005e-01,-7.716967e-02,-1.460443e+01)
  names(coef) <- c("age_rcs1","age_rcs2","age_rcs3","sexFemale", "bmi",
                   "smoke_statFormer","smoke_statCurrent","hypertensionYes",
                   "systolic","diastolic","t_rcs1","t_rcs2","(Intercept)")
  req_vars <- c("age", "sex", "bmi", "smoke_stat", "hypertension",
                "systolic", "diastolic", "t")
  
  preddat <- read.csv(data)
  for (i in 1:length(req_vars)) {
    if (!(req_vars[i] %in% colnames(preddat))) {
      stop("Variable '", req_vars[i], "' is required")
    }
  }
  
  preddat$sex <- factor(preddat$sex, levels=c("Male", "Female"))
  preddat$smoke_stat <- factor(preddat$smoke_stat, levels=c("Never", "Former", "Current"))
  preddat$hypertension <- factor(preddat$hypertension, levels=c("No", "Yes"))
  
  age_rcs <- rcs(preddat[, "age"], aknots)
  colnames(age_rcs) <- paste0("age_rcs", seq(1,ncol(age_rcs),by=1))
  t_rcs <- rcs(log(preddat[, "t"]), tknots)
  colnames(t_rcs) <- paste0("t_rcs", seq(1,ncol(t_rcs),by=1))
  
  preddat <- cbind(preddat, age_rcs, t_rcs)
  predmat <- model.matrix(~ ., data=preddat)
  predmat <- predmat[, names(coef)]
  pr <- as.vector(1-exp(-exp(predmat %*% coef)))
  preddat[, "Pr"] <- pr
  write.csv(preddat, file=output, row.names=FALSE)
}

# Predicted risk of renal cell carcinoma (RCC) based on the EPIC risk prediction model
This repository provides R functions to calculate the predicted risk of
renal cell carcinoma (RCC) based on supplied information and the EPIC risk
prediction model.

## How to use this code
You will need to have the R statistical computing environment installed. To get started,
download this repository, open an R session, and change the working directory to the downloaded
repository. Typing `source("rcc_predict.R")` will make the function `predict_rcc` available
in your R session. If you then type:
```
predict_rcc()
```
the predicted probability of RCC will be calculated and saved. By default this will
take covariate information from the file 'input.csv', calculate the probability of RCC 
for each record therein and save the results in the file 'output.csv'. These default input and ouptut
files can be changed by specifying them as arguments to `predict_rcc`:
```
predict_rcc(data="my_input_file.csv", output="my_output_file.csv")
```

## Input specification
The input file must be an ASCII plain text CSV file, and must contain
the following variables:

variable name | description | type | valid values
--------------|:------------|:-----|:-------------
age | age in years | real | [40,70]
sex | sex of the participant | character | Female, Male
bmi | Body Mass Index (kg/m^2) | real | 
smoke\_stat | smoking status | character | Never, Former, Current
hypertension | Ever been diagnosed with hypertension | character | No, Yes
systolic | Systolic blood pressure (mm Hg) | real |
diastolic | Diastolic blood pressure (mm Hg) | real |
t | Time horizon for the predicted probabilities (years) | [0,10]


Other variables can be included in the input file, but they are
ignored by the program.

## Output file
The output file contains the same variables as the input file, with
the addition of the variable 'Pr' which contains the predicted
probability over the given time horizon for each input observation.

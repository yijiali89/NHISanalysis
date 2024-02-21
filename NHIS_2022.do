clear
use "Path\to\your\preprocessed\data file\NIHS 2021.dta", clear

*Please note some variables have different names between 2021 and 2022 surveys.

*Generate variable to reflect IS diagnosis including health condition or immunosuppressant use
generate isdx=0
replace isdx=1 if medrxtrt_a==1
replace isdx=1 if hlthcond_a ==1

*Generate variable to reflect blood cancer diagnoses, to include those who had diagnoses coded as Blood cancer, Leukemia and Lymphoma within 2 years from the survey
generate bloodca_age= agep_a-bloodagetc_a
generate leuk_age=agep_a-leukeagetc_a
generate lymphoma_age=agep_a-lymphagetc_a

generate bldis=0
replace bldis=1 if bloodca_age<=2 & bloodca_age>=0 & bloodcan_a==1
replace bldis=1 if leuk_age<=2 & leuk_age>=0 & leukecan_a==1
replace bldis=1 if lymphoma_age<=2 & lymphoma_age>=0 & lymphcan_a==1

*Generate IS variable to account for both isdx and bldis variables
generate is=0
replace is=1 if isdx==1 | bldis==1

*Set up survy data design, code from CDC file https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2022/srvydesc-508.pdf
svyset [pweight=wtfa_a], strata(pstrat) psu(ppsu)

*Proportion of IS
svy: proportion is

*Proportion of COVID vaccination
svy: proportion shtcvd191_a, over(is)

*Mean number of COVID vaccines
svy: mean shtcvd19nm_a if shtcvd19nm_a<=4, over(is)

*Ever had COVID-19
generate covid=0
replace covid=1 if cvddiag_a==1|postest_a==1
svy: proportion covid, over(is)

*Long COVID-19
svy: proportion longcvd_a, over(is)

*Ever had flu vaccines in past 12mo
svy: proportion shtflu12m_a, over(is)

*Ever had pneumococcal vaccines
svy: proportion shtpnuev_a, over(is)


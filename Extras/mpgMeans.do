// ==========================================================================

// Week 07 Repeated Random Samples Demo

// ==========================================================================

// standard opening options

version 14
log close _all
graph drop _all
clear all
set more off
set linesize 80

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// change directory

if "`c(os)'" == "MacOSX" {
  cd "/Users/`c(username)'/Desktop"
}
else if "`c(os)'" == "Windows" {
  cd "E:/Users/`c(username)'/Desktop"
}

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// check to see if appropriate directories exist

global projName "mpgMeans"
capture mkdir $projName

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// log process

log using "$projName/$projName.txt", text replace

// ==========================================================================

/*
file name - mpgMeans.do

research project name - SOC5050: Quantitative Analysis, Fall 2016

purpose - Illustrate the Central Limit Theorem

created - 03 Oct 2016

updated - 03 Oct 2016

author - CHRIS
*/

// ==========================================================================

/*
full description -
This do-file draws repeated random samples from the auto.dta dataset.
The mean of the variable mpg is calculated from a sample of n=40 and stored
in a new dataset. This is repeated k=5000 times.
*/

/*
updates -
none
*/

// ==========================================================================

/*
superordinates  -
none
*/

/*
subordinates -
none
*/

// ==========================================================================
// ==========================================================================
// ==========================================================================

// create variables for storing sample data
generate id = .
generate mpgMeans = .

// save empty sample dataset
save mpgMeans.dta, replace

// run loop that generates the k=5000 samples
forvalues i = 1/5000 {
	sysuse auto.dta, clear

	sample 54 // generates samples of n=40

	summarize mpg
	local mpg = r(mean) // save mean

	use mpgMeans.dta, clear

	local new = _N + 1
  set obs `new' // add new observation

	replace id = `i' in `new' // add value for id
	replace mpgMean = `mpg' in `new' // add value for mean

	save mpgMeans.dta, replace
}

// generate histogram
histogram mpgMeans, frequency fcolor("97 100 167") ///
	normal normopts(lcolor("167 97 100") lwidth(medthick)) ///
	scheme(s1mono) ///
	graphregion(color("235 235 235")) ///
	plotregion(color("255 255 255")) ///
	bgcolor("235 235 235") ///
	title("Distribution of Sample Means for Miles per Gallon") ///
	subtitle("{it:k}=5000 random samples of {it:n}=40 from {stMono:auto.dta}") ///
	ylabel(0(100)400, grid) ///
	xtitle("Mean")

// save histogram
graph export "$projName/mpgMeans.png", width(1000) height(750) replace

// ==========================================================================
// ==========================================================================
// ==========================================================================

// save altered data

save "$projName/mpgMeans.dta", replace

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// copy code to code archive

copy "mpgMeans.do" "$projName/mpgMeans.do", replace

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// standard closing options

log close _all
graph drop _all
set more on

// ==========================================================================

exit

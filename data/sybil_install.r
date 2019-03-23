## Default repo
local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.r-project.org" 
       options(repos=r)
})
chooseCRANmirror(graphics=False, ind=1)

check_install <- function(package_name) {
	package_availbility=requireNamespace(package_name, quietly = TRUE)
	cat('Package ', package_name, ' is installed? ', package_availbility,'\n')
	if (!package_availbility) {
		print('installing...')
		install.packages( package_name)
		library(package_name, character.only = TRUE)
	}
}

bioconductor_install <- function(package_name_exact) {
	package_name = paste("^", package_name_exact,"$", sep="")
	package_consult = BiocManager::available(package_name, include_installed = FALSE)
	package_installed = length(package_consult) == 0
	cat('Package ', package_name_exact, ' is installed? ', package_installed,'\n')
	if (!package_installed) {
		print('installing...')
		BiocManager::install(package_name_exact, ask = FALSE)
	}
}

install_exp2flux <- function() {
	package_name="exp2flux"
	package_availbility=requireNamespace(package_name, quietly = TRUE)
	cat('Package ', package_name, ' is installed? ', package_availbility,'\n')
	if (!package_availbility) {
		print('installing...')
		devtools::install_git("git://github.com/cran/exp2flux.git", upgrade = "always")
		library(package_name, character.only = TRUE)
	}
}

install_sybilSBML <- function() {
	package_name="sybilSBML"
	package_availbility=requireNamespace(package_name, quietly = TRUE)
	cat('Package ', package_name, ' is installed? ', package_availbility,'\n')
	if (!package_availbility) {
		print('installing...')
		devtools::install_url("https://cran.r-project.org/src/contrib/Archive/sybilSBML/sybilSBML_3.0.1.tar.gz", upgrade = "always")
		library(package_name, character.only = TRUE)
	}
}

check_install('glpkAPI')
check_install('sybil')
check_install('rjson')
check_install('curl')
check_install('httr')
check_install('devtools')
check_install('BiocManager')
bioconductor_install('Biobase')
bioconductor_install('gage')
install_exp2flux()
install_sybilSBML()
print('Sybil libraries installed!')

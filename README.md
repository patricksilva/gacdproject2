# gacdproject2
Repository for Coursera Getting and Cleaning Data, Course Project 2

run_analisys.R

To run this program, you must source the file in R Studio, or the standard R environment, then use the run() command documented below.
It is also advised that all files should be extracted to the working directory. The code assumes that the working directory is the directory
structure as presented in the zip file.

This project is centered around the run_analysis.R file. It contains two helper functions and a single main function.

downloadData(): This function downloads to the current working directory a single zip file as prescribed in the course assignment text.

loadData(): 	Once the zip file from downloadData has been extracted, this function is used simply to wrap a call to read.table. While
				in this context, it likely appears somewhat short and silly, ideally such a function would have additional error 
				handling not used for this assignment.

run():			The main body of the code. The function loads the various files through calls to loadData. It then parses the information
				and creates the required "tidy data set".

# Other oddities

I have been endeavoring to use better encapsilation more akin to Python as I familiarize myself with the language. As such, you will
see that all of the variables have been embedded in a module level environment variable, pkg.env. Again, in this assignment
this is overkill, and likely more confusing. With larger bodies of code it is intended to used to reduce parameter blow outs, where 
functions require ever greater numbers of parameters. This is still not fully _safe_ as the pkg.env variable can be accessed from
the global namespace. I will continue to look for other alternatives.


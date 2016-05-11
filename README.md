# ESP: A Statistical Approach to Estimating Application Interference

Code
The main code is in code\Matlab

Data
The data can be downloaded from https://www.dropbox.com/sh/m52uif7p5gn9wn3/AADqJCCpUtmVjjy4wsd3SSSea?dl=0
The path to the data should be put in the function ESP/Code/Matlab/tmp_path.m

Notes on the Code:

1. Algorithm 1: ESP
	See function glmnet_new.m

2. Algorithm 2: Iterative Scheduling Algorithm:
	See functions schedule_cover_controller.m and singlenode_schedule.m
	Example run:  
	a) [ Output ] = singlenode_schedule(); % Function would run with default options.
			
	b) [ Output ] = parallel_schedule_combb('k',k+1,'Nproc',i+1,'N',15,'Nqueue',40,'display',0);
	Options: k 	    - Maximum number of applications that can be scheduled together.
			 N      - Number of runs of the algorithm
			 display- 0 to hide display, 1 to print output.

3. Algorithm 3: Multi-node Iterative Scheduling Algorithm
	See function: schedule_cover_controller.m and parallel_schedule_combb.m

	Example run: 
	a) [ Output ] = parallel_schedule_combb(); % Function would run with default options.

	b) [ Output ] = parallel_schedule_combb('k',k+1,'Nproc',i+1,'N',15,'Nqueue',40,'display',0);
	Options: k 	    - Maximum number of applications that can be scheduled together.
			 Nproc  - Number of processors
			 N      - Number of runs of the algorithm
			 Nqueue - Number of jobs in the queue
			 display- 0 to hide display, 1 to print output.

   

#!/usr/bin/env zsh
### Example SLURM script
### It executes all commands given in the file 'cmdline_jobs.txt' in parallel and writes the output in the directory 'output'.
### All necessary configuration (timeout, memout) is set in this file and can be modified.
### The jobs can be scheduled with 'sbatch bench_cmdline_args.sh'

### Project name. Required to actually use *our* cluster
#SBATCH -A moves

### Job name
#SBATCH --job-name=benchmarks

### Array job
### The upper bound should be the number of lines in the job script (i.e., the number of commands to run)
#SBATCH --array=1-40

### Output file name. Zero-pad task id with 4
#SBATCH -o /home/%u/output/ppta_mon_aodv%x.job%A_task%4a.out

### Timelimit in hours:minutes:seconds
#SBATCH -t 2:00:00

### Number of available threads
#SBATCH --cpus-per-task=1

### Memory per thread in Megabytes. Total amount of available memory is --cpus-per-task * --mem-per-cpu
#SBATCH --mem-per-cpu=32G
### Receive all kinds of email notifications
# // #SBATCH --mail-type=ALL
# // #SBATCH --mail-user=your.name@cs.rwth-aachen.de


### Load the module system configuration, necessary to load dependent libraries
source $HOME/hpc-scripts/prepareEnvironmentGcc.sh 

### Change Directory to your working directory (binaries, etc)
WORKDIR=$HOME/test_python
cd $WORKDIR

### Horizontal line for better distinction of tool output
HLINE="===================================================================================================="

### Find the correct line according to the task id
cur=$SLURM_ARRAY_TASK_ID
### Jobs are in a text file where each line contains one cmdline call
cmd=$(time sed -n "${cur}p" < $HOME/hpc-scripts/examples/cmdline_jobs_ppta_mon_aodv.txt)
### Print command
echo "Executing $cmd"
start=`date +"%s%3N"`

### Exececute the call
echo $HLINE
### Ulimit:
###  -c 0: No core dumps (important!)
###  -v N: Limit to N kilobytes of memory
###  -t N: Limit of CPU time for this subprocess
ulimit -c 0 && ulimit -S -v $MEMOUT && ulimit -S -t $TIMEOUT && eval time $cmd ; rc=$?
echo $HLINE

### Print time and exitcode
end=`date +"%s%3N"`
echo "time: $(( end - start ))ms"
echo "exitcode: $rc"


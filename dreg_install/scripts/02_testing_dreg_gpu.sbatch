#!/bin/bash 

#SBATCH --job-name=dreg_example_gpu_run # Job name
#SBATCH --mail-type=FAIL,END # Mail events (NONE, BEGIN, END, FAIL, ALL)

#SBATCH --mail-user=rutendo.sigauke@colorado.edu

#SBATCH --ntasks=4
#SBATCH --nodes=1

#SBATCH --time=04:00:00 # Time limit
#SBATCH --partition=nvidia-a100
#SBATCH --gres=gpu:1

#SBATCH --mem=70gb # Memory ##whats the limit in memory required

#SBATCH --output=/scratch/Users/rusi2317/projects/bidir_detection/e_and_o/%x_%j.out              
#SBATCH --error=/scratch/Users/rusi2317/projects/bidir_detection/e_and_o/%x_%j.err   


#Load modules
module load R/4.4.0
module load samtools/1.10

##working directory
WD=/Users/rusi2317/bin/dREG_R440/dREG

##Define paths

DATADIR=/scratch/Users/rusi2317/projects/bidir_detection/dreg_install_test/data
OUTDIR=/scratch/Users/rusi2317/projects/bidir_detection/dreg_install_test/out

##first copy example bigwig files to scratch
cp ${WD}/example/*.bw ${DATADIR}/

##run dREG
bash ${WD}/run_dREG.bsh ${DATADIR}/K562.chr21.plus.bw ${DATADIR}/K562.chr21.minus.bw ${OUTDIR}/k562.test ${WD}/asvm.gdm.6.6M.20170828.rdata 4 1

##delete the copied bigwig files
rm ${DATADIR}/*.bw

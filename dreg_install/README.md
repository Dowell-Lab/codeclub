# Installing dREG on Fiji

Authors: Rutendo F. Sigauke (Add your name if you edit)

dREG GitHub Repository: https://github.com/Danko-Lab/dREG

## Dependencies
Check each of the tools for installation instructions. For examples, refer to the “Detailed notes from Rutendo’s installations” section. 

- bedops (http://bedops.readthedocs.org/en/latest/index.html)
- R (http://www.r-project.org/)
- bigWig R package (https://github.com/andrelmartins/bigWig)
- Rgtsvm (https://github.com/Danko-Lab/Rgtsvm) 
  Also has the following dependencies (see the configuration notes below):
  - CUDA library (https://developer.nvidia.com/cuda-toolkit-archive).
  - Boost library (http://www.boost.org/users/download/)
  - Extra R Packages (need to be installed before installing Rgtsvm): bit64, snow, SparseM, Matrix


## Configuring Rgtsvm on the GPU (nvidia-a100)
For the Rgtsvm installation, you must run an interactive job to configure with CUDA and boost.
- CUDA is only installed on the GPUs (there are different versions): /usr/local/cuda-XX.X.
- Boost can be module loaded on fiji (path is /opt/boost/1.86.0)
Note: Rutendo had to install a different boost. Here are instructions to install Boost without root (Takes ~5-10 minutes):

[Link to Boost install instructions](https://masumhabib.com/blog/how-to-install-the-boost-library-with-mpi-and-without-root-access/)

a. Get the latest version of Boost from here: https://www.boost.org/users/download/

`wget https://archives.boost.io/release/1.86.0/source/boost_1_86_0.tar.gz`

b. Unpack the tar zipped file

`tar -xvf boost_1_86_0.tar.gz`

c. Before configuring, boost first test the help command and list of libraries 

`./bootstrap.sh --help`

`./bootstrap.sh --show-libraries`

This will show libraries that will need to be built separately

d. Install Boost in home directory, use the --prefix option for bootstrap.sh, and disable libraries using the --without-libraries option.

`./bootstrap.sh --prefix=/Users/rusi2317/bin/boost_1_86_0 --without-libraries=`

e. Make and install the program. 

`./b2 install | tee install.log`

When done, there should be an`include` folder and a `lib` folder.

- Once dREG plus all the dependencies are installed, we can now configure the Rgtsvm package on the GPU 

a. Run an interactive job 

`srun --pty --gres=gpu:1 --mem=8gb --ntasks=4 --nodes=1 --partition=nvidia-a100 --job-name=R --time=04:00:00 bash`

b. Configure Rgtsvm with the installed CUDA and Boost installs 

`R CMD INSTALL --configure-args="--with-cuda-arch=sm_80 --with-cuda-home=/usr/local/cuda-12.0 --with-boost-home=/Users/rusi2317/bin/boost_1_86_0" Rgtsvm`

If you have issues at this step, you may try including a path to your R libraries.

`R CMD INSTALL --configure-args="--with-cuda-arch=sm_80 --with-cuda-home=/usr/local/cuda-12.0 --with-boost-home=/Users/rusi2317/bin/boost_1_86_0" --library=/Users/rusi2317/R/x86_64-redhat-linux-gnu-library/4.4 Rgtsvm`

## Detailed notes from Rutendo’s installations

This is how dREG and the different dependencies were installed. Both the dREG and Rgtsvm packages have an `R_dependencies` command that will try and install all the R dependencies. However, not all packages were successfully installed in my case, so I had to install them manually. In general, for R packages, if CRAN does not behave they were installed from source (e.g. rphast) or GitHub (e.g. bigWig). 

1. Module load to the latest version of R

`module load R/4.4.0`

2. Install dREG and all the package dependencies (Takes ~30-40 minutes)

a. Install dREG. Clone the repository and install dREG in R (cloned on 08/20/2024).

`git clone https://github.com/Danko-Lab/dREG.git`

b. Move into the dREG folder that has been just cloned, and run the following command to install the following dependencies. 

`cd dREG`

`make R_dependencies`

NOTE: I got the following warning “make: warning:  Clock skew detected.  Your build may be incomplete.” However, I was able to load the library in R.

c. Now, install dREG by running

`make dreg`
 
NOTE: The following package rphast did not install, so manually installing it.

d. Installing rphast using devtools following instructions from their GitHub page. https://github.com/CshlSiepelLab/RPHAST

`devtools::install_github("CshlSiepelLab/RPHAST")`

e. Try and install dREG again. It worked for me this time!

`make dreg`

f. Download the dREG model Rdata file. Downloaded this in the dREG folder. 

`wget https://dreg.dnasequence.org/themes/dreg/assets/file/asvm.gdm.6.6M.20170828.rdata`

3. Install the Rgtsvm package in R and configure it on the GPU. This will allow faster processing times on the GPU. https://github.com/Danko-Lab/Rgtsvm

a. Before installing, make sure all the R dependencies are installed for Rgtsvm (i.e. bit64, snow, SparseM, and Matrix). At this point, the other packages had been installed and I only had to install SparseM.

`install.packages("SparseM")`

b. Double-check the CUDA arch is matched when configuring Rgtsvm (see https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/)
We are configuring dREG on the NVIDIA A100 GPUs so we want to select the appropriate arch SM80 or SM_80 with CUDA 11.1 and later.

c. First, log into a GPU node interactively.

`srun --pty --gres=gpu:1 --mem=8gb --ntasks=4 --nodes=1 --partition=nvidia-a100 --job-name=R --time=04:00:00 bash`

d. Second, check for the versions of CUDA and Boost installed on the GPU and get the path to the latest version of the installation.

`/usr/local/cuda-12.0`

`/opt/boost/1.86.0` (or location of you installed Boost)

e. Now, reload R and continue with the Rgtsvm install (since we have logged into the GPU server). Here, the package was cloned in my bin folder. 

```
module load R/4.4.0

git clone https://github.com/Danko-Lab/Rgtsvm.git

cd Rgtsvm

make R_dependencies
```

f. Configure CUDA and Boost. 

`R CMD INSTALL --configure-args="--with-cuda-arch=sm_80 --with-cuda-home=/usr/local/cuda-12.0 --with-boost-home=/Users/rusi2317/bin/boost_1_86_0" Rgtsvm`

NOTE: When configured correctly, you should get the * DONE (Rgtsvm) message (shown in the screenshot below).

4. Install bedops based on their instructions (I installed v2.4.39 when I made the initial configuration. The latest release is v2.4.41, and it can be found in part (ii) below). https://bedops.readthedocs.io/en/latest/content/installation.html#linux

https://github.com/bedops/bedops/releases/download/v2.4.39/bedops_linux_x86_64-v2.4.39.tar.bz2
https://github.com/bedops/bedops/releases

5. Testing the installation

a. Load dREG in R and check what libraries are also loaded

Check the session information by running the following command in R

`sessionInfo()`

b. Example run on the GPU cluster

Unfortunately, there is an R 4> bug that has not been fixed: https://github.com/Danko-Lab/dREG/issues/15

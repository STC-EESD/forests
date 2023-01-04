#!/bin/bash

currentDIR=`pwd`
   codeDIR=${currentDIR}/code
 outputDIR=${currentDIR//github/gittmp}/output

parentDIR=`dirname ${currentDIR}`
  dataDIR=${parentDIR}/000-data

if [ ! -d ${outputDIR} ]; then
    mkdir -p ${outputDIR}
fi

cp -r ${codeDIR} ${outputDIR}
cp    $0         ${outputDIR}/code

########################################################
source ${HOME}/.gee_environment_variables
if [[ "${OSTYPE}" =~ .*"linux".* ]]; then
  # cp ${HOME}/.gee_environment_variables ${outputDIR}/code/gee_environment_variables.txt
  pythonBinDIR=${GEE_ENV_DIR}/bin
else
  pythonBinDIR=`which python`
  pythonBinDIR=${pythonBinDIR//\/python/}
fi

########################################################
googleDriveFolder=earthengine/ken

########################################################
myPythonScript=${codeDIR}/main.py
stdoutFile=${outputDIR}/stdout.py.`basename ${myPythonScript} .py`
stderrFile=${outputDIR}/stderr.py.`basename ${myPythonScript} .py`
${pythonBinDIR}/python ${myPythonScript} ${dataDIR} ${codeDIR} ${outputDIR} ${googleDriveFolder} > ${stdoutFile} 2> ${stderrFile}
sleep 300

##################################################
myRscript=${codeDIR}/main-download.R
stdoutFile=${outputDIR}/stdout.R.`basename ${myRscript} .R`
stderrFile=${outputDIR}/stderr.R.`basename ${myRscript} .R`
R --no-save --args ${dataDIR} ${codeDIR} ${outputDIR} ${googleDriveFolder} < ${myRscript} > ${stdoutFile} 2> ${stderrFile}
sleep 60

##################################################
myRscript=${codeDIR}/main-analyze.R
stdoutFile=${outputDIR}/stdout.R.`basename ${myRscript} .R`
stderrFile=${outputDIR}/stderr.R.`basename ${myRscript} .R`
R --no-save --args ${dataDIR} ${codeDIR} ${outputDIR} ${googleDriveFolder} < ${myRscript} > ${stdoutFile} 2> ${stderrFile}

##################################################
exit

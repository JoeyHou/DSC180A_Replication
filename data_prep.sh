#!/bin/bash

# Note: 
# This is a simplied version for DSC180A Checkpoint #1. 
# As a shortened version from auto_phrase.sh, this script only prepares data needed to auto phrase training.
# -- Joey 10/29/2020
# Reference: shangjingbo1226/AutoPhrase (https://github.com/shangjingbo1226/AutoPhrase/blob/master/auto_phrase.sh)

# The comment below are directly from AutoPhrase repo. 
# DATA_DIR is the default directory for reading data files.  Because this directory contains not only the default
# dataset, but also language-specific files and "BAD_POS_TAGS.TXT", in most cases it's a bad idea to change it.
# However, when this script is run from a Docker container, it's perfectly fine for the user to mount an external
# directory called "data" and read the corpus from there, since the directory holding the language-specific files
# and "BAD_POS_TAGS.txt" will have been renamed to "default_data".
if [ -d "default_data" ]; then
    DATA_DIR=${DATA_DIR:- default_data}
else
    DATA_DIR=${DATA_DIR:- data}

fi
# MODEL is the directory in which the resulting model will be saved.
if [ -d "models" ]; then
    MODELS_DIR=${MODELS_DIR:- models}
else
    MODELS_DIR=${MODELS_DIR:- default_models}
fi
MODEL=${MODEL:- ${MODELS_DIR}/DBLP}
# RAW_TRAIN is the input of AutoPhrase, where each line is a single document.
DEFAULT_TRAIN=${DATA_DIR}/EN/DBLP.txt
RAW_TRAIN=${RAW_TRAIN:- $DEFAULT_TRAIN}

green=`tput setaf 2`
reset=`tput sgr0`

mkdir -p tmp
mkdir -p ${MODEL}

if [ $RAW_TRAIN == $DEFAULT_TRAIN ] && [ ! -e $DEFAULT_TRAIN ]; then
    echo ${green}===Downloading Toy Dataset===${reset}
    curl http://dmserv2.cs.illinois.edu/data/DBLP.txt.gz --output ${DEFAULT_TRAIN}.gz
    gzip -d ${DEFAULT_TRAIN}.gz -f
fi
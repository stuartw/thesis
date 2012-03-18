#!/bin/bash

if [ $# -gt 1 ] || [ "$1" = "-h" ]; then
  echo "Usage `basename $0` [clean | -h]"
  exit 1
fi



if [ "$1" = "clean" ]; then
 rm -f thesis.aux thesis.log thesis.pdf thesis.toc thesis.bbl thesis.blg thesis.dvi thesis.out
else
  TOP=/usr/users/stuartw/thesis
  export TEXINPUTS=.:$TOP:$TOP/tex:$TOP/fig::
  export TEXPSHEADERS=$TEXPSHEADERS:$TEXINPUTS
  export BIBINPUTS=.:$TOP:$TOP/bib::

  rm -f thesis.aux thesis.log thesis.pdf thesis.toc thesis.bbl thesis.blg thesis.dvi thesis.out 

  if [ "$1" = "bib" ]; then
    echo "===> get bibtex file"
    BIBFILE=$TOP/bib/swakefield.bib
    rm -f ${BIBFILE}
    wget http://citeulike.org/bibtex/user/swakefield -O $BIBFILE
  fi

  if [ $? -ne 0 ]; then
    echo "===> Unable to wget bibtex file"
    exit 1
  fi

  echo "===> 1st Latex pass"
  pdflatex -interaction=nonstopmode thesis #| egrep -i -C 2 "/Missing|Warning|Error|Fatal|Undefined|runaway|pdftex Warning|Float|float|Font Warning|weird|multiply/"
  #if [ $? -ne 1 ]; then
  #  echo "===> ERROR"
  # exit 1
  #fi

  echo "===> Bibtex pass"
  bibtex thesis #| egrep -i -C 2 "/Missing character|Warning:|Error:|Fatal|Undefined|runaway|pdftex Warning|Float|float|Font Warning|weird|multiply/"
  #if [ $? -ne 1 ]; then
  #  echo "===> ERROR"
  #  exit 1
  #fi

  echo "===> 2nd Latex pass"
  pdflatex -interaction=batchmode thesis #| egrep -i "/Missing character|Warning:|Error:|Fatal|Undefined|runaway|pdftex Warning|Float|float|Font Warning|weird|multiply/"
  #if [ $? -ne 1 ]; then
  #  echo "===> ERROR"
  # exit 1
  #fi

  echo "===> 3rd Latex pass"
  pdflatex -interaction=nonstopmode thesis #| egrep -i "/Missing character|Warning:|Error:|Fatal|Undefined|runaway|pdftex Warning|Float|float|Font Warning|weird|multiply/"

  #if [ $? -eq 0 ]; then  
    kpdf thesis.pdf
  #else
  # echo "===> ERROR"
  # exit 1
  #fi
fi



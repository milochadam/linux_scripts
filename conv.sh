#!/bin/bash
NUMBER=$(ls -l | grep -v ^d | grep -v ^t | grep ".pdf" | wc -l )
echo "" #newline
i=0
for pdffile in ./*.pdf; do
    i=$((i+1))
    PERCENT=$(($i*100/$NUMBER))
    echo -ne "\rProcessing $pdffile... $i/$NUMBER ($PERCENT%)"
    convert -density 300 "$pdffile" -quality 90 "$(basename "$pdffile" .pdf).png"
done
echo -e "\ndone."

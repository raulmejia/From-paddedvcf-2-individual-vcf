#!/bin/bash
#############
# Purporse: #
#############
# This script receives a padded multivcf and retrieves the selected vcf(s) from it. It also filters out the variants without genotype support (0/0, 0|0, .|., ./.) you wil get a file with the extension .00-Genotypes_deleted, and finally it filters non PASS variants (file .00-Genotypes_deleted_OnlyPASS)   

#######################################
### For the options given by the user #
#######################################
OPTIND=1 # Reset if getopts used previously

if [ -z "$1" ]
  then
    echo "No argument supplied, usage is ..."
fi

while getopts ":i:o:s:n:h" opt; do
        case "$opt" in

                i)
                        infile=$OPTARG
                        ;;
                o)
                        outdir=$OPTARG
                        ;;
                s)
                        sample=$OPTARG
                        ;;
                n)
                        user_outfile_name=$OPTARG
                        ;;
		h)
		    echo "\nUsage: Orchester.sh -i yourinputfile(paddedvcf) -o(outdir) -s(sample_to_extract) \n-i Your infile (padded vcf) ='$infile'  \n-o Your output directory ='$outdir'  \n-s sample to extract='$sample'  \n-n this is an optional parameter to choose the name of the output file, if nothing is given the default is the name of the inputfile plus the sample" >&2
		    exit 2;;

                \?)
                        echo "ERROR: Invalid option: -$OPTARG" >&2
                        exit 2;;
                :)
                       echo "ERROR: Option -$OPTARG requires an argument" >&2
                       exit 2;;
        esac
done
shift $((OPTIND-1))
echo "\nUsage: Orchester.sh -i yourinputfile(paddedvcf) -o(outdir) -s(sample_to_extract) \n-i Your infile (padded vcf) ='$infile'  \n-o Your output directory ='$outdir'  \n-s sample to extract='$sample'  \n-n this is an optional parameter to choose the name of the output file, if nothing is given the default is the name of the inputfile plus the sample"

if [ -z "$infile" ]; then
    echo "ERROR: the parameter i = path to your output file option was NOT given. Usage: Orchester.sh -i yourinputfile(paddedvcf)  -o(outdir)" >&2
    exit 2;
fi

if [ -z "$outdir" ]; then
    echo "ERROR: Missing parameter -o(outdir). Usage: Orchester.sh -i yourinputfile(paddedvcf) -o(outdir)" >&2
    exit 2;
fi
if [ -z "$sample" ]; then
    echo "ERROR: Missing parameter -s(sample). Usage: Orchester.sh -i yourinputfile(paddedvcf) -o(outdir) -s(sample_to_extract)" >&2
    exit 2;
fi

###############################
# changing or keeping default parameters
###############################
filename=$user_outfile_name # if the user gave some value

if [ -z "$user_outfile_name" ]; then
    basename_infile=$(basename $infile)
    filename=$basename_infile.$sample.vcf # default filename
fi

path_outfile=$outdir/$filename

########################
## The script begins ###
########################
mkdir -p $outdir
bcftools view -s $sample $infile > $path_outfile # extracting the selected vcfs

awk '!/0\/0/ && !/\.\/\./ && !/0\|0/ && !/\.\|\./' $path_outfile > $path_outfile.00-Genotypes_deleted # deleting all the variants absent in this sample

grep "PASS" $path_outfile.00-Genotypes_deleted > $path_outfile.00-Genotypes_deleted_OnlyPASS # keepig only the high confident variants (PASS)

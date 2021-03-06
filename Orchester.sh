#!/bin/bash
#############
# Purporse: #
#############
# This script receives a padded multivcf and retrieves the selected vcf(s) from it.

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
		    echo "Usage: Orchester.sh -i yourinputfile(paddedvcf) -o(outdir) -s(sample_to_extract) -n(user_outfile_name optional parameter)" >&2
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
echo "\n-i Your infile (padded vcf) ='$infile'  \n-o Your output directory ='$outdir'  \n-s sample to extract='$sample'  \n-n this is an optional parameter to choose the name of the output file, if nothing is given the default is the name of the inputfile plus the sample name Additionals: $@ \n"

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

####
# changing or keeping default parameters
####
filename=$user_outfile_name # if the user gave some value

if [ -z "$user_outfile_name" ]; then
    basename_infile=$(basename $infile)
    filename=$basename_infile.$sample.vcf # default filename
fi

path_outfile=$outdir/$filename



### Pseudo entries for testing
# infile=/data/Projects/Phosoholipidosis/Exome_Lipidosis/2ndDILpac_Afro_pading/Results/ApplyVSQR/ApplyVSQR_recalibrated_snps_tranche99.9_NoGaussianLimit.30YRI_1000G_3Ctrl_WW10_Daugther2ndDataSet_2ndDILpacient.bk.vcf.gz

#outdir=/data/Projects/Phosoholipidosis/Exome_Lipidosis/2ndDILpac_Afro_pading/Results/called_variants_in_individual_vcfs_extracted_from_padded_multivcfs

########################
## The script begins ###
########################

echo 
echo " path to save the result '$path_outfile' "
# echo " '$basename_infile' "
# bcftools view -s sample1,
#bcftools view -s $sample
#bcftools view -s sample1,sample2 file.vcf > filtered.vcf

# 
########################
### 

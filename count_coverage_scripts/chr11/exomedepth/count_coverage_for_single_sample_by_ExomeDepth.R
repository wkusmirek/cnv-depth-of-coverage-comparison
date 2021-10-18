# docker run --rm -it -v /tmp:/tmp -w /tmp biodatageeks/cnv-opt-exomedepthcov Rscript count_coverage_for_single_sample_by_ExomeDepth.R NA06984.chrom11.ILLUMINA.bwa.CEU.exome.20120522.bam exomedepth.bed NA06984_exomedepth.txt

library(ExomeDepth)
library(methods)

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 3) {
  stop("Invalid number of arguments!!!", call.=FALSE)
}
bamFile <- args[1]
bedFile <- args[2]
outputFile <- args[3]

system(paste('cp ', bamFile, ' bam.bam', sep=""))
system(paste('cp ', bamFile, '.bai bam.bam.bai', sep=""))

target.df <- read.delim(bedFile, header = TRUE)
colnames(target.df) <- c('chromosome','start','end')

my.counts <- getBamCounts(bed.frame = target.df,
                          bam.files = 'bam.bam',
                          include.chr = FALSE)

write.table(data.frame(my.counts$bam.bam), sep=",", col.names=F, row.names=F, quote=F,  file=outputFile)

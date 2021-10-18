# docker run --rm -it -v /tmp:/tmp -w /tmp biodatageeks/cnv-opt-exomecopycov Rscript count_coverage_for_single_sample_by_exomeCopy.R NA06984.chrom11.ILLUMINA.bwa.CEU.exome.20120522.bam exomecopy.bed NA06984 11 NA06984_exomecopy.txt

library(exomeCopy)

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 5) {
  stop("Invalid number of arguments!!!", call.=FALSE)
}
bamFile <- args[1]
bedFile <- args[2]
sample <- args[3]
chr <- args[4]
outputFile <- args[5]

target.file <- bedFile
bam.files <- c(bamFile)
sample.names <- c(sample)
target.df <- read.delim(target.file, header = FALSE)
target <- GRanges(seqname = target.df[,1], IRanges(start = target.df[,2] + 1, end = target.df[,3]))
counts <- RangedData(space = seqnames(target), ranges = ranges(target))
for (i in 1:length(bam.files)) {
  cov <- countBamInGRanges(bam.files[i], target)
}
write.table(data.frame(cov), sep=",", col.names=F, row.names=F, quote=F,  file=outputFile)


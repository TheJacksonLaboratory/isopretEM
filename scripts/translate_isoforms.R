library(seqinr)
library(Biostrings)
library(data.table)

###########################################################################
# 1) Read the GTF and FASTA file, which can be obtained from Ensembl at
# http://useast.ensembl.org/info/data/ftp/index.html/
###########################################################################

# Adjust the following path as necessary
gtf.file.path = 'Homo_sapiens.GRCh38.91.gtf'
gtf.file=fread(gtf.file.path, sep='\t', quote = '', data.table=FALSE)

# Adjust the following path as necessary
# This file is used to extract the sequences accoridng to the GTF file
# using the gffread tool in order for it to generate the protein sequence:

fasta.file='GRCh38_r91.all.fa'

###########################################################################
# 2) Extract the exon rows from the GTF file
###########################################################################
gtf.file=gtf.file[gtf.file$V3=='exon',]

###########################################################################
# 3) Extract the corresponding transcript IDs
###########################################################################
transcript.ids=gsub(';','',unlist(lapply(strsplit(as.character(gtf.file[,9]),split=' '),'[[',6)))
transcript.ids=gsub("\"",'',transcript.ids)




input=mclapply(unique(transcript.ids),function(isoform.id)
{
  tr.gtf=gtf.file[transcript.ids == isoform.id,]
  
  write.table(tr.gtf,paste0("transcript",isoform.id,".gtf"),sep='\t',col.names = FALSE,row.names = FALSE,quote = FALSE)
  
  system(paste0('gffread -y isoform_seqs/translated_',isoform.id,'.fa -g ',fasta.file," transcript",isoform.id,".gtf"))
  
  system(paste0("rm transcript",isoform.id,".gtf"))
  
},mc.cores = 32)
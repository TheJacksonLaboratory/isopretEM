# isopretEM

Isoform Interpretation by Expectation Maximization (isopretEM) is a method for infering isoform specific functions based on the relationship between sequence and functional isoform similarity. 


## Running isopretEM

The script [all_isoforms.R](https://github.com/TheJacksonLaboratory/isopretEM/blob/main/scripts/translate_all_isoforms.R) can be used for obtaining isoform amino-acid sequences. It extracts isoform coordinates from a .gtf file and calls the tool gffread to translate the genomic sequence. The variables containing the paths to the .fasta file containing the genome sequence and the .gtf file with isoform coordinates (‘fasta.file’ and ‘gtf.file’, respectively) should match the locations of the files in the system.

The script [predicts.R](https://github.com/TheJacksonLaboratory/isopretEM/blob/main/scripts/predicts.R) processes a subset of the isoforms to compute an assignment of GO terms that agrees with their sequence similarity. It is currentlty set to process a subset that contains 1/200 (0.5%) of the isoforms (determined by the variable ‘number.of.nodes’). The subset number, ranging between 1 and the number of subsets (currently 200), is provided as a command line argument. The number of cores dedicated to each subset is determined by the parameter ‘num.cores’ (currently 4). Each instance of this script can be run on a separate machine, since the output is written to disk and all outputs are combined by the script combine_tables.R. Paths to files containing the GO annotation, HGNC mappings, interpro domains, interpro2GO mapping and gene and isoform annotations should be modified to match the location of the corrresponding files on the system. Similarly, the path to the isoform amino-acid sequences should be modified accordingly (currently ‘/projects/robinson-lab/USERS/karleg/projects/isopret/isoform_seqs/’).

The script [combine_tables.R](https://github.com/TheJacksonLaboratory/isopretEM/blob/main/scripts/predicts.R) should be run after every instance of predict2.R has completed running and producing output. It combined all the outputs, perform the M step if needed, and creates new inputs for the next round of predict2.R runs. The patameter ‘number.of.nodes’ (currently 200) is the number of subsets the isoforms are split into. When the local maximum is reached, it outputs -1 into the file ‘convergence_log.txt’. The sparse matrix ‘combined_iso_has_func.txt’ is an isoform X GO term Boolean matrix that indicates which functions were assigned to each isoforms. The isoform names that correspond to rows are in the output file named ‘rownames.txt’ , and the GO terms corresponding to columns are in the output file named ‘columns.txt’.

##  gold-standard isoform-specific dataset
We reviewed the literature for papers that determine the function of isoform that can be mapped to Ensembl IDs and whose function can be mapped to GO terms, resulting in a collection of 307 examples where an isoform was shown to be either associated with a certain GO term or not associated with it. 

* [isoform-literature-curation.tsv](https://github.com/TheJacksonLaboratory/isopretEM/blob/main/data/isoform-literature-curation.tsv)

	 	 	 	 	 	 	 	

| Column            |      Example    |
|-------------------|:---------------:|
| gene.symbol       |  PAX3           | 
| gene.id           |   5077          |  
| isoform.accession |ENST00000409828  | 
| iensembl.name     | PAX3-208        |
| synonyms          | PAX3a           |
| qualifier         | NOT             |
| GO.label          |apoptotic process|
| GO.id             | GO:0006915      | 
| PMID              | PMID:16951170   | 


								


## Citing isopretEM

A preprint is available as [Karlebach et al., An algorithmic framework for isoform-specific functional analysis](https://www.biorxiv.org/content/10.1101/2022.05.13.491897v1). A manuscript version is currently in review.

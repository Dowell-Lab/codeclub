# 1. Summary of Tools and Databases
## A. Tools
### Single cell
* [SAIGE-QTL](https://www.medrxiv.org/content/10.1101/2024.05.15.24307317v1): allows to model single cell counts using a poisson model
* sc-QTLs: [CellRegMap](https://www.embopress.org/doi/full/10.15252/msb.202110663): sc method to map context-specific regulatory variants to identify eQTLs interacting with single cells at continuous cellular states
* sc-QTLs: E-P-INAnalyzer: clustering of substructures of regulation (one enhancer to multiple genes)
* sc-QTLs: CIGMA: partitions scRNA-seq heritability within and between cell types
* sc-QTLs: Macromap and Kundu?

### Integration
* [MCFA](https://pmc.ncbi.nlm.nih.gov/articles/PMC10435377/) (Multiset Correlation and Factor Analysis): allows integration of scRNA-seq and ATAC-seq in low dimensionality space
* [Bayesian GWAS](https://www.nature.com/articles/ncomms15842) uses QTL-calibrated priors to determine significance
* Cox Regression models
* Identify relevant gene modules in scRNA-seq (hdWGCNA) and figure out the next or previous stage of a cell before/after perturbation in gene modules ([COMPACT](https://rootze.github.io/projects/COMPACT_project/))

## B. Predicting impact of the variant
* ChromBPNet
* Enformer
* deltaSVM
* [Neuronet](https://scholar.google.co.uk/citations?view_op=view_citation&hl=en&user=iaK2ZucAAAAJ&sortby=pubdate&citation_for_view=iaK2ZucAAAAJ:WqliGbK-hY8C)
* [BRAIN-MAGNET](https://www.medrxiv.org/content/10.1101/2024.04.13.24305761v2): Basically ChromBPNet but for ChIP-STARR-seq
* JARVIS 2.0 (AstraZeneca) --> still being developed

## C. Statistical fine-mapping
* [Expression Modifier Score](https://www.nature.com/articles/s41467-021-23134-8) combines GWAS, fine-mapping, reporter assays. But now EMSv2
* [RSparsePro](https://www.biorxiv.org/content/10.1101/2024.10.29.620968v1):performs robust fine-mapping even if LD mismatch
* SuSIE


## D. Databases
### Single cell eQTLs
* [OneK1K](https://www.science.org/doi/10.1126/science.abf3041) (soon TenK1K) 28 distinct immune cell types & 50 million variants
* scRNA-seq [atlas](https://www.medrxiv.org/content/10.1101/2024.11.02.24316590v1) of human brain (I believe with sc-QTLs)
* [IBDverse](https://www.medrxiv.org/content/10.1101/2023.09.06.23295056v1) scRNA-seq atlas and QTLs
* [CLUES](https://pmc.ncbi.nlm.nih.gov/articles/PMC9297655/) (California Lupus Study): 1.2 million PBMCs from 264 donors
### Enhancer-promoter linkages
* An encyclopedia of enhancer-gene regulatory interactions in the human genome from 352 cell types/tissues ([Preprint](https://www.biorxiv.org/content/10.1101/2023.11.09.563812v1))
### cCRE associations
* ENCODE [cCRE associations](https://doi.org/10.1101/2024.11.06.24316407) (directly associating regions with traits using SAIGE-GENE)
### Isoform analysis 
* Immune Isoform Atlas: TRAILS (Transcriptomic Resource of Immune Cells using Long-read Sequencing) [Website](http://gfdweb.tmd.ac.jp:3838/)
### Other
* Omics Wide Association Analysis Platform: integrates TWAS and GWAS for heart failure and coronary artery disease (Yuvraj Singh, Nikhil Sharma, Kabir Raghuvanshi, Jennifer Kwan, Alokkumar Jha)
* [Effector Gene Prediction](pegkp.org) from NCBI: GWAS --> loci --> Multiple data types & methods --> predicted causal genes at significant loci

## E. Example Processes
* [Example](https://www.biorxiv.org/content/10.1101/2022.10.05.511011v3.full) of using ATAC-seq, Hi-C, and RNA-seq to find active enhancer regions, screen effector genes in a biologically relevant system, refine candidates in a human-specific model
* Example of using ATAC-seq, RNA-seq, GWAS to reestablish cross-species analysis pipeline AND cis/trans regulatory mechanisms (Yuncheng Duan Duke University – not published yet)
* [Example](https://pmc.ncbi.nlm.nih.gov/articles/PMC10516070/) of systematic identification of variants in untranslated regions (identified based on FABIAN and RNA binding protein motif and SpliceAI)  from Nicola Whiffin (University of Oxford) → I asked and she said she’s happy to help consult ideas

# 2. Highlights Learned
## A. Random
* Looking at different ancestries is great to clarify LD better if replicated
* RNA editing QTLs (edQTLs) – but identified if impacts expression somehow usually with GTEx
## B. Dealing with the nightmares of non-coding genome terminology
* Functional categorization of gene regulatory variants that cause Mendelian conditions ([Paper](https://pubmed.ncbi.nlm.nih.gov/38436667/) headed by Andrew Stergachis, MD, PhD Associate Prof of Medicine and Genome Sciences (University of Washington))
  * Loss-of-expression (of gene) vs Modular-loss-of-expression(based on cell state, developmental or enviornmental stage)
  * Ectopic gain of expression 
  * A single variant can cause loads of problems though
* How do we name genes according to HUGO Gene Nomenclature Committee ([Paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC7494048/))
* How do we name noncoding RNAs according to HUGO Gene Nomenclature Committee ([Paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC7073466/))
* How do we name variants ([HGVS nomenclature](https://hgvs-nomenclature.org))
* How do we name genomic rearrangements (https://isen.karger.com/)
* How do we name CREs?
  * RefSeq is currently trying with LOC functional elements ([Paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC8744684/))
## C. Clinical interpretation of variants
* Recommendations for clinical interpretation of variants found in non-coding regions of the genome (Paper)
* ClinVar trying to represent functional data of cREs with a new [mock up](http://github.com/ncbi/clinvar/) – looking for feedback at clinvar@ncbi.nlm.nih.gov

# 3. More notes
* More notes can be found in this [google doc](https://docs.google.com/document/d/1XyuS6JtrmaW10giGu5iFn_lY_CkbDYvJh_EySW_Tp0I/edit?usp=sharing)




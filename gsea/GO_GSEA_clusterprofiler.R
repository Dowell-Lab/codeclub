
# -------------------------------------------------------------------------
# GO analysis of results --------------------------------------------------
# -------------------------------------------------------------------------

# GO analysis requires these three libraries
#   - clusterProfiler: package that has all the GO functions 
#   - AnnotationDbi: contains function to work with gene names 
#   - org.Hs.eg.db: Homo sapiens genes with all their different identifiers 

  if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  
  BiocManager::install("clusterProfiler")
  BiocManager::install("AnnotationDbi")
  BiocManager::install("org.Hs.eg.db")

# Need to import libraries once you install them. 
  library(clusterProfiler) # package that has all the GO functions 
  library(AnnotationDbi)  # This contains function to work with gene names 
  library(org.Hs.eg.db)  # Homo sapiens genes with all their different identifiers 

# Load gene names (hs is for homo sapiens)
  hs <- org.Hs.eg.db
  
# Read in data
  data_import <- read_csv('path/to/file/here.csv')

# Pull out genes of interest (i.e. significantly changing)
  sig_genes_up <- de_results %>% filter(log2FoldChange > 0 & padj <= 0.05)  
    # is log2FoldChange > 0 a high enough change? What do you think is a good 
    # cutoff to get the most changed/interesting genes? 



# mapIds is a function from AnnotationDbi to convert symbols to entrezIDS
# It's annoying but, GO will only run on entrezIDs and not gene symbols
  genes_up_entrez <- mapIds(org.Hs.eg.db, 
                            keys = genes_up_lfc0$Gene, # gene symbol 
                            column = "ENTREZID", # what I want to convert to 
                            keytype = "SYMBOL")  # what I have


# create background list of all the genes we measured 
# this is all the genes in our DESeq results, regardless of significance 
  background <- data_import$Gene

# Also convert symbols to entrezIDs for background 
  background_entrez <- mapIds(org.Hs.eg.db, 
                              keys = background, 
                              column = "ENTREZID", 
                              keytype = "SYMBOL")

# enrichGO does the over-representation test 
# ont = ontology (BP, MF, CC, ALL)
# BP = biological process, MF = molecular function, CC = cellular compartment
# ALL = test all 3 (BP + MF + CC)
  go_res <- enrichGO( gene = genes_up_entrez, 
                      universe = background_entrez, 
                      OrgDb = hs, #what organism 
                      ont = "BP", 
                      pAdjustMethod = "BH", 
                      pvalueCutoff = 0.01, 
                      qvalueCutoff = 0.05, 
                      readable = TRUE)


# enrichGO returns an S4 object, which you investigate using "@"
# To look at results: go_res@result %>% View()
  go_res@result %>% View()
  
##-- Visualize the GO results 
# barplot and dotplot are functions from clusterProfiler, 
# designed to work with format output from enrichGO, but they're inflexible 
# you are often better off turning results into tibble and plotting with ggplot
  
  barplot(go_res, showCategory = 15)
  dotplot(go_res, showCategory = 15)

  
  

# -------------------------------------------------------------------------
# GSEA Analysis of Results ------------------------------------------------
# -------------------------------------------------------------------------

  
  ##-- Steps to completing GSEA analysis
  
  #0. Will need to install msigdbr through BiocManager. Don't forget to load
  #   it into the R environment at the top of this code section!
  
  install.packages("msigdbr") 
  # I use msigdbr but Bella, with a newer version of R, needed to use 
  # msigdbdf. Installation is below. 
  #install.packages('msigdbdf', repos = 'https://igordot.r-universe.dev')
  
  library(msigdbr)
  # library(msigdbdf)
  
  #1. Order so that most upregulated at top or downregulated at bottom.
  #.  Recommend by the signed padj, but can also do by log2FC. 
  
  t21_ordered <- t21_ifn_res %>% 
    arrange(desc(log2FoldChange))
  
  
  #2. Turn sorted df into a named list. The values of the named list must be 
  #   decreasing. 
  
  #create list
  list_t21_ordered <- t21_ordered$log2FoldChange
  #give each entry in list its corresponding gene name 
  names(list_t21_ordered) <- t21_ordered$gene_id
  
  
  #3. Load gene sets that you'll want to work with, example code below: 
  

  hallmark_geneset <- msigdbr(species = "Homo sapiens", category = "H") %>% 
    dplyr::select(gs_name, gene_symbol)
  
  c2_geneset <- msigdbr(species = "Homo sapiens", category = "C2") %>% 
    dplyr::select(gs_name, gene_symbol)
  
  
  #4. Run GSEA, example code below: 
  
  
  t21_GSEA_res_c2_geneset <- GSEA(list_t21_ordered, # ordered list 
                                  TERM2GENE = c2_geneset, # set of pathways testing
                                  pAdjustMethod = 'BH', # adjust for multiple hypotheses
                                  minGSSize = 10, 
                                  maxGSSize = 500, 
                                  eps = 1e-20, # minimum p-value that will be reported 
                                  pvalueCutoff = 0.05) # significance threshold 
  
  t21_GSEA_res_hallmark_geneset <- GSEA(list_t21_ordered, 
                                        TERM2GENE = hallmark_geneset, 
                                        pAdjustMethod = 'BH', 
                                        minGSSize = 10, 
                                        maxGSSize = 500, 
                                        eps = 1e-20, 
                                        pvalueCutoff = 0.05)
  
  
  
  
  #5. Extract results into form for plotting, then plot. 
  
  # use res_gsea@result to access results and turn it into a tibble
  # using as_tibble(). Then you can experiment with plotting. 
  
  t21_GSEA_res_c2_geneset@result  


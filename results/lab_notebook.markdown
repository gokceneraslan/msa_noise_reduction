Project Lab Notebook by Basak Eraslan, Gokcen Eraslan & Javeria Ali
===================================================================

December 21, 2012
-----------------

We started to work on coding the project. Added command line and short arguments for input and output files. To generate Newick trees, we used [PyCogent](http://pycogent.org) and its [FastTree module](http://pycogent.org/examples/phylogeny_app_controllers.html). Initial files were added to [GitHub account](https://github.com/gokceneraslan/msa_noise_reduction).

We finished coding the `reduce_noise` [Python script](https://github.com/gokceneraslan/msa_noise_reduction/blob/master/bin/reduce_noise) which reduces noise and generates trees. The noise reduction script was tested and noise reduced output and tree files were generated. A Bash script was also added, and made executable, to iterate over all the input files and execute `reduce_noise` script to generate according noise reduced alignments and tree files.

The following is what remains to be done:

1. Tree files in both outputs and inputs directories  need to be compared.
2. Project layout needs to be converted to that  specified in the paper by Noble.
3. Understand what controls are and how they need to  be used for testing our program.

December 22, 2012
-----------------

We made changes to the tree generating program to render Newick trees as PNG, PDF or SVG using the PhyloTree class of the [ETE library](http://ete.cgenomics.org/) and also to shorten the species names in the tree files.


December 23, 2012
-----------------

Some minor errors in the noise function were fixed. We finished coding for the script for comparing reference tree with many trees in a directory.  We used [DendroPy library](http://pypi.python.org/pypi/DendroPy).

We ran our script and compared the trees, generating results that were added to pur project at GitHub. Comparison results were added in a TSV (tab separated value) file.

We added tree comparison plots and an overall tree plot, in a graphical format, to the results folder. Minor changes were made to the graph axis titles.

We also discussed the usage of controls and what test cases can be made to test our program. Will implement this tomorrow.

**Problem:** For some reason the PyCogent, DendroPy, and ete2 modules were not installing or being picked up by the Python editor in Javeria's PC. Cannot understand why.

December 24, 2012
-----------------

We changed the some of the functions in our programs so that PyCogent and ete2 modules are only required for tree generation function.

```udiff
commit 7d62a362cbbf529a60d6bec06dc63e59c2d3e774
Author: Gökçen Eraslan <gokcen.eraslan@gmail.com>
Date:   Mon Dec 24 12:43:12 2012 +0100

    Use cogent and ete2 modules only in the tree generator function.

diff --git a/reduce_noise b/reduce_noise
index a56caf9..961ec64 100755
--- a/reduce_noise
+++ b/reduce_noise
@@ -25,12 +25,6 @@ from collections import Counter
 # Biopython is used to parse and manipulate fasta formatted MSA files
 from Bio import AlignIO, Align, Seq, SeqRecord
 
-# PyCogent is used to generate phylogenetic tree from the fasta files
-import cogent
-
-# ETE toolkit is used to render newick trees as images
-import ete2
-
 
 # matlab style indexing i.e.: x = 'AGCGAGGC'; index_string(x, [0, 3, 4]-> 'AGA'
 index_string = lambda string, i: ''.join([string[x] for x in i])
@@ -86,6 +80,12 @@ def filter_noise_in_columns(msa, noise_func):
 def generate_phylo_tree(msa, outfilename, format, image_format, tree_module):
     """Generates phylogenetic tree from given sequence alignment file."""
 
+    # PyCogent is used to generate phylogenetic tree from the fasta files
+    import cogent
+
+    # ETE toolkit is used to render newick trees as images
+    import ete2
+
     aln = cogent.LoadSeqs(data=msa,
                           moltype=cogent.PROTEIN,
                           aligned=True,
```

We  worked on making the control data sets. Using real data from protein databases was proving to be time consuming. Need to consider using random protein sequence generators. We used some online tools for generating random fasta sequences of proteins.

The control files were added to GitHub in a separate folder. We generated some results on these control files in the respective folder. Today we also discussed the possibility of using null data to make some statistical analysis.

December 25, 2012
-----------------

We added a folder containing random fasta sequences to the control folder, and generated results by running them on the scripts. Some arguments in `generate_outputs.sh` were fixed. This was run to obtain `generate_outputs.sh` file for control inputs.

Generated files were cleaned up and regenerated. More changes were made to the program. Fixes were made for checking if all noise columns are removed. Changes were also made so that output files are created after parsing input file to get rid of empty output files in error conditions.

```udiff
commit 04d725a71ac2f8ce3a9d20a1acdffa3280e70e46
Author: Gökçen Eraslan <gokcen.eraslan@gmail.com>
Date:   Tue Dec 25 15:04:13 2012 +0100

    Fix assertion that checks whether all columns are removed.

diff --git a/Control/reduce_noise b/Control/reduce_noise
index 961ec64..c8b6a45 100755
--- a/Control/reduce_noise
+++ b/Control/reduce_noise
@@ -65,7 +65,7 @@ def filter_noise_in_columns(msa, noise_func):
     valid_columns = [col for col in range(num_columns)
                          if not noise_func(msa[:, col])]
 
-    assert num_columns != valid_columns, "All columns seem noisy, exiting..."
+    assert valid_columns, "All columns seem noisy, exiting..."
 
     new_msa = []
 
diff --git a/reduce_noise b/reduce_noise
index 29f9e45..9ff6e61 100755
--- a/reduce_noise
+++ b/reduce_noise
@@ -65,7 +65,7 @@ def filter_noise_in_columns(msa, noise_func):
     valid_columns = [col for col in range(num_columns)
                          if not noise_func(msa[:, col])]
 
-    assert num_columns != valid_columns, "All columns seem noisy, exiting..."
+    assert valid_columns, "All columns seem noisy, exiting..."
 
     new_msa = []
 ```

We compile the results and work on finishing the report.

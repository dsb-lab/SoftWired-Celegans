# SoftWired-Celegans
Code for the paper *Soft-wired long-term memory in a natural recurrent neuronal network* ([doi:10.1063/5.0009709](https://doi.org/10.1063/5.0009709)).

<p align="center">
    <img width="750" height="320"src="Others/graph.png">
</p>


#### AlgorithmOutput

Optimal network found by the genetic algorithm. 

#### Connectome

Connectome from [Whole-animal connectomes of both Caenorhabditis elegans sexes](https://www.nature.com/articles/s41586-019-1352-7) in `xls` files. The directory also includes the code for the pruning and *Gephi* files for <u>figure 1a</u>.

#### Figures

- **FinalFigures:** Different figures of the paper in `pdf`.
- **ProgrammingFigures:** `ipynb` files for plotting the figures.

#### GeneticAlgorithm

Source files for running the genetic algorithm specified in section III. Contains the code necessary to reproduce <u>figure 2</u> and <u>figure 3a</u>. Neural signals in `worm_data.mat` do not correspond to the data used in the study. A placeholder was created, preserving some features of the original calcium traces in [Pan-neuronal imaging in roaming *Caenorhabditis elegans*](https://www.pnas.org/content/113/8/E1082.long).

#### Others

Additional complementary resources.

#### Pentropy

Necessary files to compute permutation entropy in <u>figure 3b</u>.  The main file is `mainPentropy.m`, which calls `petropy.m` from [Practical considerations of permutation entropy: A tutorial review](https://link.springer.com/article/10.1140/epjst/e2013-01862-7).

#### Rdistribution

`Python` code to generate different R distributions in <u>figure 6d</u>.

#### StatisticalTest

Chi-square test to compare distributions in <u>figure 5b</u>.








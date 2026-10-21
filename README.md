# De Novo Bacterial Genome Assembly and Annotation

**Authors:** Andrea Villarruel García and Addiel Antonio Renteral Platas

**Context:** Collaborative final project for an undergraduate Assembly course (2025)

## Overview

This repository documents a comparative *de novo* bacterial genome assembly and annotation project completed as part of an undergraduate Genomics course in the Licenciatura en Ciencias Genómicas at the National Autonomous University of Mexico (UNAM).

Using Illumina paired-end and PacBio long-read data supplied for the course, we examined multiple assembly strategies, compared their outputs, polished selected assemblies, and explored gene prediction and functional annotation. The analysis was performed by running bioinformatics tools through the command line on the university's Chaac computing server.

**Scope:** This repository is a record of a collaborative coursework analysis, **not** a newly developed assembly algorithm or a validated, automated pipeline.

## Analysis workflow

| Stage | Tools | Purpose |
| --- | --- | --- |
| Read quality assessment | FastQC | Inspect sequencing-read quality |
| Read preprocessing | Trim Galore, Trimmomatic | Evaluate trimming approaches |
| Short-read assembly | Velvet, SPAdes | Assemble Illumina reads |
| Long-read assembly | Canu, Flye | Assemble PacBio reads |
| Short-, long-, and hybrid-read assembly | Unicycler | Compare assembly strategies |
| Assembly evaluation | QUAST, MUMmer | Examine contiguity metrics and structural alignments |
| Polishing | Bowtie2, SAMtools, Pilon | Align Illumina reads and polish selected assemblies |
| Gene prediction and annotation | Glimmer3, BLASTn, Prokka | Explore predicted genes, sequence similarity, and annotation |

The original step-by-step commands, methodological decisions, and figures are preserved in the [coursework report (Spanish)](docs/reporte_completo.md). The [original HackMD export](docs/ProyectoEnsamble_PlatasAddiel_VillarruelAndrea.html) is also available.

## Selected results

### Assembly comparison

The following metrics come from the saved [QUAST assembly comparison](results/quast/quast_assemblers_comparison.tsv):

| Assembly | Contigs | Total length (bp) | N50 (bp) | GC (%) |
| --- | ---: | ---: | ---: | ---: |
| Unicycler — long reads | 10 | 5,772,339 | 1,798,739 | 67.48 |
| Unicycler — short reads | 89 | 5,466,457 | 103,614 | 67.67 |
| Unicycler — hybrid | 6 | 5,582,936 | 952,931 | 67.61 |
| Canu | 1 | 5,641,814 | 5,641,814 | 67.59 |
| Flye | 3 | 5,671,425 | 3,540,261 | 67.56 |

Canu produced a single-contig assembly in this comparison, while Flye produced three contigs. These continuity metrics alone do not establish which assembly is more accurate at the nucleotide level.

### Polishing and annotation

The saved [post-Pilon QUAST comparison](results/quast/quast_pilon_comparison.tsv) reports:

| Assembly | Contigs | Total length (bp) | N50 (bp) |
| --- | ---: | ---: | ---: |
| Canu + Pilon | 1 | 5,641,952 | 5,641,952 |
| Flye + Pilon | 3 | 5,671,434 | 3,540,269 |

The Flye + Pilon assembly was used for downstream annotation in the coursework analysis. This choice should not be interpreted as proof of superior nucleotide-level accuracy without further validation.

The [Prokka summary](results/annotation/CP10_summary_stats.txt) for that assembly reports **5,008 predicted coding sequences (CDS), 12 rRNAs, 65 tRNAs, and 1 tmRNA**. Sequence-similarity searches yielded matches to *Cupriavidus gilardii*; however, the genus, species, and strain name supplied to Prokka were input labels, **not an independent taxonomic identification**. Confirming the organism's identity and exact strain would require additional analyses, such as genome-wide comparisons.

Other saved outputs include [MUMmer alignment coordinates](results/mummer/) and [selected BLASTn hits](results/annotation/blast_top_hits.txt).

## Repository contents

```text
.
├── README.md
├── docs/
│   ├── reporte_completo.md
│   └── ProyectoEnsamble_PlatasAddiel_VillarruelAndrea.html
├── results/
│   ├── quast/
│   ├── mummer/
│   └── annotation/
├── scripts/
│   ├── run_pipeline.sh
│   └── 01_quality_control.sh ... 09_functional_annotation.sh
├── environment.yml
├── .gitignore
└── LICENSE
```

## Computational workflow and reproducibility

The project was performed interactively on the command line on Chaac, using existing bioinformatics software. The repository provides the original coursework documentation and selected outputs, rather than a scripted or tested, one-command reproduction of the analysis.

Some commands in the original report rely on absolute paths, input datasets, software installations, and configurations specific to the course computing environment. They should be treated as a historical record of the analysis, not as independently validated instructions for rerunning every step on another system.
Data availability and limitations
The Illumina files (`ILLU_GRP4_1.fq, ILLU_GRP4_2.fq`) and the PacBio file (`PAC_GRP4.fastq`) were supplied for the course and are not distributed in this repository. Reuse or redistribution of those data requires authorization from the relevant course instructors or data owners.

Only selected analysis outputs are included. The project was educational and exploratory; conclusions concerning assembly accuracy and exact taxonomic identity require additional validation.

## Authors and acknowledgments
This coursework project was carried out collaboratively by Andrea Villarruel García and Addiel Antonio Renteral Platas. The descriptions of the work refer to the joint project, without attributing individual steps that have not been independently documented.

We acknowledge the UNAM Genomics course for providing the sequencing data and access to the Chaac computing resources.
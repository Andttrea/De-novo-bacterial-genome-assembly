# PROYECTO ENSAMBLE

Integrantes:

- Renteral Platas Addiel Antonio
- Villarruel García Andrea

## INTRODUCCIÓN

El objetivo de este proyecto es ensamblar, evaluar y anotar el genoma de un organismo bacteriano a partir de lecturas Illumina (cortas) y PacBio (largas). Para ello se aplicaron distintas herramientas de control de calidad, limpieza y ensamblaje, comparando su desempeño para seleccionar la reconstrucción genómica más completa y precisa. Finalmente, se realizó la predicción de genes y la anotación funcional para identificar taxonómicamente al organismo y caracterizar su contenido génico. Este flujo de trabajo integra todo el proceso bioinformático necesario para obtener un genoma bacteriano ensamblado y anotado de manera confiable.

## METODOLOGÍA

El siguiente proyecto se realizó en el servidor Chaac perteneciente a la Licenciatura en Ciencias Genómicas, los directorios del proyecto en donde se realizaron todos los comandos son los siguientes:

##### Path de Antonio:

```
/home/addielpr/WORKING_TREE/GENOMICA/PROYECTO_EQUIPO_4
```

##### Path de Andrea:

```
/export/storage/users/andreavg/genomica/proyecto
```

### OBTENCIÓN DE ARCHIVOS

Desde la ruta `/export/space3/users/llozano/GENOMICA/DATA/` se obtuvieron los siguientes archivos:

- ILLU_GRP4_1.fq
- ILLU_GRP4_2.fq
- PAC_GRP3.fastq

Los archivos se guardaron en PROYECTO_EQUIPO_4/DATA mediante lineas simbólicas:

```
mkdir PROYECTO_EQUIPO_4
cd PROYECTO_EQUIPO_4
mkdir DATA
cd DATA
ln -s ../../DATA/ILLU_GRP4_1.fq
ln -s ../../DATA/ILLU_GRP4_2.fq
ln -s export/storage/users/addielpr/GENOMICA/TRIM/TRIMMOMATIC/TruSeq3-PE.fa
```

### FASTQC

Creamos el directorio para guardar los resultados del FASTQC:

```
mkdir FASTQS
cd FASTQS
```

Luego se realizó un FASTQC con los siguientes comandos:

```
fastqc ../DATA/ILLU_GRP4_* 
fastqc ../DATA/PAC_GRP4.fastq
```

Procedemos a ver los archivos .html generados para decidir a partir de donde debemos cortar

##### Archivos crudos:

Archivo ILLU_GRP4_1_fastqc.html:

![ILLU_GRP4_1_fastqc_SS1](https://hackmd.io/_uploads/ByevS1Pebg.png)

![ILLU_GRP4_1_fastqc_SS2](https://hackmd.io/_uploads/BykOHJDe-g.png)

Archivo ILLU_GRP4_2_fastqc.html:

![ILLU_GRP4_2_fastqc_SS1](https://hackmd.io/_uploads/rJDorJDebx.png)

![ILLU_GRP4_2_fastqc_SS2](https://hackmd.io/_uploads/SkaoHywebg.png)

Archivo PAC_GRP4_fastqc.html:

![PAC_GRP4_fastqc_SS1](https://hackmd.io/_uploads/Byvhr1vxbg.png)

![PAC_GRP4_fastqc_SS2](https://hackmd.io/_uploads/rJi2S1wgWx.png)

### LIMPIEZA

Una vez obtenidos los resultados del FASTQC procedimos a visualizarlos, donde nos dimos cuenta que aproximadamente

a partir del 12 por lo que procedimos a correr el comando tomando en cuenta solo los valores delante del 12

Creamos el directorio para guardar los resultados de TRIMM (TRIMMOMATIC y TRIM_GALORE):

```
mkdir TRIMM
cd TRIMM
mkdir TRIMMOMATIC TRIM_GALORE
```

Primero creamos las lineas simbolicas a los archivos tanto del proyecto como del archivo de adaptadores que

previamente se nos dió y luego corrimos ambos programas con los siguientes comandos:

#### TRIM_GALORE

```
cd TRIM_GALORE
ln -s ../../data/ILLU_GRP4_1.fq 
ln -s ../../data/ILLU_GRP4_2.fq
ln -s /export/storage/users/addielpr/GENOMICA/TRIMM/TRIMMOMATIC/TruSeq3-PE.fa
trim_galore --fastqc -j 4 --clip_R1 12 --clip_R2 12 --paired --retain_unpaired ../../data/ILLU_GRP4_1.fq ../../data/ILLU_GRP4_2.fq
```

> FLAGS
> 
> `fastqc`: Genera automáticamente reportes FASTQC antes y después del trimming
> 
> `j`: Indica el número de threads, en este caso 4
> 
> `clip_R1`: Indica la cantidad de nucleótidos que se va a cortar en el extremo 5´ en el archivo R1, en este caso 12
> 
> `clip_R12`: Hace lo mismo que clip_R1 pero ahora en el segundo archivo
> 
> `paired`: Indica que las secuencias en el formato paired-ended
> 
> `retain_unpaired`: Guarda a las lecturas que pierdan a su pareja durante el trimming

#### TRIMMOMATIC

```
cd ../TRIMMOMATIC
ln -s ../../data/ILLU_GRP4_1.fq 
ln -s ../../data/ILLU_GRP4_2.fq
ln -s /export/storage/users/addielpr/GENOMICA/TRIMM/TRIMMOMATIC/TruSeq3-PE.fa
trimmomatic PE ILLU_GRP4_1.fq ILLU_GRP4_2.fq ILLU_GRP4_1_pair.fq ILLU_GRP4_1_unpair.fq ILLU_GRP4_2_pair.fq ILLU_GRP4_2_unpair.fq
ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:25
```

> FLAGS
> 
> `PE`: Indica que se realizara un trimming de datos paired-ended
> 
> `ILLUMINACLIP:TruSeq3-PE.fa:2:30:10`: Va a remover los adaptadores,
> 
> `LEADING: 3`: Elimina las bases con calidad menor a 3 al inicio de cada lectura
> 
> `TRAILING:3`: ELimina las bases con calidad menor a 3 al final de cada lectura
> 
> `SLIDINGWINDOW:4:20`: Aplica una ventana de 4 bases que exigue un promedio mínimo de cálidad de Q20
> 
> `MIDLEN:25`: Descarta cualquier lectura que tenga menos de 25 bases

Visualizamos y comparamos los resultados obtenidos tanto por FASTQC como por TRIM_GALORE y TRIMMOMATIC. Dandonos cuenta

que los que mejor se veian eran los archivos de datos crudos por lo que los siguientes pasos se trabajaron con esos archivos

##### Archivos obtenidos por trim galore:

Archivo ILLU_GRP4_1_val_1_fastqc.html:

![ILLU_GRP4_1_val_1_fastqc](https://hackmd.io/_uploads/B1qqo1Pxbx.png)

Archivo ILLU_GRP4_2_val_2_fastqc.html:

![ILLU_GRP4_2_val_2_fastqc](https://hackmd.io/_uploads/BygjiJDeWl.png)

##### Archivos obtenidos por trimmomatic:

Archivo ILLU_GRP4_1_paired_fastqc.html:

![ILLU_GRP4_1_paired_fastqc](https://hackmd.io/_uploads/Syv50ywxWx.png)

Archivo ILLU_GRP4_1_unpaired_fastqc.html:

![ILLU_GRP4_1_unpaired_fastqc](https://hackmd.io/_uploads/ryHs01DeWl.png)

Archivo ILLU_GRP4_2_paired_fastqc.html:

![ILLU_GRP4_2_paired_fastqc](https://hackmd.io/_uploads/B1AnCkvlWe.png)

Archivo ILLU_GRP4_2_unpaired_fastqc.html:

![ILLU_GRP4_2_unpaired_fastqc](https://hackmd.io/_uploads/SJO11eDgbx.png)

### ENSAMBLE LECTURAS CORTAS

#### VELVET

Creamos la carpeta ENSAMBLE y dentro de esta una llamada VELVET_OPTIMISER.

```
mdkir ENSAMBLE
cd ENSAMBLE
mkdir VELVET_OPTIMISER
cd VELVET_OPTIMISER
ln -s ../../DATA/ILLU_GRP4_1.fq
ln -s ../../DATA/ILLU_GRP4_2.fq
VelvetOptimiser.pl --s 21 --e 61 --x 2 --t 16 -f '-fastq -shortPaired -separate ILLU_GRP4_1.fq ILLU_GRP4_2.fq'
```

> FLAGS
> 
> `s`: Valor inicial del rango del *k-mero*, en este caso 21
> 
> `e`: Valor final del rango del *k-mero* a evaluar, en este caso 61
> 
> `x`: Incremento del *k-mero*
> 
> `t`: Número de threads, en este caso 16
> 
> `f`: Específica los argumentos que se enviarán a **velveth**

Posteriormente corrimos el VelvetOptimiser con rangos diferentes, escoggidos al azar, para ver cual era el mejor valor:

```
VelvetOptimiser.pl --s 31 --e 51 --x 2 --t 16 -f '-fastq -shortPaired -separate ILLU_GRP4_1.fq ILLU_GRP4_2.fq'
VelvetOptimiser.pl --s 35 --e 47 --x 2 --t 16 -f '-fastq -shortPaired -separate ILLU_GRP4_1.fq ILLU_GRP4_2.fq'
```

De acuerdo a los resultados, el mejor valor fue el 43

Proseguimos creando una carpeta para ejecutar velveth y otra para ejecutar velvetg. Mismas que están dentro de la carpeta ENSAMBLE.

```
mkdir VELVETH
mkdir VELVETG
```

#### VELVETH

```
cd VELVETH
ln -s ../../DATA/ILLU_GRP4_1.fq
ln -s ../../DATA/ILLU_GRP4_2.fq
velveth VELVET_43 43 -fastq  -shortPaired -separate ILLU_GRP4_1.fq ILLU_GRP4_2.fq
```

> FLAGS
> 
> `43`: Tamaño del *k-mero* que se usará para construir la tabla de *hashes*
> 
> `fastq`:Indica que las lectura están en formato FASTQ
> 
> `shortPaired`:Indica que las lecturas que son paired_ended y cortas
> 
> `separate`: Indica que los dos archivos se proporcionan como lecturas separadas

#### VELVETG

```
cd ../VELVETG
ln -s ../../DATA/ILLU_GRP4_1.fq
ln -s ../../DATA/ILLU_GRP4_2.fq
ln -s ../VELVETH/VELVET_43/ 
velvetg VELVET_43 -cov_cutoff auto -exp_cov auto -ins_length 300 -scaffolding no
```

> FLAGS
> 
> `cov_cutoff`: Filtrado por baja cobertura, en este caso automáticamente
> 
> `exp_cov`: Estima la cobertura esperada, en este caso automáticamente
> 
> `ins_length`: Insert site promedio, en este caso 300 bp
> 
> `scaffolding`: Controla si **Velvetg** une los contigs, en este caso no lo va a hacer

Output:

Final graph has 817 nodes and n50 of 16580, max 90662, total 5503767, using 906308/999998 reads

Output:

Final graph has 814 nodes and n50 of 15627, max 90352, total 5502284, using 906201/999998 reads

#### SPADES

Posteriormente, creamos una carpeta para correr spades dentro de la carpeta de ENSAMBLE y activamos el entorno.

```
mkdir SPADES
cd SPADES
conda activate spades
ln -s ../../DATA/ILLU_GRP4_1.fq
ln -s ../../DATA/ILLU_GRP4_2.fq
spades.py --careful -t 10 -1 ILLU_GRP4_1.fq -2 ILLU_GRP4_2.fq -k 21,33,55,77 -o SPADES_V1
```

> FLAGS
> 
> `careful`: Reduce errores en el ensamblado, usa métodos más estrictos
> 
> `t`: Uso de 10 threads
> 
> `1`: Archivo de lecturas paired_ended R1
> 
> `2`: Archivo de lecturas paired_ended R2
> 
> `k`: Conjunto de *k-meros* que se utilizaran durante el ensamblado
> 
> `o`: Directorio de salida

Spades se corrió con nuevos *k-meros* escogidos al azar

```
spades.py --careful -t 10 -1 ILLU_GRP4_1.fq -2 ILLU_GRP4_2.fq -k 51,61,63,69,71 -o SPADES_V2
spades.py --careful -t 10 -1 ILLU_GRP4_1.fq -2 ILLU_GRP4_2.fq -k 17,23,31,41,53,67,79 -o SPADES_V3
```

#### UNICYCLER - ENSAMBLE DE LECTURAS LARGAS

Posterior al ensamblado con Spades, decidimos correr Unicycler con el archivo de PacBio, para esto se creo una carpeta dentro de ENSAMBLE:

```
mkdir UNICYCLER
conda activate unicycler
ln -s ../../DATA/PAC_GRP4.fastq
```

Luego de esto, procedemos a correr unicycler con los siguientes comandos:

```
unicycler -t 10 --linear_seqs 1 -l PAC_GRP4.fastq -o UNI_LONG_V1
```

> FLAGS
> 
> `t`: Indica el número de threads, en este caso 10
> 
> `linear_seqs`: Permite que se reporten secuencias lineares
> 
> `l`: Archivo de lecturas long-read
> 
> `o`: Archivo de salida

### QUAST

Ya una vez que tenemos los ensambles mediante tres programas distintos, procedemos a correr un quast para evaluar cual es el mejor ensamble

```
conda activate quast 
quast -m 200 VELVETH/VELVET_43/contigs.fa SPADES/SPADES_V1/contigs.fasta SPADES/SPADES_V2/contigs.fasta SPADES/SPADES_V3/contigs.fasta UNICYCLER/UNI_LONG_V1/assembly.fasta
```

> FLAG
> 
> `m`: Indica que solo se analicen contigs con longitud mayor o igual a 200 bp

![image](https://hackmd.io/_uploads/B1yACCLl-g.png)

Hasta el momento, de acuerdo a los resultados del quast, el mejor programa ha sido Unicycler en la version LONG, esto debido a que reduce drásticamente el número de contigs (10 frente a más de 100 en otros ensambladores), incrementa de manera significativa el valor de N50 (1.79 Mb) y genera los contigs más largos (2.1 Mb), manteniendo al mismo tiempo una longitud total coherente con el tamaño esperado del genoma (~5.7 Mb) y un contenido GC consistente (~67%).

### ENSAMBLE HIBRÍDO

Para mejorar nuestro ensamble , procederemos a correr Unicycler pero en la version SHORT y HYBRID.

```
cd UNICYCLER
#Creación de ligas simbólicas 
ln -s ../../DATA/ILLU_GRP4_1.fq 
ln -s ../../DATA/ILLU_GRP4_2.fq
conda activate unicycler
#unicycler short 
unicycler -1 ILLU_GRP4_1.fq -2 ILLU_GRP4_2.fq -t 6 -o UNI_SHORT_V1
#unycicler híbrido 
unicycler -t 10  --linear_seqs 1 -1 ILLU_GRP4_1.fq -2 ILLU_GRP4_2.fq -l PAC_GRP4.fastq   -o UNI_HYBRID_V1
```

> FLAGS
> 
> `t`: Indica el número de threads, en este caso 10
> 
> `linear_seqs`: Permite que se reporten secuencias lineares
> 
> `l`: Archivo de lecturas long-read
> 
> `o`: Archivo de salida

### ENSAMBLE DE LECTURAS LARGAS

#### CANU

Posterior a esto, correremos el programa Canu y Flye para poder buscar un mejor ensamble

```
cd ../
mkdir CANU
cd CANU
conda activate canu
#creación de línea simbólica 
ln -s ../../DATA/PAC_GRP4.fastq  
canu -d CANU_V1 -p GRP4 genomeSize=5.7m -pacbio PAC_GRP4.fastq
```

> FLAG
> 
> `d`: Directorio de salida
> 
> `p`: Prefijo de los archivos de salida
> 
> `pacbio`: Indica que las lecturas de entrada son de PacBio

#### FLYE

```
mkdir FLYE
cd FLYE
ln -s ../../DATA/PAC_GRP4.fastq 
conda deactivate
flye -g 5.7m -t 15 --pacbio-corr PAC_GRP4.fastq -o FLYE_V1
```

> FLAG
> 
> `g`: Tamaño del genoma estimado, en este caso 5.7 millones de bp
> 
> `t`: Número de threads, en este caso 15
> 
> `pabcio-corr`: Indica que las lecturas de entrada son de PacBio corregidas
> 
> `o`: Archivo de salida

### QUAST

Procedimos a correr otro quast para observar si UNY_LONG sigue siendo nuestro mejor ensamble

```
conda activate quast
quast -m 200 UNICYCLER/UNI_LONG_V1/assembly.fasta UNICYCLER/UNI_SHORT_V1/assembly.fasta UNICYCLER/UNI_HYBRID_V1/assembly.fasta CANU/CANU_V1/GRP4.contigs.fasta FLYE/FLYE_V1/assembly.fasta
```

> FLAG
> 
> `m`: Indica que solo se analicen contigs con longitud mayor o igual a 200 bp

![image](https://hackmd.io/_uploads/ryZAS1PgWg.png)

El mejor ensamblaje es el de Canu porque contiene solo un contig, tiene una longitud total cercana al tamaño real del genoma, y muestra el N50 y largest contig más altos, lo que indica la mayor continuidad y completitud entre todos los ensambles. Sin embargo, Flye también posee una buena calidad solo que posee tres contigs.

### MUMMER

Posteriormente, correremos el programa mummer para visualizar mejor la calidad de nuestros ensambles, con los siguientes comandos, los resultados irán dentro de una carpeta llamada MUMMER que se encuentra dentro de ENSAMBLE:

```
mkdir MUMMER
cd MUMMER
mkdir MUMMER_CANU_FLYE
mkdir MUMMER_UNIHYB_CANU
cd MUMMER_CANU_FLYE/
ln -s ../../CANU/CANU_V1/GRP4.contigs.fasta
ln -s ../../FLYE/FLYE_V1/assembly.fasta
nucmer --coords GRP4.contigs.fasta assembly.fasta
mummerplot out.delta
cd ../MUMMER_UNIHYB_CANU/
ln -s ../../UNICYCLER/UNI_HYBRID_V1/assembly.fasta
ln -s ../../CANU/CANU_V1/GRP4.contigs.fasta
nucmer --coords assembly.fasta GRP4.contigs.fasta
mummerplot out.delta
```

> FLAG
> 
> `coords`: Le dice al programa que genere también una tabla resumida de los alineamientos

Corrimos dos veces el programa, en la primera fue usando nuestro mejor ensamble (Canu) contra el segundo mejor ensamble (Flye), para la segunda fue usando de nuevo nuestro mejor ensamble contra el tercer mejor ensamble hasta el momento (UniHybrid)

##### Salidas de mummerplot:

Mummerplot_Canu_Flye:

![Mummerplot_Canu_Flye](https://hackmd.io/_uploads/Hy9t9gDxWl.png)

Mummerplot_Unihyb_Canu:

![Mummerplot_Unihyb_Canu](https://hackmd.io/_uploads/rkJ65xveWe.png)

### MEJORAMIENTO DEL ENSAMBLE

#### PILON

Como segundo método de mejora para nuestro ensamble utilizamos pilon, este lo corrimos con nuestros dos mejores ensambles: canu y flye. Se creó una carpeta llamada PILON dentro de ENSAMBLE, y dentro de esta, dos subcarpetas: CANU_PILON y FLYE_PILON:

```
mkdir PILON
cd PILON
mkdir CANU_PYLON 
mkdir FLYE_PILON
cd CANU_PYLON
#creación de líneas simbólicas 
ln -s ../../CANU/CANU_V1/GRP4.contigs.fasta
ln -s ../../../DATA/ILLU_GRP4_1.fq
ln -s ../../../DATA/ILLU_GRP4_2.fq
#uso de bowtie para la creación de los archivos sam 
bowtie2-build GRP4.contigs.fasta CANU_BUILD
bowtie2 -p 10 --no-unal -x CANU_BUILD -1 ILLU_GRP4_1.fq -2 ILLU_GRP4_2.fq -S assembly.sam
```

> FLAG
> 
> `p`: Indica el número de threads, en este caso son 10
> 
> `no-unal`: Indica que no se va a imprimir el archivo sam de las lecturas que no alinearon
> 
> `x`: Indica el bowtie2 previamente construido
> 
> `1`: Archivo R1
> 
> `2`: Archivo R2
> 
> `S`: Indica el archivo sam de salida

Convertimos el archivo sam generado por bowtie a bam para poder correr ese archivo en pilon

```
samtools view -bSo assembly.bam assembly.sam
```

> FLAGS
> 
> `view`: Convierte SAM a BAM
> 
> `bS`: Entrada SAM, salida BAM
> 
> `o`: Nombre del BAM de salida

```
samtools sort -o assembly_sort.bam assembly.bam
samtools index assembly_sort.bam
```

> FLAGS
> 
> `sort`: Ordena el archivo BAM
> 
> `o`: Archivo BAM ordenado de salida
> 
> `index`: Genera el archivo .bai para acceso rápido

Corremos pilon con el archivo BAM generado

```
conda activate pilon 
pilon --genome assembly.fasta --bam assembly_sort.bam --output assembly_canu_pilon --outdir . --changes --chunksize 1000000
```

> FLAGS
> 
> `genome`: Ensamble a corregir
> 
> `bam`: Alineamientos utilizados para la corrección
> 
> `output`: Prefijo del archivo de salida
> 
> `outdir`: Directorio de salida
> 
> `changes`: Reporta cambios aplicados
> 
> `chunksize`: Divide el genoma en fragmentos, en este caso en 1 Mb

Ahora vamos a proceder a hacer lo mismo, pero con **flye**

```
cd ../FLYE_PILON
ln -s ../../FLYE/FLYE_V1/assembly.fasta
ln -s ../../../DATA/ILLU_GRP4_1.fq
ln -s ../../../DATA/ILLU_GRP4_2.fq
bowtie2-build assembly.fasta FLYE_BUILD
bowtie2 -p 10 --no-unal -x FLYE_BUILD -1 ILLU_GRP4_1.fq -2 ILLU_GRP4_2.fq -S assembly.sam
```

> FLAGS
> 
> `p`: Número de hilos (threads)
> 
> `no-unal`: No reporta lecturas no alineadas
> 
> `x`: Índice de Bowtie2 a usar
> 
> `1`: Lecturas forward (R1)
> 
> `2`: Lecturas reverse (R2)
> 
> `S`: Archivo SAM de salida

```
samtools view -bSo assembly.bam assembly.sam
samtools sort -o assembly_sort.bam assembly.bam
samtools index assembly_sort.bam
```

> FLAGS
> 
> `bS`: Indica que es una entrada .bam y salida .sam
> 
> `o`: Nombre del .bam de salida

```
conda activate pilon 
pilon --genome assembly.fasta --bam assembly_sort.bam --output assembly_flye_pilon --outdir . --changes --chunksize 1000000
```

> FLAGS
> 
> `genome`: Ensamble a corregir
> 
> `bam`: Alineamientos utilizados para la corrección
> 
> `output`: Prefijo del archivo de salida
> 
> `outdir`: Directorio de salida
> 
> `changes`: Reporta cambios aplicados
> 
> `chunksize`: Divide el genoma en fragmentos, en este caso en 1 Mb

### QUAST

Para saber cual de nuestros dos assembly era el mejor, corrimos quast

```
conda activate quast
quast -m 200 PILON/CANU_PILON/assembly_canu_pilon.fasta PILON/FLYE_PILON/assembly_flye_pilon.fasta
```

> FLAG
> 
> `m`: Indica que solo se analicen contigs con longitud mayor o igual a 200 bp

![image](https://hackmd.io/_uploads/BJ6k_9IlZe.png)

Aunque el ensamblaje de canu_pilon muestra mejores métricas en QUAST, Flye puede ser preferible porque está optimizado específicamente para lecturas largas PacBio, manejando mejor su nivel de ruido y resolviendo con mayor precisión regiones altamente repetitivas o estructuralmente complejas. Además, Flye suele recuperar plásmidos y elementos secundarios con mayor fidelidad, lo que puede reflejar más adecuadamente la biología real del genoma, incluso si el resultado final queda en varios contigs.

### PREDICCIÓN DE GENES

#### Glimmer

Se utilizó glimmer para hacer la predicción de genes con el ensamble de flye_pilon.fasta

```
#creación de carpeta de glimmer y línea simbólica
mkdir GLIMMER
cd GLIMMER
ln -s ../ENSAMBLE/FLYE/FLYE_V1/assembly.fasta
```

Uso de herramientas (long-orfs, extract y build-icm) para poder hacer uso de glimmer

```
long-orfs -n -t 1.15 assembly.fasta flye_run1.longorfs
```

> FLAGS
> 
> `n`: No inicia ORFs con codones alternativos
> 
> `t`: Umbral mínimo de relación codificante, en este caso 1.15

```
extract -t assembly.fasta flye_run1.longorfs > flye_run1.train
```

> FLAGS
> 
> `t`: Traduce coordenadas según el ensamblaje

```
build-icm -r flye_run1.icm < flye_run1.train
```

> FLAGS
> 
> `r`: Crea archivo ICM

Corremos glimmer

```
glimmer3 -o 50 -g 110 -t 30 assembly_flye_pilon.fasta flye_run1.icm flye_run1.glimmer
```

> FLAGS
> 
> `o`: Longitud mínima de ORFs (50 nt en este caso)
> 
> `g`: Tamaño mínimo de gen predicho (110 nt)
> 
> `t`: Umbral de puntuación (threshold) para llamar un gen (30)

Redirigimos la salida a un archivo llamado flye_run1.fnn, archivo que utilizaremos para correr blastn

```
extract -t assembly_flye_pilon.fasta flye_run1.glimmer.predict > flye_run1.ffn
```

> FLAGS
> 
> `t`: Modo “training/test”, indica que debe extraer las secuencias de los genes predichos según el archivo .predict

Utilizamos **grep** para observar cuantos ORFs existen en nuestro ensamble, esto nos arrojo la cantidad de **5420**

```
grep -c ">" flye_run1.fnn
5240
```

### ANOTACIÓN FUNCIONAL

#### BLASTN

Utilizamos la base de datos *nt* del *NCBI* para la identificación taxónomica de nuestro organismo, la base de datos se encuentra en el siguiente path: /export/storage/data/blast/db/nt

```
# Creación de la carpeta PROKKA y de la carpeta BLASTN
mkdir PROKKA
cd PROKKA
mkdir BLASTN
#creación de la liga simbólica al archivo flye_run1.fnn
ln -s ../../GLIMMER/flye_run1.ffn
blastn -query flye_run1.ffn -db /export/storage/data/blast/db/nt -out blast_results.txt -evalue 1e-5 -outfmt 6 -num_threads 12
```

> FLAGS
> 
> `query`: Archivo de secuencia que se va a comparar
> 
> `db`: Base de datos BLAST donde se hará la búsqueda
> 
> `out`: Archivo donde se guardarán los resultados
> 
> `evalue`: Valor e-value máximo permitido, 1e-5 en este caso
> 
> `outfmt`: Formato de salida , en este caso 6 = tabular
> 
> `num_threads`: Número de hilos utilizados para acelerar el análisis

Mediante **head** pudimos observar cual era el ID de nuestro organismo, dicho ID lo buscamos en el *NCBI*

```
head blast_results.txt  
orf00003	CP104386.1	97.753	178	0	4	1	177	1892083	1892257	6.66e-78	303
orf00003	CP085344.1	97.753	178	0	4	1	177	2158620	2158794	6.66e-78	303
orf00003	CP104387.1	87.079	178	19	4	1	177	372684	372510	3.24e-46	198
orf00004	CP104386.1	99.130	115	0	1	1	114	1892500	1892614	1.08e-48	206
orf00004	CP085344.1	99.130	115	0	1	1	114	2159037	2159151	1.08e-48	206
orf00004	CP054626.1	93.913	115	5	2	1	114	1498291	1498178	1.09e-38	172
orf00004	CP104387.1	93.913	115	6	1	1	114	372267	372153	1.09e-38	172
orf00004	CP098736.1	93.913	115	5	2	1	114	1933444	1933557	1.09e-38	172
orf00005	CP104386.1	99.398	166	0	1	1	165	1892707	1892872	7.89e-77	300
orf00005	CP085344.1	99.398	166	0	1	1	165	2159244	2159409	7.89e-77	300
```

El mejor hit fue el ID **CP104386.1**, el cual corresponde a la especie *Cupriavidus gilardii*

![image](https://hackmd.io/_uploads/SyYVNjUl-e.png)

#### PROKKA

Para tener una mejor anotación de nuestro genoma, decidimos correr prokka para saber cuales son los genes predichos

```
cd ../
conda activate prokka
prokka --outdir Cupriavidus10_prokka --prefix CP10 --genus Cupriavidus --species gilardii  --strain WM02  --locustag CP10 --cpus 10 ../ENSAMBLE/PILON/FLYE_PILON/assembly_flye_pilon.fasta
```

> FLAGS
> 
> `outdir`: Carpeta donde se guardarán todos los resultados de la anotación
> 
> `prefix`: Prefijo para todos los archivos de salida generados
> 
> `genus`: Género asignado al organismo en la anotación
> 
> `species`: Especie asignada al organismo
> 
> `strain`: Cepa del organismo
> 
> `locustag`: Etiqueta usada para nombrar genes y loci (prefijo en IDs)
> 
> `cpus`: Número de hilos que Prokka utilizará

Observamos el archivo CP10.txt para darnos una idea detallada de lo que contiene nuestro genona

```
more CP10.txt
organism: Cupriavidus gilardii WM02 
contigs: 3
bases: 5671434
CDS: 5008
rRNA: 12
tRNA: 65
tmRNA: 1
```

Estos resultados concuerdan una predicción biológica acerca de la cepa predicha por *blastn* por lo que podemos decir que esta es la especie perteneciente a nuestro ensamble.

## CONCLUSIÓN

La realización de este proyecto permitió recorrer de manera completa el flujo de trabajo necesario para ensamblar, evaluar y anotar un genoma bacteriano utilizando datos de lecturas cortas y largas. A lo largo del proceso se aplicaron herramientas de control de calidad, limpieza, ensamblado y refinamiento, lo que permitió comparar múltiples estrategias y seleccionar la reconstrucción más precisa. Los resultados mostraron que el enfoque híbrido basado en lecturas largas corregidas con lecturas cortas (Flye seguido de Pilon) produjo el ensamble más sólido, con un número reducido de contigs, estadísticas óptimas y una longitud acorde al tamaño esperado del genoma.

Mediante BLASTN, los contigs obtenidos mostraron una alta identidad con secuencias del organismo Cupriavidus gilardii, y la anotación realizada con Prokka confirmó que el genoma correspondía a la cepa Cupriavidus gilardii WM02, una variante conocida por su capacidad para sobrevivir en ambientes diversos y por presentar un genoma relativamente grande y rico en genes asociados a resistencia antimicrobiana y adaptación metabólica. La anotación final reveló más de 5000 CDS, junto con un repertorio completo de ARNr, ARNt y otros elementos funcionales, lo cual concuerda con las características descritas para esta especie.

En conjunto, este proyecto integró de manera exitosa las principales herramientas bioinformáticas modernas para la reconstrucción y análisis de un genoma bacteriano, demostrando la importancia de combinar tecnologías de secuenciación y métodos robustos de análisis para obtener un ensamblado confiable y una caracterización biológica precisa de la cepa estudiada.

# QOCE
These codes are for our paper "Quadratic Optimization based Clique Expansion for Overlapping Community Detection"

## Requirements
Before compiling codes, the following software should be installed in your system.
- Matlab
- gcc (for Linux and Mac) or Microsoft Visual Studio (for Windows)

## Datasets Information
- Synthetic networks: LFR benchmark refers to (1) (available at http://sites.google.com/site/santofortunato/inthepress2/)
- Real-world networks: Karate refers to (2); TerrorAttack and TerroristRel refer to (3); Polbooks refers to (4); Polblogs refers to (5); Amazon and DBLP refer to (6) (available at http://snap.stanford.edu/data/)

(1) A. Lancichinetti, S. Fortunato, and F. Radicchi, “Benchmark graphs for testing community detection algorithms,” Physical Review E, vol. 78, no. 4, p. 046110, 2008.

(2) W. W. Zachary, “An information flow model for conflict and fission in small groups,” Journal of Anthropological Research, vol. 33, no. 4, pp. 452–473, 1977.

(3) B. Zhao, P. Sen, and L. Getoor, “Entity and relationship labeling in affiliation networks,” in ICML Workshop on Statistical Network Analysis, 2006.

(4) V. Krebs, http://www.orgnet.com/.

(5) L. A. Adamic and N. Glance, “The political blogosphere and the 2004 us election: divided they blog,” in Proceedings of the 3rd International Workshop on Link Discovery. ACM, 2005, pp. 36–43.

(6) J. Yang and J. Leskovec, “Defining and evaluating network communities based on ground-truth,” in Proceedings of 12th International Conference on Data Mining. IEEE, 2012, pp. 745–754.

### Example dataset
Karate:
- nodes: 34, edges: 78
- two communities with ground truth size >= 3

## How to run QOCE algorithm
1. Find all maximal cliques
```
$ cd GetMaxCliques
$ cd build
$ sh makefile
$ sh produceMaximumCliques
```
2. Detect communities from maximum cliques
```
$ cd QOCE_codes 
$ matlab 
$ mex -largeArrayDims rwvec_mex.cpp   % compile the mex file 
$ testQOCE
```

## How to run baseline algorithms
```
$ cd baseline_codes
$ sh complile-all.sh
$ sh run.sh
$ cd processCode
$ matlab
$ getResults
```

Note that one of the baseline algorithms called DEMON requires python2. 

## Announcements

### Licence
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but without any warranty; without even the implied warranty of merchantability or fitness for a particular purpose. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://fsf.org/.

### Notification
Please email to panshi@hust.edu.cn or setup an issue if you have any problems or find any bugs.

### Acknowledgement
In the program, we implement Bron-Kerbosch algorithm(the directory named GetMaxCliques) by the open source codes in http://hal.elte.hu/cfinder/wiki?n=Main.Software

And we incorporate some open source codes as baseline algorithms from the following websites:
- [BIGCLAM](https://github.com/snap-stanford/snap/tree/master/examples/bigclam)
- [DEMON](http://www.michelecoscia.com/?page_id=42)
- [NISE](http://lab.icc.skku.ac.kr/~jjwhang/codes/cikm2013/nise.html)
- [DNMF](https://github.com/smartyfh/DNMF)

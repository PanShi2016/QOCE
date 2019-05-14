# QOCE
These codes are for our paper "Quadratic Optimization based Clique Expansion for Overlapping Community Detection"

## Requirements
Before compiling codes, the following software should be installed in your system.
- Matlab
- gcc (for Linux and Mac) or Microsoft Visual Studio (for Windows)

## Datasets Information
- GN benchmark refers to (1)
- LFR benchmark refers to (2) (available at http://sites.google.com/site/santofortunato/inthepress2/)
- Karate refers to (3), TerrorAttack and TerroristRel refer to (4),  Polbooks refers to (5), Polblogs refers to (6), Citeseer and Cora refer to (7)
- Amazon and DBLP refer to (8) (available at http://snap.stanford.edu/data/)

(1) M. Girvan and M. E. Newman, “Community structure in social and biological networks,” Proceedings of the National Academy of Sciences, vol. 99, no. 12, pp. 7821–7826, 2002.

(2) A. Lancichinetti, S. Fortunato, and F. Radicchi, “Benchmark graphs for testing community detection algorithms,” Physical Review E, vol. 78, no. 4, p. 046110, 2008.

(3) W. W. Zachary, “An information flow model for conflict and fission in small groups,” Journal of Anthropological Research, vol. 33, no. 4, pp. 452–473, 1977.

(4) B. Zhao, P. Sen, and L. Getoor, “Entity and relationship labeling in affiliation networks,” in ICML Workshop on Statistical Network Analysis, 2006.

(5) V. Krebs, http://www.orgnet.com/.

(6) L. A. Adamic and N. Glance, “The political blogosphere and the 2004 us election: divided they blog,” in Proceedings of the 3rd International Workshop on Link Discovery. ACM, 2005, pp. 36–43.

(7) P. Sen, G. Namata, M. Bilgic, L. Getoor, B. Galligher, and T. Eliassi-Rad, “Collective classification in network data,” AI Magazine, vol. 29, no. 3, pp. 93–106, 2008.

(8) J. Yang and J. Leskovec, “Defining and evaluating network communities based on ground-truth,” in Proceedings of 12th International Conference on Data Mining. IEEE, 2012, pp. 745–754.

### Example dataset
- Karate dataset
- nodes: 34, edges: 78
- two communities with ground truth size >= 3

## How to run QOCE algorithm
1. Find all maximal cliques
```
$ cd GetMaxCliques
$ Set the minimum size of clique "minimumCliqueSize" in code called "find_cliques.cpp"
$ cd build
$ sh makefile
$ sh produceMaximumCliques
```
2. Detect communities from maximum cliques
```
$ cd QOCE_codes 
$ matlab 
$ mex -largeArrayDims rwvec_mex.cpp   % compile the mex file 
$ QOCE(k0,alpha) 
```
Command Options:

minimumCliqueSize: minimum size of clique (default: 3)

k0: steps of random walk for sampling (default: 3)

alpha: a parameter controls quadratic optimization (default: 0.2)

## How to run baseline algorithms
```
$ cd baseline_codes
$ sh complile-all.sh
$ sh run.sh
```

## Announcements

### Licence
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but without any warranty; without even the implied warranty of merchantability or fitness for a particular purpose. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://fsf.org/.

### Notification
Please email to panshi@hust.edu.cn or setup an issue if you have any problems or find any bugs.

### Acknowledgement
In the program, we incorporate some open source codes as baseline algorithms from the following websites:
- [BIGCLAM](http://snap.stanford.edu/snap/download.html) codes in the SNAP distribution package
- [CFinder](http://hal.elte.hu/cfinder/wiki/?n=Main.Software)
- [DEMON](http://www.michelecoscia.com/?page_id=42)
- [NISE](http://lab.icc.skku.ac.kr/~jjwhang/codes/cikm2013/nise.html)

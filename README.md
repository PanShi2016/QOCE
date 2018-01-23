# SSCE
These codes are for our paper "Spectral Subspace based Clique Expansion for Global Community Detection"
## Requirements
Before compiling codes, the following software should be installed in your system.
- Matlab
- gcc (for Linux and Mac) or Microsoft Visual Studio (for Windows)
## Datasets Information
- LFR benchmark graphs (available at http://sites.google.com/site/santofortunato/inthepress2/)
- Amazon dataset (available at http://snap.stanford.edu/data/)
- Citeseer and Cora refer to (1), Senate refers to (2), and HS as well as SC refer to (3)  

 (1) P. Sen, G. Namata, M. Bilgic, L. Getoor, B. Galligher, T. Eliassi-Rad, Collective classification in network data, AI Magazine 29 (3) (2008) 93-106.

 (2) D. Gleich, K. Kloster, Seeded pagerank solution paths, European Journal of Applied Mathematics 27 (6) (2016) 812–845.

 (3) D. Park, R. Singh, M. Baym, C.-S. Liao, B. Berger, Isobase: a database of functionally related proteins across ppi networks, Nucleic acids research 39 (2010) D295–D300.

### Example dataset
- Amazon dataset (available at http://snap.stanford.edu/data/com-Amazon.html)
- nodes: 334863, edges: 925872 
- nodes are products, edges are co-purchase relationships
- top 5000 communities with ground truth size >= 3
## How to run
```
$ cd LLSA_codes 
$ matlab 
$ mex -largeArrayDims GetLocalCond.c   % compile the mex file 
$ mex -largeArrayDims hkgrow_mex.cpp   % compile the mex file 
$ LLSA(k,alpha) 
```
### Command Options:

k: number of Lanczos iteration (default: 4)

alpha: a parameter controls local minimal conductance (default: 1.03)
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
- [GCE](https://sites.google.com/site/greedycliqueexpansion/)
- [LC](https://github.com/bagrow/linkcomm)
- [NISE](http://lab.icc.skku.ac.kr/~jjwhang/codes/cikm2013/nise.html)
- [OSLOM](http://www.oslom.org/index.html)

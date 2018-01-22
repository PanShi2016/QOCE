#
# hold-out likelihood (Mon Jan 22 00:04:02 2018)
#

set title "hold-out likelihood"
set key bottom right
set autoscale
set grid
set xlabel "communities"
set ylabel "likelihood"
set tics scale 2
set terminal png font arial 10 size 1000,800
set output '../example/Citeseer/BigClam.gen.CV.likelihood.png'
plot 	"../example/Citeseer/BigClam.gen.CV.likelihood.tab" using 1:2 title "" with linespoints pt 6

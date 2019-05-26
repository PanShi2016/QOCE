#
# hold-out likelihood (Sun May 26 19:29:51 2019)
#

set title "hold-out likelihood"
set key bottom right
set autoscale
set grid
set xlabel "communities"
set ylabel "likelihood"
set tics scale 2
set terminal png font arial 10 size 1000,800
set output '../example/Karate/BigClam.gen.CV.likelihood.png'
plot 	"../example/Karate/BigClam.gen.CV.likelihood.tab" using 1:2 title "" with linespoints pt 6

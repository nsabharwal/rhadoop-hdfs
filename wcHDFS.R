Sys.setenv(HADOOP_CMD='/usr/lib/hadoop/bin/hadoop')

# You can download hadoop streaming jar from http://www.java2s.com/Code/Jar/h/Downloadhadoopstreamingjar.htm
# cd /tmp
#wget http://www.java2s.com/Code/JarDownload/hadoop-streaming/hadoop-streaming.jar.zip
# unzip hadoop-streaming.jar.zip
# cp  hadoop-streaming.jar /tmp
 Sys.setenv(HADOOP_STREAMING='/tmp/hadoop-streaming.jar')
 #Sys.setenv(mapreduce.task.io.sort.mb=64)
 #options(java.parameters = "-Xmx4000m")
 library(rhdfs)
 hdfs.init()
 library(rmr2) 
 bp = rmr.options("backend.parameters")
 trans <- list(D="mapreduce.task.io.sort.mb=64")
 bp <- list(hadoop=trans) 
 bp$hadoop[1]="mapreduce.task.io.sort.mb=64" 
 rmr.options(backend.parameters = bp)
 rmr.options("backend.parameters") 
 hdfs.init()
 system("hadoop fs -rmr /tmp/output2")
 wordcount = function(input, output = '/tmp/output2', pattern = " ") {
     wc.map = function(., lines) {
       keyval(unlist(strsplit(x = lines, split = pattern)),1)
     }
  
     wc.reduce = function(word, counts ) {
       keyval(word, sum(counts))
     }
  
     mapreduce(
       input = input,
       output = output,
       input.format = "text",
       map = wc.map,
       reduce = wc.reduce,
       combine = T
     )
 }
  
 ## Call the wordcount function with path of the input file
 wordcount('/tmp/a.txt')

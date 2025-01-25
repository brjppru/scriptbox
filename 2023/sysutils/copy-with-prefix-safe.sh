find . \*.tar.gz >file1; for i in `cat file1`; do mkdir -p $prefix`$dirname $i`; cp $i $prefix/`dirname $i`; done

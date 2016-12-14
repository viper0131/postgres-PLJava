SET pljava.libjvm_location TO '/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server/libjvm.so';
ALTER DATABASE postgres SET pljava.libjvm_location FROM CURRENT;
CREATE EXTENSION pljava;
SHOW search_path;
SELECT sqlj.get_classpath('javatest');

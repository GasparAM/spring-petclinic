
PVER=$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout | awk 'BEGIN {FS="-"} ; {print $1}')
DVER=$(echo ${PVER} | awk 'BEGIN {FS="."}; {print $1"."$2"."$3 + 1}')

./mvnw -B release:prepare -Dtag=$PVER -DreleaseVersion=$PVER -DdevelopmentVersion="${DVER}-SNAPSHOT" &&
./mvnw release:perform -Darguments="-Dmaven.deploy.skip=true"
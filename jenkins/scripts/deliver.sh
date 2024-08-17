# #!/usr/bin/env bash

# echo 'The following Maven command installs your Maven-built Java application'
# echo 'into the local Maven repository, which will ultimately be stored in'
# echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
# echo 'volume).'
# set -x
# mvn jar:jar install:install help:evaluate -Dexpression=project.name
# set +x

# echo 'The following command extracts the value of the <name/> element'
# echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
# set -x
# NAME=`mvn -q -DforceStdout help:evaluate -Dexpression=project.name`
# set +x

# echo 'The following command behaves similarly to the previous one but'
# echo 'extracts the value of the <version/> element within <project/> instead.'
# set -x
# VERSION=`mvn -q -DforceStdout help:evaluate -Dexpression=project.version`
# set +x

# echo 'The following command runs and outputs the execution of your Java'
# echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
# set -x
# java -jar target/${NAME}-${VERSION}.jar

#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x

# Install the Maven-built Java application
if ! mvn jar:jar install:install help:evaluate -Dexpression=project.name; then
    echo "Error: Failed to install the Maven-built Java application."
    exit 1
fi

set +x

echo 'The following command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name)
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract project name from pom.xml."
    exit 1
fi
set +x

echo 'The following command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract project version from pom.xml."
    exit 1
fi
set +x

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
set -x
if ! java -jar target/${NAME}-${VERSION}.jar; then
    echo "Error: Failed to run the Java application."
    exit 1
fi

echo "Delivery successful!"

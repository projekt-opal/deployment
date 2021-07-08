#!/bin/sh

mkdir -p opal-2020-10
cd opal-2020-10
wget https://hobbitdata.informatik.uni-leipzig.de/OPAL/OpalGraph/2020-11-18/2020-10/edp.tar.gz &
wget https://hobbitdata.informatik.uni-leipzig.de/OPAL/OpalGraph/2020-11-18/2020-10/govdata.tar.gz &
wget https://hobbitdata.informatik.uni-leipzig.de/OPAL/OpalGraph/2020-11-18/2020-10/mcloud-1.ttl.tar.gz &
wget https://hobbitdata.informatik.uni-leipzig.de/OPAL/OpalGraph/2020-11-18/2020-10/mdm-1.ttl.tar.gz &
wait
tar -xzf mdm-1.ttl.tar.gz &
tar -xzf mcloud-1.ttl.tar.gz &
tar -xzf govdata.tar.gz &
tar -xzf edp.tar.gz &
wait
cd ..

mkdir -p opal-2020-06
cd opal-2020-06
wget https://hobbitdata.informatik.uni-leipzig.de/OPAL/OpalGraph/2020-10-22/2020-06/mdm-1.ttl.tar.gz &
wget https://hobbitdata.informatik.uni-leipzig.de/OPAL/OpalGraph/2020-10-22/2020-06/mcloud-1.ttl.tar.gz &
wget https://hobbitdata.informatik.uni-leipzig.de/OPAL/OpalGraph/2020-10-22/2020-06/govdata.tar.gz &
wget https://hobbitdata.informatik.uni-leipzig.de/OPAL/OpalGraph/2020-10-22/2020-06/edp.tar.gz &
wait
tar -xzf mdm-1.ttl.tar.gz &
tar -xzf mcloud-1.ttl.tar.gz &
tar -xzf govdata.tar.gz &
tar -xzf edp.tar.gz &
wait
cd ..

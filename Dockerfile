FROM ubuntu:16.04 

RUN apt-get update -y && apt-get upgrade

#for handling errors
RUN apt-get install -y apt-transport-https apt-utils software-properties-common

#required dependencies
RUN apt-get update -y && apt-get install -y build-essential libssl-dev libffi-dev  libsasl2-dev libldap2-dev libxi-dev
#install python3
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update -y && apt-get install -y python3.6
RUN apt-get install python3.6-dev python3-pip


#installing latest pip and setup-tools libraries
RUN python3.6 -m pip install --upgrade setuptools pip wheel

#installing superset
RUN python3.6 -m pip install superset

#setting environment variables
RUN export LC_ALL=C.UTF-8 && export LANG=C.UTF-8

# Create an admin user 
RUN fabmanager create-admin --app superset --username heimdall --firstname couture --lastname developer --email hello@couture.ai --password couture@1234 

# Initialize the database
RUN superset db upgrade

# Create default roles and permissions
RUN superset init
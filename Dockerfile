FROM ubuntu:16.04 

#-------------setting environment variables-------------
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    SUPERSET_HOME=/usr/local/lib/python3.6/dist-packages/superset \
    SUPERSET_DB=/home/couture/.superset \
    SUPERSET_USERNAME=heimdall \
    SUPERSET_PASSWORD=couture@1234 \
    SUPERSET_EMAIL=hello@couture.ai \
    SUPERSET_FIRSTNAME=couture \
    SUPERSET_LASTNAME=developer 

RUN apt-get update -y

#standard apt packages
RUN apt-get install -y apt-transport-https apt-utils software-properties-common

#--------------install required dependencies--------------
RUN apt-get install -y build-essential libssl-dev libffi-dev  libsasl2-dev libldap2-dev libxi-dev libmysqlclient-dev

#----------install python3 and development tools----------
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update -y && apt-get install -y python3.6
RUN apt-get install python3.6-dev python3-pip python-dev -y
RUN python3.6 -m pip install --upgrade setuptools pip wheel

#------install python packages from requirements.txt------
COPY ./requirements.txt /
RUN python3.6 -m pip install -r  requirements.txt

#installing superset
RUN python3.6 -m pip install superset

#-------------New user creation and ownership-------------
RUN useradd -U -m couture && \
    chown -R couture:couture ${SUPERSET_HOME} 
USER couture:couture

#---------------Application specific changes---------------
# Create an admin user for superset
RUN fabmanager create-admin --app superset \
 --username ${SUPERSET_USERNAME} \
 --firstname ${SUPERSET_FIRSTNAME} \
 --lastname ${SUPERSET_LASTNAME} \
 --email ${SUPERSET_EMAIL} \
 --password ${SUPERSET_PASSWORD} 

# Initialize the database
RUN superset db upgrade

# Create default roles and permissions
RUN superset init

#to change app_name and app_logo
COPY ./config.py ${SUPERSET_HOME}/
#copying logo and favicon
COPY ./couture-logo.png ${SUPERSET_HOME}/static/assets/images/
COPY ./favicon.png ${SUPERSET_HOME}/static/assets/images/
#changing the default redirect
COPY ./__init__.py ${SUPERSET_HOME}/
#changing the target of onclick on logo
COPY ./navbar.html ${SUPERSET_HOME}/templates/appbuilder/

# VOLUME ["supersetdb:/root/.superset/"]

#------------------Expose required Ports------------------
EXPOSE 8088

#-----------------Run Superset Application-----------------
CMD ["superset", "runserver", "-d"]
#docker run --name CONTAINER-NAME -tid -p 8088:8088 -v supersetdb:/home/couture/.superset image:tag
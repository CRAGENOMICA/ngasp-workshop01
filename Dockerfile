# ==============================================================================
# NGASP DOCKERFILE
# ==============================================================================
# Usage:
#
#   - Build : docker build -t ngasp .
#   - Run   : xhost +
#             docker run --rm --net host ngasp

# ==============================================================================
# BASE IMAGE
# ==============================================================================

FROM node:8.15.0 AS build-env

LABEL maintainer="Héctor Gracia <hector.gracia@cragenomica.es>"

ADD . /app
WORKDIR /app

FROM gcr.io/distroless/nodejs
COPY --from=build-env /app /app

# ==============================================================================
# ENV REQUIREMENTS
# ==============================================================================

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-3.b12.el7_3.x86_64/jre
ENV PATH "/app/gradle/gradle-3.1/bin:${PATH}"
ENV OPEN_MPI_HOME /opt/lib/openmpi
ENV LD_LIBRARY_PATH "/opt/lib/openmpi/lib:${LD_LIBRARY_PATH}"
ENV PATH "/opt/lib/openmpi/bin:${PATH}"
VOLUME ["/tmp/.X11-unix", "/tmp/.X11-unix"]
ENV DISPLAY :0.0
RUN export DISPLAY=:0.0

# ==============================================================================
# Compilation
# ==============================================================================

# para que continue funcionando todo hace falta que exista la carpeta develop y
# contenga todo lo que hay en src
RUN mkdir /develop 
COPY ./src /develop

RUN /bin/bash /develop/librerias/ngasp-libraries.sh

#Añado compilacion de las librerias
#RUN /bin/bash /develop/compile_all.sh

# ==============================================================================
# START
# ==============================================================================

WORKDIR /develop/webapp
#ENTRYPOINT ["/develop/webapp/start_ngasp.sh"]
ENTRYPOINT ["/bin/bash"]
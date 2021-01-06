FROM ruby:2.6.6

# install essential packages
RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn

# build libpostal
ARG COMMIT
ENV COMMIT ${COMMIT:-master}
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y autoconf automake build-essential git libsnappy-dev libtool pkg-config
RUN git clone https://github.com/openvenues/libpostal -b $COMMIT
COPY ./*.sh /libpostal/
WORKDIR /libpostal
RUN ./build_libpostal.sh

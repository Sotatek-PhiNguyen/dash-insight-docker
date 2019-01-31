FROM tbaltrushaitis/ubuntu-nodejs:v8.11.4

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libzmq3-dev

ADD https://github.com/dashpay/dash/releases/download/v0.13.0.0/dashcore-0.13.0.0-x86_64-linux-gnu.tar.gz /tmp/
RUN tar -xvf /tmp/dashcore-*.tar.gz -C /tmp/
RUN cp /tmp/dashcore*/bin/*  /usr/local/bin
RUN rm -rf /tmp/dashcore*

ENV APP_HOME /home/node/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN npm -g config set user root
RUN npm i -g @dashevo/dashcore-node
RUN dashcore-node create mynode
WORKDIR $APP_HOME/mynode
RUN dashcore-node install @dashevo/insight-api
RUN dashcore-node install @dashevo/insight-ui
COPY mynode/data/dash.conf ./data/dash.conf
COPY mynode/dashcore-node.json ./dashcore-node.json

EXPOSE 8332 3001 28332

ENTRYPOINT dashcore-node start
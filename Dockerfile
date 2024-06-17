# docker run -p 8080:8080 --rm docker-test
# debug:
#   docker images "docker-test"

FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:20.6.1-slim as base

EXPOSE 8080

####################################################################################
# building the app
# docker build . -t docker-test-dev --target=dev

# getting nodemon changes requires a bind mount. it is two directional.
# docker run -p 8080:8080 --rm --mount type=bind,source=./,target=/opt/node_app/app docker-test-dev

FROM base as dev

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-amd64 /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# "Lift" node_module installation
WORKDIR /opt/node_app/

COPY package.json ./
# we actually don't really want package-lock.json to be copied since it's OS dependent
# COPY package-lock.json ./

RUN npm install

# add the lifted node_modules to the path
ENV PATH /opt/node_app/node_modules/.bin:$PATH

# now switch to the actual code
WORKDIR /opt/node_app/app

# Bundle app source
COPY . .

CMD [ "nodemon", "server.js" ]

####################################################################################
# docker build . -t docker-test-prod --target=prod

FROM base as prod
# "Lift" node_module installation
WORKDIR /opt/node_app/

COPY package.json ./
# we actually don't really want package-lock.json to be copied since it's OS dependent
# COPY package-lock.json ./

RUN npm install --omit=dev

# add the lifted node_modules to the path
ENV PATH /opt/node_app/node_modules/.bin:$PATH

# now switch to the actual code
WORKDIR /opt/node_app/app

# Bundle app source
COPY . .

CMD [ "node", "server.js" ]


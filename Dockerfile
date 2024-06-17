# docker run -p 8080:8080 --rm docker-test
# debug:
#   docker images "docker-test"

FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:20.6.1-slim as base

EXPOSE 8080

####################################################################################
# docker build . -t docker-test-dev --target=dev
# docker run -p 8080:8080 --rm docker-test-dev

FROM base as dev

# "Lift" node_module installation
WORKDIR /opt/node_app/

COPY package.json ./
COPY package-lock.json ./

RUN npm install

# add the lifted node_modules to the path
ENV PATH /opt/node_app/node_modules/.bin:$PATH

# now switch to the actual code
WORKDIR /opt/node_app/app

# Bundle app source
COPY . .

CMD [ "npm", "run", "dev" ]

####################################################################################
# docker build . -t docker-test-prod --target=prod

FROM base as prod
# "Lift" node_module installation
WORKDIR /opt/node_app/

COPY package.json ./
COPY package-lock.json ./

RUN npm install --omit=dev

# add the lifted node_modules to the path
ENV PATH /opt/node_app/node_modules/.bin:$PATH

# now switch to the actual code
WORKDIR /opt/node_app/app

# Bundle app source
COPY . .

CMD [ "node", "server.js" ]

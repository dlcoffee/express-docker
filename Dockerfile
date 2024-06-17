# docker run -p 8080:8080 --rm docker-test
# debug:
#   docker images "docker-test"
#   docker run --rm -it --entrypoint sh docker-test-dev
#   docker container exec -it docker-test-dev sh

####################################################################################
FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:20.6.1-slim as base

WORKDIR /opt/node_app/app

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

# "Lift" node_module installation. Since we bind mount, the node_modules/ in the container get overshadowed
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

# CMD [ "nodemon", "server.js" ] recommended approach since tini works better with it
CMD ["npm", "run", "dev"]


####################################################################################
# this stage is responsible for installing stuff for prod
FROM base as builder

COPY package.json ./
# we actually don't really want package-lock.json to be copied since it's OS dependent
# COPY package-lock.json ./

# install everything!
RUN npm install

COPY . .

RUN npm run build


####################################################################################
# docker build . -t docker-test-prod --target=prod

# running the production build
# docker run -p 8080:8080 --rm docker-test-prod

FROM builder as prod

WORKDIR /opt/node_app/app

ENV NODE_ENV production

COPY package.json ./

RUN npm install --omit=dev

COPY --from=builder /opt/node_app/app/dist/ dist/

CMD [ "node", "dist/server.js" ]


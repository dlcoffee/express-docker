# express-docker

this is a example repo of developing an express + typescript application
through docker.

## goals

- be able to develop locally
- continue having a package-lock.json for production builds

## installing packages

- running `npm install` on host machine will install dependencies in the host's
  `node_modules/` folder. we don't really need it if we're developing through
  docker. all we really need is for `package.json` to update properly.
  - if doing this approach, we need to rebuild the image so that it
    can be installed.
- if you're on windows then DO NOT commit package-lock.json

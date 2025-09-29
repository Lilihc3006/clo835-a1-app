# CLO835 Assignment 1 App

This repo contains:
- Minimal Flask app (uses COLOR env var, listens on 8080)
- Dockerfile.app and Dockerfile.mysql
- GitHub Actions workflow to build and push images to AWS ECR on merge to master

## Local test
docker build -t local-web -f Dockerfile.app .
docker run -p 8081:8080 -e COLOR=blue local-web

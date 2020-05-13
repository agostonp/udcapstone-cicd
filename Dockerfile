FROM nginx:stable

## Step 1:
# Create a working directory
WORKDIR /data

## Step 2:
# Copy source code to working directory
COPY README.md /data/
COPY www /data/www
COPY nginx /data/nginx

## Step 3:
# Install dependencies (if any)
# hadolint ignore=DL3013
#RUN apt-get update -y
#RUN apt-get install -y make
#RUN make install

## Step 4:
# Expose port 80
EXPOSE 80

## Step 5:
# Run nginx at container launch
CMD ["nginx", "-c=/data/nginx/nginx.conf"]

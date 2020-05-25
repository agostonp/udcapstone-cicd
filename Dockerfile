FROM nginx:stable

## Step 1:
# Create a working directory
WORKDIR /data

## Step 2:
# Copy source code to working directory
COPY README.md /data/
COPY images /data/images
COPY www /data/www
COPY nginx /etc/nginx

## Step 3:
# Install dependencies (if any)
# hadolint ignore=DL3013
#RUN apt-get update -y
#RUN apt-get install -y make
#RUN make install

## Step 4:
# Expose port 8000
EXPOSE 8000

## Step 5:
# Run nginx at container launch
CMD ["nginx", "-g", "daemon off;"]
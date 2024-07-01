FROM alpine:3.17

# Update Alpine packages and install nginx
RUN apk update && apk upgrade && apk add --no-cache nginx

# Expose port 443 for HTTPS traffic
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
# Start nginx in the foreground as the main container process

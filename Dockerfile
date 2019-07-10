FROM amazonlinux

# initial setup
RUN yum -y upgrade
RUN yum -y install sed curl vim sudo net-tools procps apt-transport-https wget

# install amazon nginx
RUN amazon-linux-extras install -y nginx1.12

# Set up some server stuff
RUN mkdir /app && mkdir /etc/sigsci

# Step 1 - Add the Package Repositories RedHat CentOS 7
COPY /app/sigsci.repo /etc/yum.repos.d/sigsci.repo
#RUN yum update
RUN yum -y install nginx-module-lua-amzn-1.12.2

# Step 2 - Install the Signal Sciences Agent Package
RUN sudo yum -y install sigsci-agent

# Step 3 - Install the sigsci module
RUN yum -y install sigsci-module-nginx

COPY /app/nginx.conf /etc/nginx/nginx.conf
COPY app/index.html /var/www/html/index.html
COPY app/default.conf /etc/nginx/sites-enabled/default.conf
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENTRYPOINT ["/app/start.sh"]

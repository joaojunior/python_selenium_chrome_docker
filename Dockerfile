FROM ubuntu:18.04 AS chrome
RUN apt-get update && apt-get install -y \
    libgconf2-4 libxss1 libappindicator3-1 \
    libasound2 libnspr4 libnss3 \
    fonts-liberation libappindicator1 xdg-utils \
    software-properties-common \
    curl unzip wget \
    xvfb \
    && rm -rf /var/lib/apt/lists/*
# install chromedriver
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/bin
RUN chmod +x /usr/bin/chromedriver
# install chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome*.deb
RUN apt-get install -y -f
RUN ln -s /opt/google/chrome/google-chrome /usr/bin/chrome
# set chrome to start with --no-sandbox to root user
RUN sed -i 's/exec -a \"$0\" \"$HERE\/chrome\" \"$@\"/exec -a \"$0\" \"$HERE\/chrome\" \"$@\" --no-sandbox/g' /usr/bin/google-chrome

FROM chrome AS python3_chrome
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install -y \
    python3 python3-pip\
    && rm -rf /var/lib/apt/lists/*
WORKDIR /code
ADD requirements.txt /code
RUN pip3 install -r requirements.txt
ADD run_chrome.py /code
CMD python3 run_chrome.py

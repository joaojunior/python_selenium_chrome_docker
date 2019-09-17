# Introduction

Sometimes, when I execute the Chrome inside a docker container I receive the error below:
```
selenium.common.exceptions.WebDriverException: Message: unknown error: Chrome failed to start: crashed
```
After looking for about this error, I didn't find good information about it. After I found the root problem I write this post to describe the problem and the solution.

# Root problem
The problem is caused because Chrome uses the `/dev/shm` to share memory and the docker, by default, set 64MB for this partition.

# How to reproduce the error
We need to get this repository and create the docker image with the command:
```
docker build -t python_selenium_chrome .
```

After creating the image, we need to run the container with the command:
```
docker run --shm-size=1b -it python_selenium_chrome bash
```
Obs.: This command says to docker set the `/dev/shm` with 1 byte only to show the problem.

Then, we run the file that calls the chrome:
```
python run_chrome.py
```

# How to resolve the problem
We only need to set the correct value to `/dev/shm` with the command:
```
docker run --shm-size=1g -it python_selenium_chrome bash
```
Then, we run the file that calls the chrome:
```
python run_chrome.py
```
# References
We can get the information about the `/dev/shm` and Chrome in [1]. To check the default values and how to set
the `/dev/shm` in docker, we can read [2].

- [1] https://developers.google.com/web/tools/puppeteer/troubleshooting
- [2] https://docs.docker.com/engine/reference/run/
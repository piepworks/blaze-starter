FROM python:3.11.4

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /code

WORKDIR /code

# install Git and Node
RUN apt-get update && \
    apt-get install -y git && \
    apt-get remove nodejs npm && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash && \
    apt-get install -y nodejs

# Install Litestream
RUN wget https://github.com/benbjohnson/litestream/releases/download/v0.3.8/litestream-v0.3.8-linux-amd64.deb \
    && dpkg -i litestream-v0.3.8-linux-amd64.deb

COPY requirements/requirements.txt /tmp/requirements.txt

RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/

COPY . /code/

EXPOSE 8000

RUN npm i && npm run build

CMD ["/code/start.sh"]

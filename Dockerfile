FROM python:3

RUN groupadd -r hc && useradd -r -m -g hc hc

# Install deps
RUN apt-get update \
    && apt-get install -y \
        default-libmysqlclient-dev\
        python3-setuptools \
        python3-pip \
        python3-psycopg2 \
        python3-dev\
        python3-rcssmin \
        python3-rjsmin \
        python3-mysqldb \
        uwsgi \
        uwsgi-plugin-python3 \
        --no-install-recommends \
    && pip3 install --no-cache-dir braintree raven==5.33.0 \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/*

WORKDIR /app

ADD . /app/
RUN pip3 install -r requirements.txt
RUN python3 manage.py migrate
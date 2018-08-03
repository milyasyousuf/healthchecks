FROM ubuntu:yakkety

RUN groupadd -r hc && useradd -r -m -g hc hc

# Install deps
RUN set -x && apt-get -qq update \
    && apt-get install -y \
        python3-setuptools \
        python3-pip \
        python3-psycopg2 \
        python3-rcssmin \
        python3-rjsmin \
        python3-mysqldb \
        uwsgi \
        uwsgi-plugin-python3 \
        --no-install-recommends \
    && pip3 install --no-cache-dir -r /app/requirements.txt \
    && pip3 install --no-cache-dir braintree raven==5.33.0 \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/*

WORKDIR /app

COPY . /app/
RUN python3 manage.py collectstatic --noinput && python3 manage.py compress
RUN python3 manage.py migrate
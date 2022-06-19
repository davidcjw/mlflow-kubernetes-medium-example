FROM python:3.8-slim-bullseye

ARG WORKDIR=/mlflow
RUN mkdir /mlflow
WORKDIR ${WORKDIR}

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN echo "export LC_ALL=$LC_ALL" >> /etc/profile.d/locale.sh
RUN echo "export LANG=$LANG" >> /etc/profile.d/locale.sh

COPY requirements.txt ${WORKDIR}
RUN pip install -U pip && \
  pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

ARG DB_CONN=postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:5432/${DB_NAME}

ENTRYPOINT mlflow server \
  --host=0.0.0.0 \
  --port=8080 \
  --backend-store-uri=${DB_CONN} \
  --default-artifact-root=${DEFAULT_ARTIFACT_ROOT}
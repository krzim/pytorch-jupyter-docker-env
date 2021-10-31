FROM jupyter/base-notebook

WORKDIR /tmp

RUN pip install --no-cache-dir torch torchvision torchaudio torchviz


# kite engine for enhanced autocomplete
USER root
ENV KITE_ROOT /home/jovyan/.local/share/kite
WORKDIR $KITE_ROOT
# COPY --chmod=770 kite-installer.sh ./
# RUN ./kite-installer.sh
COPY --chmod=770 ./kite-updater-2.20210610.0.sh ./
RUN ./kite-updater-2.20210610.0.sh --target $KITE_ROOT/kite-v2.20210610.0/
COPY --chmod=770 ./kited $KITE_ROOT

USER jovyan
RUN pip install --no-cache-dir "jupyterlab>=3.0.14" "jupyterlab-kite>=2.0.2" xeus-python supervisor

WORKDIR /home/jovyan/
COPY supervisord.conf /etc/supervisor/conf.d/

CMD ln -s $KITE_ROOT/kite-v2.20210610.0 $KITE_ROOT/current && supervisord -c /etc/supervisor/conf.d/supervisord.conf
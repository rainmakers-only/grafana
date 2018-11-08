FROM rainmakersonly/grafana:heroku_deploy

USER root

RUN apt-get update && apt-get install -qq -y bash && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

USER grafana

ENTRYPOINT ["/bin/bash"]

CMD ["/run.sh"]

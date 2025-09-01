FROM python:alpine

# ARG USER=dev

RUN adduser -D -s $(which ash) dev

USER dev

# NOTE: HOME may not have been set yet. Is this intended, a bug, or a new feature idea?
ENV HOME /home/dev
WORKDIR /home/dev
ENV PATH="$HOME/.local/bin:$PATH"

RUN pip install llm && \
    set -x && \
    # llm install llm-openrouter && \
    set +x

ENTRYPOINT [ "llm" ]
CMD [ "--help" ]

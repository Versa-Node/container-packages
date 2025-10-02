FROM docker.io/jupyter/scipy-notebook:latest

# Install PyCaret and useful extras
USER root
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir pycaret psycopg2-binary sqlalchemy ipywidgets plotly scikit-plot

# Small wrapper to allow optional EXTRA_PIP_PACKAGES at runtime
USER $NB_UID
COPY start-vncp.sh /usr/local/bin/start-vncp
RUN chmod +x /usr/local/bin/start-vncp

# Labels
LABEL org.opencontainers.image.title="vncp-pycaret-notebook" \
      org.opencontainers.image.source="https://github.com/Versa-Node/container-packages" \
      org.opencontainers.image.keywords="versanode-controller-package,versanode,controller,package,jupyter,pycaret" \
      io.versanode.kind="controller-package" \
      org.opencontainers.image.documentation="https://github.com/Versa-Node/container-packages/tree/main/packages/vncp-pycaret-notebook#readme"

# Default command
CMD ["start-vncp"]

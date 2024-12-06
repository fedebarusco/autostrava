    FROM python:3.12.7-bullseye AS builder

    RUN pip install poetry==1.8.3

    ENV POETRY_NO_INTERACTION=1
    ENV POETRY_VIRTUALENVS_IN_PROJECT=1
    ENV POETRY_VIRTUALENVS_CREATE=1

    WORKDIR /opt/pysetup

    COPY pyproject.toml poetry.lock ./

    RUN poetry install --without dev

    # --------------------------------------------------

    FROM builder AS dev

    RUN poetry install

    ENV PATH="/opt/pysetup/.venv/bin:$PATH"
    ENV PYTHONPATH="/app:$PYTHONPATH"

    WORKDIR /app

    RUN playwright install
    RUN playwright install-deps 

    # --------------------------------------------------

    FROM python:3.12.7-slim-bullseye AS runtime

    ENV VIRTUAL_ENV="/opt/pysetup/.venv"
    ENV PATH="$VIRTUAL_ENV/bin:$PATH"

    COPY --from=builder $VIRTUAL_ENV $VIRTUAL_ENV
    COPY . /app/

    WORKDIR /app

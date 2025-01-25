.PHONY: clean

FETCH_CMD=curl -O
PYTHON=python
DISTRIBUTE_URL=http://nightly.ziade.org/distribute_setup.py
NOSE=nosetests

all: test sdist

sdist:
	${PYTHON} setup.py sdist

test:
	@${NOSE}

fetch_distribute:
	${FETCH_CMD} ${DISTRIBUTE_URL}

clean:
	find . -name "*.pyc" -print -delete


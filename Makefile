#!/usr/bin/make -f
SHELL=/bin/sh

DOCKER_IMAGE=jupyterdocker_jupyter
DESTDIR?=/usr/local
prefix?=${DESTDIR}
EXEC_FILES=\
	bin/jupyter-notebook

.PHONY: all
all:
	@echo "usage: make install"
	@echo "       make uninstall"

.PHONY: install
install: build
	install -d -m 0755 $(prefix)/bin
	install -m 0755 $(EXEC_FILES) $(prefix)/bin

.PHONY: uninstall
uninstall:
	docker inspect --type=image $(DOCKER_IMAGE) &> /dev/null && docker rmi $(DOCKER_IMAGE) || true
	test -d $(prefix)/bin && \
	cd $(prefix) && \
	rm -f $(EXEC_FILES)

.PHONY: build
build:
	docker-compose build

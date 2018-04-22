#!/usr/bin/make -f
SHELL=/bin/sh

DOCKER_IMAGE=jupyterdocker_jupyter
DESTDIR?=/usr/local
prefix?=${DESTDIR}
EXEC_FILES=\
	$(JUPYTER_NOTEBOOK)

JUPYTER_NOTEBOOK=bin/jupyter-notebook

.PHONY: all
all:
	@echo "usage: make install"
	@echo "       make uninstall"

.PHONY: install
install: $(prefix)/bin/jupyter-notebook

$(prefix)/$(JUPYTER_NOTEBOOK): build $(prefix)/bin
	install -m 0755 $(JUPYTER_NOTEBOOK) $(prefix)/bin

$(prefix)/bin:
	install -d -m 0755 $(prefix)/bin

.PHONY: uninstall
uninstall:
	docker inspect --type=image $(DOCKER_IMAGE) &> /dev/null && docker rmi $(DOCKER_IMAGE) || true
	test -d $(prefix)/bin && \
	cd $(prefix) && \
	rm -f $(EXEC_FILES)

.PHONY: build
build:
	docker-compose build

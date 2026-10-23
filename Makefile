PREFIX ?= /usr
QMLDIR ?= $(PREFIX)/lib/qt6/qml
DEST = $(DESTDIR)$(QMLDIR)/Twilight/Lock

install:
	install -d $(DEST)
	cp -r Twilight/Lock/. $(DEST)

uninstall:
	rm -rf $(DEST)

.PHONY: install uninstall

all: rpm deb


VERSION != cat Version

rpm:
	cat build/ssh-remote.spec.template | sed -e "s/{{ VERSION }}/${VERSION}/g" > build/ssh-remote.spec
	rpmbuild -ba --build-in-place build/ssh-remote.spec
	cp ${HOME}/rpmbuild/RPMS/noarch/ssh-remote-${VERSION}-1.noarch.rpm build/
deb:
	cat build/control.template | sed -e "s/{{ VERSION }}/${VERSION}/g" > build/control
	rm -r ssh-remote_$(VERSION)-1_all || echo Previous build does not exist
	mkdir ssh-remote_$(VERSION)-1_all
	mkdir -p ssh-remote_$(VERSION)-1_all/usr/lib/systemd/system
	cp src/systemd/ssh-remote@.service ssh-remote_$(VERSION)-1_all/usr/lib/systemd/system
	mkdir -p ssh-remote_$(VERSION)-1_all/etc/ssh-remote
	cp src/conf.d/ssh-remote.example ssh-remote_$(VERSION)-1_all/etc/ssh-remote/ssh-remote.example
	mkdir ssh-remote_$(VERSION)-1_all/DEBIAN
	cp build/control ssh-remote_$(VERSION)-1_all/DEBIAN/control
	dpkg-deb --build --root-owner-group ssh-remote_$(VERSION)-1_all
	rm -r ssh-remote_$(VERSION)-1_all
	mv ssh-remote_${VERSION}-1_all.deb build/

# DVD_mit_mplayer_kopieren

Mit diesem Skript mann man den Inhalt einer lesbaren DVD auf die lokale Festplatte kopieren.
----

Dazu muß aber (meistens) der CSS-Kode installiert werden.
Das darf nicht automatisch erfolgen und bedarf immer manuelle Aktionen!

----

Seit Ubuntu 18.04 gibt es eine Vereinfachung, um die Erweiterung zum lesen von css-verschlüsselten DVDs zu installieren.
Jetzt muss nur das Paket "libdvd-pkg" installiert und anschließend ausdrücklich konfiguriert werden:

    > apt install vlc vlc-l10n libdvd-pkg
    > dpkg-reconfigure libdvd-pkg

In FreeBSD müssen diese beiden Pakete aus dem Ports-Tree installiert werden.
Hierbei wird die Konfiguration des Paketes "libdvdread" vorher vorgenommen (css einschalten):

    > cd /usr/ports/multimedia/libdvdread/ && make config
    > cd /usr/ports/multimedia/libdvdread && make clean ; make && make install && make clean
    > cd /usr/ports/multimedia/mplayer && make clean ; make && make install && make clean

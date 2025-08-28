# Learnings for Future Docs

* MAAS [version should support OS version](https://canonical.com/maas/docs/supported-maas-versions):
    * MAAS 3.6 requires Ubuntu 24.
    * MAAS 3.5 does not work on Ubuntu 24.
* Prefer apt over Snap on Raspberry Pi
    * Snap's containerisation is very confined and might not allow relevant access.
    * Consider `--classic` install to avoid sandboxing.
* Building from source is quite expensive and might not be the best choice for Raspberry Pi.
* To avoid set up problems, ensure that both region and rack controler are running.
* CLI commands in official documentation seem to be for older versions of MAAS.

==============
Fog PXE Server
==============

.. image:: https://travis-ci.com/dlux/vagrant-fog.svg?branch=master
    :target: https://travis-ci.com/dlux/vagrant-fog

This project installs fog into a Centos7 Vagrant environment.
Soon to be integrated also on vagrant-network101 to integrate a full E2E

Setup - fog_min_setup.sh:

* No firewalld setup
* Disable SELinux
* Normal installation
* Uses eth0 as pxe interface
* No DHCP
* No DNS
* No language package installation
* Installs apache, mysql, php, tftp

Setup - fog_full_setup.sh:

* keep SELinux, configure firewalld, dhcp, and dns

FOG is a Linux-based, open source computer imaging solution for various versions of Windows, Linux, and MacOS.
It ties together few open source tools with a PHP-based web interface and TFTP and PXE.

To run
------

.. code-block:: bash

   $ git clone https://github.com/dlux/vagrant-fog.git
   $ cd vagrant-fog
   $ vagrant up

Open browser and go to http://localhost:8090


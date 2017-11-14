# This is the main state file for configuring openvpn.

{% from "openvpn/map.jinja" import map with context %}

# Install openvpn packages
openvpn_pkgs:
  pkg.installed:
    - pkgs:
      {% for pkg in map.pkgs %}
      - {{pkg }}
      {% endfor %}

# Generate diffie hellman files
{% for dh in map.dh_files %}
openvpn_create_dh_{{ dh }}:
  cmd.run:
    - name: openssl dhparam -out {{ map.conf_dir }}/dh{{ dh }}.pem {{ dh }}
    - creates: {{ map.conf_dir }}/dh{{ dh }}.pem
{% endfor %}


# Ensure openvpn service is running and autostart is enabled
{% for ovpn_service in map.service %}
openvpn_service_{{ ovpn_service }}:
  service.running:
    - name: {{ ovpn_service }}
    - enable: True
    - require:
      - pkg: openvpn_pkgs
{% endfor %}

#!/usr/bin/env python3

import csv
import json
import os
import sys
from typing import Tuple, List, Any, Dict

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_FILE_WITH_MACHINE_DATA = os.path.join(BASE_DIR, "../data/machines.csv")


def load_hosts(csv_path: str) -> Tuple[List[str], List[str], Dict[str, Dict[str, Any]]]:
    servers = []
    agents = []
    hostvars = {}

    with open(csv_path, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            hostname = row["hostname"].strip()
            is_master = row["is_k3s_master"].strip().lower() == "true"

            if is_master:
                servers.append(hostname)
            else:
                agents.append(hostname)

            hostvars[hostname] = {
                "ansible_host": hostname,  # use hostname as address
                "ansible_user": row["admin_user_name"],
            }

    return servers, agents, hostvars


def build_inventory(csv_path: str) -> Dict[str, Any]:
    servers, agents, hostvars = load_hosts(csv_path)

    inv = {
        # make sure 'all' knows about our top-level group
        "all": {
            "children": ["k3s_cluster"]
        },
        "k3s_cluster": {
            "children": ["server", "agent"],
        },
        "server": {"hosts": servers},
        "agent": {"hosts": agents},

        # hostvars for fast mode
        "_meta": {"hostvars": hostvars},
    }

    return inv


def main():
    # Ansible calls the script with --list or --host <name>
    if len(sys.argv) >= 2 and sys.argv[1] == "--list":
        print(json.dumps(build_inventory(CSV_FILE_WITH_MACHINE_DATA), indent=2))
        return

    if len(sys.argv) >= 3 and sys.argv[1] == "--host":
        # Return per-host vars (Ansible may call this even if _meta is present)
        _, _, hostvars = load_hosts(CSV_FILE_WITH_MACHINE_DATA)
        print(json.dumps(hostvars.get(sys.argv[2], {}), indent=2))
        return

    # If Ansible calls unexpectedly, just output an empty inventory
    print(json.dumps({}, indent=2))


if __name__ == "__main__":
    main()

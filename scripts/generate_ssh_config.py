#!/usr/bin/env python3

import argparse
import csv
from pathlib import Path

JUMP_HOST_ALIAS = "gohfert-jump"
JUMP_HOST_NAME = "maas.cluster.gohfert.com"
JUMP_HOST_USER = "felix-seifert"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    with args.input.open(newline="") as f:
        nodes = [
            (row["hostname"].strip(), row["admin_user_name"].strip())
            for row in csv.DictReader(f)
        ]

    lines = [
        "# Generated from machine data. Do not edit by hand.",
        "# Regenerate with: make generate-ssh-config",
        "",
        f"Host {JUMP_HOST_ALIAS}",
        f"    HostName {JUMP_HOST_NAME}",
        f"    User {JUMP_HOST_USER}",
    ]

    for hostname, user in nodes:
        lines += [
            "",
            f"Host {hostname}",
            f"    HostName {hostname}",
            f"    User {user}",
            f"    ProxyJump {JUMP_HOST_ALIAS}",
        ]

    args.output.write_text("\n".join(lines) + "\n")
    print(f"Wrote {len(nodes) + 1} host entries to {args.output}")


if __name__ == "__main__":
    main()

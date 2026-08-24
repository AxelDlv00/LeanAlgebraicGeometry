#!/usr/bin/env python3
"""Measure build reachability: which AlgebraicJacobian modules are NOT in the
transitive import cone of the default target `AlgebraicJacobian.lean`?

A module outside the cone is never elaborated by a bare `lake build`, so any
axiom/sorry probe run against the root target silently skips it.

Usage: python3 scripts/reach.py [--json] [--counts]
Run from the project root (the directory holding AlgebraicJacobian.lean).
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LIB = ROOT / "AlgebraicJacobian"
ROOT_MODULE = "AlgebraicJacobian"

IMPORT_RE = re.compile(r"^import\s+([A-Za-z_][\w.«»]*)", re.MULTILINE)


def module_of(path: Path) -> str:
    rel = path.relative_to(ROOT).with_suffix("")
    return ".".join(rel.parts)


def imports_of(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8", errors="replace")
    # imports only occur in the header, before any command
    head = text.split("\nnamespace ", 1)[0]
    return IMPORT_RE.findall(head)


def main() -> int:
    files = {module_of(p): p for p in sorted(LIB.rglob("*.lean"))}
    root_file = ROOT / f"{ROOT_MODULE}.lean"
    files[ROOT_MODULE] = root_file

    graph = {m: imports_of(p) for m, p in files.items()}

    seen: set[str] = set()
    stack = [ROOT_MODULE]
    while stack:
        m = stack.pop()
        if m in seen:
            continue
        seen.add(m)
        for dep in graph.get(m, []):
            if dep in files and dep not in seen:
                stack.append(dep)

    unrooted = sorted(m for m in files if m != ROOT_MODULE and m not in seen)
    total = len(files) - 1

    # who imports an unrooted module (from anywhere, rooted or not)?
    importers: dict[str, list[str]] = {m: [] for m in unrooted}
    for m, deps in graph.items():
        for d in deps:
            if d in importers:
                importers[d].append(m)

    if "--json" in sys.argv:
        json.dump(
            {
                "total": total,
                "rooted": total - len(unrooted),
                "unrooted": len(unrooted),
                "modules": [
                    {
                        "module": m,
                        "lines": len(files[m].read_text(errors="replace").splitlines()),
                        "imports_unrooted": sorted(
                            d for d in graph[m] if d in importers
                        ),
                        "importers": sorted(importers[m]),
                    }
                    for m in unrooted
                ],
            },
            sys.stdout,
            indent=1,
        )
        print()
        return 0

    print(f"{total} modules under {LIB.name}/; {len(unrooted)} UNROOTED")
    if "--counts" in sys.argv:
        return 0
    for m in unrooted:
        n = len(files[m].read_text(errors="replace").splitlines())
        pulls = sorted(d for d in graph[m] if d in importers)
        tag = f"  needs-unrooted: {', '.join(s.split('.')[-1] for s in pulls)}" if pulls else ""
        print(f"  {m}  ({n} lines){tag}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

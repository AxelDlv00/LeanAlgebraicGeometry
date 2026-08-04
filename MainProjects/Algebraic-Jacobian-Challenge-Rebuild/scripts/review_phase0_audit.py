#!/usr/bin/env python3
"""Static Phase 0 audit for an AJCR ledger revision.

The script reads commit objects directly from Horizon's out-of-tree ledger.  It
does not check out a revision and does not read or mutate the shared index.

Usage:
  python3 scripts/review_phase0_audit.py LABEL=REV [LABEL=REV ...]
"""

from __future__ import annotations

import json
import os
import re
import subprocess
import sys
from collections.abc import Iterable
from pathlib import Path


PROJECT = "MainProjects/Algebraic-Jacobian-Challenge-Rebuild"
ROOT_MODULE = "AlgebraicJacobian"
ROOT_PATH = f"{PROJECT}/{ROOT_MODULE}.lean"
LIB_PREFIX = f"{PROJECT}/AlgebraicJacobian/"

IMPORT_RE = re.compile(r"^import\s+([A-Za-z_][\w.\u00ab\u00bb]*)", re.MULTILINE)
IDENTIFIER_RE = re.compile(r"\b[A-Za-z_][A-Za-z0-9_']*\b")
DECL_RE = re.compile(
    r"^\s*(?:noncomputable\s+)?(?:def|theorem|lemma|abbrev|opaque|axiom|structure|class)\s+"
    r"([A-Za-z_][A-Za-z0-9_']*)",
    re.MULTILINE,
)
OPTION_RE = re.compile(
    r"^\s*set_option\s+(maxHeartbeats|maxRecDepth|maxSynthPendingDepth)\s+(\S+)",
    re.MULTILINE,
)

CRITICAL_DECLARATIONS = (
    "divFunctorAff_genus_representableBy",
    "divFunctorAff_admissible_representableBy",
    "divFunctorAff_representableBy_at",
    "not_injective_abelSigmaChart_of_divFamZar",
    "not_isOpenImmersion_abelSigmaChart_of_not_injective_chartValue",
    "not_isOpenImmersion_abelSigmaChart_of_genus_lt_degree",
    "PicRankOneOpen",
    "DivRankOneOpen",
    "rankOneAbel",
    "divisorOfRankOne",
    "rankOneAbelIso",
    "rankOneAbel_isOpenImmersion",
    "rankOne_translate_cover_sepClosed",
    "exists_translation_mem_picRankOneOpen",
    "pic0_sepClosed_representableBy",
    "representableBy_of_finiteGalois_baseChange",
    "pic0_representableBy",
    "jacobianData",
)


def git(*args: str, check: bool = True) -> str:
    git_dir = os.environ.get("HORIZON_LEDGER_GIT_DIR")
    work_tree = os.environ.get("HORIZON_LEDGER_WORK_TREE")
    if not git_dir or not work_tree:
        workspace = Path(__file__).resolve().parents[3]
        git_dir = str(workspace / ".archon-horizon/vcs/workspace.git")
        work_tree = str(workspace)
    result = subprocess.run(
        ["git", f"--git-dir={git_dir}", f"--work-tree={work_tree}", *args],
        cwd=work_tree,
        check=check,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    return result.stdout


def module_of(path: str) -> str:
    relative = path.removeprefix(f"{PROJECT}/").removesuffix(".lean")
    return relative.replace("/", ".")


def strip_lean_comments_and_strings(source: str) -> str:
    """Remove lexical regions in which `sorry` and `axiom` are prose."""
    out: list[str] = []
    i = 0
    block_depth = 0
    in_string = False
    while i < len(source):
        pair = source[i : i + 2]
        if block_depth:
            if pair == "/-":
                block_depth += 1
                i += 2
            elif pair == "-/":
                block_depth -= 1
                i += 2
            else:
                out.append("\n" if source[i] == "\n" else " ")
                i += 1
            continue
        if in_string:
            if source[i] == "\\":
                out.extend("  ")
                i += 2
            elif source[i] == '"':
                in_string = False
                out.append(" ")
                i += 1
            else:
                out.append("\n" if source[i] == "\n" else " ")
                i += 1
            continue
        if pair == "/-":
            block_depth = 1
            out.extend("  ")
            i += 2
        elif pair == "--":
            end = source.find("\n", i)
            if end == -1:
                out.extend(" " * (len(source) - i))
                break
            out.extend(" " * (end - i))
            i = end
        elif source[i] == '"':
            in_string = True
            out.append(" ")
            i += 1
        else:
            out.append(source[i])
            i += 1
    return "".join(out)


def identifier_count(source: str, identifier: str) -> int:
    return sum(token == identifier for token in IDENTIFIER_RE.findall(source))


def paths_at(revision: str) -> list[str]:
    paths = git("ls-tree", "-r", "--name-only", revision, "--", PROJECT).splitlines()
    return sorted(
        path
        for path in paths
        if path == ROOT_PATH or (path.startswith(LIB_PREFIX) and path.endswith(".lean"))
    )


def sources_at(revision: str, paths: Iterable[str]) -> dict[str, str]:
    return {path: git("show", f"{revision}:{path}") for path in paths}


def audit(label: str, requested_revision: str) -> dict[str, object]:
    revision = git("rev-parse", f"{requested_revision}^{{commit}}").strip()
    paths = paths_at(revision)
    sources = sources_at(revision, paths)
    modules = {module_of(path): path for path in paths}
    imports = {
        module: IMPORT_RE.findall(sources[path].split("\nnamespace ", 1)[0])
        for module, path in modules.items()
    }

    reachable: set[str] = set()
    stack = [ROOT_MODULE]
    while stack:
        module = stack.pop()
        if module in reachable:
            continue
        reachable.add(module)
        stack.extend(dep for dep in imports.get(module, ()) if dep in modules)

    library_modules = sorted(module for module in modules if module != ROOT_MODULE)
    rooted_modules = sorted(module for module in reachable if module != ROOT_MODULE)
    unrooted_modules = sorted(set(library_modules) - set(rooted_modules))
    rooted_paths = [modules[module] for module in sorted(reachable)]
    cleaned = {path: strip_lean_comments_and_strings(sources[path]) for path in rooted_paths}

    declared: dict[str, str] = {}
    for path in rooted_paths:
        for name in DECL_RE.findall(cleaned[path]):
            declared.setdefault(name, path)

    carrier_data: dict[str, object] = {}
    for carrier, implementation_prefix in (
        ("DivFamZar", "DivisorFamilyZar"),
        ("DivFamZarAff", "DivisorFamilyAff"),
    ):
        references = [
            {
                "module": module_of(path),
                "occurrences": identifier_count(cleaned[path], carrier),
            }
            for path in rooted_paths
            if identifier_count(cleaned[path], carrier)
        ]
        consumers = [
            entry
            for entry in references
            if not entry["module"].split(".")[-1].startswith(implementation_prefix)
        ]
        carrier_data[carrier] = {
            "rooted_reference_files": len(references),
            "rooted_reference_occurrences": sum(entry["occurrences"] for entry in references),
            "outside_named_implementation_files": len(consumers),
            "outside_named_implementation_modules": [entry["module"] for entry in consumers],
        }

    options: dict[str, list[dict[str, str]]] = {
        "maxHeartbeats": [],
        "maxRecDepth": [],
        "maxSynthPendingDepth": [],
    }
    for path in rooted_paths:
        for option, value in OPTION_RE.findall(cleaned[path]):
            options[option].append({"module": module_of(path), "value": value})

    return {
        "label": label,
        "requested_revision": requested_revision,
        "commit": revision,
        "commit_date": git("show", "-s", "--format=%cI", revision).strip(),
        "library_modules": len(library_modules),
        "rooted_modules": len(rooted_modules),
        "unrooted_modules": len(unrooted_modules),
        "unrooted_module_names": unrooted_modules,
        "lean_lines_total": sum(sources[path].count("\n") + 1 for path in paths),
        "lean_lines_rooted": sum(sources[path].count("\n") + 1 for path in rooted_paths),
        "rooted_sorry_tokens": sum(identifier_count(cleaned[path], "sorry") for path in rooted_paths),
        "rooted_explicit_axiom_declarations": sum(
            len(re.findall(r"^\s*axiom\s+", cleaned[path], re.MULTILINE)) for path in rooted_paths
        ),
        "carrier_references": carrier_data,
        "critical_declarations": {
            name: {"rooted": name in declared, "module": module_of(declared[name]) if name in declared else None}
            for name in CRITICAL_DECLARATIONS
        },
        "proof_budget_overrides": options,
    }


def main() -> int:
    if len(sys.argv) < 2 or any("=" not in arg for arg in sys.argv[1:]):
        print(__doc__.strip(), file=sys.stderr)
        return 2
    results = []
    for argument in sys.argv[1:]:
        label, revision = argument.split("=", 1)
        results.append(audit(label, revision))
    json.dump({"schema": 1, "revisions": results}, sys.stdout, indent=2)
    print()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

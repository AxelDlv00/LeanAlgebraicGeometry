#!/usr/bin/env python3
"""Align AJCR provenance markers between the blueprint, Lean, and hgraph.

The graph is the input of this tool.  A ``formalizes`` edge carries the
provenance of its blueprint source to the public Lean declaration at its
target.  The default mode is a read-only report; ``--apply`` is deliberately
all-or-nothing and refuses to write when any endpoint, declaration, or marker
is ambiguous.

Examples (from the project root)::

    python hgraph/sync_provenance.py --dry-run
    python hgraph/sync_provenance.py --dry-run --path AlgebraicJacobian/Cohomology
    python hgraph/sync_provenance.py --apply --path AlgebraicJacobian/Algebra/Foo.lean

``--path`` (and the positional path aliases) restrict Lean declaration and Lean
node edits to one or more files/directories.  TeX node tags are always checked
and mirrored, since they are the source of the alignment.
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable

import yaml

try:
    # Reuse the exact scanner used by Horizon hgraph sync.  These are private
    # helpers in Horizon, so a small fallback below keeps this script usable
    # with an older installed Horizon as well.
    from archon_horizon.hgraph.sync import _DECL_RE, _lean_code_lines
except ImportError:  # pragma: no cover - exercised only outside Horizon
    _DECL_RE = re.compile(
        r"^\s*(?:@\[[^\]]*\]\s*)?"
        r"(?:private\s+|protected\s+|noncomputable\s+)*"
        r"(theorem|lemma|def|abbrev|instance|structure|class|inductive)\s+"
        r"([^\s(:=]+)"
    )

    def _lean_code_lines(lines: list[str]) -> list[str]:
        """Blank Lean comments while retaining line/column positions."""
        result: list[str] = []
        depth = 0
        for line in lines:
            chars = list(line)
            i = 0
            while i < len(line):
                pair = line[i:i + 2]
                if depth == 0 and pair == "--":
                    chars[i:] = [" "] * (len(line) - i)
                    break
                if pair == "/-":
                    depth += 1
                    chars[i:i + 2] = [" ", " "]
                    i += 2
                    continue
                if pair == "-/" and depth:
                    depth -= 1
                    chars[i:i + 2] = [" ", " "]
                    i += 2
                    continue
                if depth:
                    chars[i] = " "
                i += 1
            result.append("".join(chars))
        return result


PRIMARY = ("REFERENCE", "ADAPTED", "CUSTOM")
PRIMARY_SET = set(PRIMARY)
CHECK = "TO CHECK"
TAG_SET = PRIMARY_SET | {CHECK}
PEER_EXCLUDED = {
    "AlgebraicJacobian/Picard/Pic0CriticalPath.lean",
    "AlgebraicJacobian/Picard/Pic0GaloisInvariantMatch.lean",
    "AlgebraicJacobian/Picard/Pic0FiniteGaloisRepresentable.lean",
}
PROVENANCE_LINE_RE = re.compile(
    r"(?:\bProvenance\s*:\s*(REFERENCE|ADAPTED|CUSTOM)\b|"
    r"\*\*(REFERENCE|ADAPTED|CUSTOM)\.\*\*)"
)
CHECK_LINE_RE = re.compile(r"\bTO CHECK\b")


@dataclass
class Record:
    path: Path
    meta: dict
    body: str


@dataclass
class Declaration:
    path: Path
    fqname: str
    kind: str
    line: int
    command_start: int
    private: bool
    doc_start: int | None
    doc_end: int | None
    lines: list[str]

    @property
    def doc_text(self) -> str:
        if self.doc_start is None or self.doc_end is None:
            return ""
        raw = "".join(self.lines[self.doc_start:self.doc_end])
        raw = re.sub(r"^\s*/--", "", raw, count=1)
        raw = re.sub(r"-\/\s*$", "", raw)
        return raw.strip()


@dataclass
class Mapping:
    source: Record
    target: Record
    label: str
    primary: str
    check: bool
    target_file: Path
    decl_name: str


@dataclass
class Edit:
    path: Path
    line: int
    replacement: str
    reason: str


@dataclass
class Audit:
    root: Path
    mappings: list[Mapping] = field(default_factory=list)
    declarations: dict[str, list[Declaration]] = field(default_factory=dict)
    edits: list[Edit] = field(default_factory=list)
    node_tags: dict[Path, list[str]] = field(default_factory=dict)
    errors: list[str] = field(default_factory=list)
    notes: list[str] = field(default_factory=list)
    ignored_private: int = 0


class AuditError(Exception):
    """A malformed graph/source that must prevent ``--apply``."""


def _read_record(path: Path) -> Record:
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        raise AuditError(f"{path}: missing YAML frontmatter")
    close = text.find("\n---\n", 4)
    if close < 0:
        raise AuditError(f"{path}: unterminated YAML frontmatter")
    try:
        meta = yaml.safe_load(text[4:close]) or {}
    except yaml.YAMLError as exc:
        raise AuditError(f"{path}: invalid YAML frontmatter: {exc}") from exc
    if not isinstance(meta, dict):
        raise AuditError(f"{path}: frontmatter is not a mapping")
    return Record(path, meta, text[close + 5:])


def _records(directory: Path) -> dict[str, Record]:
    out: dict[str, Record] = {}
    if not directory.is_dir():
        raise AuditError(f"missing graph directory: {directory}")
    for path in sorted(directory.glob("*.md")):
        out[path.stem] = _read_record(path)
    return out


def _macro_args(text: str, macro: str) -> list[str]:
    """Read balanced ``\\macro{...}`` arguments without flattening TeX."""
    token = "\\" + macro
    out: list[str] = []
    pos = 0
    while True:
        match = re.search(re.escape(token) + r"\s*\{", text[pos:])
        if not match:
            return out
        start = pos + match.end() - 1
        depth = 1
        i = start + 1
        escaped = False
        while i < len(text) and depth:
            char = text[i]
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == "{":
                depth += 1
            elif char == "}":
                depth -= 1
            i += 1
        if depth:
            raise AuditError(f"unterminated \\{macro}{{...}} marker")
        out.append(text[start + 1:i - 1].strip())
        pos = i


def _source_tags(record: Record) -> tuple[str | None, bool, list[str]]:
    """Return primary/check markers and validation errors for a TeX node."""
    errors: list[str] = []
    try:
        primary_args = _macro_args(record.body, "provenancetag")
        check_args = _macro_args(record.body, "alignmentcheck")
    except AuditError as exc:
        return None, False, [f"{record.path}: {exc}"]
    primary = [arg for arg in primary_args if arg in PRIMARY_SET]
    if len(primary_args) != 1 or len(primary) != 1:
        errors.append(
            f"{record.path}: expected exactly one \\provenancetag{{REFERENCE|ADAPTED|CUSTOM}}, "
            f"found {primary_args!r}"
        )
    check = False
    if len(check_args) > 1:
        errors.append(f"{record.path}: expected at most one \\alignmentcheck marker")
    elif check_args:
        check = check_args[0].strip().startswith(CHECK)
        if not check:
            errors.append(
                f"{record.path}: alignment marker must begin with '{CHECK}', "
                f"found {check_args[0]!r}"
            )
    return (primary[0] if len(primary) == 1 else None), check, errors


def _tag_values(value) -> list[str]:
    if value is None:
        return []
    if isinstance(value, str):
        return [value]
    if isinstance(value, (list, tuple)):
        return [str(item) for item in value]
    raise AuditError(f"unsupported tags value {value!r}")


def _metadata_tags(meta: dict, path: Path, errors: list[str]) -> tuple[str | None, bool]:
    try:
        tags = _tag_values(meta.get("tags"))
    except AuditError as exc:
        errors.append(f"{path}: {exc}")
        return None, False
    primary = [tag for tag in tags if tag in PRIMARY_SET]
    if len(set(primary)) > 1 or len(primary) > 1:
        errors.append(f"{path}: conflicting or duplicate provenance tags {primary!r}")
    checks = [tag for tag in tags if tag == CHECK]
    if len(checks) > 1:
        errors.append(f"{path}: duplicate '{CHECK}' tags")
    return (primary[0] if primary else None), bool(checks)


def _scan_declarations(path: Path) -> list[Declaration]:
    """Scan one file with the same comment and namespace rules as Horizon."""
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines(keepends=True)
    plain = [line.rstrip("\r\n") for line in lines]
    code = _lean_code_lines(plain)
    namespace: list[str] = []
    raw: list[tuple[int, str, str, bool]] = []
    for index, line in enumerate(code):
        stripped = line.strip()
        namespace_match = re.match(r"namespace\s+([A-Za-z0-9_.]+)", stripped)
        if namespace_match:
            namespace.append(namespace_match.group(1))
            continue
        end_match = re.match(r"end\s+([A-Za-z0-9_.]+)", stripped)
        if end_match and namespace and namespace[-1] == end_match.group(1):
            namespace.pop()
            continue
        match = _DECL_RE.match(line)
        if not match:
            continue
        kind, name = match.group(1), match.group(2)
        prefix = line[:match.start(1)]
        is_private = bool(re.search(r"\bprivate\s+", prefix))
        fqname = name.removeprefix("_root_.") if name.startswith("_root_.") else ".".join(namespace + [name])
        raw.append((index, fqname, kind, is_private))

    def previous_attribute(start: int) -> int | None:
        """Start of a standalone ``@[...]`` block immediately above ``start``."""
        end = start
        while end > 0 and code[end - 1].strip() == "":
            end -= 1
        if end == 0 or not code[end - 1].strip().endswith("]"):
            return None
        balance = 0
        for index in range(end - 1, -1, -1):
            fragment = code[index]
            balance += fragment.count("]") - fragment.count("[")
            token = fragment.find("@[")
            if token >= 0 and balance <= 0:
                if fragment[:token].strip():
                    return None
                return index
            if balance <= 0:
                return None
        return None

    def command_start(decl_line: int) -> int:
        start = decl_line
        while True:
            attribute = previous_attribute(start)
            if attribute is None:
                return start
            start = attribute

    def doc_span(start_line: int) -> tuple[int, int] | None:
        end = start_line
        while end > 0 and lines[end - 1].strip() == "":
            end -= 1
        if end == 0 or not lines[end - 1].strip().endswith("-/"):
            return None
        start = end - 1
        while start >= 0:
            if "/--" in lines[start]:
                return start, end
            start -= 1
        return None

    out: list[Declaration] = []
    for line, fqname, kind, is_private in raw:
        start = command_start(line)
        span = doc_span(start)
        out.append(Declaration(
            path=path,
            fqname=fqname,
            kind=kind,
            line=line,
            command_start=start,
            private=is_private,
            doc_start=span[0] if span else None,
            doc_end=span[1] if span else None,
            lines=lines,
        ))
    return out


def _selected_paths(root: Path, specs: Iterable[str], errors: list[str]) -> set[Path] | None:
    specs = list(specs)
    if not specs:
        return None
    selected: set[Path] = set()
    for spec in specs:
        candidate = Path(spec)
        if not candidate.is_absolute():
            candidate = root / candidate
        candidate = candidate.resolve()
        if candidate.is_dir():
            selected.update(path.resolve() for path in candidate.rglob("*.lean"))
        elif candidate.is_file() and candidate.suffix == ".lean":
            selected.add(candidate)
        else:
            errors.append(f"path slice does not name a Lean file or directory: {spec}")
    return selected


def _lean_files(root: Path, errors: list[str]) -> list[Path]:
    """Lean files under the hgraph-configured roots, excluding peer-owned files."""
    config_path = root / "hgraph" / "config.yaml"
    try:
        config = yaml.safe_load(config_path.read_text(encoding="utf-8")) or {}
    except (OSError, yaml.YAMLError) as exc:
        errors.append(f"{config_path}: cannot read Lean roots: {exc}")
        return []
    roots = config.get("lean") or []
    if isinstance(roots, str):
        roots = [roots]
    if not isinstance(roots, list):
        errors.append(f"{config_path}: 'lean' must be a path or list of paths")
        return []
    excluded = {(root / path).resolve() for path in PEER_EXCLUDED}
    files: set[Path] = set()
    for item in roots:
        candidate = (root / str(item)).resolve()
        if candidate.is_dir():
            files.update(path.resolve() for path in candidate.rglob("*.lean"))
        elif candidate.is_file() and candidate.suffix == ".lean":
            files.add(candidate)
        else:
            errors.append(f"{config_path}: configured Lean path does not exist: {item}")
    return sorted(files - excluded)


def _doc_marker_state(decl: Declaration) -> tuple[str | None, bool, list[str]]:
    text = decl.doc_text
    matches = [a or b for a, b in PROVENANCE_LINE_RE.findall(text)]
    errors: list[str] = []
    if len(set(matches)) > 1 or len(matches) > 1:
        errors.append(f"{decl.fqname}: conflicting or duplicate provenance markers {matches!r}")
    checks = CHECK_LINE_RE.findall(text)
    return (matches[0] if matches else None), bool(checks), errors


def _pointer(labels: list[str]) -> str:
    labels = sorted(set(labels))
    if len(labels) == 1:
        target = f"blueprint `{labels[0]}`"
    else:
        target = "blueprint labels " + ", ".join(f"`{label}`" for label in labels)
    return f"TO CHECK: See {target} for the recorded alignment check."


def _marker_insert(decl: Declaration, primary: str | None, check: bool, labels: list[str]) -> Edit | None:
    current, has_check, errors = _doc_marker_state(decl)
    if errors:
        return None
    additions: list[str] = []
    if primary and current is None:
        additions.append(f"Provenance: {primary}.")
    if check and not has_check:
        additions.append(_pointer(labels))
    if not additions:
        return None
    if decl.doc_start is not None:
        line = decl.lines[decl.doc_start]
        newline = "\r\n" if line.endswith("\r\n") else "\n"
        marker = re.match(r"\s*", line).group(0)
        token = line.find("/--")
        if token < 0:
            return None
        prefix = line[:token + 3]
        suffix = line[token + 3:].rstrip("\r\n")
        replacement = prefix + newline + marker + "  "
        replacement += (newline + marker + "  ").join(additions) + newline
        if suffix.strip():
            replacement += marker + suffix.lstrip() + newline
        return Edit(decl.path, decl.doc_start, replacement, "Lean docstring marker")
    line = decl.lines[decl.command_start]
    indent = re.match(r"\s*", line).group(0)
    newline = "\r\n" if line.endswith("\r\n") else "\n"
    doc = indent + "/--" + newline
    doc += (newline.join(indent + "  " + item for item in additions) + newline)
    doc += indent + "-/" + newline
    return Edit(decl.path, decl.command_start, doc + line, "new Lean docstring marker")


def _replace_tags(text: str, tags: list[str]) -> str:
    """Replace only the top-level YAML ``tags`` field, preserving other bytes."""
    if not text.startswith("---\n"):
        raise AuditError("node has no YAML frontmatter")
    close = text.find("\n---\n", 4)
    if close < 0:
        raise AuditError("node has unterminated YAML frontmatter")
    header = text[4:close]
    lines = header.splitlines(keepends=True)
    tag_index = None
    tag_end = None
    for i, line in enumerate(lines):
        if re.match(r"^tags\s*:", line):
            tag_index = i
            j = i + 1
            while j < len(lines) and not re.match(r"^[^\s#][^:\n]*:", lines[j]):
                j += 1
            tag_end = j
            break
    newline = "\r\n" if "\r\n" in header else "\n"
    block = "tags:" + newline + "".join("- " + tag + newline for tag in tags)
    block_lines = block.splitlines(keepends=True)
    if tag_index is None:
        if lines and not lines[-1].endswith(("\n", "\r")):
            lines[-1] += newline
        lines.extend(block_lines)
    else:
        lines[tag_index:tag_end] = block_lines
    new_header = "".join(lines).rstrip("\r\n")
    return text[:4] + new_header + text[close:]


def _merged_tags(meta: dict, primary: str, check: bool) -> list[str]:
    old = _tag_values(meta.get("tags"))
    out: list[str] = []
    primary_seen = False
    check_seen = False
    for tag in old:
        if tag in PRIMARY_SET:
            if not primary_seen:
                out.append(primary)
                primary_seen = True
        elif tag == CHECK:
            if check and not check_seen:
                out.append(CHECK)
                check_seen = True
        else:
            out.append(tag)
    if not primary_seen:
        out.insert(0, primary)
    if check and not check_seen:
        out.insert(1 if out and out[0] == primary else 0, CHECK)
    return out


def _audit(root: Path, path_specs: list[str], mirror_hgraph: bool) -> Audit:
    audit = Audit(root=root)
    nodes_dir = root / "hgraph" / "nodes"
    edges_dir = root / "hgraph" / "edges"
    try:
        nodes = _records(nodes_dir)
        edges = _records(edges_dir)
    except AuditError as exc:
        audit.errors.append(str(exc))
        return audit
    selected = _selected_paths(root, path_specs, audit.errors)

    # Validate every blueprint node, including nodes without a formalizes edge,
    # because tags on TeX are the source metadata that hgraph exposes.
    tex_tags: dict[str, tuple[str, bool]] = {}
    for node_id, record in nodes.items():
        if record.meta.get("type") != "tex":
            continue
        primary, check, errors = _source_tags(record)
        audit.errors.extend(errors)
        if primary:
            tex_tags[node_id] = (primary, check)
            try:
                old_primary, old_check = _metadata_tags(record.meta, record.path, audit.errors)
                if old_primary and old_primary != primary:
                    audit.errors.append(f"{record.path}: hgraph tag {old_primary} conflicts with {primary}")
                if old_check and not check:
                    audit.errors.append(f"{record.path}: hgraph '{CHECK}' tag has no blueprint marker")
            except Exception as exc:
                audit.errors.append(f"{record.path}: cannot read tags: {exc}")
            if mirror_hgraph:
                audit.node_tags[record.path] = _merged_tags(record.meta, primary, check)

    # Read only generated formalizes edges.  An edge is malformed if either
    # endpoint is absent or has the wrong population; that is never guessed.
    by_target: dict[str, list[Mapping]] = {}
    for edge_id, edge in edges.items():
        if edge.meta.get("type") != "formalizes":
            continue
        source_id, target_id = edge.meta.get("source"), edge.meta.get("target")
        if source_id not in nodes or target_id not in nodes:
            audit.errors.append(f"{edge.path}: formalizes endpoint missing ({source_id!r}, {target_id!r})")
            continue
        source, target = nodes[source_id], nodes[target_id]
        if source.meta.get("type") != "tex" or target.meta.get("type") != "lean":
            audit.errors.append(f"{edge.path}: formalizes endpoints are not tex -> lean")
            continue
        if source_id not in tex_tags:
            continue
        primary, check = tex_tags[source_id]
        label = str(source.meta.get("label") or source.meta.get("title") or source_id)
        filename = target.meta.get("file")
        decl_name = target.meta.get("decl")
        if not isinstance(filename, str) or not filename:
            audit.errors.append(f"{target.path}: Lean target has no source file")
            continue
        if not isinstance(decl_name, str) or not decl_name:
            audit.errors.append(f"{target.path}: Lean target has no declaration name")
            continue
        target_file = (root / filename).resolve()
        if not target_file.is_file():
            audit.errors.append(f"{target.path}: Lean source file not found: {filename}")
            continue
        mapping = Mapping(source, target, label, primary, check, target_file, decl_name)
        by_target.setdefault(target_id, []).append(mapping)

    # A target with two different primary tags is an irreconcilable source
    # conflict.  A check on any source is intentionally additive.
    mappings: list[Mapping] = []
    for target_id, group in by_target.items():
        primary_values = {item.primary for item in group}
        if len(primary_values) > 1:
            audit.errors.append(
                f"{nodes[target_id].path}: linked sources disagree on provenance "
                + ", ".join(sorted(primary_values))
            )
            continue
        mappings.extend(group)
    # Parse the configured Lean tree once.  Duplicate hgraph names exist in the
    # project, and one formalizes target currently points at a private duplicate
    # even though exactly one public declaration with that name exists.  The
    # resolver below prefers the graph-recorded file when it contains a public
    # occurrence, otherwise it requires a unique public occurrence globally.
    files = _lean_files(root, audit.errors)
    for path in files:
        try:
            declarations = _scan_declarations(path)
        except (OSError, UnicodeError) as exc:
            audit.errors.append(f"{path}: cannot scan Lean source: {exc}")
            continue
        for declaration in declarations:
            audit.declarations.setdefault(declaration.fqname, []).append(declaration)

    resolved: list[Mapping] = []
    for target_id, group in by_target.items():
        if not group or target_id not in nodes:
            continue
        mapping = group[0]
        hits = audit.declarations.get(mapping.decl_name, [])
        preferred = [
            declaration for declaration in hits
            if not declaration.private and declaration.path == mapping.target_file
        ]
        public = [declaration for declaration in hits if not declaration.private]
        if len(preferred) == 1:
            declaration = preferred[0]
        elif len(preferred) > 1:
            audit.errors.append(
                f"{mapping.target.path}: declaration {mapping.decl_name!r} has "
                f"{len(preferred)} public occurrences in {mapping.target_file}"
            )
            continue
        elif len(public) == 1:
            declaration = public[0]
        elif not public and mapping.target.meta.get("private"):
            audit.ignored_private += 1
            continue
        elif not public:
            audit.errors.append(
                f"{mapping.target.path}: declaration {mapping.decl_name!r} has no public occurrence"
            )
            continue
        else:
            locations = ", ".join(str(item.path.relative_to(root)) for item in public)
            audit.errors.append(
                f"{mapping.target.path}: declaration {mapping.decl_name!r} is ambiguous across "
                f"{len(public)} public occurrences: {locations}"
            )
            continue
        if str(declaration.path.relative_to(root)) in PEER_EXCLUDED:
            audit.errors.append(f"{declaration.path}: peer-owned file is excluded from provenance edits")
            continue
        for item in group:
            item.target_file = declaration.path
        resolved.extend(group)
        labels = [item.label for item in group if item.check]
        current, has_check, marker_errors = _doc_marker_state(declaration)
        audit.errors.extend(f"{mapping.target_file}: {error}" for error in marker_errors)
        if current and current != mapping.primary:
            audit.errors.append(
                f"{mapping.target_file}: {mapping.decl_name} has {current}, expected {mapping.primary}"
            )
        if has_check and not any(item.check for item in group):
            audit.errors.append(
                f"{mapping.target_file}: {mapping.decl_name} has '{CHECK}' but no linked blueprint check"
            )
        if selected is None or mapping.target_file in selected:
            edit = _marker_insert(declaration, mapping.primary, bool(labels), labels)
            if edit:
                audit.edits.append(edit)
            if mirror_hgraph:
                try:
                    old_primary, old_check = _metadata_tags(mapping.target.meta, mapping.target.path, audit.errors)
                    if old_primary and old_primary != mapping.primary:
                        audit.errors.append(
                            f"{mapping.target.path}: hgraph tag {old_primary} conflicts with {mapping.primary}"
                        )
                    if old_check and not bool(labels):
                        audit.errors.append(
                            f"{mapping.target.path}: hgraph '{CHECK}' tag has no linked blueprint check"
                        )
                    audit.node_tags[mapping.target.path] = _merged_tags(
                        mapping.target.meta, mapping.primary, bool(labels)
                    )
                except Exception as exc:
                    audit.errors.append(f"{mapping.target.path}: cannot mirror tags: {exc}")
        else:
            audit.notes.append(f"slice skipped {mapping.target_file}")

    audit.mappings = resolved

    return audit


def _apply_edits(audit: Audit) -> None:
    """Apply validated Lean edits and hgraph tag-only updates."""
    grouped: dict[Path, list[Edit]] = {}
    for edit in audit.edits:
        grouped.setdefault(edit.path, []).append(edit)
    for path, edits in grouped.items():
        text = path.read_text(encoding="utf-8")
        lines = text.splitlines(keepends=True)
        for edit in sorted(edits, key=lambda item: item.line, reverse=True):
            lines[edit.line:edit.line + 1] = [edit.replacement]
        path.write_text("".join(lines), encoding="utf-8")
    for path, tags in sorted(audit.node_tags.items(), key=lambda item: str(item[0])):
        text = path.read_text(encoding="utf-8")
        updated = _replace_tags(text, tags)
        if updated != text:
            path.write_text(updated, encoding="utf-8")


def _report(audit: Audit, *, apply: bool, mirror_hgraph: bool) -> None:
    print("AJCR provenance alignment")
    print(f"root: {audit.root}")
    print(f"formalizes mappings: {len(audit.mappings)}")
    print(f"public Lean doc edits: {len(audit.edits)}")
    print(f"hgraph node tag candidates: {len(audit.node_tags) if mirror_hgraph else 0}")
    print(f"private targets ignored: {audit.ignored_private}")
    if audit.notes:
        print(f"slice notes: {len(audit.notes)}")
    if audit.errors:
        print(f"validation errors: {len(audit.errors)}")
        for error in audit.errors:
            print(f"  ERROR {error}", file=sys.stderr)
    else:
        action = "applied" if apply else "would apply"
        print(f"status: clean; {action} marker-only changes")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--dry-run", action="store_true", help="validate and report without writing")
    mode.add_argument("--apply", action="store_true", help="write only after a clean validation")
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument(
        "--path", dest="paths", action="append", default=[], metavar="PATH",
        help="Lean file/directory slice; repeat for multiple paths",
    )
    parser.add_argument("positional_paths", nargs="*", metavar="PATH")
    parser.add_argument(
        "--no-hgraph", action="store_true",
        help="validate/edit Lean docs only; skip hgraph tag mirroring",
    )
    args = parser.parse_args(argv)
    paths = [*args.paths, *args.positional_paths]
    root = args.root.resolve()
    audit = _audit(root, paths, mirror_hgraph=not args.no_hgraph)
    if audit.errors:
        _report(audit, apply=False, mirror_hgraph=not args.no_hgraph)
        return 2
    if args.apply:
        _apply_edits(audit)
    _report(audit, apply=args.apply, mirror_hgraph=not args.no_hgraph)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

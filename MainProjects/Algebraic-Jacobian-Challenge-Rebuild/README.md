# AlgebraicJacobian (rebuild)

<!-- archon:readme -->

## Project

A **from-scratch rebuild** of the Lean 4 + Mathlib formalization of the **Jacobian of a smooth,
proper, geometrically irreducible curve** over a field (Christian Merten's AI challenge, inspired by
Kevin Buzzard's Riemann-surface version). By a smooth curve we mean a geometrically irreducible,
smooth scheme of relative dimension one over a field.

This project supplies the missing definitions (`genus`, `Jacobian`, the Abel–Jacobi map `ofCurve`)
and theorems (the Jacobian is smooth of relative dimension equal to the genus, proper, geometrically
irreducible, and is the Albanese variety of the curve, characterized by the universal property
`exists_unique_ofCurve_comp`). It targets the **extended** challenge: additionally, the Jacobian is
**functorial** in the curve (`Jacobian.functor`) and **commutes with base change of fields**
(`baseChangeIso` with identity and cocycle coherences, and Abel–Jacobi compatibility
`baseChange_ofCurve`), which makes the construction canonical.

It is rebuilt rather than continued: the goal is a cleaner, more general, mathlib-idiomatic
infrastructure and a shorter, clearer path to the conclusion. The existing project
`MainProjects/Algebraic-Jacobian-Challenge` may be **read** when genuinely blocked, but nothing is
copied from it — every declaration is rewritten. The rebuild is driven by its Archon Horizon task,
which carries the full charter (target, constraints, working model, and phases).

## Structure

- `AlgebraicJacobian/Challenge.lean` — the single, reviewable **statement file**: every signature a
  reviewer must trust, and nothing else. Agents own the proofs, never these signatures.
- `AlgebraicJacobian/` — the infrastructure that discharges the statement (added as the rebuild
  proceeds; house limit 500 lines per file, currently exceeded by 19 files tracked in inbox
  `I-0220`; layout mirrors the mathematical structure of the paper).
- `AlgebraicJacobian.lean` — the library root import list, and the index of what is actually
  checked: `lake build`'s default target is this module, so a new file is **not** elaborated by a
  bare `lake build` until it is imported here. Add the import, or check the file explicitly by
  module name. **This gap is large, not hypothetical:** of 711 `.lean` files under
  `AlgebraicJacobian/`, **71 are unreachable** from the root and so never kernel-checked by a bare
  `lake build` (re-measured 2026-07-29); 38 of those are the sorry-free
  `Picard/DivSchemeHighWindow*` family. Measure reachability transitively, not by the root's import
  lines, and re-measure rather than quoting — parallel lanes move these figures hourly. See roadmap
  row `AJCR.w4-rep.build-reach` for the triaged list and inbox `I-0624` for why it bites in both
  directions. Check the root before trusting a "landed" claim.
- `informal/` — 78 design worksheets, brick specs, and recon dumps (~29k lines). **Start from
  [`informal/README.md`](informal/README.md)**, which says what each file is for and which are
  superseded; several are pinned to routes that have since been abandoned.
- `blueprint/` — a clean **mathematical** blueprint (no Lean code in the prose; nodes carry `\lean{}`
  and `\source{}` anchors). Build with `leanblueprint pdf` / `leanblueprint web`.
- `archon-protected.yaml` — the mathematician-owned signatures agents must not modify.

## Sources

The shared workspace-root [`references/`](../../references/) library (indexed by
`references/manifest.yaml`) backs the blueprint. Read a source before citing it with `\source{...}`.

## How to build

```bash
lake build           # compile (olean cache shared via ../../.lake-packages)
```

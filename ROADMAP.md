# Algebraic Jacobian Challenge Rebuild — Palimpsest review lane

<!-- palimpsest-governance -->

## Goal

Improve **code quality** and **mathematical correctness** of the existing Lean
development under `MainProjects/Algebraic-Jacobian-Challenge-Rebuild` (AJCR),
integrating into branch `palimpsest/main`.

This is a **review-and-improve** project, not a bottom-up formalization from an
empty repository. The baseline on `palimpsest/main` is a lean/tex-focused snapshot
of the public mainline. Agents must not re-architect the whole tree unprompted.

## Scope discipline (how work is selected)

1. **Human issues are the scope.** Preferred workflow: the maintainer opens a
   focused GitHub issue naming the module(s), lemma(s), or concern (quality,
   naming, docstrings, mathlib style, mathematical gap, sorry debt, etc.), then
   labels it ready (or runs `palimpsest run … --issue N`).
2. **One issue → one coherent PR** into `palimpsest/main`. Prefer small,
   reviewable increments over monorepo-wide rewrites.
3. **Do not invent a parallel formalization route.** Preserve theorem strength
   and public APIs unless the issue explicitly authorizes a breaking change.
4. **Discovery** (when the ready queue is empty) may open at most a few frontier
   issues that refine *already identified* review themes in this roadmap or in
   open maintainer comments — never a blind whole-repo audit dump.

## Priority themes (AJCR)

When filing or discovering work, prefer:

| Theme | What “done” looks like |
| --- | --- |
| Mathematical correctness | Statements match the intended AG/Jacobian meaning; no silent weakenings; axioms/sorrys accounted for |
| Maths–Lean correspondence | Names, docstrings, and APIs match the mathematics; no misleading encodings |
| Lean / mathlib quality | Style, naming, simp hygiene, dead code, import hygiene, library-grade structure |
| Architecture (local) | Module boundaries and dependencies improved *within* the issue’s scope |

Out of scope unless an issue says otherwise: Horizon/Archon control plane files,
dashboard, status logs, SubProjects historical trees, and unrelated MainProjects
companions except interfaces AJCR already depends on.

## Acceptance criteria (per PR)

- Builds under repository CI (`lake-build` / Lean CI workflow).
- Change is limited to the claimed issue; description cites issue number.
- Review panel (mathematical-correctness, maths-lean-correspondence, lean-quality)
  can accept or request changes; no silent `sorry` introduction without issue debt notes.
- `ROADMAP.md` and this governance intent remain accurate; update only when the
  issue is about planning.

## Integration branch

- **Base branch:** `palimpsest/main`
- **Upstream reference:** public `main` of `AxelDlv00/LeanAlgebraicGeometry` (lean/tex snapshot)
- Merges land on `palimpsest/main` for staged review; promoting back to `main` is a human decision.

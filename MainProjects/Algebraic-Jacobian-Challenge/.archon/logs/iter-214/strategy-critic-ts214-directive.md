# strategy-critic — slug ts214

Fresh-view soundness audit of the project strategy. You have NO iter history and no prover
narrative by design — judge the strategy as a fresh mathematician would.

## What to read (and ONLY these)

1. `.archon/STRATEGY.md` (verbatim — the strategy under audit).
2. `references/summary.md` (the reference index).
3. Blueprint chapter titles + one-line topic each: skim the first `\chapter`/section line and any
   top comment of each file in `blueprint/src/chapters/*.tex`. Do not read full proofs.

Do NOT read PROGRESS.md, task_*.md, iter sidecars, or any prover/review report.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: nine protected Lean declarations giving an
Albanese/Jacobian object `J := Pic⁰_{C/k}` for a smooth proper geometrically irreducible curve
`C/k` over an arbitrary field (no rational point assumed, no characteristic-zero assumption), with
`isAlbaneseFor` quantified over the `k`-rational pointing. The end-state is zero inline `sorry` in
the dependency cone of the nine protected decls, kernel-only axioms.

## What changed this iter (audit focus)

The critical-path sub-phase A.1.c.SubT (line-bundle ⊗-group law) shifted its associator realization
from "route (c)" to the cleaner sibling "route (d)": the associator `tensorObj_assoc_iso` is now
fully assembled and compiles, resting on ONE residual lemma — that whiskering an arbitrary module by
a locally-bijective (J.W) morphism preserves local bijectivity, proved stalkwise (a J.W-map is a
stalkwise iso, so `id ⊗ g_x` is an iso; no flatness, no local triviality). The residual is
mathematically true but needs two Mathlib-absent `PresheafOfModules` stalk lemmas (stalk-char of
J.W on `Opens X`; stalk commutes with the relative module tensor) — estimated ~200–400 LOC, to be
built via a dedicated mathlib-build iteration.

## Questions for you

1. Is the overall arc (A.1.c.SubT → A.1.c → A.2.c, under the option-(c) RR pause) still SOUND, or
   is there a structural error (a forced case-split, a hallucinated route, a missing prerequisite,
   a silent assumption)?
2. Is committing a multi-iter ~200–400 LOC stalk-infrastructure build to close the SubT associator
   the right place to spend budget, given the substrate (`tensorObj = sheafification(presheaf
   tensor)`) — or does the recurring need to build absent `PresheafOfModules` infrastructure suggest
   the substrate design itself is the wrong altitude (e.g. a different model of line bundles would
   avoid this)?
3. Any still-live CHALLENGE from earlier audits the strategy now needs to address (RR-pause cost,
   autoduality RR-freeness, R^i f_* fork)?

Report verdict SOUND / CHALLENGE / REJECT per route, with the cheapest signal that would change it.

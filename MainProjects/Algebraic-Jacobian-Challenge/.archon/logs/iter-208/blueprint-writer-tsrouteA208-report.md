# Blueprint Writer Report

## Slug
tsrouteA208

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Revised** `lem:tensorobj_restrict_iso` (statement block) — retitled
  "Tensor product commutes with restriction along an open immersion"; restated
  for **arbitrary** `M, N : Scheme.Modules X` (dropped the "let L, M be line
  bundles, hence flat" framing); added one sentence on why no
  flatness/local-freeness is needed (restriction along an open immersion is base
  change along the structure-sheaf *isomorphism*). Changed `\uses{...}` from
  `{def:scheme_modules_tensorobj, lem:restrictscalars_laxmonoidal}` to
  `{def:scheme_modules_tensorobj}`. Removed the **two stale `% NOTE` blocks**
  (the iter-207 "δ-route / sole ingredient disproven" note and the "comparison
  map is the oplax δ" note). `\lean{...}` pin unchanged
  (`AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso`).

- **Rewrote** the proof of `lem:tensorobj_restrict_iso` to **Route A
  (open-immersion sectionwise base change)**. New structure:
  - *Preamble*: `φ = (Scheme.Hom.toRingCatSheafHom f).hom`; the open-immersion
    ring comparison `f.appIso V : Γ(X, f(V)) ≅ Γ(U, V)` is a `CommRingCat`
    isomorphism, so restriction is extension of scalars along a ring **iso**.
  - *Step 1*: reduce restriction to abstract pullback via
    `Scheme.Modules.restrictFunctorIsoPullback` (unchanged in spirit).
  - *Step 2*: move pullback inside sheafification via
    `SheafOfModules.sheafificationCompPullback` (unchanged in spirit); descend
    to presheaf-level base-change comparison.
  - *Step 3* (NEW, replaces dead mate-δ Steps 3–4): sectionwise unfolding of
    `PresheafOfModules.pullback φ` along the open immersion — section-by-section
    base change along the ring iso `f.appIso V`; an iso commuting with `⊗` by
    `ModuleCat.restrictScalarsEquivalenceOfRingEquiv`. States explicitly the one
    genuinely-new project-side ingredient is the bounded (~30–60 LOC)
    sectionwise unfolding (no Mathlib presheaf analogue of
    `restrictFunctorIsoPullback`; precedent in the Kähler base-change lane).
  - *Gluing*: assemble via `PresheafOfModules.isoMk`; transport back through
    Steps 1–2. Explicit closing statement: route needs no monoidal structure on
    `SheafOfModules`/pullback, no flatness, no line-bundle hypothesis.
  Proof `\uses{...}` also reduced to `{def:scheme_modules_tensorobj}`.

- **Revised** `lem:restrictscalars_laxmonoidal` — kept the `\lean{...}` pin
  (`PresheafOfModules.restrictScalarsLaxMonoidal`) and `\uses{...}`. Replaced the
  stale iter-207 `% NOTE` (which referenced a now-removed note on
  `lem:tensorobj_restrict_iso` and project-history disproof) with a clean
  standalone note: self-contained `CommRingCat`-level supplement, NOT used by
  `lem:tensorobj_restrict_iso`, off the critical path. Replaced the final
  statement sentence ("supplies the hypothesis … sole genuinely project-side
  ingredient") with prose stating it is an off-path supplement retained for
  reuse and explicitly *not* an ingredient of `lem:tensorobj_restrict_iso`.
  Math content of the lemma (the lax-monoidal claim + its proof) unchanged.

- **Revised** the internal-consistency-check section
  (`sec:tensorobj_consistency_check`) — the two bullets describing
  `lem:restrictscalars_laxmonoidal` and `lem:tensorobj_restrict_iso` were
  tracking the old `\uses` edges and the dead "sole project-side ingredient"
  role. Updated them to match the edited edges (this is bookkeeping prose that
  mirrors the `\uses{}` edges I was directed to change, kept consistent so
  blueprint-doctor's uses-graph stays accurate).

## Cross-references introduced
- None new. `lem:tensorobj_restrict_iso` now `\uses{def:scheme_modules_tensorobj}`
  only (both target labels exist in this chapter). Downstream lemmas
  (`lem:tensorobj_assoc_iso`, `_unit_iso`, `_comm_iso`,
  `_inverse_invertible`, `_lift_onproduct`) retain their existing
  `\uses{lem:tensorobj_restrict_iso}` edges — untouched, still valid.

## References consulted
None. The rewritten proof is Archon-bespoke substrate plumbing (tensor commutes
with open restriction), built from Mathlib primitives; the directive specifies
no external mathematical source, so no `% SOURCE` / `% SOURCE QUOTE` blocks were
written. I consulted the project's own `analogies/tsroute208.md` and
`analogies/kaehler-tensorequiv-presheafpullback.md` (Decision 5) for the
Mathlib-name inventory of Route A — these are internal analysis files, not
`references/` sources, so they require no citation block.

## Macros needed (if any)
- None. All math uses existing macros (`\Scheme`, `\mathtt`, `\Spec`, etc.).

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent

- **Stale dead-route prose remains in three out-of-scope locations** (the
  directive restricted me to the two lemma blocks + their `\uses` edges, so I
  did NOT edit these; they need a follow-up writer pass):
  1. `sec:tensorobj_motivation` (the long paragraph ending ~"the comparison map
     is the oplax δ of the left adjoint, produced by `leftAdjointOplaxMonoidal`
     … the sole project-side ingredient is the sectionwise
     `(restrictScalars φ).LaxMonoidal` instance, and flatness of line bundles
     then makes δ an isomorphism"). Now describes the dead route.
  2. `sec:tensorobj_api_survey` ("The gap" paragraph: same δ / lax-monoidal /
     flatness narrative, and it still calls the iso "flat-scoped" for "line
     bundles L, M"). Now stale: the iso is for arbitrary M, N and uses no
     flatness.
  3. `sec:tensorobj_loc_estimates`, Piece 2 bullet: describes
     `tensorObj_restrict_iso` "via the oplax δ of `leftAdjointOplaxMonoidal` …
     flatness of line bundles … upgrades δ to an isomorphism via
     `Module.Invertible.lTensor_bijective_iff`". Should be re-pointed to the
     sectionwise-unfolding helper + `restrictScalarsEquivalenceOfRingEquiv`, and
     the "flat-scoped" framing dropped.
  Recommend dispatching a follow-up blueprint-writer for this same chapter to
  bring those three prose passages in line with Route A. They do not affect the
  `\uses` graph or any `\lean{...}` pin, but they will read as contradicting the
  rewritten `lem:tensorobj_restrict_iso` until updated.

- The downstream existence-of-iso lemmas (`lem:tensorobj_assoc_iso`,
  `_unit_iso`, `_comm_iso`) and their proofs still phrase their reduction as
  "every tensor product … is again a line bundle, hence flat, so
  `lem:tensorobj_restrict_iso` applies". With the lemma now holding for
  arbitrary modules, the "hence flat" justification is no longer *needed* to
  invoke it (though it remains *true* and harmless). I left these untouched per
  the out-of-scope instruction; flagging in case the plan agent wants them
  simplified later.

## Strategy-modifying findings
None. The rewrite stays within the existing strategy (the substrate route to the
relative Picard group law); it only changes *how* `tensorObj_restrict_iso` is
proved (open-immersion base change vs. the abandoned mate-δ), and broadens the
lemma to arbitrary modules — which strictly strengthens it and breaks no
downstream consumer.

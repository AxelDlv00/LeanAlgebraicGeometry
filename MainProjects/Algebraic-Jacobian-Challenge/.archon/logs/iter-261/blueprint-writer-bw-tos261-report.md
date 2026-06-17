# Blueprint Writer Report

## Slug
bw-tos261

## Status
COMPLETE — all three directed fixes applied; chapter remains valid LaTeX.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### FIX 1 — `lem:dual_restrict_iso` leg-(A) paragraph rewritten to route-(2)
- **Revised** the paragraph headed *"The leg-(A) atom `sliceDualTransport`"* (was ~L5786–5830).
  It previously described `sliceDualTransport` as a *consumer / per-`V` localization* of the
  shared root `overEquivalence U` (consuming `restrictOverIso` / `unitOverIso`). It now reads:
  - `sliceDualTransport f M V` is a single `𝒪_Y(V)`-linear equivalence realizing leg (A)
    **built by hand**, explicitly *not* obtained from a sheaf-level slice equivalence.
  - Added the structural reason: the sheaf-of-modules slice equivalence compares restriction
    functors/units but carries **no internal-hom/dual content**; leg (A)'s assertion (dual
    commutes with slice reindexing along `f.opensFunctor`) would need a monoidal-closed
    structure the development deliberately avoids (`\cref{rem:scheme_modules_monoidal_off_path}`).
  - Forward/inverse = `eqToHom`-conjugation of slice-Hom components across `f.opensFunctor`,
    transported along the down-set identity `image_preimage_of_le` (`ι(ι⁻¹(V)) = V`), naturality
    by `Subsingleton.elim` on the thin poset `Opens Y` — same pattern as `homLocalSection` /
    `dualUnitIsoGen`.
  - Step-4 residual = `PresheafOfModules.isoMk` of (leg (A) = `sliceDualTransport`) ; (leg (B) =
    `restrictScalarsRingIsoDualEquiv` along the ring iso `(f.appIso V).inv`), outer naturality
    thin-poset-trivial.
- **Deleted** the iter-260 review `% NOTE ...` comment block flagging route-1 as wrong.
- Kept the `% NOTE` on the `𝒪_Y(V)`-module structure (`Module.compHom (β.app V)`), reworded to
  reference the leg-(A) source Hom rather than the now-removed displayed equivalence.

### FIX 2 — stale `\uses` edges removed on `lem:dual_restrict_iso`
- **Revised** both the statement block (`\uses` near L5673) and the proof block (`\uses` near
  L5702): removed `def:sheafofmodules_over_equivalence`,
  `lem:sheafofmodules_restrict_over_iso`, `lem:sheafofmodules_unit_over_iso`. Kept
  `lem:internal_hom_isSheaf` and `lem:restrictscalars_ringiso_dualequiv`.

### FIX 3 — Sq2b prose of `lem:pullback_tensor_map_basechange` corrected
- **Revised** the "Second" proof-method paragraph: replaced the overstated
  `extendScalarsComp`/`restrictScalarsComp`/`homEquiv_extendScalarsComp` change-of-rings
  framing with the actual **short sectionwise pure-tensor collapse**: `pushforward_μ_eq`
  reduces the pushforward μ *definitionally* to the lighter `restrictScalars` μ on the
  strongly-monoidal pushforward objects, after which `ModuleCat.restrictScalars_μ_tmul`
  collapses each pure tensor `m ⊗ n`. States plainly that Sq2b (`pullbackComp_δ` together
  with `pushforwardComp_lax_μ`) is now fully discharged.
- **Revised** the "genuinely missing ingredients" sentence: removed Sq2b from the missing
  list; the only genuinely-remaining ingredients are Sq1 (`sheafificationCompPullback`) and
  Sq4 (`pullbackValIso`); Sq2b is recorded as fully discharged.
- **Deleted** both iter-260 review `% NOTE ...` comment blocks in this region.

## Cross-references introduced
- `\cref{rem:scheme_modules_monoidal_off_path}` in the rewritten leg-(A) paragraph — verified
  the label is defined in this same chapter (L395).
- No new `\uses` edges added (FIX 2 only removed edges).

## References consulted
None — all three fixes are corrections of project-internal prose to match the committed Lean
state described in the directive. No external `% SOURCE` / `% SOURCE QUOTE` citations were
added or altered (the existing Stacks 01CM internal-hom-pullback quote on `lem:dual_restrict_iso`
was left intact).

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The shared-root blocks `def:sheafofmodules_over_equivalence`,
  `lem:sheafofmodules_restrict_over_iso`, `lem:sheafofmodules_unit_over_iso` remain in the
  chapter (their own definition/proof blocks, ~L5593–5663) — only the `\uses` edges from
  `lem:dual_restrict_iso` were removed, as directed. If those three lemmas now have no other
  consumer in the dependency graph, the plan agent may want to confirm whether they should be
  retained as standalone substrate or pruned in a later pass (out of scope this round).

## Strategy-modifying findings
None.

# Informal notes

Campaign plans and per-declaration proof sketches.  Unlike `../analogies/` (which
is history), most of this directory is **live**: each note is the informal working
document for a declaration or cone that is still open.  Status as of 2026-07-27.

## Live

- `pic-representability-campaign.md` (72 KB) — the plan of record for
  `instHasPicScheme` (D3 Milne–Kollár route, with the milestone DAG).  The largest
  open cone; 18 live references in the tree.
- `milne-lemma-3.3.md` — verbatim Milne source plus the four-substep Lean
  decomposition.  **No longer open:** the lemma is proved in `Albanese/Milne33.lean`
  (run 0069) and `Albanese/CodimOneExtension.lean` is `sorry`-free.  Kept as the
  source transcription behind that chain.
- `higherDirectImage.md` — records the foundational
  `EnoughInjectives`/`IsGrothendieckAbelian (SheafOfModules R)` mathlib gap and the
  decision to carry `[HasInjectiveResolutions]` as a hypothesis.  Still in force.
- `affineBaseChange_pushforward_iso.md` — the missing affine dictionary for the flat
  base-change frontier; the declaration is still sorried in `FlatBaseChange.lean`.
- `isLocallyInjective_whiskerLeft_of_W.md` — the complete route-(d) proof
  (`W` = stalkwise iso), and why the flat route is false for invertibles over
  non-affine opens.
- `chartOverIso.md` — restrict-vs-over type analysis; still the `sorry` in
  `Picard/LineBundleCoherence.lean`.
- `dual_restrict_iso.md` — Steps 1–4 decomposition with the exact residual; live in
  `SheafOverEquivalence`/`PresheafDualPullback`.
- `KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero.md` — proves a stated lemma
  **false** with two counterexamples (standard-smooth ≠ geometrically connected).  A
  recorded dead end: keep even though its host `ChartAlgebra.lean` is gone, or it
  will be re-attempted.

## Review — stale journals, live subjects

- `tensorObj_restrict_iso.md` — an iter-208 "compiles GREEN" snapshot with stale line
  numbers, and its three-step reduction is restated in `dual_restrict_iso.md`.  The
  declaration itself is very much alive (87 references), so retire the journal, not
  the mathematics.
- `exists_tensorObj_inverse.md` — an iter-218 blocker report opening with an unrelated
  tooling incident; the dual / internal-hom route it recommends has since been built
  (`TensorObjSubstrate/DualInverse/`, `PresheafInternalHom`).  Declaration still live
  (39 references).

## Superseded

- `projectiveLineBar_geomIrred.md`, `projectiveLineBar_smoothOfRelDim.md` — both
  target `Genus0BaseObjects/BareScheme.lean` in the genus-0 lane deleted 2026-06-23.
  `ProjectiveLineBar` has **zero** references anywhere in the tree.

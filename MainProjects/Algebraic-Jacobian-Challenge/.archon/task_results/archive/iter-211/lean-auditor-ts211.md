# Lean Audit Report

## Slug
ts211

## Iteration
211

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 2 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - (Known / already tracked) The module-level `/-! ... -/` docstring (lines 37–85) is stale: item 3 of the 4 blueprint-pinned declarations still names `AlgebraicGeometry.Scheme.Modules.monoidalCategory`, which was deliberately removed at the iter-206 pivot. The "Status (iter-202 Lane TS — file-skeleton scaffold)" heading is also anachronistic. Reported once per directive.
  - The `addCommGroup_via_tensorObj` docstring (lines 707–712) still reads "iter-202 Lane TS scaffold" and "iter-204+ closure target for the residual…". Current iteration is 211; the timeline stamps are stale (the sorry remains, so the status text is accurate, but the iter labels are misleading). Minor.
  - **10 uses of the deprecated `CategoryTheory.Sheaf.val`** — all generated compiler warnings (lines 366, 383, 428, 445, 447, 457, 459, 467, 469, 477). The replacement accessor is `ObjectProperty.obj`. Every substantive new non-sorry definition in the `Scheme.Modules` namespace uses the deprecated form at least once (`tensorObj`, `tensorObj_functoriality`, `tensorObjIsoOfIso`, `tensorObj_unit_iso`, `tensorObj_left_unitor`, `tensorObj_right_unitor`, `tensorObj_braiding`). This is a systematic API-drift issue; the file will break at any Mathlib-pin bump that removes the deprecation alias.
  - **`ext r` unused pattern** (line 120, inside `restrictScalarsLaxε.naturality`): the compiler warning "`ext` did not consume the patterns `r`" confirms `r` is introduced but never used. Either remove the pattern (`ext` without `r`) or use it in the subsequent rewrite.
  - **10 uses of `erw`** (lines 122, 125, 140, 207, 217, 240, 296, 302, 303, 305). The directive explicitly sanctions only line 305 (`erw [TensorProduct.tmul_zero]; rfl`) as bridging a `restrictScalars` defeq. The remaining 9 are clustered around `PresheafOfModules.unit_map_one` (×2), `PresheafOfModules.Monoidal.tensorObj_map_tmul` (×4), `toPresheaf_map_app_apply` (×3), and `presheaf_map_apply_coe` (×3 — overlapping). They are presumably all necessary for the same `restrictScalars`/`forget₂`/`coercion` transparency layer, but none of the non-305 sites have an explanatory comment, leaving their necessity implicit rather than documented.
  - **`set_option backward.isDefEq.respectTransparency false in`** (lines 111, 127, 144) applied to `restrictScalarsLaxε`, `restrictScalarsLaxμ`, and `restrictScalarsLaxMonoidal`. Per the Lean docs, this reverts to the old (more expensive) transparency behavior where all implicit arguments are bumped to `.default` during `isDefEq`. These proofs are therefore sensitive to the option default changing, and the three occurrences confirm that the `restrictScalars ⋙ forget₂ CommRingCat RingCat` coercion chain does not unify at `.instances` transparency. Localized and correct, but worth flagging as a brittleness signal.
  - **`@[implicit_reducible]`** on `addCommGroup_via_tensorObj` (line 714): LSP confirms this is a valid Lean 4 attribute ("Marks a definition as `[implicit_reducible]`, meaning it is unfolded at `TransparencyMode.instances` or above but *not* at `TransparencyMode.reducible`"; it is what the `instance` command adds automatically). The docstring explains the intent — the def is used instead of an `instance` to avoid an instance diamond with `PicSharp.addCommGroup` in `RelPicFunctor.lean`, and `@[implicit_reducible]` preserves instance-resolution unfolding. The use is correct. No finding.
  - The sanctioned sorry bodies (`tensorObj_assoc_iso` line 506, `tensorObj_restrict_iso` line 636, `exists_tensorObj_inverse` line 679, `addCommGroup_via_tensorObj` line 718) all carry substantive recipe-level documentation and are noted in the directive. Not flagged.
  - The `isLocallySurjective_whiskerLeft`, `isLocallyInjective_whiskerLeft_of_flat`, and `W_whiskerLeft_of_flat` proofs are all complete (no sorry), and the diagnostic report is clean for those lines. The mathematical structure of each proof is sound (induction on tensor products, flatness via `Module.Flat.lTensor_exact`, the `W_iff_isLocallyBijective` rewrite). No issues.
  - `tensorObj_isLocallyTrivial` (lines 649–662) is a fully elaborated proof, but it calls `tensorObj_restrict_iso` (line 660), which is a sorry. This is acknowledged in the docstring and is a known transitive dependency. No independent finding.
  - `restrictIsoUnitOfLE` (lines 521–543) uses `CategoryTheory.final_of_representablyFlat _` (line 529) to derive `Final` for `Opens.map j.base` where `j` is an open immersion. This is an indirect route — open immersions should have a more direct `Final` instance. However, since open immersions are representably flat, this is mathematically correct and the diagnostics report no error. Minor observation.
  - `PresheafOfModules.restrictScalarsLaxMonoidal` (lines 147–176): full proof, axiomatic fields discharged sectionwise via `Functor.LaxMonoidal.*` lemmas. Structure is correct.

---

## Must-fix-this-iter

None.

No excuse-comments, no wrong definitions, no unauthorized sorry bodies, and no substantive claims with `:= True`, `:= Classical.choice _`, or axiom bodies.

---

## Major

- `TensorObjSubstrate.lean:366,383,428,445,447,457,459,467,469,477` — 10 compiler-warning uses of the deprecated `CategoryTheory.Sheaf.val`; all new non-sorry `Scheme.Modules` definitions are affected. Should be updated to `ObjectProperty.obj` before the next Mathlib-pin bump that removes the alias.
- `TensorObjSubstrate.lean:37–85` — Module docstring is stale: lists `monoidalCategory` as item 3 of the 4 blueprint-pinned declarations (removed at iter-206 pivot) and carries "iter-202 Lane TS" status heading. (Known issue, reported once per directive.)

---

## Minor

- `TensorObjSubstrate.lean:120` — `ext r` unused pattern in `restrictScalarsLaxε.naturality`; compiler warning confirms `r` is never consumed. Fix: `ext` with no pattern, or consume `r`.
- `TensorObjSubstrate.lean:122,125,140,207,217,240,296,302,303` — 9 `erw` uses beyond the one sanctioned at line 305. Individually they are probably correct (same defeq layer as line 305), but none carry an explaining comment. The recurrence of `presheaf_map_apply_coe` + `tensorObj_map_tmul` as a paired pattern (lines 240, 302–303) in two separate proofs suggests a shared sectionwise unfolding friction point that would benefit from a named helper lemma.
- `TensorObjSubstrate.lean:111,127,144` — `set_option backward.isDefEq.respectTransparency false in` on `restrictScalarsLaxε`, `restrictScalarsLaxμ`, `restrictScalarsLaxMonoidal`. Localized with `in`, but signals that `restrictScalars` implicit arguments don't unify at default (`.instances`) transparency — a brittleness marker.
- `TensorObjSubstrate.lean:707–712` — `addCommGroup_via_tensorObj` docstring carries stale iteration timestamps ("iter-202 Lane TS scaffold", "iter-204+ closure target") while the current iteration is 211. The sorry status itself is accurate; only the timeline labels are stale.
- `TensorObjSubstrate.lean:529` — `final_of_representablyFlat _` used to prove `Final` for an open-immersion opens-map; an open-immersion-specific `Final` instance would be more direct. Correct but surprising route.

---

## Excuse-comments (always called out separately)

None. The `tensorObj_restrict_iso` comments (lines 596–635) are a mathematical diagnosis of the residual obstacle, not an admission that the code is wrong. The docstrings for sanctioned sorry declarations state the body type and the closure plan clearly, without apologetic language.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (1 deprecation cluster + 1 known-stale docstring)
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: The newly-added FlatWhisker proofs and `Scheme.Modules` definitions are mathematically well-structured and compile cleanly; the sole actionable cluster is the pervasive use of the deprecated `Sheaf.val` accessor (10 warnings across all 7 non-sorry new definitions), which needs a mechanical sweep to `ObjectProperty.obj` before the next Mathlib pin.

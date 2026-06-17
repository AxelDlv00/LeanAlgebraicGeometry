# Recommendations for the next plan iteration (post-iter-233)

## HIGH — mechanical, do first

1. **Wire `StalkTensor.lean` into the aggregator.** Add
   `import AlgebraicJacobian.Picard.TensorObjSubstrate.StalkTensor` to
   `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (alongside `Vestigial`, `PresheafInternalHom`).
   This is **free** — the file has 0 sorries — and makes the d.2 forward map enter the canonical build,
   consistent with the `% archon:covers` annotation. The StalkTensor prover explicitly flagged this as
   a wiring TODO it cannot do itself (refactor/plan domain).

2. **Decide HigherDirectImage wiring deliberately.** Wiring it adds **3 sorries** to the canonical count.
   Either (a) keep it an orphan until its proofs progress, or (b) wire it and accept the +3 (matching the
   FlatBaseChange precedent). Recommend (a) for now — the 3 lemmas are deep Mathlib-gap blocked; wiring
   only inflates the counter without build value. Record the choice explicitly so it is not re-litigated.

## HIGH — the critical path (d.2 → pic_commgroup)

3. **The d.2 lane is now the named critical path; do not let it churn.** The next round on
   `StalkTensor.lean` must land at minimum `stalkTensorLinearMap` (the `R_x`-linear upgrade of
   `stalkTensorDesc`). Concrete decomposition (from the prover + LVB):
   - (i) `stalkTensorDescU_smul` — blocked by CommRingCat/RingCat **carrier duality**. Build the small
     `RingEquiv`/`eqToHom` bridge between `↑(R.obj (op U))` and `↑((R ⋙ forget₂).obj (op U))` first,
     then `TensorProduct.smul_tmul'` + `germ_smul` compose (~20–40 LOC).
   - (ii) `stalkTensorLinearMap` — mirror the existing d.1 `PresheafOfModules.stalkLinearMap` in
     `Vestigial.lean` (~L391–426): same germ-representative pattern with `germ_exist` + `germ_res` +
     `germ_smul`.
   - (iii) reverse map `stalkTensorInv` via `TensorProduct.lift` of an `R_x`-bilinear map out of the two
     stalks — the larger piece (~150–250 LOC, nested colimit descent).
   - (iv) `stalkTensorIso` — bundle (ii)+(iii) as mutually inverse on generators (`germ a ⊗ germ b`),
     using `stalkTensorDesc_germ_tmul` and `TopCat.Presheaf.stalk_hom_ext`.
   Keep it mathlib-build (no sorry pins). **Gate the lane:** the next round PASSES only if it lands
   `stalkTensorLinearMap` (or further); a third no-iso round = stop and reconsider the reverse-map
   strategy before continuing.

## HIGH — code correctness (HigherDirectImage)

4. **`flatBaseChange_higherDirectImage_isIso` — two flagged issues (auditor + LVB, major).**
   - Add the missing `(hi : 1 ≤ i)` hypothesis (the theorem is intended for `i ≥ 1`; the Čech/spectral-
     sequence proof does not handle `i = 0`, which is the separate `FlatBaseChange.lean` argument), OR
     explicitly document why it is stated for all `i : ℕ`.
   - The conclusion `Nonempty (…≅…)` cannot serve as a source of the canonical natural transformation.
     Plan to upgrade it to the actual (canonical) isomorphism once the higher base-change map is built;
     do not leave a permanently-weak statement.
   This is a prover/refactor fix on the file, not a blueprint-only fix.

## MEDIUM — blueprint-writer follow-ups (all "major", blueprint-side, 0 must-fix)

5. **`Picard_TensorObjSubstrate.tex` (`sec:tensorobj_stalk_tensor`):** the proof sketch is under-specified
   for the remaining iso steps. Add named sub-steps (forward map done → `stalkTensorDescU_smul` →
   reverse map → mutual inversion on germs), note the carrier-duality obstacle, and clarify the direction
   asymmetry. Optionally add a `\lean{PresheafOfModules.stalkTensorDesc}` pin (partial/scaffold) so the
   in-progress work is machine-readable.
6. **`Cohomology_HigherDirectImage.tex`:** record `[HasInjectiveResolutions X.Modules]` on the 3 downstream
   statement blocks (not just the def `% NOTE`); document the `1 ≤ i` drop and the `Nonempty` weakening in
   `thm:flat_base_change_higher`.
7. **`Cohomology_FlatBaseChange.tex`:** add a "Project-local locality criteria" supplement subsection with
   `\lean{}` blocks for the 3 new locality lemmas and `\uses{}` tags from `lem:affine_base_change_pushforward`.

## MEDIUM — the next engine sub-lane

8. **Tilde dictionary as its own mathlib-build lane** (`Cohomology/TildeDictionary.lean`): build
   `pushforward (Spec.map φ)` of tilde ≅ `restrictScalars φ` and `pullback (Spec.map φ)` ≅ base change
   `extendScalars φ`; then `affineBaseChange_pushforward_iso` closes via
   `TensorProduct.AlgebraTensorModule.cancelBaseChange` (verified present, axiom-clean). This is the
   single remaining blocker for the affine theorem (locality half already done this iter).

## Do NOT retry

- `TopCat.Sheaf.isIso_iff_isIso_basis` — loogle reports it but it is **ABSENT** in the pinned Mathlib.
  Use the stalk route (`isIso_of_stalkFunctor_map_iso` + germ-of-basis lifts), as `FlatBaseChange.lean`
  does.
- Abstract derived-functor vanishing for `higherDirectImage_affine_eq_zero` — `pushforward f` is NOT
  exact on the full `X.Modules` even for affine `f`; the genuine proof needs the explicit `Rⁱf_*`
  description (Stacks 02KG), Mathlib-absent.
- Both alternative associator routes (already excised by the planner): the flat-restriction associator
  (FALSE — no global sectionwise flatness) and reading the associator off Mathlib monoidal-sheafification
  (`Sites.Point.IsMonoidalW` ABSENT; needs `MonoidalClosed (PresheafOfModules)`).

## Reusable patterns discovered (see PROJECT_STATUS Knowledge Base)

- `colimit.desc` into `AddCommGrpCat` cocone naturality: bare `ext z` + `TensorProduct.induction_on`;
  `tmul` via `erw` chain (`erw` essential for `R` vs `R⋙forget₂`); `zero`/`add` via term-mode
  `AddMonoidHom.map_*` (generic `map_zero`/`map_add` don't match the `AddCommGrpCat.Hom.hom` wrapper).
- `Scheme.Modules` iso-locality: stalk route via packaging `Ab`-presheaves as `TopCat.Sheaf` +
  `isIso_of_stalkFunctor_map_iso` + `toPresheaf` reflects isos; `((toPresheaf X).map φ).app (op U)` is
  defeq-not-syntactic to `φ.app U` → `stalkFunctor_map_germ_apply` needs `erw` + trailing `rfl`.

# AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

## Summary
- **Declarations added (5, all axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `preadditiveCoyoneda_mapHomologicalComplex_d_apply` (private helper, line 263)
  - `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` (line 274) — **Bridge (1)/(2) homological remainder**
  - `enoughInjectives_of_hasInjectiveResolutions` (line 299) — the requested EnoughInjectives connector
  - `subsingleton_ext_of_iso_fst` (line 310) — contravariant `Ext`-transfer along a first-arg iso
  - `ext_jShriekOU_eq_zero_of_specIso` (line 332) — **Bridge (2) Serre-vanishing assembly**
- **Leaf `higherDirectImage_openImmersion_acyclic` progress:** the line-373 `sorry`
  (`IsZero (coyoneda rightDerived q H)`) is now **discharged through bridge (1)/(2)** down to the two
  named geometric transport sub-lemmas. `hV'` (affineness of the image open) is **proved inline**.
- **Sorry count in this file: 2 → 3.** Net **+1**, an *intentional factoring*: the single opaque
  `Ext`-vanishing residual is replaced by exactly the two blueprint-named geometric sub-lemmas
  `hjt` (`jShriekOU` transport iso) and `hqc` (qcoh preservation). The whole assembly
  `ext_jShriekOU_eq_zero_of_specIso U U.isoSpec (j⁻¹W) H q hq V' hV' hjt hqc e` **typechecks**
  (validated via `lake env lean`), so the reduction is signature-correct — only the two geometric
  isos remain. `_comp` (line 551) sorry unchanged.
- **`lake env lean` on the file: EXIT 0**, only the two expected `declaration uses sorry` warnings.

## isZero_coyoneda_rightDerived_of_forall_ext_eq_zero (line 274) — RESOLVED, axiom-clean
- **Approach:** The deep "Bridge (1)" `(coyoneda(op P)).rightDerived q ≅ Ext^q(P,-)` is avoided.
  Instead: `InjectiveResolution.isoRightDerivedObj` identifies the right-derived object with the
  homology at `q` of the abelian-group Hom-cochain-complex `n ↦ (P ⟶ Iⁿ)`; that complex is exact at
  `q ≥ 1` **iff every class of `Ext P H q` is zero**, read off directly from
  `InjectiveResolution.extMk_eq_zero_iff` (a `q`-cocycle `f : P ⟶ I^q` is a coboundary iff
  `extMk f = 0`). Wired via `HomologicalComplex.exactAt_iff'` + `ShortComplex.ab_exact_iff` and the
  private apply-lemma for the post-composition differential.
- **Key Mathlib:** `InjectiveResolution.{isoRightDerivedObj, extMk_eq_zero_iff}`,
  `Functor.mapHomologicalComplex_obj_d`, `ShortComplex.ab_exact_iff`,
  `HomologicalComplex.{ExactAt.isZero_homology, exactAt_iff'}`, `preadditiveCoyoneda`.
- **Note:** This sidesteps the planner's suggested `extAddEquivCohomologyClass ∘ homologyAddEquiv`
  (ℤ-indexed `HomComplex`/`CohomologyClass`) route entirely — `extMk_eq_zero_iff` works on the
  ℕ-indexed `cocomplex` so there is no ℕ/ℤ degree reconciliation.

## enoughInjectives_of_hasInjectiveResolutions (line 299) — RESOLVED, axiom-clean
- **Approach:** degree-0 term of a chosen injective resolution + its mono unit = an injective
  presentation. **Trap:** the auto `Mono`/`Injective` structure-default tactics *fail to synthesize*
  in this file's environment (they succeed in clean Mathlib) — must supply explicitly
  `mono := CategoryTheory.InjectiveResolution.instMonoFNatι R 0`, `injective := R.injective 0`, and
  obtain a *concrete* `R` from `(HasInjectiveResolutions.out X).out` (the opaque `injectiveResolution X`
  also defeated synthesis).

## subsingleton_ext_of_iso_fst (line 310) — RESOLVED, axiom-clean
- **Approach:** every `z : Ext A Y q` equals `(mk₀ φ.hom).comp ((mk₀ φ.inv).comp z)`
  (`Ext.mk₀_comp_mk₀_assoc` + `φ.hom_inv_id` + `Ext.mk₀_id_comp`); the inner factor lands in the
  subsingleton `Ext B Y q`, so `z = 0` by `Ext.comp_zero`.

## ext_jShriekOU_eq_zero_of_specIso (line 332) — RESOLVED, axiom-clean
- **Approach:** generic over `φ : U ≅ Spec R`. Uses the already-built `pushforwardExtAddEquiv φ`
  (spectrum transport) + `EnoughInjectives.of_equivalence Φ.inverse` (Spec-side enough injectives
  from the U-side connector) + `subsingleton_ext_of_iso_fst hjt` (transfer along the transport iso) +
  `affine_serre_vanishing_general_open` (the now-unconditional Need#2 result). `htr.injective` then
  forces `e = 0`. Takes `V'`/`hV'`/`hjt`/`hqc` as hypotheses so the residual geometry is isolated.

## hV' (image-open affineness) — RESOLVED inline in the leaf
- `(hW.preimage j).preimage_of_isIso U.isoSpec.inv` : `j⁻¹W` affine (affine morphism `IsAffineHom j`)
  then preimage under the iso `U.isoSpec.inv`. Both `IsAffineOpen.preimage` (needs `[IsAffineHom j]`,
  already in context) and `IsAffineOpen.preimage_of_isIso` are in Mathlib.

## hjt / hqc (the two residual leaf sorries, lines 484/485) — NOT ADDED
These are the blueprint-named geometric transport sub-lemmas; both are genuine Mathlib gaps:
- **`hjt : Φ(jShriekOU (j⁻¹W)) ≅ jShriekOU V'`** (`lem:jshriek_transport_along_iso`). Needs the three
  pushforward-commutation sub-lemmas `pushforward_commutes_free`, `pushforward_commutes_sheafify`,
  `yoneda_transport_along_homeo` (unfold `jShriekOU = sheafification(free(yoneda V))` and chase the iso
  through each functor; the presheaf pushforward `Φ_pre` relabels opens by the homeomorphism). These are
  deep adjunction-mate / left-adjoint-uniqueness natural-iso constructions — not attempted (high LOC,
  out of this session's budget after the homological bridge work).
- **`hqc : (Φ H).IsQuasicoherent`** (`lem:pushforward_iso_preserves_qcoh`). **Confirmed Mathlib gap:**
  `Scheme.Modules.pushforward` (Modules/Sheaf.lean) has NO qcoh-preservation lemma (pushforward
  preserves qcoh only along iso/qcqs, not in general). Requires transporting the local
  `QuasicoherentData` presentation across the iso of ringed spaces. Not attempted.
- **Dead-end note:** there is no Mathlib `Functor.rightDerived ≅ Ext` lemma (Ext is derived-category
  based); the `extMk_eq_zero_iff` route in bridge (1) is the correct replacement — do not look for one.

## Why I stopped
**Real progress:** 5 axiom-clean declarations added (lines 263, 274, 299, 310, 332) + `hV'` proved
inline + the leaf's deep `Ext` residual factored (validated by typecheck) into the two named geometric
sub-lemmas. The homological half of the open-immersion acyclicity (Bridge (1)/(2) remainder) is fully
discharged. Remaining: the two **geometric** transport isos (`hjt`, `hqc`), which are large
natural-iso / qcoh-transport constructions with no Mathlib shortcut — the correct next lane.

## Needs blueprint entry
The following new non-private declarations are `lean_aux` nodes needing blueprint blocks (planner):
1. `AlgebraicGeometry.isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`
   — relies on `InjectiveResolution.isoRightDerivedObj`, `InjectiveResolution.extMk_eq_zero_iff`,
   `ShortComplex.ab_exact_iff`, `HomologicalComplex.exactAt_iff'`. (Could anchor `lem:bridge_1_2_remainder`
   or a new `lem:ext_vanishing_coyoneda_rightDerived`.)
2. `AlgebraicGeometry.enoughInjectives_of_hasInjectiveResolutions`
   — connector `HasInjectiveResolutions C → EnoughInjectives C` (degree-0 of a resolution).
3. `AlgebraicGeometry.subsingleton_ext_of_iso_fst`
   — `Ext.mk₀_comp_mk₀_assoc` + `Ext.mk₀_id_comp` + `Ext.comp_zero`.
4. `AlgebraicGeometry.ext_jShriekOU_eq_zero_of_specIso`
   — assembly; relies on `pushforwardExtAddEquiv`, `affine_serre_vanishing_general_open`,
   `EnoughInjectives.of_equivalence`, and (as hypotheses) `lem:jshriek_transport_along_iso` +
   `lem:pushforward_iso_preserves_qcoh`. Natural anchor extending `lem:open_immersion_pushforward_comp`'s
   Bridge (2).

Blueprint `\leanok` is owned by `sync_leanok` — not touched.

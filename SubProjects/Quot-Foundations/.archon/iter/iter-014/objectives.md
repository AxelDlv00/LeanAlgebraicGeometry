# Iter 014 — Per-lane objective detail

## Lane GF — `gf_torsion_reindex` (a)–(e) helper-factoring recipe

Source: the iter-012 GF prover task result (the hard content `Module.Finite (P_g ⧸ ⟨F_g⟩) T_g'`
already landed and compiles; what remains is the (a)–(e) transport, which blows `isDefEq`/`whnf`
heartbeats when stacked INLINE on the single type `LocalizedModule MC T`). **Factor each into a
standalone top-level helper lemma with its own minimal instance context.** Verified lemma names from
the iter-012 attempt:

- **Setup already verified in-body** (keep): `algPPg := MvPolynomial.algebraMvPolynomial` (supply
  explicitly; `inferInstance` fails); `hPgloc : IsLocalization MC P_g := MvPolynomial.isLocalization
  (powers g) A_g` with `set MC : Submonoid P := Submonoid.map MvPolynomial.C (Submonoid.powers g)`
  (pin the σ or `IsLocalization` synthesis stalls); `Module P_g Tg' :=
  LocalizedModule.moduleOfIsLocalization` via **`letI`** (not `haveI` — defeq loss breaks the
  `IsScalarTower`); `Module.Finite P_g Tg' := Module.Finite.of_isLocalizedModule MC (mkLinearMap MC
  T)` (Rₚ implicit); `Module.Finite (P_g ⧸ ⟨F_g⟩) Tg'` via `Module.Finite.of_surjective` with
  `map_smul' := fun r x => (htorsion.mk_smul r x).symm`.
- **(a)** `hmap : Submonoid.map e MC = MC` (from `e.commutes`, `MvPolynomial.algebraMap_eq`), then
  `ebar := IsLocalization.algEquivOfAlgEquiv P_g P_g e hmap : P_g ≃ₐ[A] P_g`.
- **(a′)** `ebar F_g = G` with `G := MvPolynomial.map (algebraMap A A_g) (e F)`, via
  `IsLocalization.algEquivOfAlgEquiv_mk'` at the unit denominator (`IsLocalization.mk'_one`).
- **(b)** `ψ : (P_g ⧸ ⟨F_g⟩) ≃+* (P_g ⧸ ⟨G⟩) := Ideal.quotientEquiv _ _ ebar.toRingEquiv hspan`,
  `hspan : ⟨G⟩ = Ideal.map ebar ⟨F_g⟩` from (a′) via `Ideal.map_span`, `Set.image_singleton`.
- **(c)** `Module.Finite R (P_g ⧸ ⟨F_g⟩)`: `hfin = RingHom.Finite ρ`, `ρ := (Quotient.mk ⟨G⟩).comp
  (rename Fin.succ).toRingHom`; transport along `ψ.symm` as an R-linear equiv via `Module.Finite.equiv`.
- **(d)** `Module.Finite R Tg'` by `Module.Finite.trans (P_g ⧸ ⟨F_g⟩)` (with `Module R Tg' :=
  compHom θ`, `Algebra R (P_g⧸⟨F_g⟩) := θ.toAlgebra`, `IsScalarTower.of_algebraMap_smul fun _ _ => rfl`).
- **(e)** TRANSPORT to the goal's `T_g = LocalizedModule (powers g) T`: both `Tg'` (P-loc at MC) and
  `T_g` (A-loc at powers g) localize `T` at `g` over A. **VERIFIED glue (iter-014):**
  `IsLocalizedModule.linearEquiv (powers g) (LocalizedModule.mkLinearMap (powers g) T)
  ((LocalizedModule.mkLinearMap MC T).restrictScalars A) : T_g ≃ₗ[A] Tg'` — needs the
  `IsLocalizedModule (powers g)` instance on the restricted P-loc map (the "descent" the iter-012
  prover flagged as missing; build it from `IsLocalizedModule.mk'`/`surj` if the instance isn't
  synthesized). Transport the R-module structure + finiteness across that equiv; conclude with
  witnesses `g`, `m' = m` (`Nat.lt_succ_self m`).
- **Performance:** keep `set_option synthInstance.maxHeartbeats 1000000` / `maxHeartbeats 1000000`
  but the FACTORING is what avoids the blow-up, not bigger budgets.

After reindex: `exists_free_localizationAway_polynomial` (L5, `Nat.strong_induction_on d`
generalizing base domain A into the motive — IH typechecks at base `A_g`) →
`exists_localizationAway_finite_mvPolynomial` (L4, Finset-fold over `gf_clear_one_denominator`) →
`genericFlatnessAlgebraic`. `gf_mvPolynomial_quotient_finite_monic` discharges `RingHom.Finite`.

## Lane FBC — Seam 1 abstract conjugate-unit calculus

Source: `analogies/fbc-mate.md` (api-alignment, iter-014). Seam 1 = `base_change_mate_unit_value`
(`sorry` ~1010): the affine pullback–pushforward adjunction unit, read on sections via the tilde
dicts, equals the algebraic `extendRestrictScalarsAdj` unit `η_M`. **NO element/ext chase** — the
`conjugateIsoEquiv` element action is opaque by design (the 2-iter dead end). Four moves:

1. `Adjunction.comp_unit_app` + `tilde.adjunction` definitional unit (`toTildeΓNatIso.hom`,
   `Mathlib/AlgebraicGeometry/Modules/Tilde.lean`) ⟹ seam factors 1+2 = `adjL.unit.app M`.
2. `unit_conjugateEquiv_symm adjL adjR (gammaPushforwardNatIso inclA).hom M` (from
   `Mathlib/CategoryTheory/Adjunction/Mates.lean`) ⟹ the central identity
   `adjL.unit.app M ≫ β.hom.app (L₁.obj M) = adjR.unit.app M ≫ R₂.map ((pullback_spec_tilde_iso
   inclA M).inv)`, `β := gammaPushforwardNatIso inclA`; the `.inv` identification via
   `conjugateIsoEquiv_symm_apply_hom` + `Iso.symm`.
3. `Adjunction.comp_unit_app` on `adjR.unit` ⟹ split off `extendRestrictScalarsAdj.unit.app M` (RHS)
   from the residual `restrictScalars.map(tilde-Γ unit)` factor.
4. ONE project-local dictionary-bridge iso identity at the `gammaPushforwardIso` level: match the
   seam's second bracket (`pushforward_spec_tilde_iso` + `toTildeΓNatIso` + `Γ_A.map(pushforward.mapIso
   (pullback_spec_tilde_iso))`) against `β.hom.app(L₁.obj M) ≫ R₂.map(pullback_spec_tilde_iso.inv)` +
   the step-3 residual — provable by unfolding `gammaPushforwardNatIso` vs `gammaPushforwardTildeIso`,
   NOT elements. Then steps 1–3 cancel the non-algebraic factors, leaving `extendRestrictScalarsAdj.unit`.

Verified pins: `unit_conjugateEquiv_symm`, `Adjunction.comp_unit_app`, `conjugateEquiv_apply_app`.
Cascade after Seam 1: Seam 2 `fstar_reindex` (uses Seam 1 + the proven `inner_value` ρ +
`pullback_fst_snd_specMap_tensor`), Seam 3 `gstar_transpose` (uses Seam 2 + `pullback_spec_tilde_iso`)
⟹ `section_identity` (already proved mod Seam 3) ⟹ `generator_trace` ⟹ `cancelBaseChange` ⟹
`affineBaseChange_pushforward_iso`.

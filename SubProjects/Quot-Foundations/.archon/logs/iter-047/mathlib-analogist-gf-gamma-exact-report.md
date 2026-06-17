# Mathlib Analogist: gf-gamma-exact
**Mode:** api-alignment | **Iter:** 047

## Headline
The directive's premise is OBSOLETE. Mathlib `Mathlib/AlgebraicGeometry/Modules/Tilde.lean`
already has the **global tilde–Γ adjunction** (counit = `fromTildeΓ`, natural). Seam 2 is a
~12-line corollary. **No H¹-vanishing build, no new equivalence, no exactness-from-scratch.**

## Verdicts
- **`gf_affine_qcoh_Gamma_epi`**: ALIGN_WITH_MATHLIB (Must-fix the hand-wave). Mechanism =
  counit-naturality + "faithful reflects epi". Replaces blueprint's "affine Γ is exact".
- **IsIso-feeder**: PROCEED. Project's quasicoherence→`IsIso fromTildeΓ` bridge is correct;
  Mathlib only has essImage / IsLocalizing / presentation versions, not the project's predicate.

## Answers to the 3 questions
1. **YES — Mathlib has the affine qcoh⇄Mod adjunction (not just object-wise):**
   - `AlgebraicGeometry.moduleSpecΓFunctor : (Spec (.of R)).Modules ⥤ ModuleCat R` (Tilde.lean:50)
     = the affine `Γ`. Blueprint `Γ(π)` = `moduleSpecΓFunctor.map π`; `.hom` is the B-linear map.
   - `AlgebraicGeometry.tilde.adjunction : tilde.functor R ⊣ moduleSpecΓFunctor` (Tilde.lean:279).
   - `tilde.toTildeΓNatIso : 𝟭 ≅ tilde.functor ⋙ moduleSpecΓFunctor` (unit iso, Tilde.lean:273);
     `instIsIso…adjunction.unit` confirms iso.
   - `tilde.functor R` is `Full`, `Faithful`, `Additive`, `IsLeftAdjoint`, `FullyFaithful`.
   - `isIso_fromTildeΓ_iff : IsIso M.fromTildeΓ ↔ (tilde.functor R).essImage M` (qcoh = ess image).
2. **Cheapest mechanism — option (b)+(a) FUSED via the counit; NOT (c):**
   - counit `Scheme.Modules.fromTildeΓNatTrans : moduleSpecΓFunctor ⋙ tilde.functor ⟶ 𝟭`
     (Tilde.lean:248), with **`.app M := M.fromTildeΓ` definitionally** (Tilde.lean:250).
   - Square: `~(Γπ) ≫ F.fromTildeΓ = G.fromTildeΓ ≫ π` (`.naturality π`). With `IsIso _.fromTildeΓ`
     (G,F qcoh) ⇒ `~(Γπ) = G.fromTildeΓ ≫ π ≫ inv F.fromTildeΓ` is `Epi` (iso∘epi∘iso).
   - `tilde.functor` Faithful ⇒ `reflectsEpimorphisms_of_faithful` ⇒
     `Functor.epi_of_epi_map` ⇒ `Epi (Γπ)` ⇒ `ModuleCat.epi_iff_surjective` ⇒ surjective.
   - **(c) genuine H¹(affine,qcoh)=0 is NOT required** — the faithful-reflects-epi step delivers
     the same content. (No Mathlib affine-qcoh-H¹-vanishing tag is needed.)
3. **YES — `fromTildeΓ` is natural.** It is literally `fromTildeΓNatTrans.app` (Tilde.lean:250)
   = `tilde.adjunction.counit.app` (Tilde.lean:281). Naturality lemma: `fromTildeΓNatTrans.naturality`.

## Proof skeleton (every ingredient is a named Mathlib decl)
```lean
open CategoryTheory AlgebraicGeometry in
theorem gf_affine_qcoh_Gamma_epi {R : CommRingCat} {G F : (Spec R).Modules}
    (π : G ⟶ F) [Epi π] [IsIso G.fromTildeΓ] [IsIso F.fromTildeΓ] :
    Function.Surjective (moduleSpecΓFunctor.map π).hom := by
  rw [← ModuleCat.epi_iff_surjective]
  have hnat := (Scheme.Modules.fromTildeΓNatTrans (R := R)).naturality π
  haveI : Epi ((tilde.functor R).map (moduleSpecΓFunctor.map π)) := by
    have h : (tilde.functor R).map (moduleSpecΓFunctor.map π)
           = G.fromTildeΓ ≫ π ≫ inv F.fromTildeΓ := by
      simp only [Functor.comp_map, Functor.id_map] at hnat; rw [← hnat]; simp
    rw [h]; infer_instance
  exact (tilde.functor R).epi_of_epi_map ‹_›
```
Signature note: take `[IsIso _.fromTildeΓ]` (cheapest); callers feed them from quasicoherence —
free source `O_V^{⊕I}` via `isIso_fromTildeΓ_of_presentation`, finite-type `F` via project G1-core
`isIso_fromTildeΓ_of_isLocalizedModule_restrict` (`QuotScheme.lean:614`).

## Persistent file
- `analogies/gf-gamma-exact.md` written.

Overall verdict: ALIGN_WITH_MATHLIB — seam 2 is a ~12-line corollary of Mathlib's
`tilde.adjunction`; the "affine Γ is exact" hand-wave should be replaced by the faithful-reflects-epi
argument, and no H¹-vanishing infrastructure needs to be built.

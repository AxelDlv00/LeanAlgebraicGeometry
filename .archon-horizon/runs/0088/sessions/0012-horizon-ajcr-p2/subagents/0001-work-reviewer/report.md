Everything below was re-elaborated just now from scratch, after I had deleted the originals — so this is verified text, not reconstruction from memory. One correction to my report is flagged at the end.

## Finding 1: `zz_isDivisorDegree_iff_left`

```lean
import AlgebraicJacobian.Picard.Pic0ChartIndexLedgerFeed

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Opposite

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable local instance zzOv : C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [IsIntegral C.left]
  [SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k))]
  [QuasiCompact (C.left ↘ Spec (CommRingCat.of k))]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]

theorem zz_isDivisorDegree_iff_left {c : ℤ} :
    IsDivisorDegree C c ↔ ∃ W : C.left.CurveDivisor, Scheme.CurveDivisor.deg k W = c := by
  haveI := instSmoothOfRelativeDimensionBaseChange C k
  haveI := instQuasiCompactBaseChange C k
  haveI := instModuleFiniteHModuleZeroBaseChange C k
  haveI := instModuleFiniteHModuleOneBaseChange C k
  constructor
  · rintro ⟨D, hD⟩
    obtain ⟨W, hW⟩ := Scheme.CurveDivisor.exists_picClass_eq (K := k) (X := C.left)
      (Scheme.CechPic.map (inv (fst C (overSpec k k)).left)
        (Scheme.CurveDivisor.picClass k D))
    refine ⟨W, ?_⟩
    have hiso : classDeg k (Scheme.CechPic.map (fst C (overSpec k k)).left
        (Scheme.CechPic.map (inv (fst C (overSpec k k)).left)
          (Scheme.CurveDivisor.picClass k D)))
        = classDeg k (Scheme.CechPic.map (inv (fst C (overSpec k k)).left)
          (Scheme.CurveDivisor.picClass k D)) :=
      classDeg_cechPicMap_of_isIso k _ (fst_left_self_over C) _
    rw [← classDeg_picClass k W, hW, ← hiso, ← MonoidHom.comp_apply,
      ← Scheme.CechPic.map_comp, IsIso.hom_inv_id, Scheme.CechPic.map_id,
      MonoidHom.id_apply, classDeg_picClass k D, hD]
  · rintro ⟨W, hW⟩
    obtain ⟨D, hD⟩ := Scheme.CurveDivisor.exists_picClass_eq (K := k)
      (X := (C ⊗ overSpec k k).left)
      (Scheme.CechPic.map (fst C (overSpec k k)).left (Scheme.CurveDivisor.picClass k W))
    exact ⟨D, by rw [← classDeg_picClass k D, hD,
      classDeg_cechPicMap_of_isIso k _ (fst_left_self_over C), classDeg_picClass k W, hW]⟩

end AlgebraicGeometry
```

`#print axioms` → `[propext, Classical.choice, Quot.sound]`. Control `theorem zzControl : IsDivisorDegree C 17 := by sorry` in the same file → `sorryAx`, so the file was discriminating.

**1. Imports.** `import AlgebraicJacobian.Picard.Pic0ChartIndexLedgerFeed` alone suffices — I re-ran the whole proof with that as the only import, EXIT=0. My original probe also imported `RiemannRoch.WindowFieldTransport`; that import is redundant given `LedgerFeed`. If you want to put this in `Pic0ChartIndexAdmissible` instead (which imports only `ThetaShift` + `SectionSpaces`), you need one added import: `AlgebraicJacobian.RiemannRoch.WindowFieldTransport`. `ClassDegMapIso` is *not* enough on its own — it gives `classDeg_cechPicMap_of_isIso` but not `fst_left_self_over`, which lives at `WindowFieldTransport.lean:212`.

**2. Both directions needed separate proofs.** Neither is `rfl` or free. The `mpr` (from `C.left` to `C_k`) is the short one — three rewrites. The `mp` is longer because it transports along `inv` and then has to cancel `map (hom) ∘ map (inv)`, which needs the `MonoidHom.comp_apply` / `CechPic.map_comp` / `map_id` / `MonoidHom.id_apply` chain. There is no `CechPic.map` simp lemma that does that collapse in one step.

**3. The four `haveI`s, in the order shown, all before `constructor`.** They are the base-change instance pack from `Curve/BaseChangeInstances.lean`: `instSmoothOfRelativeDimensionBaseChange`, `instQuasiCompactBaseChange`, `instModuleFiniteHModuleZeroBaseChange`, `instModuleFiniteHModuleOneBaseChange`, each applied `C k`. Order among the four does not matter; all four must precede the `obtain`s, since `exists_picClass_eq` and `classDeg_picClass` at `X := (C ⊗ overSpec k k).left` need them in the statement. Two things I expected to need and did **not**: no `haveI` for `IsIntegral (C ⊗ overSpec k k).left` (`instIsIntegralBaseChange` fires by itself), and no `haveI` for `IsIso` (`isIso_fst_left_overSpec_self` is a global instance and `inferInstance` finds it — I confirmed separately with `example : IsIso (fst C (overSpec k k)).left := inferInstance`). I did need the local `C.left.Over` instance `zzOv`, matching what `LedgerFeed` itself installs as `instOverCleftLedgerFeed`. Note `attribute [local instance]` on the four base-change instances does **not** work — it fails to synthesize; they must be `haveI` inside the proof.

**4. Always applied to `(fst C (overSpec k k)).left`, never to `inv`.** Both call sites pass the forward projection, with `fst_left_self_over C` in its native direction (no `.symm`). In the `mp` branch the class being transported is itself `map (inv …) (…)`, which is why the `hiso` `have` looks like it is about `inv` — the *map* is forward, the *argument* involves `inv`. The composite that then appears is `hom ≫ inv`, so the cancellation lemma is `IsIso.hom_inv_id`, not `inv_hom_id` — that was my one wrong first guess and the error message named it.

## Finding 3: the general law and the per-`m` producer

Import: `AlgebraicJacobian.Picard.Pic0ChartIndexAdmissible` only. All six below are axiom-clean.

```lean
omit [IsProper C.hom] in
variable (C) in
theorem zz_isDegree_shift_iff {a c : ℤ} (ha : IsDivisorDegree C a) :
    IsDivisorDegree C (a + c) ↔ IsDivisorDegree C c := by
  obtain ⟨Wa, hWa⟩ := ha
  refine ⟨fun ⟨W, hW⟩ => ⟨W - Wa, ?_⟩, fun ⟨W, hW⟩ => ⟨W + Wa, ?_⟩⟩
  · rw [Scheme.CurveDivisor.deg_sub' k, hW, hWa]; ring
  · rw [Scheme.CurveDivisor.deg_add, hW, hWa]; ring
```

Note the `omit [IsProper C.hom]` — the general law does not need properness, matching how you already `omit` it on `isDegree_sub` and `isDegree_zero`. All three of your current lemmas fall out:

```lean
variable (C) in
theorem zz_isDegree_mul_thetaDeg_add_iff' (a : ℕ) (c : ℤ) :
    IsDivisorDegree C ((a : ℤ) * classDeg k (thetaCechClass C) + c)
      ↔ IsDivisorDegree C c :=
  zz_isDegree_shift_iff C (isDegree_mul_thetaDeg C a)

variable (C) in
theorem zz_isDegree_add_mul_iff' (c : ℤ) (a : ℕ) :
    IsDivisorDegree C c
      ↔ IsDivisorDegree C (c + (a : ℤ) * classDeg k (thetaCechClass C)) := by
  rw [add_comm c]
  exact (zz_isDegree_mul_thetaDeg_add_iff' C a c).symm

omit [IsProper C.hom] in
variable (C) in
theorem zz_isDegree_sub' {c c' : ℤ} (h : IsDivisorDegree C c) (h' : IsDivisorDegree C c') :
    IsDivisorDegree C (c - c') := by
  refine (zz_isDegree_shift_iff C h' (c := c - c')).mp ?_
  rwa [add_sub_cancel]
```

The per-`m` producer, inside `section` with `attribute [local instance] isFinite_thetaP1 isDominant_thetaP1`:

```lean
variable (C) in
theorem zz_chartIndex_of_isDegree_forall_m (m : ℕ) {c : ℤ} (h : IsDivisorDegree C c) :
    ∃ Z : (C ⊗ overSpec k k).left.CurveDivisor,
      Scheme.CurveDivisor.deg k Z = (m : ℤ) * classDeg k (thetaCechClass C) - c := by
  obtain ⟨W, hW⟩ := h
  refine ⟨m • fiberWeilDivisor (thetaP1 C) - W, ?_⟩
  rw [Scheme.CurveDivisor.deg_sub' k, Scheme.CurveDivisor.deg_nsmul' k, hW,
    ← classDeg_fiberTwist_one (thetaP1 C)]
  rfl

variable (C) in
theorem zz_chartIndex_of_isDegree' {c : ℤ} (h : IsDivisorDegree C c) :
    ∃ (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor),
      Scheme.CurveDivisor.deg k Z = (m : ℤ) * classDeg k (thetaCechClass C) - c :=
  ⟨0, zz_chartIndex_of_isDegree_forall_m C 0 h⟩
```

**Correction to my report.** I described the per-`m` producer as "four lines". It is five: the `rw` leaves a residual `fiberTwist (thetaP1 C) 1` vs `thetaCechClass C` goal that needs a closing `rfl`. My original probe elaborated it under `attribute [local instance]`, which supplied that unfolding; when I re-ran it today with `haveI` for the two `thetaP1` instances it left the goal open, and I only got it closed by switching back to `attribute [local instance]` and adding the `rfl`. The `attribute [local instance] isFinite_thetaP1 isDominant_thetaP1` form is load-bearing — `haveI` inside the proof is not equivalent here. The substance of the finding stands (the per-`m` producer is cheap and absent), but "four lines" was one line optimistic and the instance mechanism matters.

Everything else in my report is as stated. Scratch files removed; neither target file was modified.

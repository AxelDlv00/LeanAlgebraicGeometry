The exact next unit should be `AlgebraicJacobian/Picard/Pic0SepClosedAtlasGlueData.lean`. The smallest package is the actual canonical `Scheme.GlueData`, not a new ring-data structure:

```lean
abbrev Pic0FiniteStageChartIndex :=
  { U // U ∈ (pic0FiniteStageAtlas C).charts }

instance : Finite (Pic0FiniteStageChartIndex C) :=
  (pic0FiniteStageAtlas C).finite_charts.to_subtype

noncomputable def pic0SepClosedAtlasOpenCover :
    (pic0_sepClosed_representableBy (C := C)).1.left.OpenCover where
  I₀ := Pic0FiniteStageChartIndex C
  X U := U.1.1.toScheme
  f U := U.1.1.ι
  mem₀ := by
    rw [Scheme.presieve₀_mem_precoverage_iff]
    refine ⟨fun x => ?_, inferInstance⟩
    have hx : x ∈ (⨆ U ∈ (pic0FiniteStageAtlas C).charts, U.1) := by
      rw [(pic0FiniteStageAtlas C).iSup_opens]
      trivial
    rw [Opens.mem_iSup] at hx
    obtain ⟨U, hx⟩ := hx
    rw [Opens.mem_iSup] at hx
    obtain ⟨hU, hx⟩ := hx
    exact ⟨⟨U, hU⟩, ⟨x, hx⟩, rfl⟩

noncomputable abbrev pic0SepClosedAtlasGlueData : Scheme.GlueData.{u} :=
  (pic0SepClosedAtlasOpenCover C).gluedCover
```

This compiled in the LSP probe. It gives definitionally:

- `J = Pic0FiniteStageChartIndex C`
- `U i = i.1.1.toScheme`
- `V (i,j) = pullback i.1.1.ι j.1.1.ι`
- `f i j = pullback.fst`, oriented `Vᵢⱼ ⟶ Uᵢ`
- `t i j = pullbackSymmetry.hom`, oriented `Vᵢⱼ ⟶ Vⱼᵢ`
- `t' i j k : Vᵢⱼ ×[Uᵢ] Vᵢₖ ⟶ Vⱼₖ ×[Uⱼ] Vⱼᵢ`

`gluedCover` supplies all required proofs directly: `f_id`, `t_id`, `t_fac`, `cocycle`, and `f_open`. Also `(pic0SepClosedAtlasOpenCover C).fromGlued` is an iso onto the exact representer.

The overlap-affineness theorem also compiled:

```lean
theorem isAffine_pic0SepClosedAtlasGlueData_V
    (i j : (pic0SepClosedAtlasGlueData C).J) :
    IsAffine ((pic0SepClosedAtlasGlueData C).V (i, j)) := by
  let J := (pic0_sepClosed_representableBy (C := C)).1
  letI : GrpObj J := by
    dsimp only [J]
    exact (picRepDatumSepClosed C).grpObj
  letI : IsSeparated J.hom := isSeparated_of_grpObj J
  haveI : J.left.IsSeparated := by
    rw [Scheme.isSeparated_iff, ← terminal.comp_from J.hom]
    infer_instance
  let h := isPullback_opens_inf i.1.1 j.1.1
  letI : IsAffine ((i.1.1 ⊓ j.1.1).toScheme) := i.1.2.inf j.1.2
  change IsAffine (pullback i.1.1.ι j.1.1.ι)
  exact IsAffine.of_isIso h.isoPullback.inv
```

Imports needed are `Pic0FiniteStageAtlas`, `AbelianVariety.GroupSeparated`, and `Mathlib.AlgebraicGeometry.Gluing`.

At ring level, contravariance is:

- `(f i j).appTop.hom : Γ(Uᵢ) → Γ(Vᵢⱼ)`
- `(t i j).appTop.hom : Γ(Vⱼᵢ) → Γ(Vᵢⱼ)`
- `(t' i j k).appTop.hom` runs from the target triple-overlap ring to the source triple-overlap ring.

The finite map/equality families are indexed by `I × I` for `f` and `t`, and `I × I × I` for `t'`, `t_fac`, and `cocycle`; a tagged sum of those types is finite and gives one common stage.

Two cautions:

1. `FiniteAffineOverlapPresentation` alone cannot feed `Scheme.GlueData`: its pieces merely cover an overlap and would require another gluing layer. Separatedness removes that recursion.
2. Descending finitely many algebra maps and equations does not automatically prove the descended `f` maps are open immersions. The eventual finite-stage theorem should return an actual `Scheme.GlueData` and must separately establish `f_open`, plus a structure map to `Spec L` and a base-change comparison. `Scheme.LocalRepresentability.glueData` is not the right API for this raw atlas diagram.

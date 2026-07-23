---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushforward_iso_qcoh_of_slice_qcoh
docstring: '**Reduction of quasi-coherence of an iso-pushforward to the per-slice
  case** (Need #1 `hqc`,

  `of_coversTop` wiring). Given a quasi-coherence datum `q` for `H` and quasi-coherence
  of the

  restricted pushforward `(φ_* H).over (φ.inv ⁻¹ᵁ (q.X i))` over each preimage cover
  member, the

  pushforward `φ_* H` is quasi-coherent.  Project-local: wires Mathlib''s

  `IsQuasicoherent.of_coversTop` to the cover-transport `coversTop_preimage_of_iso`,
  isolating the

  residual per-slice obligation.'
file: AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushforward_iso_qcoh_of_slice_qcoh
type: lean
updated: '2026-07-16T21:14:26'
---
lemma pushforward_iso_qcoh_of_slice_qcoh {X Y : Scheme.{u}} (φ : X ≅ Y) (H : X.Modules)
    (q : SheafOfModules.QuasicoherentData.{u, u, u, u} H)
    (hslice : ∀ i, (((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj H).over
        (φ.inv ⁻¹ᵁ q.X i)).IsQuasicoherent) :
    ((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj H).IsQuasicoherent := by
  haveI : ∀ i, (((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj H).over
      (φ.inv ⁻¹ᵁ q.X i)).IsQuasicoherent := hslice
  exact SheafOfModules.IsQuasicoherent.of_coversTop
    ((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj H) (fun i => φ.inv ⁻¹ᵁ q.X i)
    (coversTop_preimage_of_iso φ q.X q.coversTop)

/-! ## Project-local Mathlib supplement — the slice structure-sheaf ring map `ψ_r` (Need #1 `hqc`)

The genuine wall of `hqc`: a single cross-ring slice structure-sheaf ring map `ψ_r` from which the
colimit-preserving `SheafOfModules.pullback ψ_r` is built.  For a scheme iso `φ : X ≅ Y` and an open
`Uᵢ ⊆ X` with image `Vᵢ = φ.inv⁻¹ᵁ Uᵢ ⊆ Y`, the underlying opens-equivalence functor is
`F₀ = Opens.map φ.inv.base : Opens X ⥤ Opens Y` (sending `Uᵢ` to `Vᵢ` by `rfl`).  Its slice version
`Over.post F₀ : Over Uᵢ ⥤ Over Vᵢ` is continuous and final (both because `F₀` is an equivalence,
`φ` being an iso).  The map `ψ_r` is the slice of the structure-sheaf comparison
`φ.inv.toRingCatSheafHom : 𝒪_X ⟶ (F₀.sheafPushforwardContinuous _ _ _).obj 𝒪_Y`, obtained simply by
applying the over-pullback functor `(Opens.grothendieckTopology X).overPullback RingCat Uᵢ`; the
codomain matches the desired sliced pushforward by the Beck–Chevalley identity
`Over.post F₀ ⋙ Over.forget Vᵢ = Over.forget Uᵢ ⋙ F₀` (`rfl`). -/

section SlicePsi

open TopologicalSpace

variable {X Y : Scheme.{u}} (φ : X ≅ Y) (Ui : X.Opens)
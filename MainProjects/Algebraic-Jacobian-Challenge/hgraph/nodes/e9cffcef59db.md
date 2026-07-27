---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.gammaFiber_finrank_baseChange_field
docstring: '**Flat base change of the global sections of the twisted fibre module
  over

  the residue field extension** ([Stacks 02KH], `i = 0`, via the schematic

  support reduction; [Nitsure] §1): in the setting of

  `Scheme.hilbertFunction_quotBaseMap`, with `t := ψ(t'')`, the `κ(t'')`-dimension

  of the global sections of the pullback of the twisted module

  `F_t ⊗ L_t^{⊗m}` along `Scheme.fiberBaseChange π ψ t''` equals the

  `κ(t)`-dimension of the global sections of the twisted module itself — the

  right-hand side being the graded Hilbert function of `F` at `t`.  Proper

  support of `F` over `T` makes the (schematic) support of the twisted module

  proper, in particular quasi-compact and separated, over the residue field, so

  that [Stacks 02KH] applies to it; quasi-coherence of `L` (hence of the twist)

  is likewise required.  In the infinite-dimensional case both sides carry the

  junk value `0` of `Module.finrank`, matching the equality of infinite

  dimensions.  Blueprint: `lem:gamma_fiber_baseChange_field`.


  The scheme-level content is carried by

  `Scheme.gammaFiber_finrank_baseChange_field_of_quasicoherent` above (transfer

  of properness to the fibre, monotonicity of the support under twisting, and

  the flat base-change statement for `Γ`,

  `finrank_gammaTop_baseChange_of_hasProperSupport` of

  `Picard/SchematicSupport.lean`).  What is left unproved here, and is the

  reason this declaration still uses `sorry`, is quasi-coherence of the

  sheafified tensor `moduleTensorPow F_t L_t^{⊗m}` of quasi-coherent modules —

  the affine tensor-section formula of `Picard/TensorSectionFormula.lean`

  ([Stacks 01CB]), the same input `lem:pullback_tensor_map_isiso` needs.'
file: AlgebraicJacobian/Picard/QuotFunctorDef.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Scheme.gammaFiber_finrank_baseChange_field
type: lean
updated: '2026-07-27T12:05:13'
---
theorem gammaFiber_finrank_baseChange_field (π : X ⟶ S) (L : X.Modules)
    [L.IsQuasicoherent] {T T' : Over S} (ψ : T' ⟶ T)
    (F : (Limits.pullback π T.hom).Modules) (hfp : F.IsFinitePresentation)
    (hps : Modules.HasProperSupport (pullback.snd π T.hom) F)
    (t' : (T'.left : Scheme.{u})) (m : ℕ) :
    (letI := (pullback.snd π T'.hom).fiberSectionsModule t'
        ((Scheme.Modules.pullback (fiberBaseChange π ψ t')).obj
          (Scheme.Modules.moduleTensorPow
            ((pullback.snd π T.hom).fiberModule (ψ.left.base t') F)
            ((pullback.snd π T.hom).fiberModule (ψ.left.base t')
              ((Scheme.Modules.pullback (pullback.fst π T.hom)).obj L)) m))
     Module.finrank (T'.left.residueField t')
        Γ((Scheme.Modules.pullback (fiberBaseChange π ψ t')).obj
          (Scheme.Modules.moduleTensorPow
            ((pullback.snd π T.hom).fiberModule (ψ.left.base t') F)
            ((pullback.snd π T.hom).fiberModule (ψ.left.base t')
              ((Scheme.Modules.pullback (pullback.fst π T.hom)).obj L)) m), ⊤))
      = hilbertFunction (pullback.snd π T.hom)
          ((Scheme.Modules.pullback (pullback.fst π T.hom)).obj L) F
          (ψ.left.base t') m := by
  refine gammaFiber_finrank_baseChange_field_of_quasicoherent π L ψ F hfp hps t' m ?_
  -- Remaining obligation (`lem:gamma_fiber_baseChange_field`): quasi-coherence
  -- of the sheafified tensor of quasi-coherent modules (Stacks 01CB), i.e. the
  -- affine tensor-section formula for `sheafTensorObj` of
  -- `Picard/TensorSectionFormula.lean`.
  sorry
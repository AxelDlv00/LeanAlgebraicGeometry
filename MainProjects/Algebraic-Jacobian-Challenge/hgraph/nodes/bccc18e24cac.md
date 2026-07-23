---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv
docstring: "**Reverse slice transport (the `invFun` of `sliceDualTransport`), extracted\
  \ top-level.**\n\nGiven a dual section `ψ : restr V ((pushforward β).obj M.val)\
  \ ⟶ restr V \U0001D7D9_Y` over `Over V`,\nthis produces the X-slice dual section\
  \ `restr fV M.val ⟶ restr fV \U0001D7D9_X` over `Over fV`\n(`fV = f.opensFunctor.obj\
  \ V.unop`), the mirror of `sliceDualTransport`'s forward `toFun`.\n\nFor `W'' :\
  \ (Over fV)ᵒᵖ`, set `P := f⁻¹ᵁ W''.left` (so `f.opensFunctor.obj P = W''.left` only\n\
  propositionally, via `image_preimage_of_le` since `fV ⊆ range f`).  The component\
  \ at `W''` is the\nX-slice mirror of the forward component, conjugated by the `eqToHom`s\
  \ from `image_preimage_of_le`\n(mirror of `homLocalSection`):\n`eqToHom … ≫ (restrictScalars\
  \ (f.appIso P).hom.hom).map (ψ.app (op (Over.mk (homOfLE hPV)))) ≫\n  dualUnitRingSwapHom\
  \ f P`,\nthe codomain swap being `dualUnitRingSwapHom = inv (ε (restrictScalars\
  \ (f.appIso P).hom.hom))`\n(the `.hom`-direction `inv ε`)."
file: AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def sliceDualTransportInv {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) (V : (TopologicalSpace.Opens ↥Y)ᵒᵖ)
    (β : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj)
    -- β-compatibility (iter-303): `β` is the open-immersion structure ring iso `(f.appIso).inv`,
    -- so post-composing it with `(f.appIso P).hom` is the identity on `𝒪_X(f''ᵁP)`.  This is the
    -- load-bearing ring identity that collapses the double `restrictScalars` in the reverse
    -- component (`?collapse`); it is FALSE for an arbitrary `β`, hence supplied as a hypothesis and
    -- discharged at the unique caller (`sliceDualTransport.invFun`) via `Iso.hom_inv_id`.
    (hβ : ∀ (P : TopologicalSpace.Opens ↥Y),
        ((β.app (op P)).hom).comp ((Scheme.Hom.appIso f P).hom.hom) = RingHom.id _)
    (ψ : (((PresheafOfModules.pushforward β).obj M.val).dual.obj V : Type u)) :
    (((PresheafOfModules.pushforward β).obj M.val.dual).obj V : Type u) := by
  refine { app := fun W'' => ?_, naturality := ?_ }
  · -- app component at `W''` (over `fV`).  `W' := (unop W'').left ≤ fV`; `P := f⁻¹ᵁ W'`.
    -- The down-set facts are established (axiom-clean); the morphism itself is the documented
    -- residual below.
    set W' := (unop W'').left with hW'
    have hW'fV : W' ≤ f ''ᵁ (unop V) := (unop W'').hom.le
    have hPV : f ⁻¹ᵁ W' ≤ unop V :=
      le_trans ((TopologicalSpace.Opens.map f.base).monotone hW'fV)
        (le_of_eq (f.preimage_image_eq (unop V)))
    have he : f ''ᵁ (f ⁻¹ᵁ W') = W' := by
      rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
      exact inf_eq_right.mpr (hW'fV.trans (f.image_le_opensRange (unop V)))
    -- **app component — CLOSED axiom-clean (iter-303).**  The X-slice mirror of the forward
    -- `toFun`, conjugated across the propositional preimage round-trip `he : f''ᵁ(f⁻¹ᵁ W') = W'`.
    -- It is the four-leg composite (all legs concrete):
    --   (1) `M.val.map (eqToHom (op he.symm))` : source relabel `M.val(W') ⟶ restr_ρ M.val(fP)`
    --       (SEMILINEAR — codomain restricted along `ρ = X.ringCatSheaf.map (eqToHom (op he.symm))`,
    --       crossing the `𝒪_X(W') ↔ 𝒪_X(fP)` fiber);
    --   (2) `restrictScalars ρ |>.map (?collapse ≫ core)` transports the in-fiber-`fP` core:
    --       `?collapse` (the double-restrict collapse `M.val(fP) ≅ restrictScalars (f.appIso P).hom
    --       (restrictScalars (β.app P) (M.val fP))` via `restrictScalarsId'App` + `restrictScalarsComp'App`
    --       fed the ring identity `hβ (f⁻¹ᵁ W')`), and `core` (legs (3) ψ-reindex `restrictScalars
    --       (f.appIso P).hom |>.map (ψ.app …)` + (4) codomain unit swap `dualUnitRingSwapHom f P`);
    --   (3) `unitRelabelSwap (op he.symm)` : the codomain unit transport `restrictScalars ρ 𝟙_X(fP)
    --       ⟶ 𝟙_X(W')` (`inv ε` of the relabel, the new top-level helper).
    -- The cross-fiber transport (a single `≫`-chain cannot express it — the relabel is semilinear)
    -- is realised by applying the functor `restrictScalars ρ` to the in-fiber-`fP` core.
    -- **core (legs 3+4): VERIFIED well-formed in fiber `𝒪_X(fP)` (iter-303).**  The ψ-reindex
    -- `restrictScalars (f.appIso P).hom ∘ ψ.app` post-composed with the codomain unit swap
    -- `dualUnitRingSwapHom f P` assembles into
    --   `core : restrictScalars (f.appIso P).hom ((pushforward β M.val)(P)) ⟶ 𝟙_X(fP)`,
    -- a morphism of `ModuleCat 𝒪_X(fP)`.  (NB: the leg-3 target `restrictScalars (f.appIso P).hom
    -- ((restr V 𝟙_Y)-section)` DID defeq-unify with leg-4's `restrictScalars (f.appIso P).hom
    -- (𝟙_ (ModuleCat 𝒪_Y(P)))` — the unit-spelling reconciles here, exactly as in the closed
    -- forward `toFun`.)
    have core := (ModuleCat.restrictScalars (Scheme.Hom.appIso f (f ⁻¹ᵁ W')).hom.hom).map
        (ψ.app (op (Over.mk (homOfLE hPV)))) ≫ dualUnitRingSwapHom f (f ⁻¹ᵁ W')
    -- **Cross-fiber transport — CLOSED (iter-303).**  The goal lives in `ModuleCat 𝒪_X(W')` but
    -- `core` lives in `ModuleCat 𝒪_X(fP)` (`fP = f''ᵁf⁻¹ᵁW'`, propositionally `= W'` via `he`, but
    -- the section RINGS `𝒪_X(W')` / `𝒪_X(fP)` are only propositionally equal).  The source relabel
    -- `M.val(W') ⟶ M.val(fP)` is `M.val.map (eqToHom (op he.symm))` — SEMILINEAR, landing in
    -- `restrictScalars (X.ringCatSheaf.map (eqToHom …))`; combined with the source double-restrict
    -- collapse `restrictScalars (f.appIso P).hom ∘ restrictScalars (β.app P) ≅ restrictScalars 𝟙
    -- ≅ id` (ring identity `hβ (f⁻¹ᵁ W')`: `(β.app P).hom ∘ (f.appIso P).hom.hom = 𝟙_{𝒪_X(fP)}`,
    -- collapsed by `ModuleCat.restrictScalarsComp'App` + `restrictScalarsId'App`).  A single
    -- `≫`-chain in one `ModuleCat` cannot express this — the relabel crosses ring fibers — so `core`
    -- is conjugated across the `𝒪_X(fP) ↔ 𝒪_X(W')` fiber by applying the functor
    -- `restrictScalars (X.ringCatSheaf.map (eqToHom (op he.symm)))` to `?collapse ≫ core` (per memory
    -- `ts271-slicedualtransportinv`).  This cross-fiber transport is the next fine-grained target.
    refine M.val.map (eqToHom (congrArg op he.symm)) ≫
      (ModuleCat.restrictScalars ((X.ringCatSheaf.obj.map (eqToHom (congrArg op he.symm))).hom)).map
        (?collapse ≫ core) ≫ ?unit
    case collapse =>
      -- Collapse the double `restrictScalars` on `M.val(fP)` to the identity, using the ring
      -- identity `hβ (f⁻¹ᵁ W')` (`(β.app P).hom ∘ (f.appIso P).hom = 𝟙`).
      exact (ModuleCat.restrictScalarsId'App _ (hβ (f ⁻¹ᵁ W'))
            (M.val.obj (op (f ''ᵁ f ⁻¹ᵁ W')))).inv ≫
        (ModuleCat.restrictScalarsComp'App ((Scheme.Hom.appIso f (f ⁻¹ᵁ W')).hom.hom)
            ((β.app (op (f ⁻¹ᵁ W'))).hom) _ rfl (M.val.obj (op (f ''ᵁ f ⁻¹ᵁ W')))).hom
    case unit =>
      -- **Unit transport (?unit) — CLOSED (iter-303).**  Goal:
      -- `restrictScalars ρ (𝟙_ ModuleCat 𝒪_X(fP)) ⟶ (restr fV 𝟙_X).obj W''`, with
      -- `ρ = X.presheaf.map (eqToHom (op he.symm)) : 𝒪_X(W') → 𝒪_X(fP)` the (bijective, eqToHom-
      -- induced) section-ring relabel.  This is `inv (ε (restrictScalars ρ))`, supplied by the new
      -- top-level helper `unitRelabelSwap` (phrased at the `X.presheaf` CommRingCat carrier so
      -- `CommRing`/`LaxMonoidal` are native — the direct in-place `inv ε` cannot be FORMED here
      -- because the `set`-local `W'` blocks call-site `CommRing ↑(X.presheaf.obj (op W'))` synthesis).
      -- The `X.ringCatSheaf.map`-vs-`X.presheaf.map` and unit-section spellings reconcile by defeq.
      exact unitRelabelSwap (congrArg op he.symm)
  · -- **naturality of the reverse component (the sole remaining hole of `sliceDualTransportInv`,
    -- iter-303 — `app` is now fully CLOSED).**  The thin-poset square over `(Over fV)ᵒᵖ`: for
    -- `f_1 : X_1 ⟶ Y_1`, `restr.map f_1 ≫ app Y_1 = app X_1 ≫ (restr 𝟙_X).map f_1`.  Each `app`
    -- is now the explicit 4-piece composite `M.val.map (eqToHom he) ≫ restrictScalars(ρ).map
    -- (collapse ≫ core) ≫ unitRelabelSwap`; the base maps of `Opens X` agree by `Subsingleton.elim`,
    -- but the four legs (the `eqToHom`/`restrictScalarsComp'App`/`restrictScalarsId'App` transports,
    -- the `ψ`-reindex `core`, and the two ε-swaps) must be slid through the restriction `.map` — an
    -- `erw`-level paste mirroring `homLocalSection.naturality`.  CLOSED (v4.31.0 migration) by
    -- gluing into the extracted standalone square `sliceDualTransportInv_naturality_apply`.
    intro X₁ Y₁ f₁
    apply ModuleCat.hom_ext
    refine LinearMap.ext fun z => ?_
    exact sliceDualTransportInv_naturality_apply f M V β hβ ψ f₁ z
      (le_trans ((TopologicalSpace.Opens.map f.base).monotone (unop X₁).hom.le)
        (le_of_eq (f.preimage_image_eq (unop V))))
      (by rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
          exact inf_eq_right.mpr ((unop X₁).hom.le.trans (f.image_le_opensRange (unop V))))
      (le_trans ((TopologicalSpace.Opens.map f.base).monotone (unop Y₁).hom.le)
        (le_of_eq (f.preimage_image_eq (unop V))))
      (by rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
          exact inf_eq_right.mpr ((unop Y₁).hom.le.trans (f.image_le_opensRange (unop V))))

open PresheafOfModules InternalHom Opposite in
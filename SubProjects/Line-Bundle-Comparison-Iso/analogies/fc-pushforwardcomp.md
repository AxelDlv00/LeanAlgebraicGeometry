# Analogy: should `FC` be the concrete `pushforwardComp` instead of the `leftAdjointCompIso` mate?

## Mode
api-alignment

## Slug
fc-pushforwardcomp

## Iteration
078

## Question
The `case hstar` residual of `presheafDualPullbackComparison_restrict` is blocked on the opaque
section `(FC.hom.app dM).app V φ`, where
`FC := hadjf.leftAdjointCompIso hadjh hadjhf (PresheafOfModules.pushforwardComp φRf φRh)`.
Should `FC` instead be the concrete left-adjoint comp `PresheafOfModules.pushforwardComp βf βh`
(computable `.hom.app`), and does Mathlib provide a lemma identifying the `leftAdjointCompIso`
mate with the concrete left-adjoint comp so the section becomes computable WITHOUT unfolding the
`pushforwardPushforwardAdj` unit/counit (carrier diamond)?

## Project artifact(s)
- `…/PresheafDualPullback.lean:786-788` — `FC` (the `leftAdjointCompIso` mate).
- `…/PresheafDualPullback.lean:617-650` — `presheafDualH1Cocycle` consuming `FC` (proven, clean).
- `…/PresheafDualPullback.lean:826-920` — `case hstar` + crisp residual L887-890.
- `…/PresheafDualPullback.lean:46-116` — §0 mate calculus already in-file.

## Mathlib facts established
- `Adjunction.leftAdjointCompIso` (`Mathlib/CategoryTheory/Adjunction/CompositionIso.lean:72`) is
  `(conjugateIsoEquiv adj₀₂ (adj₀₁.comp adj₁₂)).symm e.symm` — the **mate** of the right-comp `e`.
  Its `.hom = leftAdjointCompNatTrans = (conjugateEquiv …).symm e.inv` (L76-79). The generated
  `leftAdjointCompIso_hom_app` therefore expands, componentwise, to a `conjugateEquiv.symm` =
  `unit ≫ map(…) ≫ counit` composite (`Mates.lean:307,326`) → genuinely carries the adjunction
  unit/counit.
- `PresheafOfModules.pushforwardComp φ ψ` (`…/Presheaf/Pushforward.lean:135`) **is `Iso.refl _`** —
  pushforward composition is strict (precomposition / restriction of scalars).
- `PresheafOfModules.pullbackComp` (`…/Presheaf/Pullback.lean:131`) is **DEFINED as**
  `Adjunction.leftAdjointCompIso (pullbackPushforwardAdjunction …) … (pushforwardComp φ ψ)`. So the
  project's `pbC` (P-side of the cocycle) and `FC` (F-side) are the *same Mathlib idiom*.
- Mathlib's only characterizations of these comp-isos are **mate-level**: `conjugateEquiv_pullbackComp_inv`
  (`Sheaf/PullbackContinuous.lean:176`), `conjugateEquiv_leftAdjointCompIso_inv/hom`, `leftAdjointCompIso_assoc`,
  `pullback_assoc`, `pullbackComp_id`. **Mathlib NEVER computes a `pullbackComp`/`pushforwardComp`-mate
  sectionwise (`.hom.app`).** No "mate = concrete left-comp" `.app` lemma exists anywhere in Mathlib.
- Codomain mismatch: `FC : pushforward βf ⋙ pushforward βh ≅ pushforward βhf`, but the concrete
  `pushforwardComp βh βf : pushforward βf ⋙ pushforward βh ≅ pushforward (βh ≫ whiskerLeft _ βf)`.
  `βhf = whiskerRight αhf` (αhf.app U = `((h≫f).appIso _).inv`) differs from `βh ≫ whiskerLeft _ βf`
  by the `Scheme.Hom.comp_appIso` `eqToHom` — **different codomain functor**, so they are not even
  type-compatible (this is exactly why `rw [show FC.hom = pushforwardComp.hom from rfl]` type-errors).

## Decisions identified

### Decision: `FC` = abstract `leftAdjointCompIso` mate vs concrete `pushforwardComp βf βh`
- **Mathlib idiom**: comp-isos of pullback/pushforward left adjoints are the `leftAdjointCompIso`
  mate; consumed via mate calculus, never sectionwise. Cite: `Presheaf/Pullback.lean:131`,
  `Sheaf/PullbackContinuous.lean:166-180`, `CompositionIso.lean`.
- **Project's path**: `FC = leftAdjointCompIso` (F-side), `pbC = pullbackComp = leftAdjointCompIso`
  (P-side); `presheafDualH1Cocycle` proves the cocycle in ONE line via
  `leftAdjointUniq_leftAdjointCompIso_comm` — exactly the Mathlib mate idiom.
- **Gap**: identical (project mirrors Mathlib). Replacing `FC` by concrete `pushforwardComp βf βh`
  is **divergent-and-wrong**: (a) codomain `eqToHom`/`comp_appIso` mismatch (not type-compatible);
  (b) it would break the already-proven `presheafDualH1Cocycle`, which requires *both* flanks to be
  `leftAdjointCompIso` of the *same* `e = pushforwardComp φRf φRh` so `leftAdjointUniq_leftAdjointCompIso_comm`
  fires.
- **Verdict**: PROCEED (keep `FC = leftAdjointCompIso`; do not swap to concrete comp).

### Decision: is there a Mathlib lemma making `(FC.hom.app dM)` computable without the units?
- **Mathlib idiom**: none — Mathlib stays at the natural-transformation level for every comp-iso
  coherence. There is no sectionwise mate-vs-concrete-comp bridge, and none can exist *generically*:
  the mate `(conjugateEquiv …).symm e.inv` carries the unit/counit of the (project-specific)
  `pushforwardPushforwardAdj`, and the codomain reindex `eqToHom (comp_appIso)` is intrinsic.
- **Project's path**: tries `leftAdjointCompIso_hom_app` + `simp [pushforwardPushforwardAdj …]`
  (iter-075) → does not reduce; forcing it hits the `restrictScalars` carrier diamond.
- **Gap**: divergent-with-cost — the `case hstar` proof attacks the comp-iso **sectionwise**, the one
  place the project leaves the Mathlib idiom (Mathlib's analogue `pullbackTensorMap_restrict` closed
  its composition law entirely at the nat-trans level via `pullbackComp_δ` / `leftAdjointCompIso_assoc`,
  never `.app`).
- **Verdict**: NEEDS_MATHLIB_GAP_FILL — but the gap is NOT "FC = pushforwardComp"; see below.

## Recommendation
Keep `FC = leftAdjointCompIso` (it is the Mathlib idiom and the cocycle depends on it). The bridge to
build is a **diamond-free sectionwise characterization of `(FC.hom.app dM).app V`**, NOT a swap to the
concrete `pushforwardComp`. Two viable shapes (low → high cost):

1. **`change`/`show` to the `X.presheaf.map (·).op` form (the triangle-component idiom).** The
   `pushforwardPushforwardAdj.left/right_triangle_components` proofs (`PresheafInternalHom.lean:449-461`)
   prove the units/counits ARE definitionally `X.presheaf.map (adj.counit/unit.app _).op`-shaped and
   reachable by `change` — they do NOT need `simp` (which is what triggers the diamond). Apply the same
   `change`/`← Functor.map_comp`/`← op_comp` collapse to the three unit/counit factors that
   `leftAdjointCompIso_hom_app` exposes; the composite folds to a single `X.presheaf.map (composite).op`
   that matches the RHS via `comp_appIso` + `Subsingleton` (thin poset `Opens X`). This is the prover's
   CRISP RESIDUAL (L887-903) made tractable WITHOUT `simp`-unfolding `pushforwardPushforwardAdj`.

2. **`sliceDualTransport_comp` brick in `SliceTransport.lean` (cross-file).** The prover's standing
   recommendation: a def-level sectionwise pseudofunctoriality of `sliceDualTransport`, proven from
   `comp_appIso` + `Over.map`/opensFunctor composition + `Subsingleton`, that ABSORBS `FC.hom.app dM`
   via the §0 `conjugateEquiv_leftAdjointCompIso_hom` (FC.hom ↦ `e.inv = 𝟙` abstractly — no units) and
   leaves only the slice/reindex bookkeeping where `sliceDualTransport` is defined.

DEAD (do not pursue): `rw [show FC.hom = pushforwardComp.hom from rfl]` (codomain eqToHom — not defeq);
`simp [leftAdjointCompIso_hom_app, pushforwardPushforwardAdj, pushforwardCongr]` (carrier diamond).

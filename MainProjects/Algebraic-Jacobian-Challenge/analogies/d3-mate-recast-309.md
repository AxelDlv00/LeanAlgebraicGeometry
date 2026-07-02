# Analogy: composition-coherence of a `leftAdjointUniq` comparison across a composite of adjunctions (one factor a reflective localization)

## Mode
cross-domain-inspiration

## Slug
d3recast309

## Iteration
309

## Structural problem (abstracted)
Two left adjoints `L_A, L_B` to the **same** right adjoint `R` over a vertical composite of
adjunctions (one factor a reflective localization). The canonical iso `S := leftAdjointUniq A B`
is a *comparison of left adjoints*. We need its **cocycle/composition coherence**: for a 2-step
composite `h≫f`, `S_{h≫f}` factors through `S_f` (whiskered), `S_h`, and the two pseudofunctor
coherences `pullbackComp` (left adjoints) / `pushforwardComp` (right adjoints). The hand
`homEquiv` telescope transposes the whole identity under a **single** adjunction `A_{h≫f}`, which
forces every comparison through one unit/counit — and the intermediate-scheme sheafification
`sheafAdj_Y` buried inside `A_h = sheafAdj_Y.comp ShPb_h` has nowhere to live in that single
transpose. It must be slid in by hand. That sliding is the wall.

## Failed approaches (from directive)
- Mirror `gr_pullbackObjUnitToUnit_comp` (forward `homEquiv` telescope, `change`+`have`+`erw`):
  the h-comparison has no sheafification partner free in the single-adjunction transpose.
- Forward explicit-`have`+`erw` assembly: fragile + blows the 3.2M-heartbeat budget.

## Key discovery (verified by LSP this iter)
`leftAdjointUniq` **is, definitionally, a conjugate of the identity.** Both facts are `rfl`:
- `(conjugateEquiv adj1 adj2).symm (𝟙 R) = (adj1.leftAdjointUniq adj2).inv`  — `rfl` (verified).
- `SheafOfModules.sheafificationCompPullback φ = A_φ.leftAdjointUniq B_φ`     — `rfl`
  (already in-file: `sheafificationCompPullback_eq_leftAdjointUniq`, L1603).

Therefore the comparison `(sheafificationCompPullback φ).inv` **is** `conjugateEquiv A_φ B_φ`'s
preimage of `𝟙 R_φ`, and the whole coherence can be discharged in Mathlib's **conjugate calculus**
(`Mathlib/CategoryTheory/Adjunction/Mates.lean`) with NO `homEquiv` telescope.

## Why the conjugate calculus dodges the obstruction (the core insight)
The `homEquiv` telescope transposes under ONE adjunction `A_{h≫f}`; every factor must be expressed
through that single transpose's unit/counit, so `sheafAdj_Y` (data of `A_h`, neither a factor of
`A_{h≫f}` nor free in the residual) has to be slid in by hand.

`conjugateEquiv_comp` keeps each comparison as a conjugate **w.r.t. its own adjunction pair**:
```
conjugateEquiv adj₁ adj₂ α ≫ conjugateEquiv adj₂ adj₃ β = conjugateEquiv adj₁ adj₃ (β ≫ α)
```
The **middle adjunction `adj₂` is free** — it is exactly the intermediate-scheme composite
`A_Y / B_Y` that carries `sheafAdj_Y`. So `sheafAdj_Y` becomes a *parameter* of `adj₂`, absorbed,
never needing to be free in a transposed chain. This is the precise structural reason the cocycle
closes where the telescope stalled.

## Analogues found

### Analogue: `CategoryTheory.conjugateEquiv_comp` (`Mathlib/CategoryTheory/Adjunction/Mates.lean`)
- **Domain**: category theory / bicategory mates (the conjugate = mate with identity verticals).
- **Same structural problem there**: vertical stacking of conjugate transformations across THREE
  adjunctions `adj₁,adj₂,adj₃` (different middle), with the order-reversing fusion law above. This
  is `mateEquiv_vcomp` specialized to identity verticals (`G=H=𝟙`); see also
  `iterated_mateEquiv_conjugateEquiv` (mate∘mate.natTrans = conjugate of `adj₁.comp adj₄`) and
  `mateEquiv_conjugateEquiv_vcomp`.
- **Technique**: drop `.app P`, work at the NatTrans level; rewrite `S = conjugateEquiv.symm 𝟙`
  (definitional), then apply the injective `conjugateEquiv A_{h≫f} B_{h≫f}` to the `.inv` identity.
  LHS conjugate `= 𝟙` (`conjugateEquiv_id`). RHS: push whiskers through with
  `conjugateEquiv_whiskerLeft` / `conjugateEquiv_whiskerRight`, fuse the four conjugate factors
  with `conjugateEquiv_comp`, identify the coherence factors via the project's
  `conjugateEquiv_pullbackComp_inv` (left `pullbackComp.inv` ↦ right `pushforwardComp.hom`) and the
  presheaf strictness `pushforwardComp = Iso.refl` (δ-conjugate = id). The residue is the
  `pushforwardComp` cocycle, which is strict (presheaf side `rfl`).
- **Mapping to project**: `adj₁ = A_{h≫f}`, `adj₃ = B_{h≫f}`, the FREE middle `adj₂` = the
  intermediate-scheme composite `A_Y`/`B_Y` carrying `sheafAdj_Y`. The four RHS factors
  (`pullbackComp.inv` whiskered by `a_X`; `(pullback h).map S_f`; `S_h`; `a_Z.map δ_pre`) each
  become a `conjugateEquiv` and telescope.
- **Porting cost**: low. All lemmas exist (Mathlib + in-file `conjugateEquiv_pullbackComp_inv`,
  `sheafificationCompPullback_eq_leftAdjointUniq`). No new infrastructure — it REPLACES the
  `homEquiv` telescope, not adds to it.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `CategoryTheory.conjugateEquiv_whiskerLeft` / `_whiskerRight` (Mates.lean)
- **Domain**: category theory.
- **Same structural problem**: a conjugate of a whiskered transformation = whiskered conjugate.
  `conjugateEquiv (adj.comp adj₁) (adj.comp adj₂) (L.whiskerLeft τ) = whiskerRight (conjugateEquiv adj₁ adj₂ τ) R`
  (and the right-whisker dual). Exactly handles `(pullback h).map S_f` (= `whiskerLeft`-style
  composite-adjunction whisker) and the `a_X`/`a_Z` sheafification whiskers.
- **Technique**: rewrite each whiskered comparison to a whisker of a bare conjugate BEFORE fusing.
- **Mapping**: the project already uses `conjugateEquiv_whiskerLeft` at TensorObjSubstrate L2617;
  the recast just uses it on EVERY factor, not only R0.
- **Porting cost**: low.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `Adjunction.leftAdjointUniq_trans` (`Adjunction/Unique.lean`)
- **Domain**: category theory.
- **Same structural problem**: `(leftAdjointUniq adj1 adj2).hom ≫ (leftAdjointUniq adj2 adj3).hom
  = (leftAdjointUniq adj1 adj3).hom` — comparisons compose WITHOUT a coherence iso when they share
  ONE common right adjoint `G`.
- **Why only PARTIAL**: here the right adjoints DIFFER across the chain (each comparison has its
  own `A/B` pair). `leftAdjointUniq_trans` is the "single common right adjoint" shape — the very
  trap the telescope fell into. Use it ONLY for sub-steps where a common `G` genuinely appears
  (it likely does not in the cross-scheme chain). `conjugateEquiv_comp` (varying middle adjunction)
  is the correct generalization.
- **Porting cost**: n/a.
- **Verdict**: PARTIAL_ANALOGUE (cautionary — do NOT force a common-`G` route).

## Top suggestion
Recast `sheafificationCompPullback_comp` in the conjugate calculus. Concretely:
1. Restate the goal at NatTrans level (or keep `.app P` and `NatTrans.congr_app` at the end) and
   pass to **inverses** of the iso identity.
2. Rewrite each comparison `(sheafificationCompPullback φ).inv` as `(conjugateEquiv A_φ B_φ).symm
   (𝟙 R_φ)` — definitional (`sheafificationCompPullback_eq_leftAdjointUniq` + the `rfl` bridge).
3. Apply the injective `conjugateEquiv A_{h≫f} B_{h≫f}` to both sides. LHS ↦ `𝟙` (`conjugateEquiv_id`).
4. On the RHS, `conjugateEquiv_whiskerLeft`/`_whiskerRight` to expose bare conjugates, then
   `conjugateEquiv_comp` (×3) to fuse into one `conjugateEquiv A_{h≫f} B_{h≫f} (composite of
   coherences)`. Identify the coherence factors via `conjugateEquiv_pullbackComp_inv`
   (`pullbackComp.inv` ↦ `pushforwardComp.hom`) and presheaf `pushforwardComp = Iso.refl`.
5. The residual right-adjoint identity is the `pushforwardComp` pseudofunctor cocycle — strict
   (presheaf-level `rfl`). Close.
Read first: `Mathlib/CategoryTheory/Adjunction/Mates.lean` (`conjugateEquiv_comp`,
`conjugateEquiv_id`, `conjugateEquiv_whiskerLeft/Right`). First project file to touch:
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean` `sheafificationCompPullback_comp` (~L2560),
replacing the `homEquiv` telescope from line 2589 onward. The `mateEquiv_vcomp`/`TwoSquare`
machinery is the OVER-general tool; `conjugateEquiv_comp` is the right altitude (no explicit
verticals to build).

## Discarded
- `mateEquiv_vcomp` with explicit `TwoSquare` verticals: works but forces constructing the
  verticals `G,H`; the comparisons are identity-vertical mates, so `conjugateEquiv_comp` is
  strictly cleaner. Keep `mateEquiv_vcomp` only as the citation that *justifies* `conjugateEquiv_comp`.
- `leftAdjointUniq_trans` as the main closer: assumes a single shared right adjoint — the
  telescope's trap. (Partial above.)
- Forward `homEquiv_naturality_left/right` continuation (the current `sorry` route): the directive's
  failed approach; abandoned.

# blueprint-writer directive — iter-239, slug `invpull`

## Chapter to edit
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — ONLY this chapter.

## Goal
Add a new subsection blueprinting the **pullback-monoidality / invertibility-under-pullback substrate**
for general scheme morphisms. This is the prerequisite for re-basing the relative-Picard consumer
(`OnProduct`/RPF) onto the `IsInvertible` carrier (Route Y of A.1.c). Place it AFTER the existing
restriction-compatibility material (`lem:tensorobj_restrict_iso`) and BEFORE / separate from the
group-law section `sec:tensorobj_pic_carrier` (do NOT modify the group-law section).

## Strategy context (the slice that matters)
The project's Picard group `picCommGroup` (DONE) is carried on tensor-invertibility
`IsInvertible M := ∃ N, Nonempty (M ⊗_X N ≅ 𝒪_X)` (Stacks 0B8K). The relative-Picard consumer needs to
re-base its line-bundle carrier `OnProduct` onto `IsInvertible`, and its functorial pullback maps
(`pullbackAlongProjection` along the projection `C×_S T → T`, `functorial` along the base-change
`g_C : C×_S T' → C×_S T`) require that **pullback preserves tensor-invertibility** for GENERAL scheme
morphisms (these are not open immersions, not flat).

IMPORTANT distinction to record in the prose: the existing `lem:tensorobj_restrict_iso` handles only the
OPEN-IMMERSION case, and it does so by routing through `pushforward`/`restrictScalars` (the LAX right
adjoint, strong-monoidal there only because an open immersion's ring map is a local isomorphism). The
general case must instead use the LEFT adjoint — pullback = inverse image = extension of scalars — which
is **strong monoidal for ANY ring map** (no iso hypothesis). This is the whole reason the general lemma
is a separate result, not a corollary of the open-immersion one.

## Required new blocks (give each a `\lean{...}` pin and a precise mathematical proof sketch)

1. **`lem:pullback_tensor_iso`** — pin `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}`.
   Statement: for any morphism of schemes `f : Y ⟶ X` and `M, N ∈ Scheme.Modules X`,
   `(Scheme.Modules.pullback f).obj (tensorObj M N) ≅ tensorObj ((Scheme.Modules.pullback f).obj M)
   ((Scheme.Modules.pullback f).obj N)`, natural in `M, N`.
   `\uses{def:scheme_modules_tensorobj}`.
   % SOURCE: Stacks tag for `lemma-tensor-product-pullback`, references/stacks-modules.tex lines 2392–2400.
   % SOURCE QUOTE: copy verbatim L2392–2400 (the statement `f^*(F⊗G) = f^*F ⊗ f^*G functorially`).
   Proof sketch (mirror the structure of `lem:tensorobj_restrict_iso` but via the LEFT adjoint):
   - `tensorObj M N` is by definition the sheafification of the presheaf tensor
     `PresheafOfModules.Monoidal.tensorObj M.val N.val`.
   - The genuine Mathlib lemma `SheafOfModules.sheafificationCompPullback` moves the pullback INSIDE the
     sheafification (it is general — holds for any ring-sheaf map, already used for the open-immersion
     case), reducing the goal to the presheaf level:
     `(PresheafOfModules.pullback φ).obj (M.val ⊗ₚ N.val) ≅ (pullback M).val ⊗ₚ (pullback N).val`
     where `φ = f`'s ring-sheaf map and `⊗ₚ = PresheafOfModules.Monoidal.tensorObj`.
   - The presheaf-level pullback `PresheafOfModules.pullback φ` is STRONG monoidal: sectionwise it is
     extension of scalars, and Mathlib provides `(extendScalars f).Monoidal` (strong-monoidal extension
     of scalars for any ring hom, in `Mathlib/Algebra/Category/ModuleCat/Monoidal/Adjunction.lean`).
     The strong-monoidal tensorator `μ` of this functor furnishes the presheaf comparison; sheafifying
     it gives the claim.

2. **`lem:pullback_unit_iso`** — pin `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}`.
   Statement: for any `f : Y ⟶ X`, `(Scheme.Modules.pullback f).obj (SheafOfModules.unit X.ringCatSheaf)
   ≅ SheafOfModules.unit Y.ringCatSheaf` (i.e. `f^*𝒪_X ≅ 𝒪_Y`).
   Proof sketch: the monoidal unit is preserved by the strong-monoidal pullback — the unit comparison
   `ε` of `(extendScalars f).Monoidal` is the iso `S ⊗_R R ≅ S`; at the sheaf level this descends to
   `f^*𝒪_X ≅ 𝒪_Y`. Note: a Mathlib morphism `SheafOfModules.pullbackObjUnitToUnit` exists (it is used in
   `IsLocallyTrivial.pullback`, where it is an iso for open immersions via finality); flag whether it is
   an iso for general `f` or whether the iso must come from the `extendScalars` unit comparison instead.

3. **`lem:isinvertible_pullback`** — pin `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback}`.
   Statement: for any `f : Y ⟶ X` and `M ∈ Scheme.Modules X`, `IsInvertible M →
   IsInvertible ((Scheme.Modules.pullback f).obj M)`.
   `\uses{def:scheme_modules_isinvertible, lem:pullback_tensor_iso, lem:pullback_unit_iso}`.
   % SOURCE: Stacks `lemma-pullback-invertible`, references/stacks-modules.tex lines 4142–4147 (statement)
   % and lines 4149–4157 (proof).
   % SOURCE QUOTE: copy verbatim L4142–4147.
   % SOURCE QUOTE PROOF: copy verbatim L4149–4157.
   Proof sketch (the Stacks proof, in project notation): from `IsInvertible M` get a witness `N` with
   `e : M ⊗_X N ≅ 𝒪_X`. The pullback witness is `(pullback f).obj N`; the required iso
   `(pullback f).obj M ⊗_Y (pullback f).obj N ≅ 𝒪_Y` is
   `(pullbackTensorIso).symm ≪≫ (pullback f).mapIso e ≪≫ pullbackUnitIso`.

## Verified Mathlib handles to cite in the prose as available ingredients (do NOT write Lean tactics)
- `(extendScalars f).Monoidal` — strong-monoidal extension of scalars, any ring hom [verified present
  this iter in `Mathlib/Algebra/Category/ModuleCat/Monoidal/Adjunction.lean`].
- `SheafOfModules.sheafificationCompPullback` — sheafification commutes with pullback [verified: already
  consumed by `lem:tensorobj_restrict_iso`].
- `Scheme.Modules.pullback`, `PresheafOfModules.pullback`, `PresheafOfModules.Monoidal.tensorObj`.

## Citation discipline
You are authorized `references/**`. Open `references/stacks-modules.tex` and copy the verbatim
`% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` text from the exact line ranges above. A visible
`\textit{Source: Stacks, ...}` line opens each block's prose. Do NOT cite from memory.

## Out of scope (do NOT touch)
- The group-law section (`sec:tensorobj_invertibility`, `sec:tensorobj_pic_carrier`) — already complete.
- The `OnProduct` re-base itself (that is a future `Picard_LineBundlePullback.tex` edit).
- Markers: do NOT add `\leanok` / `\mathlibok` anywhere (managed deterministically downstream).

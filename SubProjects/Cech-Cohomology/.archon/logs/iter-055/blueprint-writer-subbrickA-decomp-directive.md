# Blueprint-writer directive — decompose Sub-brick A + clear coverage debt

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter;
`% archon:covers` lists CechAugmentedResolution.lean + OpenImmersionPushforward.lean among others).

## Context (strategy slice)
`cechAugmented_exact` (`lem:cech_augmented_resolution`) is wired axiom-clean end-to-end down to ONE
residual: a contracting homotopy `Homotopy (𝟙 D) 0` for the **evaluated-at-`V` augmented Čech section
complex**, where `V ≤ coverOpen 𝒰 i` (V lies inside one cover member). This residual = **Sub-brick A**,
the per-degree section identification
`Γ(V, pushPullObj F Yₚ) ≅ ∏_{σ:Fin(p+1)→I} Γ(coverInterOpen 𝒰 σ ⊓ V, F)`. It has blocked the theorem
for 4 iterations. A mathlib-analogist consult (`analogies/subbrickA.md` — READ IT) decomposed Sub-brick A
into a `\uses`-chain with exactly ONE new-infra leaf; the rest is off-the-shelf Mathlib / project reuse.

This decomposition lives in a NEW Lean file `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
(being scaffolded this iter). Your job: author the blueprint blocks for that chain so the prover has a
rigorous source of truth, and clear the coverage debt for 5 prover-created helpers.

## TASK 1 — decompose `lem:cech_augmented_resolution` Sub-brick A into a `\uses`-chain

Do NOT rewrite the whole `lem:cech_augmented_resolution` proof. Its Steps 1–3 (toSheaf-reflect →
`homologyIsoSheafify` → `sheafify_kills_locally_zero` → covering sieve → eval-preserves-homology) are
correct and DONE. ONLY refine Step 3(b)+(c) (the "project-side work" — the local contractibility over
`V ≤ coverOpen 𝒰 i`) so it points at the new sub-lemma chain, and ADD the chain as new `\begin{lemma}`
blocks (with `\label`, `\lean{}`, `\uses{}`, and a rigorous informal proof each).

Author these blocks (use these exact `\lean{}` names — the scaffolder will create matching Lean stubs):

1. **`lem:cech_backbone_left_sigma`** — `\lean{AlgebraicGeometry.cechBackbone_left_sigma}` (or fold into #3
   if it is definitional). Geometric bookkeeping: the degree-`p` left object of `coverCechNerveOver 𝒰`
   (the Čech nerve of the cover map `q : ∐_i 𝒰.X i → X`) is the coproduct `∐_{σ:Fin(p+1)→I} U_σ`, with
   each component the open immersion `j_σ : U_σ = coverInterOpen 𝒰 σ ↪ X` (fibre powers of open
   immersions = intersection opens). `\uses` the cover-nerve definitions.

2. **`lem:pushPull_sigma_iso`** — `\lean{AlgebraicGeometry.pushPull_sigma_iso}`. **THE ONE NEW-INFRA LEAF.**
   `pushPullObj F Yₚ ≅ ∏_σ pushPullObj F (Over.mk j_σ)` in `X.Modules`, equivalently
   `(q_p)_* (q_p)^* F ≅ ∏_σ (j_σ)_* (j_σ)^* F`. Informal proof: a module sheaf on the coproduct
   `∐_σ U_σ` is the product of its restrictions to the (disjoint-on-the-coproduct) components. Mathlib has
   only BINARY / structure-sheaf versions (`Scheme.coprodPresheafObjIso`,
   `TopCat.Sheaf.isProductOfDisjoint`); this is the indexed `SheafOfModules` lift. Route: build the
   module-linear comparison map, check it is an iso on the underlying `Ab`-presheaf via the sheaf
   condition over the disjoint component cover, transport back through `Scheme.Modules.toPresheaf`
   (faithful, reflects isos, preserves limits). `\uses` the cover-nerve defs + a `\mathlibok` anchor for
   the binary disjoint-union sheaf decomposition (see TASK 3).

3. **`lem:pushPull_leg_sections`** — `\lean{AlgebraicGeometry.pushPull_leg_sections}`. For one leg:
   `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(coverInterOpen 𝒰 σ ⊓ V, F)`. Off-the-shelf composite:
   pushforward sections are `rfl` (`pushforward_obj_obj`: `Γ(V,(j_σ)_* N)=Γ(j_σ⁻¹V,N)`); then
   pullback-along-open-immersion = restriction via `restrictFunctorIsoPullback` (the project already uses
   this in `QcohRestrictBasicOpen.lean`); then `restrict_obj` (`rfl`) gives `Γ(j_σ⁻¹V, F.restrict j_σ) =
   Γ(j_σ ''ᵁ (j_σ⁻¹V), F) = Γ(U_σ ∩ V, F)`. `\uses` `\mathlibok` anchors for these Mathlib decls (TASK 3).

4. **`lem:pushPull_eval_prod_iso`** — `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}`. The degreewise
   object iso `Γ(V, pushPullObj F Yₚ) ≅ ∏_σ Γ(coverInterOpen 𝒰 σ ⊓ V, F)`, assembled from #2 (coproduct→
   product) + `SheafOfModules.evaluation` preserves products (`Γ(V,∏_σ N_σ)≅∏_σ Γ(V,N_σ)`, off-the-shelf,
   `\mathlibok` anchor) + #3 (leg sections). `\uses{lem:pushPull_sigma_iso, lem:pushPull_leg_sections}` +
   the eval-preserves-products anchor.

5. **`lem:cechSection_complex_iso`** — `\lean{AlgebraicGeometry.cechSection_complex_iso}`. The
   complex-level identification: the evaluated augmented Čech section complex `D` is isomorphic (as a
   homological complex) to the concrete section Čech complex `D'` over the family
   `(coverInterOpen 𝒰 · ⊓ V)`, with the differential matching the alternating restriction sum. Reuse the
   existing project machinery `sectionCech_objD_apply` / `sectionCechProductEquiv` (CechAcyclic.lean) for
   the differential match — do NOT rebuild the alternating-sum bookkeeping. `\uses{lem:pushPull_eval_prod_iso}`
   + the existing `\lean`-pinned `sectionCech_objD_apply` / `sectionCechProductEquiv` labels.

6. **`lem:cechSection_contractible`** — `\lean{AlgebraicGeometry.cechSection_contractible}`. Sub-brick B:
   `Homotopy (𝟙 D') 0`. Because `V ≤ coverOpen 𝒰 i_fix`, the family `U'_j = coverInterOpen 𝒰 j ⊓ V` has a
   MAXIMUM `U'_{i_fix} = V` (every `U'_j ≤ V`), so the prepend-`i_fix` map is the IDENTITY on each
   coefficient and the dependent contracting homotopy gives `d∘h + h∘d = id`. Built from the
   `CombinatorialCech.Dependent` engine (`depDiff`/`depHomotopy`/`depHomotopy_spec`/`depDiff_exact`), being
   de-privatized this iter. `\uses` the (now-public) Dependent-engine labels (find their existing labels in
   the chapter; if the engine has no blueprint pins yet, pin `depDiff_exact` / `depHomotopy_spec`).

7. **`lem:cechSection_isZero_homology`** — `\lean{AlgebraicGeometry.cechSection_isZero_homology}`. The TOP
   consumed by `cechAugmented_exact`: for `V ≤ coverOpen 𝒰 i`, `IsZero (D.homology p)` (equivalently the
   `Homotopy (𝟙 D) 0` the residual needs), obtained by transporting #6 across #5 and applying
   `isZero_homology_of_homotopy_id_zero`. `\uses{lem:cechSection_complex_iso, lem:cechSection_contractible,
   lem:isZero_homology_of_homotopy_id_zero}`.

Then update `lem:cech_augmented_resolution`'s Step 3(b)+(c) prose to cite `lem:cechSection_isZero_homology`
as the discharger, and ADD `lem:cechSection_isZero_homology` to its `\uses{}`.

## TASK 2 — standalone block for `isZero_homology_of_homotopy_id_zero` (lvb major)
Add `\begin{lemma}` `\label{lem:isZero_homology_of_homotopy_id_zero}`
`\lean{AlgebraicGeometry.isZero_homology_of_homotopy_id_zero}`: for any preadditive C and complex D, a
contracting homotopy `Homotopy (𝟙 D) 0` makes `D.homology p` a zero object for every p. One-line proof:
homotopy-invariance of the induced homology map (`Homotopy.homologyMap_eq`) makes `id` on homology equal
the zero map, i.e. `𝟙 = 0`, which characterizes a zero object. (Promote the existing Step-3(d) inline note
to this block.) Archon-original (no external source).

## TASK 3 — `\mathlibok` Mathlib dependency anchors
Author short `\mathlibok` anchor blocks (statement in project notation + `\lean{}` naming the real Mathlib
decl) for the off-the-shelf pieces, so the DAG sees the route's Mathlib reliance:
- `\lean{AlgebraicGeometry.Scheme.Modules.pushforward_obj_obj}` — pushforward sections (rfl).
- `\lean{AlgebraicGeometry.Scheme.Modules.restrictFunctorIsoPullback}` — pullback-along-open-immersion ≅ restrict.
- `\lean{AlgebraicGeometry.Scheme.Modules.restrict_obj}` — restrict sections (rfl).
- evaluation-preserves-products for `SheafOfModules` (find the real decl name in
  `Mathlib/Algebra/Category/ModuleCat/Sheaf/Limits.lean` — analogist cited line 85; verify the name).
- the binary disjoint-union sheaf decomposition `Scheme.coprodPresheafObjIso` /
  `TopCat.Sheaf.isProductOfDisjoint` that `lem:pushPull_sigma_iso` ports.
Mark these `\mathlibok` ONLY (they are genuine Mathlib results, not project obligations).

## TASK 4 — coverage debt: blocks for 4 OpenImmersionPushforward helpers
Add short blocks (statement + `\label` + `\lean{}` + accurate `\uses` + 1-line informal proof) for these
prover-created `lean_aux` decls (consult OIP task result "Needs blueprint entry" if present in
`logs/iter-054/`):
- `\lean{AlgebraicGeometry.pushforwardSectionsFunctor}` — the composite functor `M ↦ Γ(j⁻¹W, M) = Γ(W, j_* M)`.
- `\lean{AlgebraicGeometry.pushforwardSectionsFunctor_additive}` — its `Additive` instance.
- `\lean{CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero}` — sectionwise
  local-injectivity ⟹ sheafification zero (strengthening of `isZero_presheafToSheaf_of_locally_isZero` for
  the non-downward-closed affine opens).
- `\lean{CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms}` — note in the prose this is an
  import-isolation DUPLICATE of `AlgebraicGeometry.isZero_of_faithful_preservesZeroMorphisms`
  (`lem:isZero_of_faithful_preservesZeroMorphisms`); you may point both `\lean{}`s into one block (a
  block may carry multiple `\lean{}` lines) rather than duplicating the statement.

## Out of scope
- Do NOT touch `\leanok` (deterministic sync owns it). You MAY add `\mathlibok` only on the TASK-3 anchors.
- Do NOT rewrite Steps 1–2 of `lem:cech_augmented_resolution` or the `_acyclic`/`_comp` proofs.
- Do NOT address the dead `CechAcyclic.affine` node (planner is handling its cleanup separately).
- Citation discipline: this chain is Archon-original project infra (no external source needed for the
  sub-lemmas); `lem:cech_augmented_resolution` keeps its existing Stacks `% SOURCE QUOTE PROOF:`.

## Reference
`analogies/subbrickA.md` is the precise decomposition (read it; it names every Mathlib decl + line).
You MAY spawn a reference-retriever if you need a source, but this is project-internal infra.

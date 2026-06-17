# Effort-breaker directive — slug `coreiso067`

## Target

`lem:cechSection_complex_iso` in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(~line 8629). Specifically, decompose the **`coreIso` non-augmented differential-match** — the residual
that the prover declined "near budget" last iter and the progress-critic flagged as needing 2–4 typed
sub-lemmas. The augmentation-peeling bookkeeping is ALREADY discharged (helpers `lem:mapHC_augment_iso`,
`lem:map_augment_cond`, `lem:augmentCochainIso`, all sorry-free); do NOT re-decompose that. Your job is
ONLY the `coreIso` core and its degree-0 instance `hcompat`.

## Granularity

Fine — one mathematical claim per lemma. Produce 2–4 sub-lemma blocks, each with `\label`, `\lean{}`
(pin to the NEW Lean name the prover will create — use the `AlgebraicGeometry.` namespace), accurate
`\uses{}`, and a concrete informal proof. These must be small enough to close-or-fail-fast.

## What `coreIso` is (exact types — read these carefully)

`coreIso` is an isomorphism of cochain complexes of abelian groups:
```
(GV.mapHomologicalComplex cc).obj (Ψ.mapHomologicalComplex cc).obj (cechComplexOnX 𝒰 F))
  ≅ sectionCechComplexV 𝒰 F V
```
where `Ψ = SheafOfModules.forget ⋙ PresheafOfModules.restrictScalars (𝟙 ·)` and
`GV = PresheafOfModules.toPresheaf ⋙ evaluation (op V)`. So `(GV∘Ψ)(cechComplexOnX).X p` is the
abelian group `Γ(V, pushPullObj F Y_p)`, and `(sectionCechComplexV 𝒰 F V).X p = ∏_σ Γ(⨅ₖ(coverOpen 𝒰 (σ k) ⊓ V), F)`
(product over `σ : Fin (p+1) → 𝒰.I₀`, the section group over the (p+1)-fold cover-member intersection
meet `V`).

## Proof structure to cut along (the real mathematical seams)

The construction is `HomologicalComplex.Hom.isoOfComponents` (degreewise object iso + per-(p,p+1)
differential commutation). The seams:

1. **Open-meet identity (a pure `Opens` lattice fact).** For `σ : Fin (p+1) → 𝒰.I₀`,
   `coverInterOpen 𝒰 σ ⊓ V = ⨅ₖ (coverOpen 𝒰 (σ k) ⊓ V)` — the `(p+1)`-fold intersection meet `V`
   equals the meet of the `k`-wise `(coverOpen ⊓ V)`. Informal proof: `coverInterOpen 𝒰 σ = ⨅ₖ coverOpen 𝒰 (σ k)`
   by definition, and `inf` distributes over the (nonempty, `Fin (p+1)`-indexed) `iInf`:
   `(⨅ₖ Aₖ) ⊓ V = ⨅ₖ (Aₖ ⊓ V)`. Make it a standalone lemma (it is reused at every degree and in `hcompat`).

2. **Degreewise object iso.** `(GV∘Ψ)(cechComplexOnX 𝒰 F).X p ≅ (sectionCechComplexV 𝒰 F V).X p`,
   i.e. `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(⨅ₖ(coverOpen 𝒰 (σ k) ⊓ V), F)`. Informal proof:
   `pushPull_eval_prod_iso 𝒰 F p V` (Lemma~`lem:pushPull_eval_prod_iso`, DONE) gives
   `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(coverInterOpen 𝒰 σ ⊓ V, F)`; post-compose with the product reindex
   `Pi.mapIso (fun σ => eqToIso (congrArg (Γ(·,F)) (seam 1)))` along the open-meet identity of seam 1 to
   land on the `sectionCechComplexV` target. `\uses{lem:pushPull_eval_prod_iso, <seam-1 label>}`.

3. **Differential commutation square.** For each `p`, the degreewise isos of seam 2 intertwine the two
   differentials: `(objIso p).hom ≫ (sectionCechComplexV).d p (p+1) = (GV∘Ψ Č•).d p (p+1) ≫ (objIso (p+1)).hom`.
   Informal proof: read the `sectionCechComplexV` differential through `sectionCechProductEquiv`
   (Lemma~`lem:section_cech_product_equiv`) as the alternating sum of presheaf face restrictions
   `∑_i (-1)^i sectionCechFaceRestr(σ,i)` computed in `sectionCech_objD_apply`
   (Lemma~`lem:section_cech_objd_apply`); the evaluated Čech-nerve coface of `(GV∘Ψ Č•)` is assembled
   from the same push–pull restriction comparisons, so under the degreewise identification each coface
   becomes the corresponding face restriction and the alternating sums agree.
   `\uses{lem:section_cech_objd_apply, lem:section_cech_product_equiv, <seam-2 label>}`.

Then `coreIso` is `HomologicalComplex.Hom.isoOfComponents (seam 2) (seam 3)`, and the existing
`lem:cechSection_complex_iso` proof consumes it. The degree-0 `hcompat` square is the `p=0` instance of
seam 3 (already noted definitional-up-to-adapter in the chapter) — say so, so the prover discharges it
alongside seam 3 rather than separately.

## Wiring

- Place the new sub-lemma blocks immediately BEFORE `lem:cechSection_complex_iso`.
- Add the new sub-lemma labels to the `\uses{}` of `lem:cechSection_complex_iso`'s PROOF block.
- Verify with leandag that no `\uses{}` edge is broken and no new node is isolated.

## Out of scope

- Do NOT touch the augmentation helpers or `lem:cechSection_contractible`.
- Do NOT change the statement / `% NOTE:` / `\lean{}` of `lem:cechSection_complex_iso` itself.
- Do NOT add or remove `\leanok` (sync_leanok owns it).
- Verify `sectionCech_objD_apply` and `sectionCechProductEquiv` exist (they are in `CechAcyclic.lean`)
  before citing — the prover relies on your `\uses{}` being accurate.

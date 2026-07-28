You are searching an existing Lean 4 formalization workspace for EXISTING infrastructure. Do NOT write or edit any Lean file. Report findings only, with exact `file:line` and full statements.

Workspace root: /home/axel/LeanAlgebraicGeometry-Horizon
Relevant trees:
- MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/   (the main project, ~45 files)
- SubProjects/Cech-Cohomology/AlgebraicJacobian/Cohomology/  (a sibling with a completed Cech port)
- MainProjects/Algebraic-Jacobian-Challenge-Rebuild/  (another sibling)
- .lake-packages/mathlib/Mathlib/  (mathlib)

Use the workspace search CLI, which indexes ALL projects plus mathlib:
  /home/axel/.archon-env/bin/horizon search "<words or name>" --json
(run it with cwd = the workspace root). Also use grep for known strings.

CONTEXT. The key definitions (in Cohomology/CechHigherDirectImage.lean and CechSectionIdentificationBase.lean of the main project):
- `coverCechNerve 𝒰 : SimplicialObject.Augmented Scheme` := `(Arrow.mk (Sigma.desc 𝒰.f)).augmentedCechNerve` — degree p is the (p+1)-fold fibre power of `∐ᵢ Uᵢ` over X.
- `coverCechNerveOver 𝒰 : SimplicialObject (Over X)` := `Over.lift (coverCechNerve 𝒰).left (coverCechNerve 𝒰).hom`
- `pushPullObj F Y := (pushforward Y.hom).obj ((pullback Y.hom).obj F)` for `Y : Over X`; `pushPullFunctor F : (Over X)ᵒᵖ ⥤ X.Modules`.
- `CechNerve 𝒰 F` = whiskering of `(coverCechNerveOverAug 𝒰).rightOp` by `pushPullFunctor F`.
- `coverInterOpen 𝒰 σ` for `σ : Fin (p+1) → 𝒰.I₀` is the intersection open `U_σ` (in Cohomology/FreePresheafComplex.lean:141).
- `pushPull_sigma_iso 𝒰 F p : pushPullObj F ((coverCechNerveOver 𝒰).obj (op (SimplexCategory.mk p))) ≅ ∏ᶜ (fun σ : Fin (p+1) → 𝒰.I₀ => pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))))` (CechSectionIdentificationBase.lean:1210), with `pushPull_sigma_iso_π` at :1229.
- `cechNerve_drop_δ` (CechSectionIdentificationLeg.lean:117) says the Cech nerve coface is `pushPullMap F` of the backbone simplicial face.

I NEED TO KNOW WHETHER ANY OF THE FOLLOWING ALREADY EXIST ANYWHERE (main project, either sibling, or mathlib). For each, report EXISTS (with file:line + statement) or ABSENT (say what you searched):

(Q1) A lemma computing the COFACE / structure map of the Cech nerve IN σ-COORDINATES: i.e. relating `(drop.obj (CechNerve 𝒰 F)).map φ` (or `.δ k`) composed with `pushPull_sigma_iso` to the σ-indexed product map whose τ-component is the push-pull restriction map for the inclusion `U_τ ⊆ U_{τ ∘ φ}` (reindexing σ ↦ σ ∘ φ.toOrderHom together with a restriction). Any statement of the shape "sigma_iso is natural in the simplex index", or a `Pi.lift`/`Pi.map`/`Pi.π` description of the differential of the Cech complex, counts. Look especially in CechSectionIdentification*.lean, CechSectionComplex.lean, FreePresheafComplex.lean, CechTermAcyclic.lean, CechCoboundarySplitting.lean, and the whole SubProjects/Cech-Cohomology tree.

(Q2) Anything about the BACKBONE BASE CHANGE: an iso between `coverCechNerveOver 𝒰'` (for `𝒰' = (Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom`, a cover of X') and `coverCechNerveOver 𝒰 ⋙ CategoryTheory.Over.pullback g'`, or ANY statement that the Cech nerve of a base-changed cover-arrow is the base change of the nerve, or that `Arrow.cechNerve` commutes with a limit-preserving functor / with `Over.pullback`. Also: is `CategoryTheory.Over.pullback g'` (mathlib, Comma/Over/Pullback.lean:63) used ANYWHERE in these projects, and is there any instance/lemma saying it preserves limits or wide pullbacks?

(Q3) A natural transformation or natural iso, over the whole over-category `(Over X)ᵒᵖ` (not just at one object), of the form
    `pushPullFunctor F ⋙ Scheme.Modules.pullback g'  ⟶  (Over.pullback g')ᵒᵖ-ish ⋙ pushPullFunctor ((pullback g').obj F)`
i.e. a Beck–Chevalley comparison for push-pull that is NATURAL in the over-object Y, rather than stated at a single `Y`. In the main project, `openImmersion_bareBC` / `cechOuterBC` / `openImmersion_beckChevalley` / `twisted_cech_nerve_per_sigma` (all in Cohomology/CechHigherDirectImageUnconditional.lean) are the per-square / per-σ forms — I want to know if a Y-natural form exists anywhere.

(Q4) In mathlib: lemmas about `CategoryTheory.mateEquiv` composition — `mateEquiv_vcomp`, `mateEquiv_hcomp`, `conjugateEquiv`, and anything letting one compute the mate of a pasted/composed square. Give exact names + file:line + statements.

(Q5) Any lemma in these projects or mathlib stating that Cech cohomology / the Cech complex is INDEPENDENT of the chosen (affine) cover, or a comparison map between the Cech complexes of two covers with a refinement.

Be exhaustive with search queries, but do not read whole 3000-line files — use grep/search to locate, then read narrow ranges. Report compactly: one block per question. If something is ABSENT, say so plainly and list the queries you ran, because "absent" is as load-bearing an answer as "exists".

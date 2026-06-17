# Blueprint-writer directive — chapter Picard_QuotScheme.tex (annihilator sub-build)

## Scope
Edit ONLY `blueprint/src/chapters/Picard_QuotScheme.tex`. Two additive tasks below.
Do NOT touch any other chapter, any `\leanok` marker, or the Grassmannian/Hilbert sections.

## Strategy context (the slice that matters)
`def:modules_annihilator` (the annihilator ideal sheaf `Ann(F)(U) = Ann_{O_X(U)}(F(U))` on a
scheme `X`) is currently BLOCKED in Lean: its `Scheme.IdealSheafData.map_ideal_basicOpen`
coherence field needs that, for an affine open `U` and `f ∈ Γ(X,U)`, the restriction
`F(U) → F(D(f))` exhibits `F(D(f))` as the localization `(powers f)⁻¹ F(U)`. The iter-007 prover
landed the ALGEBRA half as an axiom-clean Lean lemma but it has no blueprint block, and the
SHEAF-side bridge has no blueprint target at all. This directive blueprints both so a `mathlib-build`
prover can attack the bridge next iter and `def:modules_annihilator` becomes closeable.

## Task 1 — add a blueprint block for the algebra engine lemma (already proved in Lean)
Add a `\begin{lemma}...\end{lemma}` block, placed immediately AFTER `def:modules_annihilator`
(label `def:modules_annihilator`, line ~471) and BEFORE `def:schematic_support`.
- `\label{lem:annihilator_localization_eq_map}`
- `\lean{Module.annihilator_isLocalizedModule_eq_map}`
- `\uses{def:modules_annihilator}`
- Statement (project notation): for a commutative ring `R`, a submonoid `S ⊆ R`, the localization
  `Rₚ = S⁻¹R`, and a FINITELY GENERATED `R`-module `M` with localization `f : M → Mₚ` exhibiting
  `Mₚ` as the localized module `S⁻¹M`, one has
  `Ann_{Rₚ}(Mₚ) = (Ann_R M)·Rₚ = Ideal.map (algebraMap R Rₚ) (Ann_R M)`,
  i.e. `Ann(S⁻¹M) = S⁻¹ Ann(M)` for f.g. `M`.
- This is standard commutative algebra (Bourbaki / Atiyah–Macdonald: annihilator of a f.g. module
  commutes with localization). Treat as a project-built engine lemma — the finite-generation
  hypothesis is ESSENTIAL (state it explicitly; it fails for non-f.g. modules). If you can quote a
  source verbatim from a reference you actually open under `references/`, add the `% SOURCE:` /
  `% SOURCE QUOTE:` block; otherwise write it as a project-bespoke result (omit source lines) with a
  one-paragraph informal proof: `⊇` an annihilator element of `M` maps to one of `Mₚ`; `⊆` for
  `y = a/s ∈ Ann(Mₚ)`, each of finitely many generators `mᵢ` has `uᵢ` with `uᵢ·a·mᵢ = 0`, so
  `(∏uᵢ)·a ∈ Ann_R(M)` and `y = ((∏uᵢ)a)/(∏uᵢ s) ∈ S⁻¹Ann(M)`.

## Task 2 — blueprint the QCoh → IsLocalizedModule bridge as a sub-build
Add a `\begin{lemma}...\end{lemma}` block (place it just before `def:modules_annihilator` or right
after Task 1's lemma — your call for readability) that states the MISSING bridge:
- `\label{lem:qcoh_section_localization_basicOpen}`
- `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (a TODO Lean name the prover
  will create; pick this exact name).
- `\uses{}` whatever affine/quasicoherence facts you cite.
- Statement (project notation): let `X` be a scheme, `M : X.Modules` QUASICOHERENT and of FINITE TYPE
  (over a locally-noetherian base, matching the project's `[IsQuasicoherent] + [finite-type]`
  coherence encoding), `U ⊆ X` an affine open, and `f ∈ Γ(X,U)`. Then:
  (a) `Γ(X, D(f))` is the localization `(Γ(X,U))_f` (Mathlib: `IsAffineOpen.isLocalization_basicOpen`
      — cite as the existing-Mathlib input, you MAY add a `\mathlibok` Mathlib dependency anchor block
      for it if you wish, naming `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen`); and
  (b) the section-restriction map `M(U) → M(D(f))` exhibits `M(D(f))` as the localized module
      `(powers f)⁻¹ M(U)`, i.e. it is `IsLocalizedModule (Submonoid.powers f)`.
- Informal proof sketch: on the affine open `U ≅ Spec Γ(X,U)`, a quasicoherent finite-type sheaf is
  `M̃` for the finite `Γ(X,U)`-module `M(U)`; the basic-open restriction of `M̃` is the localization
  `M(U)_f` (this is exactly the Spec-local `ModuleCat.Tilde` statement transported across the affine
  identification). The work is transporting the `ModuleCat.Tilde` localization fact to a general
  quasicoherent `X.Modules` via the affine identification / `QuasicoherentData`.
- SOURCE: this is standard (quasi-coherent modules on an affine restrict to localizations on basic
  opens). If you need a verbatim citation, dispatch a reference-retriever for the relevant Stacks tag
  in the "Quasi-coherent sheaves" / "Properties of Schemes" chapter (the basic-open = localization
  statement) OR use the already-present `references/stacks-schemes.tex` (tag 01I9 widetilde) if it
  covers it. Only write `% SOURCE QUOTE:` from a file you actually open. If you cannot retrieve a
  verbatim quote, leave the block as a project-bespoke statement with the informal proof and a
  `% SOURCE: <pointer> (verbatim text not yet retrieved)` flag.

## Task 3 — wire the dependencies on def:modules_annihilator
Update `def:modules_annihilator`: keep the existing prose, but make the annihilator's
well-definedness (the patching/`map_ideal_basicOpen` coherence) explicitly `\uses{}` BOTH new lemmas
(`lem:annihilator_localization_eq_map`, `lem:qcoh_section_localization_basicOpen`). State in the
prose that the construction REQUIRES `F` quasicoherent of finite type (so `F(U)` is a finite
`Γ(X,U)`-module) — this is the coherence hypothesis the Lean signature must carry. Leave the existing
`% NOTE (iter-007)` comment or fold its content into the new prose; do not delete the source quote.

## Out of scope
- Do NOT touch `def:sectionGradedRing` / the SNAP graded blocks (separate monoidal-infra sub-build).
- Do NOT add `\leanok` anywhere (deterministic sync owns it). `\mathlibok` only on a genuine Mathlib
  anchor (the `isLocalization_basicOpen` input, optional).
- Do NOT edit the Lean file.

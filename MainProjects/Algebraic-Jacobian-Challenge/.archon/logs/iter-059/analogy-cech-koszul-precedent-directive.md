# Analogy Directive

## Slug
cech-koszul-precedent

## Files to examine

Read-only on project source:

- `/home/archon/Lean_tests/AlgebraicJacobian/AlgebraicJacobian/Cohomology/MayerVietoris.lean` — focus on `section CoverTotality` (around L1300–1582; iter-053 → iter-058 cohort). Specifically the `class HasAffineCechAcyclicCover`, `class IsCechAcyclicCover`, `class HasCechToHModuleIso`, and the `basicOpenCover*` family.
- `/home/archon/Lean_tests/AlgebraicJacobian/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` — focus on the iter-047 cohort `Scheme.cechCochain`, `Scheme.cechCohomology` (parameterised forms; bodies `(cechComplexFunctor 𝒰).obj ((sheafToPresheaf _ _).obj F)` then `.homology n`), and the iter-009/iter-014 definitions of `HModule`/`HModule'` (both as `noncomputable abbrev = Ext ((constantSheaf J (ModuleCat k)).obj (ModuleCat.of k k)) F n`).
- `/home/archon/Lean_tests/AlgebraicJacobian/blueprint/src/chapters/Cohomology_MayerVietoris.tex` — the informal Čech-acyclicity / Mayer-Vietoris arc (iter-047 → iter-058 sections).
- `/home/archon/Lean_tests/AlgebraicJacobian/archon-protected.yaml` — the nine frozen signatures to keep in mind as the ultimate downstream consumer.

Mathlib paths to read directly (paths inside the toolchain Mathlib; the analogy subagent has read access):

- `Mathlib/CategoryTheory/Sites/SheafCohomology/Cech.lean` — definition of `cechComplexFunctor`, its homology, and any comparison API.
- `Mathlib/CategoryTheory/Limits/FormalCoproducts/Cech.lean` (or wherever `Limits.cechObj` / `Limits.cechNerve` live currently) — the underlying simplicial object.
- `Mathlib/RingTheory/LocalProperties/Exactness.lean` — `exact_of_isLocalized_span` (the spanning-set / Koszul exactness lemma). Note: name correction recorded iter-057 — earlier docs claimed `exact_of_localized_span` which does not exist.
- `Mathlib/Algebra/Module/LocalizedModule/Exact.lean` — `IsLocalizedModule.map_exact`, the chain-level localization-preserves-exactness statement.
- `Mathlib/LinearAlgebra/KoszulComplex.lean` (or `Mathlib/Algebra/Homology/Koszul/`) — whatever Mathlib has on Koszul resolutions / acyclicity. Confirm what exists.
- `Mathlib/AlgebraicTopology/AlternatingFaceMapComplex.lean` — face / coface complex constructions used by Čech complexes.
- `Mathlib/AlgebraicGeometry/AffineScheme.lean` — `IsAffineOpen.isLocalization_basicOpen`, `IsAffineOpen.isLocalization_of_eq_basicOpen`, `algebra_section_section_basicOpen` instance scope.
- `Mathlib/AlgebraicGeometry/Scheme.lean` — `Scheme.basicOpen_le`, `Scheme.basicOpen_mul`.
- Any file in `Mathlib/CategoryTheory/Sites/SheafCohomology/` providing a Čech-to-derived comparison.
- `Mathlib/AlgebraicGeometry/EllAdicCohomology/` (if present) — check whether any Čech-to-derived isomorphism is already produced there for acyclic covers.

## Question

For the upcoming iter-059+ work — proving project-locally that
`IsCechAcyclicCover (toModuleKSheaf C) (basicOpenCover s)` (degree-by-degree
exactness of the Čech complex on basic opens of an affine `U` under
`Ideal.span (s : Set Γ(C.left, U)) = ⊤`) **and** the Čech-vs-derived
comparison `HasCechToHModuleIso (toModuleKSheaf C) (basicOpenCover s)` — how
much of the chain-level / spectral-sequence machinery already exists in
Mathlib, and what is the most economical *Mathlib-faithful* design for the
project-local additions?

Concretely, please answer:

1. **What is `cechComplexFunctor`'s output type?** Is its homology *already*
   the cochain-level evaluation `n ↦ ∏_{x : Fin (n+1) → s} F(⋂_k 𝒰 (x k))` we
   need, or does it pass through a different simplicial intermediate? Pin
   down the precise Mathlib expression of the cochain at degree `n` in our
   setting.

2. **Does Mathlib have an acyclic-cover ⇒ Čech-iso-to-derived theorem in
   *any* category-theoretic form?** Specifically, look for a statement of the
   shape "if `cechComplexFunctor 𝒰` applied to an injective resolution of
   `F` is exact in positive Čech degrees then `cechCohomology 𝒰 F n ≃
   Ext^n(R, F)`" or similar. If so, name it and sketch how iter-062+ would
   plug it in. If not, sketch the shortest project-local construction
   (acyclic-cover ⇒ comparison iso) compatible with how `HModule` and
   `cechCohomology` are currently defined in the project.

3. **What is the canonical Mathlib precedent for proving
   `exact_of_isLocalized_span`-style acyclicity on a Čech complex?** I.e.
   given that each `F(⋂_k 𝒰 (x k))` is identifiable (via
   `IsAffineOpen.isLocalization_of_eq_basicOpen` invoked with iter-058's
   `basicOpenCover_finset_inf'_le` as the morphism arg + iter-057's
   `..._eq_basicOpen_prod` as the equality arg) with `Localization.Away (∏_k
   (x k).1)` of `Γ(C.left, U)`, what is the most direct way Mathlib chains
   this with the Koszul / `exact_of_isLocalized_span` / `IsLocalizedModule.map_exact`
   machinery to conclude exactness of the alternating-sum Čech differential?
   Is there a one-line wrapper somewhere, or does the project need to
   reproduce the alternating-sum-cancellation argument by hand?

4. **Is there an alternative project-local route that bypasses the Čech-vs-
   derived comparison entirely?** For example, could `HModule k F n` be
   shown directly subsingleton on the supremum cover by an Ext long-exact
   sequence over the cover terms, without ever going through
   `cechCohomology`? If so, would that simplify iter-059+ by replacing the
   ~200-400 LOC comparison branch with a more direct LES argument?

5. **Naming alignment**: what is the current Mathlib spelling of
   `cechComplexFunctor` (whose import is currently
   `Mathlib.CategoryTheory.Sites.SheafCohomology.Cech` per iter-047)? Has
   any rename / move happened since iter-047? Confirm the file path is
   still correct, and flag any deprecation.

## Why now

Iter-058 just closed the n-ary inclusion helper
`basicOpenCover_finset_inf'_le` (the last thin scaffolding step before the
substantive Koszul / comparison branch). Iter-053's
`HasAffineCechAcyclicCover` carrier, iter-054's `basicOpenCover`
infrastructure, iter-055's existence-form producer, and iter-056/057/058's
intersection helpers are all in place. Iter-059 opens a multi-iteration
substantive branch (~6-10 iterations, ~350-650 LOC) with two parallel
substantive obligations: (A) basic-open Koszul acyclicity and (B) the
Čech-vs-derived comparison iso. Before committing the project to that
construction, an audit of Mathlib precedent could either (a) reveal an
existing wrapper that collapses one or both branches to ~10-20 LOC, saving
~200+ LOC and ~3-5 iterations, or (b) confirm the construction must be done
project-locally, in which case the analogy report informs how to structure
it. The plan-agent has been deferring this audit for 5 iterations
(iter-055/056/057/058) — it should not be deferred again.

## Hints (optional)

- The project's `cechComplexFunctor` import is currently
  `Mathlib.CategoryTheory.Sites.SheafCohomology.Cech` (iter-047). Verify
  this path still resolves; if Mathlib has renamed/moved the file, that's a
  separate fix.
- The relevant Stacks tags are 03OU (Čech-to-cohomology spectral sequence),
  01EO (Čech vs derived), 03AV (acyclic covers), 02FQ (Koszul-style
  spanning exactness for affine schemes).
- Mathlib's `algebra_section_section_basicOpen` instance only fires for the
  syntactic form `Γ(X, X.basicOpen f)`, so the iter-059 Koszul argument
  must construct each `Localization.Away` identification by explicitly
  invoking `IsAffineOpen.isLocalization_of_eq_basicOpen` (which installs
  the algebra via its `(i : V ⟶ U)` morphism argument).
- The persistent output should live at `analogies/cech-koszul-precedent.md`
  with a clear "what Mathlib provides" / "what the project must provide"
  partition, plus rough LOC estimates for the project-side work. Future
  iterations will re-read this file when scoping iter-059, iter-062+, and
  iter-066+ branches.
- Report at `.archon/task_results/analogy-cech-koszul-precedent.md`. Keep
  the report executive-summary length (~1-2 pages); put the detailed
  per-Mathlib-file findings in the persistent `analogies/` file.

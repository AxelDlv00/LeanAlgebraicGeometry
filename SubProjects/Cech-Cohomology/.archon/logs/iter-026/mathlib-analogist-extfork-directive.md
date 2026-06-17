# Mathlib analogist directive — resolve the absolute-cohomology Ext FORM FORK and give scaffold signatures

## Mode: api-alignment

## Slug
extfork

## Context (self-contained)

The project is formalizing Čech computation of higher direct images. It has DECIDED (iter-025,
your prior report `analogies/absolute-cohomology.md`, slug `abscohom-025`) to realize absolute
sheaf cohomology of an `O_X`-module over an open `U` as **Ext of the structure sheaf**:

    H^p(U, F) := Ext^p_{Mod(O_U)}(O_U, F|_U)     (the "restrictFunctor form")

equivalently `Ext^p_{Mod(O_X)}(j_! O_U, F)` (the "j_! form"). The Ext bifunctor is
`CategoryTheory.Abelian.Ext` on the abelian category `U.Modules` (= `SheafOfModules` over `U`'s
ringed-space site / `AlgebraicGeometry.Scheme.Modules`).

We are about to SCAFFOLD a new Lean file `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean`
that builds this `H^p` definition plus the THREE structural facts the downstream 01EO dimension
shift consumes:
  (0) `H^0(U,F) ≅ Γ(U,F)`  (degree-0 Ext is Hom, then Hom(O_U,-) = global sections)
  (1) injective vanishing: `H^{n+1}(U, I) = 0` when `I` is an injective `O_X`-module
  (2) the covariant long exact sequence of `H^p(U,-)` for a SES `0→F→I→Q→0` of `O_X`-modules,
      at FIXED first Ext argument.

## THE decision you must resolve (this is the whole point of the dispatch)

**Which form should the scaffold commit to, and how is the injective vanishing (1) realized in
that form?** The blueprint currently DEFINES via the restrictFunctor form but JUSTIFIES (1) "via
the `j_! O_U` form" — these are inconsistent unless `j_!` exists. Resolve it concretely:

A. **Does `j_!` (extension-by-zero / lower-shriek along an open immersion) exist for
   `SheafOfModules` / `AlgebraicGeometry.Scheme.Modules` in the CURRENTLY PINNED Mathlib?**
   Search precisely (loogle/leansearch/declaration source). Report the exact decl name + file
   path if it exists, or state authoritatively that it is ABSENT. Also check whether the
   adjunction `j_! ⊣ j^*` (restriction) and its exactness are available.

B. **Injective vanishing in each form rests on the exactness of restriction's LEFT adjoint:**
   - restrictFunctor form needs `I|_U = j^*(I)` injective in `Mod(O_U)`, i.e. "restriction
     preserves injectives", which (via `CategoryTheory.Injective.injective_of_adjoint` /
     `injective_of_preservesEpimorphisms`-style results) needs `j^*` to have an EXACT left
     adjoint = `j_!`.
   - j_! form needs `Ext^{n+1}(j_!O_U, I) = 0` directly from `I` injective in `Mod(O_X)` (via
     `Ext.eq_zero_of_injective`, which needs only the 2nd Ext arg injective) — no
     restriction-preserves-injectives — but needs `j_!` to exist AND `Hom(j_!O_U, F) = Γ(U,F)`
     via the adjunction for fact (0).
   Determine which form has the SHORTER Lean path GIVEN what Mathlib actually provides. If `j_!`
   is absent, is "restriction preserves injectives" obtainable another way Mathlib supports
   (e.g. restriction to an open is itself a right adjoint of pushforward with an exact left
   adjoint; or a Mathlib `SheafOfModules`/`PresheafOfModules` injective-restriction lemma)? Note
   the project already has `injective_toPresheafOfModules` (sheaf→presheaf injectivity transport
   via `Injective.injective_of_adjoint` over `sheafificationAdjunction`) as a precedent pattern.

C. **Re-verify (do NOT trust prior-iter checks — Mathlib bumps rename) that these named decls
   exist in the pinned Mathlib, with exact current names + signatures:**
   `CategoryTheory.Abelian.Ext`, `CategoryTheory.HasExt.standard`,
   `CategoryTheory.Abelian.Ext.homEquiv₀`, `CategoryTheory.Abelian.Ext.addEquiv₀`,
   `CategoryTheory.Abelian.Ext.eq_zero_of_injective`,
   `CategoryTheory.Abelian.Ext.covariantSequence_exact` and
   `CategoryTheory.Abelian.Ext.covariant_sequence_exact₁/₂/₃`,
   `AlgebraicGeometry.Scheme.Modules.restrictFunctor`. Flag any that are renamed/absent and give
   the correct current name. Confirm `SheafOfModules`/`X.Modules` is `Abelian` and the universe
   parameters that make `HasExt` apply (the `HasExt.{w}` smallness bookkeeping — does it elaborate
   cleanly over `Scheme.Modules`, or is there a universe pain point? This is the strategy's named
   reversal signal).

## Project artifacts to read
- `analogies/absolute-cohomology.md` — your own prior report (the Ext decision rationale).
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` L2787–3110 — the
  `def:absolute_cohomology` block, the 6 Mathlib anchors, `lem:affine_serre_vanishing` (02KG),
  `lem:cech_to_cohomology_on_basis` (01EO).
- `AlgebraicJacobian/Cohomology/HigherDirectImage.lean` — `higherDirectImage` = the project's
  existing derived-functor idiom; uses `X.Modules` with `[HasInjectiveResolutions X.Modules]`.
- `AlgebraicJacobian/Cohomology/PresheafCech.lean:216` — `injective_toPresheafOfModules`
  (the `injective_of_adjoint` precedent).

## Deliverable
1. A definitive verdict on the form fork: **commit to FORM A (restrictFunctor) or FORM B (j_!)**,
   with the evidence (what Mathlib has/lacks). State the cheapest coherent path for fact (1) in
   that form.
2. Concrete Lean signature SKELETONS for the scaffold file's targets: the `H^p`/absolute-cohomology
   definition, the `H^0 ≅ Γ` iso, the injective-vanishing lemma, the LES instantiation — in the
   chosen form, naming the exact Mathlib decls each rests on.
3. The corrected/confirmed list of Mathlib anchor decl names.
4. If a genuine Mathlib gap surfaces (e.g. `j_!` absent AND restriction-preserves-injectives
   not otherwise available), name it precisely and estimate the project-side mathlib-build cost,
   and say whether FORM A or FORM B minimizes it.

Write your report to `task_results/mathlib-analogist-extfork.md` and persist the form-fork
resolution to `analogies/ext-form-fork.md`.

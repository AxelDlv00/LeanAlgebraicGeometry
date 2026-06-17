# Directive: cheapest Mathlib route to "restriction preserves injectives" + H⁰=Γ plumbing for Ext-based absolute cohomology

## Mode: api-alignment

## Context (self-contained)

The project formalizes Čech computation of higher direct images. It is about to scaffold an
absolute sheaf-cohomology definition for `O_X`-modules, realized as **Ext of the structure sheaf**:
```
H^p(U, F) := Ext^p_{Mod(O_U)}(O_U, F|_U)
```
where `U ⊆ X` is an open subscheme, `j : U ↪ X` the open immersion, `F|_U = restrictFunctor j (F)`,
and `O_U` is the structure sheaf of `U` as a module over itself. The category in play is
`AlgebraicGeometry.Scheme.Modules` (= `SheafOfModules` over the scheme's structure sheaf), which is
`Abelian`. Mathlib's `CategoryTheory.Abelian.Ext` supplies the Ext bifunctor, `HasExt.standard`
(unconditional), the covariant LES (`Ext.covariant_sequence_exact₁/₂/₃`), degree-0
`Ext.homEquiv₀ : Ext X Y 0 ≃ (X ⟶ Y)`, and injective vanishing
`Ext.eq_zero_of_injective : Ext^{n+1}(X, J) = 0` for `[Injective J]` (vanishing needs the **second**
Ext argument injective).

### The two questions

**Q1 (PRIMARY — the strategic crux). Restriction preserves injectives.**
Downstream (Stacks 01EO dimension-shift) the project needs, for an **injective** `O_X`-module `I`:
```
H^n(U, I) = Ext^n_{Mod(O_U)}(O_U, I|_U) = 0   for n > 0.
```
Via `Ext.eq_zero_of_injective` this reduces to: **`I|_U := restrictFunctor j (I)` is injective in
`U.Modules` whenever `I` is injective in `X.Modules`** (`j : U ↪ X` an open immersion).

What I have VERIFIED about the relevant Mathlib API (`Mathlib.AlgebraicGeometry.Modules.Sheaf`):
- `Scheme.Modules.restrictFunctor j : Y.Modules ⥤ X.Modules` (restriction along open immersion).
- `Scheme.Modules.restrictAdjunction j : restrictFunctor j ⊣ pushforward j` — restriction is the
  **LEFT** adjoint to pushforward. (`instIsLeftAdjointRestrictFunctor`.)
- `restrictFunctorIsoPullback`, `restrictFunctorAdjCounitIso` (pushforward ⋙ restrict ≅ id; counit iso).
- **NO left adjoint to `restrictFunctor` exists** — loogle `_ ⊣ restrictFunctor _` returns empty.
  I.e. **`j_!` (extension-by-zero) is ABSENT from Mathlib.** This rules out the standard textbook proof
  of restriction-preserves-injectives (which uses `Hom_{O_U}(N, j^*I) ≅ Hom_{O_X}(j_!N, I)` with `j_!`
  exact). It also rules out the alternative def form `Ext^p_{Mod(O_X)}(j_!O_U, F)`.

Note the available adjunction `restrictFunctor ⊣ pushforward` gives the WRONG direction: it yields
"pushforward preserves injectives" (right adjoint of a mono-preserving left adjoint — the
`Injective.injective_of_adjoint` pattern the project already uses for `injective_toPresheafOfModules`),
NOT "restriction preserves injectives".

**What I need from you:** the cheapest Lean route, using only today's Mathlib, to
`Injective I → Injective (restrictFunctor j (I))` for `j` an open immersion in `Scheme.Modules`
(equivalently `SheafOfModules`). Rank the candidate routes by cost and report which (if any) is
genuinely buildable:
  (a) Build `j_!` (extension-by-zero) as a left adjoint to `restrictFunctor` with proof it preserves
      monos/is exact, then the textbook argument. How large? Does Mathlib's
      `PresheafOfModules`/`SheafOfModules` + open-immersion (`Opens`/`IsOpenImmersion`) machinery make
      `j_!` tractable (e.g. via left Kan extension `Functor.lan` + sheafification, or a direct
      stalk-supported construction)? Is there ANY existing extension-by-zero in Mathlib for sheaves of
      *abelian groups* / *types* on a space (`TopCat.Presheaf`, `CategoryTheory.Sheaf`, `Opens`) we
      could port, even if not yet for modules?
  (b) A direct argument avoiding `j_!`: e.g. exhibit `restrictFunctor j` as a RIGHT adjoint via some
      OTHER adjunction Mathlib has (is there `pushforward? ⊣ restrictFunctor`, a `pullback`/`pushforwardₗ`
      variant, or an equivalence onto an over/comma category that flips the adjunction?), then apply
      `injective_of_adjoint`. The `restrictFunctorIsoPullback` and the open-immersion étale/localization
      structure may give a second adjunction. Check `IsOpenImmersion`, `Scheme.Hom.opensFunctor`,
      `Scheme.restrict`, `morphismRestrict`, `Sheaf.over`/localization-of-sheaf-category adjunctions.
  (c) Sidestep at the cohomology level: is there a Mathlib idiom realizing `H^p(U,-)` so that injective
      vanishing holds WITHOUT restriction-preserves-injectives AND a LES is still available? (The
      project already REFUTED `Functor.rightDerived` here — it has injective vanishing but NO LES; and
      `CategoryTheory.Sheaf.H` does not exist. Look for anything newer: `Abelian.Ext` of a *different*
      representing object, a derived `Γ(U,-)` with an attached triangle/LES, etc.) If nothing exists,
      say so plainly.
  (d) Any other route you see.

If the verdict is "route (a) build `j_!`", give a concrete decomposition (the functor, the adjunction,
the exactness proof, expected LOC) and whether, once `j_!` exists, we should ALSO switch the def to
Form B `Ext^p_{Mod(O_X)}(j_!O_U, F)` (which makes injective vanishing free and the LES at fixed first
arg `j_!O_U`). Compare "build j_! → Form B" vs "build restriction-preserves-injectives directly →
keep Form A" on total cost.

**Q2 (secondary — confirm the H⁰=Γ plumbing).** For the definition + its `H^0(U,F) ≅ Γ(U,F)` clause,
confirm the Lean chain:
`Ext^0_{O_U}(O_U, F|_U) ≃ (O_U ⟶ F|_U)` via `Ext.homEquiv₀` (verified to exist), then
`(O_U ⟶ F|_U) ≅ Γ(U, F)`. What is the Mathlib idiom for `Hom_{O_U}(O_U, M) ≅ Γ(U, M) = M.obj(⊤)`
in `Scheme.Modules` / `SheafOfModules` (the "global sections = Hom from structure sheaf" iso)? Name
the exact declaration(s) (`SheafOfModules.unit`, `PresheafOfModules`/`ModuleCat` global-sections-as-Hom,
`ΓSpec`, sections functor, etc.), or flag it as a small thing to build.

## Project artifacts to read
- `AlgebraicJacobian/Cohomology/CechBridge.lean` — see `injective_toPresheafOfModules` usage and the
  `Injective.injective_of_adjoint` pattern already in the project (for the adjunction shape).
- `AlgebraicJacobian/Cohomology/PresheafCech.lean:216` — `injective_toPresheafOfModules`.
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` §"Absolute sheaf cohomology as Ext"
  (around line 2787) — `def:absolute_cohomology` and the `lem:ext_*_mathlib` anchors; and the 01EO
  proof at lines 3109–3174 where the injective vanishing `H^n(U,I)=0` is invoked.
- Mathlib: `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`, `Mathlib/Algebra/Category/ModuleCat/Sheaf/*`,
  `Mathlib/Algebra/Homology/DerivedCategory/Ext/*`.

## Deliverable
Write `analogies/restriction-preserves-injectives.md` with the ranked routes, the chosen recommendation
for Q1 (with concrete decomposition + LOC estimate + whether to keep Form A or switch to Form B if j_!
gets built), and the Q2 plumbing answer (exact declaration names). Plus the standard `task_results/`
report. This is load-bearing: the verdict decides a sub-phase of the strategy, so be concrete about
what is buildable from today's Mathlib vs what is a genuine gap.

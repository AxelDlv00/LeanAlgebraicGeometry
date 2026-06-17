# Mathlib Analogist Report

## Mode
api-alignment

## Slug
restrict-inj

## Iteration
026

## Question
Cheapest Mathlib route to `Injective I → Injective (restrictFunctor j I)`
("restriction preserves injectives") for the Ext realization of absolute cohomology, ranked over
routes (a) build `j_!`, (b) a second adjunction, (c) sidestep at the cohomology level, (d) other —
plus confirm the `H^0 = Γ(U,-)` plumbing (Q2).

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Realize `H^p(U,-)` so vanishing+LES are free → adopt **Form B**, drop restriction-preserves-injectives | ALIGN_WITH_MATHLIB | critical (it decides the sub-phase) |
| Build `j_!O_U` as `sheafify(free(yoneda U))` (object only, from shipped pieces) | PROCEED | major |
| Route (a): build full `j_!` functor + exactness for Form A | NEEDS_MATHLIB_GAP_FILL | informational (avoid) |
| Route (b): `restrictFunctor` as a right adjoint via another Mathlib adjunction | (absent) | informational |
| Q2: `Hom(O_U,M) ≅ Γ(U,M)` via `SheafOfModules.unitHomEquiv` | PROCEED | informational |

## Must-fix-this-iter

- **Make Form B the primary realization in `def:absolute_cohomology`.** The def currently centers on
  Form A (`Ext^p_{Mod(O_U)}(O_U, F|_U)`), which is logically equivalent to restriction-preserves-
  injectives — a 200–500 LOC Mathlib gap-fill with no shortcut. The blueprint already states the Form B
  expression `Ext^p_{Mod(O_X)}(j_!O_U, F)`; promote it to primary. Under Form B the three 01EO inputs
  are all free:
  - **H⁰ = Γ(U,F):** `Ext.homEquiv₀` then corepresentability
    `Hom_{X.Modules}(jShriekOU U, F) ≅ Hom_{PMod}(free(yoneda U), forget F) ≅ F(U)`
    (`PresheafOfModules.sheafificationAdjunction (𝟙 _)` ∘ the project's `freeYonedaHomEquiv`/
    `freeYonedaHomAddEquiv`).
  - **Injective vanishing H^{n+1}(U,I)=0:** `Ext.eq_zero_of_injective` — `I` is the *second* Ext
    argument and is injective in `Mod(O_X)`. **No restriction-preserves-injectives.**
  - **Covariant LES:** `Ext.covariant_sequence_exact*` at fixed first argument `jShriekOU U`, applied
    to the SES `0→F→I→Q→0` directly in `Mod(O_X)` (no need to restrict the SES, since the second
    Ext variable is the module variable).

## Major

- **Add `jShriekOU` + its corepresentability (≈50–80 LOC, LOW).** Concrete decomposition:
  1. `def jShriekOU (U : Opens X) : X.Modules :=`
     `  (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj`
     `    ((PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj U))`.
     (This object *is* `j_!O_U` up to iso: `free(yoneda U)(V) = O_X(V)` for `V ≤ U`, `0` else =
     presheaf extension-by-zero, sheafified.)
  2. `noncomputable def jShriekOUHomEquiv (U) (F : X.Modules) : (jShriekOU U ⟶ F) ≃ F(U)` :=
     `((PresheafOfModules.sheafificationAdjunction (𝟙 _)).homEquiv _ F).trans (freeYonedaHomEquiv U _)`
     — naturality/additivity inherited from the two adjunction equivs (use `freeYonedaHomAddEquiv`).
  3. `def H (p : ℕ) (U) (F) := AddCommGrp.of (Ext (jShriekOU U) F p)`.
  4. `H⁰ ≅ Γ`, injective vanishing, LES wrappers as above.
  Verified Mathlib anchors:
  `PresheafOfModules.sheafificationAdjunction`
  (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification`) with
  `sheafificationAdjunction_homEquiv_apply`; `PresheafOfModules.free`, `yoneda`,
  `Scheme.Modules.toPresheafOfModules` (all already used in `PresheafCech.lean`).

## Informational

- **Route (b) is genuinely absent.** Loogle on `_ ⊣ Scheme.Modules.restrictFunctor _` and the full
  `restrictFunctor` neighbourhood return only `restrictAdjunction f : restrictFunctor f ⊣ pushforward f`
  (`Mathlib.AlgebraicGeometry.Modules.Sheaf`). Its counit is iso
  (`instIsIsoFunctorCounitRestrictAdjunction`), which proves `pushforward` is fully faithful and gives
  *pushforward*-preserves-injectives (the existing `injective_toPresheafOfModules` shape), **not**
  restriction. `restrictFunctorIsoPullback` only re-expresses `restrictFunctor ≅ pullback`; same
  adjunction. So `restrictFunctor` is exhibited only as a *left* adjoint — `injective_of_adjoint`
  cannot apply to it. No `j_!`/extension-by-zero exists anywhere in Mathlib for sheaves of modules,
  abelian groups, or types on a space (searches for extension-by-zero return only `res_zero`-type
  triviality lemmas).

- **Route (a) cost, if Form A were ever forced.** Build `j_!` functor `U.Modules ⥤ X.Modules` (left
  Kan extension along `Opens U ↪ Opens X` + sheafification + module structure), the adjunction
  `j_! ⊣ restrictFunctor`, and mono-preservation; then `injective_of_adjoint`. Estimated 200–500+ LOC,
  genuine new infrastructure, real risk. Not recommended — Form B dissolves the need.

- **Q2 plumbing exists off the shelf.** `SheafOfModules.unit R : SheafOfModules R` is `O` over itself;
  `SheafOfModules.unitHomEquiv : (unit R ⟶ M) ≃ M.sections` is `Hom_O(O,M) ≅ Γ(M)`
  (`Mathlib.Algebra.Category.ModuleCat.Sheaf`). With `Ext.homEquiv₀` this is the Form A H⁰ chain.
  Under Form B you don't need `unit`; the `jShriekOUHomEquiv` chain gives `H⁰ ≅ F(U)` directly.

## Persistent file
- `analogies/restriction-preserves-injectives.md` — ranked routes, Form B decomposition, Q2 names.

Overall verdict: Do not build `j_!`/restriction-preserves-injectives — switch the realization to
Form B `Ext^p_{Mod(O_X)}(sheafify(free(yoneda U)), F)`, which makes injective vanishing + LES free and
H⁰ = Γ a two-adjunction composite of already-shipped pieces (~50–80 LOC), and answers Q2 via
`SheafOfModules.unitHomEquiv` + `Ext.homEquiv₀`.

# Mathlib-analogist directive — tilde F-bridge accessor reconciliation

## Mode: api-alignment

## Context

In the project, a quasi-coherent module on `Spec R` appears through several distinct
accessors, and a proof is blocked on reconciling them into a single per-section
`AddEquiv`. We need to know Mathlib's canonical idiom for moving between these accessors,
and whether the project's section-Čech complex should have been built on a different one.

## The three accessors (all naming "sections of a qcoh module over a basic open `D(g) ⊆ Spec R`")

1. **`((toPresheafOfModules (Spec R)).obj G).presheaf.obj (op (D g))`** — `G : (Spec R).Modules`
   viewed through `toPresheafOfModules : X.Modules ⥤ X.PresheafOfModules`. This is the
   **`AddCommGrp`-valued underlying presheaf** of a `Scheme.Modules` object. The project's
   `sectionCechCosimplicial` / `sectionCechComplex` (in `PresheafCech.lean`) read sections
   through THIS accessor (Ab-valued, so the section Čech complex lives in `Ab`).
2. **`(AlgebraicGeometry.tilde.toOpen M (D g)).hom`** and
   **`(modulesSpecToSheaf.obj (tilde M)).presheaf.obj (op (D g))`** — the **`ModuleCat R`-valued**
   sheaf sections of `tilde M` (the `M^~` construction). `modulesSpecToSheaf : (Spec R).Modules ⥤
   TopCat.Sheaf (ModuleCat R) _`. The project already proved (iter-020,
   `qcohSectionsAwayLocalized`) that THIS accessor gives `IsLocalizedModule (Submonoid.powers g)`
   relating `M` to the `ModuleCat`-valued sections.
3. **`LocalizedModule (Submonoid.powers g) M`** (= `SectionCechModule.dCoeff`) — the explicit
   away-localisation module the un-localised section Čech module complex `D•` is built from.

## What is needed (the blocked goal)

A per-multi-index `σ` `AddEquiv`
`φ_σ : ToType (((toPresheafOfModules (Spec R)).obj G).presheaf.obj (op (D s_σ))) ≃+ LocalizedModule (powers s_σ) M`
(for `G = tilde M`), PLUS the naturality square intertwining the section-Čech face
restriction (`sectionCechFaceRestr`, a `presheaf.map (homOfLE …).op`) with the
localisation comparison coface `SectionCechModule.dCoface`.

The blocker is purely accessor (1)↔(2)↔(3) reconciliation: `qcohSectionsAwayLocalized`
gives (2)↔(3) but the section Čech complex reads via (1).

## Questions

1. **Is `toPresheafOfModules (Spec R) ⋙ (eval at D g)` defeq / canonically iso to the
   `ModuleCat`-valued sheaf sections of `modulesSpecToSheaf`/`tilde.toOpen` after forgetting
   to `Ab`?** i.e. does Mathlib provide a coherence iso between the `PresheafOfModules`
   underlying-Ab presheaf of a `Scheme.Modules` object and the `forget₂ (ModuleCat R) Ab`
   of its `modulesSpecToSheaf` sheaf sections? Name the exact lemma/instance if it exists.
2. **Does Mathlib already have `IsLocalizedModule` for the `toPresheafOfModules` Ab-presheaf
   restriction** `M →+ ((toPresheafOfModules (Spec R)).obj (tilde M)).presheaf.obj (op (D g))`
   directly (so we skip the (1)↔(2) hop)? Search around `AlgebraicGeometry.Modules.tilde`,
   `PresheafOfModules`, `SheafOfModules`, `Scheme.Modules`.
3. **Was building the section Čech complex on accessor (1) (Ab-valued) the wrong choice?**
   Would building it directly on the `ModuleCat R`-valued `modulesSpecToSheaf` sections
   (so `qcohSectionsAwayLocalized` applies with no Ab detour, and exactness uses
   `moduleCat_exact_iff` instead of `ShortComplex.ab_exact_iff`) be the Mathlib-aligned
   shape? Cost/benefit of switching vs. building the (1)↔(2) bridge.
4. For the AddEquiv-from-two-localisations: confirm the canonical Mathlib route is
   `IsLocalizedModule.iso` / `IsLocalizedModule.linearEquiv` uniqueness, and that
   `Function.Exact.of_ladder_addEquiv_of_exact` (`Mathlib.Algebra.Exact.Basic`) is the
   right tool to transport `dDiff_exact` across the resulting degreewise AddEquiv.

Produce a persistent `analogies/tilde-section-bridge.md` the prover can read, with the
exact Mathlib lemma names (verified present) and a concrete recommended path
(bridge-the-accessors vs. rebuild-on-ModuleCat), including the cost of NOT aligning.

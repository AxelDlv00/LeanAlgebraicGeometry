# Mathlib Analogist Report

## Mode
api-alignment

## Slug
genaffine-seed

## Iteration
057

## Question
Build the LAST residual of the open-immersion-acyclicity lane (Need #2): the general-affine-open
standard-cover Čech vanishing seed `htilde`. For `M : ModuleCat R`, `g : Fin n → R` with `V := ⨆ᵢ D(gᵢ)`
an AFFINE open of `Spec R` (general, not `= D(f)`), and `p > 0`, prove
`IsZero (cechCohomology (fun i => D(gᵢ)) ((toPresheafOfModules).obj (tilde M)) p)`. Find the cheapest
Mathlib-aligned route; answer idiom questions A–D; flag parallel-API risk.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. change-of-ring to `S=Γ(V)` (B) vs no-change-of-ring (C) | ALIGN_WITH_MATHLIB (B); reject C | informational |
| 2. `M_S := M⊗_R S` (B1) vs `Γ(V,~M)` (B2 sheaf) | ALIGN_WITH_MATHLIB (B1); diverge B2 | informational |
| 3. co-locate in `CechAcyclic.lean` vs fresh file | PROCEED (co-locate) | informational |
| 3b. per-σ base-change localization (new lemma) | NEEDS_MATHLIB_GAP_FILL (low cost) | informational |

No ALIGN_WITH_MATHLIB verdict touches shipped divergent code (all the new code is unwritten), so there is
no must-fix item. The verdicts are design guidance for the code about to be written.

## Answers to the directive's idiom questions A–D

**A. `Γ(D(gσ)) = R_{gσ} = S_{ḡσ}` — YES, via shipped ring lemmas (no new API).**
`Γ(D(gσ))` is `IsLocalization.Away gσ` over `R` (`IsAffineOpen.isLocalization_basicOpen`, `U=⊤`) AND
`IsLocalization.Away ḡσ` over `S=Γ(V)` (`IsAffineOpen.isLocalization_of_eq_basicOpen`, with
`(Spec R).basicOpen ḡσ = V ⊓ D(gσ) = D(gσ)` from `Scheme.basicOpen_res`). Both in
`Mathlib.AlgebraicGeometry.AffineScheme`/`.Scheme`. Hence `IsLocalization (powers gσ) (Localization.Away ḡσ)`
over `R`. The module statement `Γ(V,~M)_{ḡσ} ≅ M_{gσ}` is then `IsLocalizedModule` uniqueness — but see B
for the cheap algebraic realization that avoids ever forming `Γ(V,~M)`.

**B. `Γ(V,~M) = M ⊗_R S` — Mathlib does NOT package qcoh-`Γ`-on-affine as a base change at the sheaf level**
(only the ring `Γ`), and the qcoh-module restriction-to-basicOpen localization is ABSENT. The clean route
is therefore the **purely algebraic** one (B1): take `M_S := M ⊗_R S` and get the per-σ localization
`(M⊗_R S)_{ḡσ} ≅ M_{gσ}` from `Mathlib.RingTheory.Localization.BaseChange` +
`Mathlib.RingTheory.IsTensorProduct` (`tensorProduct_isLocalizedModule`,
`isLocalizedModule_iff_isBaseChange`, `IsLocalizedModule.isBaseChange`, `TensorProduct.isBaseChange`,
`IsBaseChange.comp`; concrete fallback `IsLocalization.Away.tensorEquiv`). NO sheaf-section `Γ(V,~M)` is
formed. The 5-step `IsBaseChange.comp` construction is spelled out in `analogies/genaffine-cech-seed.md` §B.

**C. WITHOUT change-of-ring — NO.** `exact_of_localized_maximal` (`…LocalProperties.Exactness`, verified)
is circular: at a maximal `J ∉ V` the localized complex is the same positive-degree Čech-of-a-general-affine
-cover problem over `R_J` (no unit in `g/1`, terms non-zero), so it has no base case.
`exact_of_isLocalized_span` over `R` cannot apply (`gᵢ` span `⊤` iff `V = Spec R`). No Mathlib
affine-cohomology-vanishing / Čech-over-affine-cover result exists at the section level. Change-of-base to
`S` (where `ḡᵢ` span `⊤`) is genuinely forced — exactly as in the `D(f)` case, only the target ring changes
from `Localization.Away f` to `S = Γ(V)` (not a localization of `R`).

**D. Cheapest packaging — option (i): co-locate in `CechAcyclic.lean`, reuse the polymorphic private core.**
Mirror `dDiff_exact_of_localizationAway` verbatim (`Rf ⇝ S`, `Mf ⇝ M⊗_R S`, `g' ⇝ ḡ`), swapping only the
per-σ `inst_comp` (base-change composite instead of `isLocalizedModule_comp_away`). Reuse `dDiff_exact`
over `S` for the full-span input. Estimate **~230–320 LOC, ~8–12 bridge lemmas**; one genuinely new
Mathlib-gap-fill (the ~30–50 LOC per-σ base-change localization instance), the rest copy-paste.

## Informational

- **Decision 1/2/3 — PROCEED on route B1, co-located.** The seed reduces through the *already-shipped*
  `SectionCechTilde` bridge (`sectionCechAbExact` ladder) to `dDiff g M` exactness over `R` — a path that
  is cover-shape-agnostic. The whole novelty over the done `D(f)` case is the per-σ "this is a localization
  of `M` at `powers gσ`" instance, which moves from an away-composite to a base-change composite. Bridge
  decomposition (7 items) is in `analogies/genaffine-cech-seed.md` §Recommendation.
- **NEEDS_MATHLIB_GAP_FILL (upstream, not a project failure)**: the qcoh-module restriction-to-basicOpen
  localization (`Γ(U,F) → Γ(D(f),F)` is `IsLocalizedModule (powers f)` for qcoh `F`, `U` affine) is missing
  from Mathlib for general quasi-coherent sheaves. Route B1 sidesteps it entirely via algebra; only route B2
  would need it (rejected as expensive).
- **Risk note**: the per-σ base-change instance (bridge lemma 3) may hit `IsScalarTower`/semiring diamonds
  (memory `rR-semiring-diamond-change-workaround.md`). The `IsBaseChange.comp` formulation minimizes
  `∘ₗ`/`LinearMap.pi` rewriting; `IsLocalization.Away.tensorEquiv` is the concrete fallback iso.
  The `IsAffineOpen.isoSpec` basic-open correspondence in the `hspan_S` lemma is the other fiddly spot.

## Persistent file
- `analogies/genaffine-cech-seed.md` — full decomposition, verified citations, and the 5-step per-σ
  base-change construction, captured for the prover.

Overall verdict: **PROCEED on route B1** — change-of-ring to `S=Γ(V)` via algebraic base change `M⊗_R S`,
co-located in `CechAcyclic.lean` as a verbatim mirror of `dDiff_exact_of_localizationAway`, with the single
new ingredient (per-σ base-change localization) fully backed by `Mathlib.RingTheory.Localization.BaseChange`.

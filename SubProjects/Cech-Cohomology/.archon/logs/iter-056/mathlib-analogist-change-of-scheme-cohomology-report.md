# Mathlib Analogist Report

## Mode
api-alignment

## Slug
change-of-scheme-cohomology

## Iteration
056

## Question
Find Mathlib's idiom (names + imports) for transporting the right-derived / `Ext` cohomology
`Ext^q(jShriekOU V, H)` across the canonical affine-scheme ≅ `Spec(Γ)` iso, so the ⊤-case
`affine_serre_vanishing` over `Spec R` discharges the residual `IsZero ((preadditiveCoyoneda.obj
(op (jShriekOU (j ⁻¹ᵁ W)))).rightDerived q).obj H)` for `j⁻¹W` a *general affine open* of the affine
scheme `U`. Is that transport sound and cheaper than building a `BasisCovSystem U` over arbitrary
affine opens?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Discharge need #2 via `V ≅ Spec Γ(V)` (directive's route) | NEEDS_MATHLIB_GAP_FILL — **WALL** | critical |
| Discharge need #2 by enlarging cover-system basis `B` to all affine opens | PROCEED (recommended) | major |
| Need #1: abstract-affine `U` → `Spec Γ(U)` transport via `isoSpec` | PROCEED (sound) | informational |
| Q1 `isoSpec` name/signature | verified | informational |
| Q2 module-category equivalence from a scheme iso | NEEDS_ASSEMBLY (pieces exist) | informational |

## Critical finding (Q4 — the counter-check the planner must hear)

**The transport route as posed (make `V = j⁻¹W` the whole space via `V ≅ Spec Γ(V)`) is a WALL, not
a shortcut — it is the restriction-preserves-injectives gap the project already rejected in
iter-026.** It is *not* circular, but it costs the 200–500 LOC `j_!`/restriction-injectives
infrastructure (`analogies/restriction-preserves-injectives.md`), with the same risk that forced the
Form-B pivot.

Why: `jShriekOU_U V` and `H` live in `U.Modules`; the only iso available is `V ≅ Spec Γ(V)`, an iso
of the **open subscheme** `V`, **not** of `U`. Using it requires **restricting** `U.Modules →
V.Modules` (`H ↦ H|_V`); the derived comparison `Ext^q_{U.Modules}(j_!𝒪_V, H) ≅ H^q(V, H|_V)` *is*
restriction-preserves-injectives. `V ↪ U` is an open immersion, not an iso, so there is no
`U.Modules ≌ V.Modules` to transport `Ext` along.

The **whole-affine** transport `U ≅ Spec Γ(U)` IS a genuine iso/equivalence (sound), but it sends the
proper open `V ⊆ U` to a **general (non-distinguished) affine open** of `Spec Γ(U)`, not to `⊤` — so
`affine_serre_vanishing` (⊤ only) still does not apply. The general-affine-open vanishing is genuinely
unavoidable (no basis dodge: boundary-straddling affine opens `W ⊆ X` force `j⁻¹W` general affine).

**Sound, Form-B-native discharge:** stay ambient and obtain general-affine-open vanishing from
`cech_eq_cohomology_of_basis` by **enlarging the cover system basis `B` from `{D f}` to all affine
opens**. That proof never touches a restriction functor.

## Major

- **Enlarge `affineCoverSystem` basis to all affine opens (need #2).** `BasisCovSystem` is generic over
  `B`; `cech_eq_cohomology_of_basis s … V hV` already yields `Ext^q(jShriekOU V, H)=0` for any `V ∈ B`,
  inside `(Spec R).Modules`. Set `B := {affine opens}`, keep `Cov` = standard covers `i ↦ D(g i)`.
  Re-proof load: `faces_mem` already covered (faces are `D(∏g)`, distinguished ⊆ affine);
  `injective_acyclic` unchanged (cover-agnostic `injective_cech_acyclicFam`); **only**
  `surj_of_vanishing` must generalize from `V = D f` to a general affine open — generalize
  `affine_surj_of_vanishing` (`AffineSerreVanishing.lean:233`) and `standard_cover_cofinal` (`:167`) by
  replacing `PrimeSpectrum.isCompact_basicOpen f` with `IsAffineOpen.isCompact` **[verified]**.
  ~40–80 LOC, low risk, zero new Mathlib gaps.

- **Need #1 transport via `isoSpec` (the sound use of the tool).** Assemble `Φ : U.Modules ≌ (Spec Γ
  U).Modules` from `Scheme.Modules.pushforward U.isoSpec.hom/.inv` + `pushforwardComp` / `pushforwardId`
  / `pushforwardCongr` (all **[verified]**, `Modules/Sheaf.lean:190,210,224`); transport the step-1
  vanishing back to `U`, `V=j⁻¹W` via `CategoryTheory.Abelian.Ext.mapExactFunctor`
  (**[verified]**, `Ext/Map.lean:126`) plus `jShriekOU` / quasi-coherence naturality under the iso.
  ~60–120 LOC, low–medium risk; smaller & lower-risk than the 01I8 site-infra route that overran.

## Informational

- **Q1 [verified]** `AlgebraicGeometry.Scheme.isoSpec (X) [IsAffine X] : X ≅ Spec (X.presheaf.obj (op
  ⊤))` (`Mathlib.AlgebraicGeometry.AffineScheme`); `isoSpec_hom = toSpecΓ`, `toSpecΓ_isoSpec_inv`,
  `IsAffineOpen.fromSpec_top = isoSpec.inv`, `IsAffineOpen.isCompact` — all **[verified]**.
- **Q2 [verified pieces / gap on packaging]** No packaged `Modules`-equivalence from a scheme iso;
  built from `Scheme.Modules.pushforward` (`Modules/Sheaf.lean:151`) + the three coherence isos +
  `Additive` instance (`:182`). Genuine equivalence because the morphism is an iso.
- **Q3 [verified]** `Ext` transports via `Abelian.Ext.mapExactFunctor` / `Functor.mapExtAddHom`
  (`Ext/Map.lean:126,169`); cleaner than `rightDerivedNatIso` for need #1. The project's
  `rightDerivedNatIso` + `sectionsFunctorCorepIso` (`OpenImmersionPushforward.lean:156,174`) stay
  correct and reusable — they are not the wall.
- **Q4** answered in the critical finding: route is sound only as the whole-affine need #1; the
  posed `V`-as-whole-space variant is the restriction-injectives wall.

## Persistent file
- `analogies/change-of-scheme-cohomology.md` — full rationale, verified names, LOC/risk, the two-need
  split, and the WALL warning for future iters.

Overall verdict: **ALIGN-WITH-MATHLIB with a partial WALL** — the directive's `j⁻¹W ≅ Spec Γ(j⁻¹W)`
transport is a restriction-preserves-injectives WALL (do not spend prover budget on it); instead
discharge general-affine-open vanishing AMBIENT by enlarging the cover-system basis `B` to all affine
opens (~40–80 LOC), and reserve `isoSpec` for the sound whole-affine `U ≅ Spec Γ(U)` transport
(need #1, ~60–120 LOC via `pushforward` coherences + `Ext.mapExactFunctor`).

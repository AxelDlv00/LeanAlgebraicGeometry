# Blueprint Reviewer Report — iter189

**Date:** 2026-05-26  
**Slug:** iter189  
**Reviewer phase:** post-iter-188 prover, pre-iter-189 prover  
**Scope:** All `blueprint/src/chapters/*.tex` chapters (29 read in full or sufficient depth), plus 6 focus-area verifications per directive.

---

## Executive Summary

Three pin additions are MISSING from blueprint chapters for iter-188 prover landings (Focus 1A–1C). Two sub-phases require new chapters: A.3.ii–vi (Pic⁰ structure) and RR.2.H¹ (skyscraper H¹ vanishing). `Albanese_AlbaneseUP.tex` must be rewritten in place to replace the Sym^g route with the divisor-map Albanese UP per the iter-188 strategy decision. One stale prose block identified in `AbelianVarietyRigidity.tex`. All other focus areas verified consistent.

---

## Focus Area Verdicts

### Focus 1 — iter-188 New Pinned Declarations

#### 1A. `pullback_app_isoTensor_baseMap_sectionLinearEquiv` (Picard/QuotScheme.lean) — **MISSING PIN**

`Picard_QuotScheme.tex` has `def:quot_pullback_app_isoTensor` → `AlgebraicGeometry.pullback_app_isoTensor` (the base tensor isomorphism), present and `\leanok`. The iter-188 Σ-pair packaging declaration `pullback_app_isoTensor_baseMap_sectionLinearEquiv` does NOT have a dedicated `\lean{...}` pin in any blueprint environment. The chapter needs a new definition/lemma block for this Σ-pair variant.

**Action required (plan agent, iter-189):** Add a `\begin{definition}[def:pullback_app_isoTensor_sigma]` block in `Picard_QuotScheme.tex` after the existing `def:quot_pullback_app_isoTensor` block, with `\lean{AlgebraicGeometry.pullback_app_isoTensor_baseMap_sectionLinearEquiv}` and `\uses{def:quot_pullback_app_isoTensor}`.

#### 1B. `H0_skyscraperSheaf_finrank_eq_one` + `H1_skyscraperSheaf_finrank_eq_zero` (RiemannRoch/RRFormula.lean) — **MISSING PINS (both)**

`RiemannRoch_RRFormula.tex` has `lem:euler_char_skyscraperSheaf` as the parent lemma collecting both halves. Neither `H0_skyscraperSheaf_finrank_eq_one` (H⁰ half, axiom-clean closure iter-188) nor `H1_skyscraperSheaf_finrank_eq_zero` (H¹ half, new typed sorry committed iter-188) has its own `\lean{...}` pin. These are independently trackable Lean declarations and should have independent blueprint environments.

**Action required (plan agent, iter-189):** In `RiemannRoch_RRFormula.tex`, split `lem:euler_char_skyscraperSheaf` into three linked environments:
- `lem:H0_skyscraperSheaf_finrank_eq_one` → `\lean{AlgebraicGeometry.H0_skyscraperSheaf_finrank_eq_one}` (H⁰ half; mark `\mathlibok` if closed against Mathlib; otherwise `\leanok` once sorry-free)
- `lem:H1_skyscraperSheaf_finrank_eq_zero` → `\lean{AlgebraicGeometry.H1_skyscraperSheaf_finrank_eq_zero}` (H¹ half; typed sorry; gated on RR.2.H¹ flasque sub-phase)
- `lem:euler_char_skyscraperSheaf` as assembly wrapper `\uses{lem:H0_skyscraperSheaf_finrank_eq_one, lem:H1_skyscraperSheaf_finrank_eq_zero}`

#### 1C. `carrierSubmoduleSheaf` (RiemannRoch/OCofP.lean) — **MISSING PIN**

`RiemannRoch_OCofP.tex` has no `\lean{AlgebraicGeometry.carrierSubmoduleSheaf}` pin. The iter-188 structural carrier refactor (`carrierSubmodule ⊓ trivAtBot` wrapper) introduced this new named declaration, but no blueprint definition block was added. The closest existing block is the general `def:O_C_of_P_carrier` environment, which describes the un-refined carrier.

**Action required (plan agent, iter-189):** Add a `\begin{definition}[def:carrierSubmoduleSheaf]` block in `RiemannRoch_OCofP.tex` with `\lean{AlgebraicGeometry.carrierSubmoduleSheaf}` and `\uses{def:O_C_of_P_carrier}`. Annotate with a `% NOTE:` explaining the `⊓ trivAtBot` refinement over the raw carrier.

#### 1D. `identityComponent_locallyConnectedSpace` (Picard/IdentityComponent.lean) — **CONSISTENT (no action)**

This declaration is `private` in the Lean source. Blueprint pins are per-project-visible declarations only. No blueprint `\lean{...}` entry is expected or required. Status verified CONSISTENT with blueprint conventions.

---

### Focus 2 — iter-188 Plan-Phase Pin Additions (SF-1 and SF-2)

#### SF-1: `Picard_LineBundlePullback.tex` — `def:IsLocallyTrivial` + `lem:IsLocallyTrivial_pullback` — **VERIFIED**

Both environments are present in `Picard_LineBundlePullback.tex` with `\leanok` and correct `\uses{}` linkage. `def:IsLocallyTrivial` → `AlgebraicGeometry.IsLocallyTrivial` and `lem:IsLocallyTrivial_pullback` → `AlgebraicGeometry.IsLocallyTrivial.pullback` are axiom-clean iter-188. Chapter A.1.b declared DONE; verified consistent.

#### SF-2: `Picard_QuotScheme.tex` — `lem:pullback_tildeIso` + `lem:pushforward_isQuasicoherent` — **VERIFIED**

Both environments are present with `\leanok`. `lem:pullback_tildeIso` → `AlgebraicGeometry.pullback_tildeIso` and `lem:pushforward_isQuasicoherent` → `AlgebraicGeometry.pushforward_isQuasicoherent` are correctly pinned. No discrepancy between chapter and iter-188 prover landings.

---

### Focus 3 — III.c Substrate Falsification (`AbelianVarietyRigidity.tex`) — **INTERNALLY CONSISTENT**

The `% NOTE (iter-188 review)` in `AbelianVarietyRigidity.tex` correctly documents:
- `IsClosedImmersion.lift_iff_range_subset` is NOT present in Mathlib at commit b80f227
- Option B corrective path (project-side substrate) is committed
- The proof block for the III.c chart-bridge closure remains under a typed sorry, consistent with BLOCKED status

The chapter prose is internally consistent with the Option B corrective path. The III.c sub-phase (GmScaling scaffold, 3 named sorries) is correctly flagged as BLOCKED pending the project-side `lift_iff_range_subset` + `tensor-of-domains` substrate build. No corrective edit needed.

**Stale prose flag (minor):** Several proof blocks in `AbelianVarietyRigidity.tex` for `lem:rigidity_eqOn_dense_open` and related chain declarations contain wording such as "single genuinely-deep residual sorry." These declarations were closed axiom-clean in iter-162. The proof-block prose is now stale. 

**Action required (plan agent, iter-189):** Update the proof-block prose for `lem:rigidity_eqOn_dense_open` and its downstream chain in `AbelianVarietyRigidity.tex` to reflect axiom-clean closure; remove the "residual sorry" wording.

---

### Focus 4 — A.3.ii–vi Unstarted Phases: Chapter Outline Proposals

No file `Picard_Pic0AbelianVariety.tex` exists. All five sub-phases are unstarted. Proposed outline for a single new chapter file covering A.3.ii–vi:

#### Proposed new chapter: `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`

```
\chapter{Pic⁰_{C/k} as an Abelian Variety}
\label{chap:Pic0AbelianVariety}
```

##### A.3.ii — Pic⁰_{C/k} Definition

```latex
\begin{definition}[def:pic0_scheme]
  \label{def:pic0_scheme}
  \lean{AlgebraicGeometry.Scheme.Pic0}
  \uses{def:pic_scheme, def:identity_component}
  Let $C/k$ be a smooth projective geometrically connected curve. We define
  $\mathrm{Pic}^0_{C/k} := (\mathrm{Pic}_{C/k})^0$, the identity component
  of the Picard scheme.
\end{definition}
```

Dependency chain: `def:pic_scheme` (Picard_FGAPicRepresentability) → `GroupScheme.IdentityComponent` (Picard_IdentityComponent) → `def:pic0_scheme`.

Estimated scope: ~80–200 LOC (small assembly once both parents close).

##### A.3.iii — Tangent Space Iso H¹(O_C) ≅ T_0 Pic⁰

```latex
\begin{theorem}[thm:pic0_tangent_space_iso]
  \label{thm:pic0_tangent_space_iso}
  \lean{AlgebraicGeometry.Scheme.Pic0.tangentSpace_iso_H1}
  \uses{def:pic0_scheme, def:genus, thm:deformation_functor_h1}
  There is a canonical $k$-linear isomorphism
  $T_0 \mathrm{Pic}^0_{C/k} \cong H^1(C, \mathcal{O}_C)$.
\end{theorem}
```

Sub-declarations needed:
- `def:deformation_functor_h1` — deformation functor at identity controlled by H¹(O_C); references Kleiman §4, Nitsure §5
- `lem:cotangent_complex_at_identity` — cotangent complex at identity section; requires Illusie or direct construction

Mathlib gap: no cotangent complex / deformation theory in Mathlib at b80f227. This theorem requires project-side development of the formal deformation functor at the identity of a group scheme, and Schlessinger's criterion applied to H¹(O_C).

Estimated scope: ~200–400 LOC (gated on A.3.ii body).

##### A.3.iv — Pic⁰ Smooth of Relative Dimension g

```latex
\begin{theorem}[thm:pic0_smooth]
  \label{thm:pic0_smooth}
  \lean{AlgebraicGeometry.Scheme.Pic0.isSmooth}
  \uses{thm:pic0_tangent_space_iso, def:genus}
  $\mathrm{Pic}^0_{C/k}$ is smooth over $k$ of relative dimension $g = \mathrm{genus}(C)$.
\end{theorem}
```

Strategy: tangent space dimension from A.3.iii equals g by definition of genus; smoothness follows from the local criterion (fiber tangent space dimension equals relative dimension for a group scheme locally of finite type over a field).

Estimated scope: ~300–500 LOC (gated on A.3.iii).

##### A.3.v — Pic⁰ Properness

```latex
\begin{theorem}[thm:pic0_proper]
  \label{thm:pic0_proper}
  \lean{AlgebraicGeometry.Scheme.Pic0.isProper}
  \uses{def:pic0_scheme, thm:pic0_degree_map}
  $\mathrm{Pic}^0_{C/k}$ is proper over $k$.
\end{theorem}
```

Strategy: Use the valuative criterion. Key ingredient: any degree-0 line bundle on a curve over a DVR extends to a line bundle on the model (Raynaud's relative Picard). A lighter path: `Pic^d_{C/k}` are all torsors under `Pic^0_{C/k}`, and properness of `Pic_{C/k}` (which follows from representability + compactness of the moduli) restricts to each component.

Sub-declaration needed:
- `lem:pic_d_torsor_pic0` — `Pic^d` is a `Pic^0`-torsor

Estimated scope: ~250–400 LOC (gated on A.3.ii).

##### A.3.vi — Pic⁰ Geometrically Irreducible

```latex
\begin{theorem}[thm:pic0_geom_irreducible]
  \label{thm:pic0_geom_irreducible}
  \lean{AlgebraicGeometry.Scheme.Pic0.isGeomIrreducible}
  \uses{def:pic0_scheme, thm:pic0_smooth}
  $\mathrm{Pic}^0_{C/k}$ is geometrically irreducible.
\end{theorem}
```

Strategy: Reduce to $k = \bar{k}$ via base-change. Over $\bar k$, a connected smooth group scheme over an algebraically closed field is irreducible (since it is integral: reduced by smoothness, irreducible by connectedness of the identity component). Apply `AlgebraicGeometry.Scheme.isGeomIrreducible_of_isAlgClosed`.

Sub-declaration needed:
- `lem:connected_smooth_grpscheme_irreducible` — smooth connected group scheme over algebraically closed field is irreducible

Estimated scope: ~150–300 LOC (gated on A.3.ii + A.3.iv).

##### Assembly: Jacobian = Pic⁰ is an Abelian Variety

```latex
\begin{theorem}[thm:pic0_abelian_variety]
  \label{thm:pic0_abelian_variety}
  \lean{AlgebraicGeometry.Scheme.Pic0.isAbelianVariety}
  \uses{thm:pic0_smooth, thm:pic0_proper, thm:pic0_geom_irreducible, def:pic0_scheme}
  $\mathrm{Pic}^0_{C/k}$ is an abelian variety over $k$ of dimension $g$.
\end{theorem}
```

This is the conjunction of A.3.ii–vi; ~50 LOC assembly once all parents close.

**Total estimated new chapter:** ~1000–1900 LOC, ~30–52 iterations (gated heavily on A.3.iii deformation theory gap).

**Iter-189 writer dispatch recommendation:** Write the chapter skeleton for `Picard_Pic0AbelianVariety.tex` with the above environments (statements only, no proofs, all `\notready` until A.3.ii body closes), and add it to `web.paux` + `AlgebraicJacobian.lean` imports.

---

### Focus 5 — A.4.d Sym^g → Divisor-Map Pivot (`Albanese_AlbaneseUP.tex`) — **MUST-FIX: FULL REWRITE IN PLACE**

`Albanese_AlbaneseUP.tex` currently describes the Sym^g symmetric-power route throughout:
- `def:symmetric_power_curve` (the symmetric product $C^{(g)}$)
- `lem:symmetric_product_av_map` (map $C^{(g)} \to J$)
- `lem:symmetric_product_to_jacobian` (birational structure)
- `lem:descent_through_birational_sigma` (descent through $S_g$-quotient)

Per the iter-188 strategy decision, this entire route is abandoned in favor of the divisor-map Albanese UP (universal effective divisor → Pic^d morphism + degree-g translate). The Sym^g route requires an $S_g$-quotient scheme gap (~800–1500 LOC unowned Mathlib gap) that is not on the committed path.

**Recommendation: full rewrite in place (not a new sibling chapter).** Rationale: the Albanese UP theorem (`thm:albanese_universal_property` → `AlgebraicGeometry.Scheme.Pic.albaneseUP`) has a fixed name in the Lean tree and in `Jacobian.tex`'s `\uses{}` chain. Adding a sibling chapter would require re-threading `\uses{}` links and risks creating a dangling orphan of the Sym^g chapter. Rewriting in place preserves all cross-references.

**New chapter structure for divisor-map route:**

```latex
\section{Divisor-Map Albanese Universal Property}

\begin{definition}[def:universal_effective_divisor]
  \lean{AlgebraicGeometry.universalEffectiveDivisor}
  The universal effective divisor of degree $g$ on $C \times \mathrm{Pic}^g_{C/k}$.
\end{definition}

\begin{lemma}[lem:degree_g_translate_pic0]
  \lean{AlgebraicGeometry.degreeGTranslatePic0}
  \uses{def:universal_effective_divisor, def:pic0_scheme}
  The degree-$g$ translate $\mathrm{Pic}^g_{C/k} \xrightarrow{\sim} \mathrm{Pic}^0_{C/k}$
  (choose a rational point $p_0 \in C(k)$ and translate by $\mathcal{O}(gp_0)^{-1}$).
\end{lemma}

\begin{theorem}[thm:albanese_universal_property]
  \lean{AlgebraicGeometry.Scheme.Pic.albaneseUP}
  \uses{lem:degree_g_translate_pic0, def:universal_effective_divisor, thm:pic_is_group_scheme}
  For any abelian variety $A/k$ and morphism $f: C \to A$ sending a rational point
  to $0_A$, there exists a unique morphism of group schemes
  $\bar f: \mathrm{Pic}^0_{C/k} \to A$ such that $\bar f \circ \phi_g = f$,
  where $\phi_g: C \to \mathrm{Pic}^0_{C/k}$ is the Abel–Jacobi map at degree $g$.
\end{theorem}
```

**Note on rational-point assumption:** The divisor-map route requires a rational point $p_0 \in C(k)$ to define the degree-g translate. The current chapter must document this hypothesis explicitly and verify it is consistent with the `AlgebraicGeometry.IsAlbanese` signature (which already carries the pointed-curve hypothesis per the spine decision).

**Action required (plan agent, iter-189):** Commission a full rewrite of `Albanese_AlbaneseUP.tex` replacing Sym^g environments with divisor-map environments as outlined above. The rewrite is informational prose + environment structure only (no Lean proofs). Cross-reference `Albanese_Thm32RationalMapExtension.tex` to verify it does not anchor on Sym^g environments (it references Thm 3.2 output, not Sym^g internals; no cascade needed).

---

### Focus 6 — RR.2.H¹ Unstarted Phase — **NO DEDICATED CHAPTER; PROPOSAL BELOW**

The committed RR.2.H¹ sub-phase has:
- `H1_skyscraperSheaf_finrank_eq_zero` as a typed sorry in `RiemannRoch/RRFormula.lean` (landed iter-188)
- No dedicated blueprint chapter

**Proposed new chapter:** `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`

```latex
\chapter{H¹ Vanishing for Skyscraper Sheaves}
\label{chap:RR_H1Vanishing}

\begin{theorem}[thm:flasque_h1_vanishing]
  \lean{AlgebraicGeometry.flasque_h1_vanishing}
  Let $X$ be a Noetherian topological space. For any flasque sheaf $\mathcal{F}$
  of abelian groups on $X$, $H^1(X, \mathcal{F}) = 0$.
\end{theorem}

\begin{lemma}[lem:skyscraper_is_flasque]
  \lean{AlgebraicGeometry.skyscraper_isFlasque}
  \uses{thm:flasque_h1_vanishing}
  The skyscraper sheaf $i_{p,*} M$ at a closed point $p$ is flasque.
\end{lemma}

\begin{theorem}[thm:H1_skyscraperSheaf_finrank_eq_zero]
  \lean{AlgebraicGeometry.H1_skyscraperSheaf_finrank_eq_zero}
  \uses{lem:skyscraper_is_flasque}
  For a skyscraper sheaf $i_{p,*} k$ at a closed point $p$ of a smooth
  projective curve $C/k$, $\mathrm{finrank}_k H^1(C, i_{p,*}k) = 0$.
\end{theorem}
```

**Mathlib gap assessment:** Mathlib at b80f227 has flasque sheaves (`Sheaf.IsFlasque`) but does NOT have H¹ vanishing for flasque sheaves at the `Ext/ModuleCat` level used by the project's cohomology infrastructure. This is the Mathlib gap identified in iter-188. Project-side build required: ~200–400 LOC, ~8–12 iterations.

**Action required (plan agent, iter-189):** Create `RiemannRoch_H1Vanishing.tex` with the above skeleton. Link `lem:H1_skyscraperSheaf_finrank_eq_zero` in `RiemannRoch_RRFormula.tex` via `\uses{thm:H1_skyscraperSheaf_finrank_eq_zero}`.

---

## Per-Chapter Checklist

| Chapter | Declarations with `\leanok` | Issues Found |
|---|---|---|
| `AbelJacobi.tex` | `def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp` (3/3) | None |
| `AbelianVarietyRigidity.tex` | Chain closed axiom-clean iter-162 except III.c GmScaling (3 named sorries, BLOCKED) | Stale "residual sorry" prose in proof blocks for `lem:rigidity_eqOn_dense_open` chain; update needed |
| `Albanese_AlbaneseUP.tex` | None (all gated) | **MUST-FIX**: full rewrite to divisor-map route; Sym^g route abandoned |
| `Albanese_AuslanderBuchsbaum.tex` | G1 closed iter-188; G2 joint induction next | `exists_isRegular_of_regularLocal` helper lacks blueprint pin (minor) |
| `Albanese_CoheightBridge.tex` | 4/4 `\leanok` | None |
| `Albanese_CodimOneExtension.tex` | Most declarations `\leanok`; `isRegularLocalRing_stalk_of_smooth` permanent sorry (accepted) | `thm:weil_divisor_obstruction` has detached `\lean{...}` pin (iter-179 NOTE, previously flagged) |
| `Albanese_Thm32RationalMapExtension.tex` | Assembly; `\leanok` on wrapper | Cross-references Thm 3.2 output; consistent with current state |
| `Cohomology_MayerVietoris.tex` | All Mayer-Vietoris infrastructure `\leanok` | Genus conditionality on `HasCechToHModuleIso` + `HasAffineCechAcyclicCover` (known; documented in chapter) |
| `Cohomology_SheafCompose.tex` | `thm:HasSheafCompose_forget` `\leanok` | None |
| `Cohomology_StructureSheafAb.tex` | 3/3 `\leanok` | None |
| `Cohomology_StructureSheafModuleK.tex` | ~60 declarations `\leanok`; `HasCechToHModuleIso` + `HasAffineCechAcyclicCover` unproduced | Carrier classes unproduced: genus conditionality documented |
| `Differentials.tex` | 5/5 `\leanok` | None |
| `Genus.tex` | `def:genus` `\leanok` | None |
| `Jacobian.tex` | `def:genusZeroWitness` + `def:positiveGenusWitness` `\leanok`; `thm:albanese_universal_property` no `\leanok` | `thm:albanese_universal_property` gated on rewritten AlbaneseUP + Thm 3.2 |
| `Picard_FGAPicRepresentability.tex` | 5/5 `\leanok` | Notes `Picard_Pic0AbelianVariety.tex` as planned/unwritten — consistent with Focus 4 |
| `Picard_IdentityComponent.tex` | Most declarations `\leanok`; body gated | None (private `identityComponent_locallyConnectedSpace` correctly unpinned) |
| `Picard_LineBundlePullback.tex` | SF-1 verified; A.1.b DONE axiom-clean | None |
| `Picard_QuotScheme.tex` | SF-2 verified; `pullback_app_isoTensor` `\leanok` | **MISSING PIN 1A**: `pullback_app_isoTensor_baseMap_sectionLinearEquiv` |
| `Picard_RelPicFunctor.tex` | 5/5 core `\leanok`; `thm:rel_pic_etale_sheaf_group_structure` not closed | `PicSharp.etSheaf` name (iter-176 correction) reflected in chapter |
| `Picard_RelativeSpec.tex` | All `\leanok`; iter-185 closed both iter-179 gaps kernel-clean | None |
| `RiemannRoch_OCofP.lean` | Carrier refactor struct `\leanok`; body gated | **MISSING PIN 1C**: `carrierSubmoduleSheaf` |
| `RiemannRoch_OcOfD.tex` | 4/4 `\leanok` (bodies gated; Lane J BLOCKED) | Lane J BLOCKED — do not flag for prover work |
| `RiemannRoch_RRFormula.tex` | Parent `lem:euler_char_skyscraperSheaf` `\leanok` | **MISSING PINS 1B**: `H0_skyscraperSheaf_finrank_eq_one` + `H1_skyscraperSheaf_finrank_eq_zero` |
| `RiemannRoch_RationalCurveIso.tex` | `localParameterAtInfty` closed iter-188; `Hom.poleDivisor_degree_eq_finrank` body iter-189 target | None blocking |
| `RiemannRoch_WeilDivisor.tex` | 9+ declarations `\leanok`; project-bespoke (no Mathlib WeilDivisor) | None |
| `Rigidity.tex` | `thm:GrpObj_eq_of_eqOnOpen` axiom-clean | None |
| `RigidityKbar.tex` | Fallback route (a) documented; `\notready` on EXCISED declarations correctly set | `lem:GrpObj_mulRight_globalises` + `lem:GrpObj_omega_basechange_proj` remain `\notready` (correctly excised iter-145); `lem:GrpObj_cotangent_bridge` `\notready` (Replacement B) — all consistent |

---

## Cross-Cutting Findings

### 1. Genus Conditionality (carrier classes unproduced)

`HasCechToHModuleIso` and `HasAffineCechAcyclicCover` remain "currently unproduced" as of iter-188. The genus definition in `Genus.tex` (`def:genus`) is `\leanok` but its usage in all downstream results (tangent space iso, smoothness of Pic⁰, RR formula) remains conditional on these two carrier classes. This is a known structural gap documented across `Cohomology_MayerVietoris.tex` and `Cohomology_StructureSheafModuleK.tex`. Not a new finding; documenting for completeness.

### 2. A.4 LOC Undercount in STRATEGY.md

The STRATEGY.md table estimates for A.4.a (Lemma 3.3 + Weil-divisor surface API) at ~1500–2500 LOC and ~40–80 iters is the dominant Route-A risk. The iter-172 audit confirmed that the A.4 bypass via autoduality FAILS; Thm 3.2 + Lemma 3.3 + Auslander–Buchsbaum sub-build is mandatory (~2500+ LOC / ~22–35 iters). The STRATEGY.md estimates are in range but the A.4.d rewrite (divisor-map Albanese UP) is NOT yet reflected in any LOC estimate — this adds ~400–800 LOC to A.4.d beyond the current estimate.

### 3. `Picard_Pic0AbelianVariety.tex` Absent from `web.paux`

No chapter file exists for A.3.ii–vi. The `web.paux` auxiliary and `AlgebraicJacobian.lean` import list will need updating when the new chapter is created (iter-189 writer dispatch).

### 4. RR.3 Subfunctor Restructure (OCofP)

The `carrierSubmoduleSheaf` pin gap (Focus 1C) is part of the RR.3 carrier refactor planned for iter-189 (Subfunctor restructure). The plan agent should coordinate the pin addition with the ongoing RR.3 work to avoid declaring the wrong Lean target name if it shifts during the refactor.

---

## Recommended iter-189 Writer Dispatches (priority order)

1. **HIGH — MUST-FIX:** Rewrite `Albanese_AlbaneseUP.tex` for divisor-map route (replace Sym^g environments).
2. **HIGH:** Add missing pin `def:pullback_app_isoTensor_sigma` in `Picard_QuotScheme.tex` (Focus 1A).
3. **HIGH:** Split `lem:euler_char_skyscraperSheaf` into `lem:H0_skyscraperSheaf_finrank_eq_one` + `lem:H1_skyscraperSheaf_finrank_eq_zero` in `RiemannRoch_RRFormula.tex` (Focus 1B).
4. **HIGH:** Add `def:carrierSubmoduleSheaf` in `RiemannRoch_OCofP.tex` (Focus 1C) — coordinate with RR.3 Subfunctor restructure.
5. **MEDIUM:** Create new chapter skeleton `Picard_Pic0AbelianVariety.tex` (A.3.ii–vi; all `\notready` until A.3.ii body closes).
6. **MEDIUM:** Create new chapter skeleton `RiemannRoch_H1Vanishing.tex` (RR.2.H¹; typed sorry placeholder).
7. **LOW:** Fix stale "residual sorry" prose in `AbelianVarietyRigidity.tex` proof blocks for `lem:rigidity_eqOn_dense_open` chain.
8. **LOW:** Add `exists_isRegular_of_regularLocal` helper pin in `Albanese_AuslanderBuchsbaum.tex`.

---

*End of iter189 blueprint-reviewer report.*

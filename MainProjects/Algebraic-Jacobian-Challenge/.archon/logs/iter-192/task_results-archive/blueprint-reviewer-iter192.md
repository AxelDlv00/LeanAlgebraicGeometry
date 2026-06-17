# Blueprint Review — Iter-192

**Reviewer:** blueprint-reviewer subagent  
**Date:** 2026-05-26  
**Chapters read:** all 31  
**Sorry count at start of iter:** 80  
**Build streak entering iter:** 11 consecutive zero-axiom builds

---

## Must-Fix This Iter (surface first)

These findings block or degrade the named prover lanes in the iter-192 dispatch plan:

| Tag | Severity | Lane | Finding | Action |
|-----|----------|------|---------|--------|
| **MF-1** | **FAIL** | Item 7 (`AbelianVarietyRigidity.lean`, Lane E Part 2) | `AbelianVarietyRigidity.tex` III.c documents the `Proj.appIso`-bypass route (separated-locus via `IsClosedImmersion.lift_iff_range_subset`) but the critical **`Proj.appIso` evaluation step `isLocElem ↦ [X_0/X_1] ↦ 1`** is nowhere described in the chapter prose. The chain is described as `pullbackSpecIso → Spec.map → chart-ring iso → Proj.awayι` but the intermediate `Proj.appIso` step is missing. Without it a prover cannot construct the explicit ring-map element needed to close the `gmScalingP1_chart` body. | Writer expansion needed on `AbelianVarietyRigidity.tex` III.c before Lane E Part 2 dispatch. Propose 2–3 sentence inline expansion around `Proj.appIso`. |
| **MF-2** | **PARTIAL** | Item 3 (`Albanese/CodimOneExtension.lean`) | `Albanese_CodimOneExtension.tex` documents Stacks 00TT Stages 1-2 (codim-1 indeterminacy removal, codimension-≥2 extension via Cohen-Macaulay). Stages 3-4 of the Stacks 00TT chain — **polynomial generators ↦ regular sequence ↦ regular local ring** — have NO blueprint declarations. The underlying Lean file carries typed-sorries for these sub-steps but the chapter provides no informal detail. | Writer dispatch to expand Stages 3-4 in the chapter. Without this, the prover has no informal guidance for the polynomial-generators → regular-sequence → regular-local-ring chain. |
| **MF-3** | **PARTIAL** | Item 6 (`Albanese/AuslanderBuchsbaum.lean`) | `Albanese_AuslanderBuchsbaum.tex` documents the regular→CM proof via the regular-domain route (route i) and the free-module route (route ii). **Route (iii) via Krull intersection** for closing `notMem_minimalPrimes_of_regularLocal_succ` is NOT covered anywhere in the chapter. | Writer dispatch to add a "Route (iii)" block covering the Krull intersection theorem approach: if every element of the maximal ideal lies in some minimal prime, then their intersection is the zero ideal by Krull, contradicting regularity. |
| **MF-4** | **PARTIAL** | Item 5 (`Picard/IdentityComponent.lean`) | `Picard_IdentityComponent.tex` references "EGA IV₂ 4.5.14" for geometric connectedness but has **no standalone `\lean{AlgebraicGeometry.geometricallyConnected_of_connected_of_section}` block** pinning the Stacks 04KU helper. The declaration exists in the Lean file but is not blueprinted; a prover dispatched to close remaining sorries in this file cannot locate it via `\lean{...}` reference. | Add a `\begin{lemma}\leanok ... \lean{AlgebraicGeometry.geometricallyConnected_of_connected_of_section}` block pinning the 04KU statement, or instruct prover to treat as already-closed auxiliary. |

**Informational (non-blocking):**

| Tag | Finding | Action |
|-----|---------|--------|
| **INFO-1** | `Picard_QuotScheme.tex` documents the Lane F aliasing-let recipe in prose but has no `% NOTE:` annotation making it easily findable | Add `% NOTE (iter-192): Lane F aliasing-let recipe documented above; update if Lean let-binding API changes.` |
| **INFO-2** | `RiemannRoch_RationalCurveIso.tex`: Pin 3 Step 2 sub-tasks (a)/(c)/(d) are documented inline in the Lean file body but NOT enumerated in the blueprint chapter. A prover reading only the blueprint is unaware of sub-task (a) (scheme-level `Scheme.Hom.toNormalization` existence), (c) (normalization-map surjectivity), (d) (iso-from-bijective-normalization). | Low-priority: add a "Step 2 sub-obligations" paragraph in `lem:degree_one_morphism_iso` proof sketch. Does not block the current sorry close (the inline documentation is sufficient for a prover reading the Lean file directly). |

---

## Lane-by-Lane HARD GATE Verdicts

### Item 1 — `H1Vanishing.lean` / `RiemannRoch_H1Vanishing.tex`

**Verdict: CONDITIONALLY CLEARS**

All 7 declarations have `\leanok` markers. The 3 remaining sorry decls are:

- `IsFlasque.constant_of_irreducible` — adequately described: "A flasque sheaf on an irreducible space has only globally constant sections; the proof uses the restriction-surjectivity property of a flasque sheaf together with irreducibility of the underlying space."
- `HModule_flasque_eq_zero` — adequately described: "Sheaf cohomology in positive degree vanishes for flasque sheaves; the standard argument produces a resolution by flasque sheaves and computes higher Ext against the terminal object."
- `skyscraperSheaf_eq_pushforward_const` — adequately described: "The skyscraper sheaf at a closed point is canonically isomorphic to the direct image of the constant sheaf along the closed immersion."

Condition: The prover must read both the chapter and the Lean file for the exact Mathlib typeclass spellings. The informal descriptions are sufficient for a body-close attempt.

### Item 2 — `WeilDivisor.lean` / `RiemannRoch_WeilDivisor.tex`

**Verdict: CLEARS**

`degree_positivePart_principal_eq_finrank` (Hartshorne II.6.9) has a fully detailed proof sketch: ramification-inertia via `Ideal.sum_ramification_inertia`, Dedekind extension, explicit `SOURCE QUOTE PROOF` from Hartshorne. All supporting declarations (prime-divisor type, `ord_Q`, principal-divisor map, degree map) are pinned with `\lean{...}` and `\leanok`. Prover lane clears.

### Item 3 — `CodimOneExtension.lean` / `Albanese_CodimOneExtension.tex`

**Verdict: PARTIAL — writer dispatch recommended before dispatch**

Stages 1-2 of the Stacks 00TT chain are well-described. Stages 3-4 (polynomial generators → regular sequence → regular local ring) have no blueprint declarations. The underlying Lean file carries typed-sorries for these sub-steps but the chapter provides no informal guidance. Dispatching a prover to this file without writer expansion risks a stalled session.

**Recommended action:** Writer dispatch to expand the chapter with 2-3 new `\begin{lemma}` blocks covering (i) existence of a regular system of parameters (polynomial generators = regular sequence in a regular local ring) and (ii) that having a regular sequence of length = Krull dim implies the local ring is regular.

### Item 4 — `QuotScheme.lean` / `Picard_QuotScheme.tex`

**Verdict: CLEARS (with INFO-1 note)**

The chapter is complete. The Lane F aliasing-let recipe is documented in the proof prose of the relevant lemma. All declarations have `\leanok` or `\mathlibok`. Prover lane clears.

### Item 5 — `IdentityComponent.lean` / `Picard_IdentityComponent.tex`

**Verdict: PARTIAL — writer dispatch or prover directive needed**

All 10 main declarations carry `\leanok`. The geometric-connectedness step cites "EGA IV₂ 4.5.14" in the proof body but does not provide a `\lean{AlgebraicGeometry.geometricallyConnected_of_connected_of_section}` block. If a prover needs to close a sorry that invokes this helper, they have no `\lean{...}` reference to locate it.

**Options:** (a) Add a `\leanok` helper block pinning the declaration name; (b) instruct the prover explicitly in their directive that this helper is already closed and to use it directly. Either suffices for iter-192.

### Item 6 — `AuslanderBuchsbaum.lean` / `Albanese_AuslanderBuchsbaum.tex`

**Verdict: PARTIAL — writer dispatch recommended**

Routes (i) and (ii) for `notMem_minimalPrimes_of_regularLocal_succ` are covered. Route (iii) (Krull intersection approach: every element of the maximal ideal lies in some associated prime, Krull intersection gives `⋂ 𝔪ⁿ = 0`, yielding a contradiction with `dim = 1`) is not described anywhere. If the prover attempts route (iii), they have no blueprint support.

**Recommended action:** Writer dispatch with a 2-sentence expansion: "Route (iii): in a regular local ring of dimension 1, the maximal ideal 𝔪 has height 1. By the Krull intersection theorem, if every nonzero element of 𝔪 were a zero-divisor it would lie in every associated prime, giving ⋂ 𝔪ⁿ ⊃ 𝔪 ≠ 0, contradiction. Therefore there exists a non-zero-divisor in 𝔪."

### Item 7 — `AbelianVarietyRigidity.lean` (Lane E Part 2) / `AbelianVarietyRigidity.tex` III.c

**Verdict: FAIL — writer expansion needed before Lane E Part 2 dispatch**

The III.c separated-locus route for `gmScalingP1_chart` is described with the `IsClosedImmersion.lift_iff_range_subset` approach and the range-containment argument. However the intermediate **`Proj.appIso` evaluation step** — specifically the identification `isLocElem ↦ [X_0/X_1] ↦ 1` — is absent. The chapter's chain description jumps from `pullbackSpecIso` to `Spec.map` to chart-ring-iso to `Proj.awayι` without documenting that the lift passes through a `Proj.appIso` whose evaluation on `isLocElem` produces the element `[X_0/X_1]` (ratio of homogeneous coordinates) and then collapses to `1` in the affine chart ring. Without this step, a prover cannot construct the explicit ring-map element.

**Recommended writer expansion (2–3 sentences to add to III.c):**
> The ring-map element threading `pullbackSpecIso → Proj.appIso → chart-ring iso` is the image of `isLocElem X_0 X_1` under `Proj.appIso`; this sends `isLocElem` to the ratio `[X_0/X_1]` in `HomogeneousLocalization.Away` and the chart-ring iso then identifies this with `1` in the localization. The prover should use `Proj.appIso_apply_isLocElem` (or the equivalent `lean_local_search` result) to establish the evaluation, then close the range-containment goal by `Set.mem_range.mpr ⟨1, rfl⟩`.

### Item 8 — `GmScaling.lean` / `AbelianVarietyRigidity.tex` III.c + `Genus0BaseObjects_Cross01Substrate.tex`

**Verdict: PASS**

`gmScalingP1_chart_agreement_cross01` requires:
1. **Topological range containment** (closed-point + density argument): covered by `Genus0BaseObjects_Cross01Substrate.tex` via `thm:IsClosedImmersion_lift_iff_range_subset` (Galois connection: range ⊆ ker → radical → Galois chain → `IsClosedImmersion.lift`) plus `thm:gmRing_tensor_homogeneousAway_isDomain` (domain property). Both have `\leanok` markers.
2. **Cross-(0,1) sub-case setup**: `Genus0BaseObjects_Cross01Substrate.tex` explicitly states "The Lane B cocycle `gmScalingP1_chart_agreement_cross01` reduces to..." and provides the relevant infrastructure.

Combined with III.c's separated-locus alternative in `AbelianVarietyRigidity.tex`, the topological range containment is adequately covered. **Note:** the `set S := ...` Mathlib regression in `Cross01Substrate.lean` is a Lean compilation issue, NOT a blueprint coverage problem — it does not affect the HARD GATE determination.

### Item 9 — `Cross01Substrate.lean` / `Genus0BaseObjects_Cross01Substrate.tex`

**Verdict: PASS (blueprint); COMPILE ISSUE (Lean file)**

Blueprint chapter `Genus0BaseObjects_Cross01Substrate.tex` is complete and correct. The `set S := ...` Mathlib regression is a Lean-file problem (the `set` tactic behavior changed in a Mathlib bump, likely around `b80f227`). The fix is to replace `set S := ...` with `let S := ...; have hS : S = ... := rfl` or to use `obtain ⟨S, hS⟩ := ...` pattern. The blueprint requires no changes; the Lean file needs a targeted refactor. This is a prover-task, not a writer-task.

### Item 10 — `RationalCurveIso.lean` / `RiemannRoch_RationalCurveIso.tex`

**Verdict: PARTIAL (blueprint gap, non-blocking for existing sorry)**

Pin 3 Step 2 (`lem:degree_one_morphism_iso`) has 4 sub-obligations (a)–(d) documented inline in the Lean body:
- (a): `Scheme.Hom.toNormalization` existence for the degree-1 map
- (b): normalization-map injectivity (already closed per inline note)
- (c): normalization-map surjectivity (sorry)  
- (d): iso-from-bijective-normalization conclusion (sorry)

Sub-tasks (a), (c), (d) are **not enumerated in the blueprint prose**; only the high-level "scheme-level lift via normalization" strategy is described. A prover dispatched purely on the blueprint chapter would not know the sub-obligation structure.

**Impact assessment:** Sub-task (b) is closed. Sub-tasks (a), (c), (d) are solvable from the Lean file's inline documentation alone. This is INFO-2 level: non-blocking for iter-192.

### Item 11 — `RRFormula.lean` / `RiemannRoch_RRFormula.tex`

**Verdict: CLEARS**

`H1_skyscraperSheaf_finrank_eq_zero` is correctly documented as gated on the H1Vanishing chain: "follows from `HModule_flasque_eq_zero` applied to `skyscraperSheaf_eq_pushforward_const`, then `IsFlasque.constant_of_irreducible`." All upstream declarations carry `\leanok` markers. No blocker; prover lane clears once H1Vanishing sorry decls close.

---

## Per-Chapter Checklist (all 31 chapters)

| # | Chapter | Status | Notes |
|---|---------|--------|-------|
| 1 | `AbelJacobi.tex` | PASS | All 3 declarations LEANOK. Purely Albanese-projection; no prover lane needed. |
| 2 | `AbelianVarietyRigidity.tex` | PARTIAL (MF-1) | Items 8 PASS, Item 7 FAIL. Proj.appIso step missing. Writer expansion needed. |
| 3 | `AlgebraicJacobian_Cotangent_GrpObj.tex` | PASS | Zero sorry-bodied declarations. All closed iter-128–134. |
| 4 | `Albanese_AlbaneseUP.tex` | PASS | Symmetric-power route fully reflected (iter-175 pivot in place). A.4.d PASS. |
| 5 | `Albanese_AuslanderBuchsbaum.tex` | PARTIAL (MF-3) | Routes (i)/(ii) covered; route (iii) Krull intersection missing. |
| 6 | `Albanese_CoheightBridge.tex` | PASS | LEANOK markers on all 4 bridge lemmas. Correctly assembled from Mathlib. |
| 7 | `Albanese_CodimOneExtension.tex` | PARTIAL (MF-2) | Stages 1-2 of Stacks 00TT covered; Stages 3-4 polynomial-generators chain missing. |
| 8 | `Albanese_Thm32RationalMapExtension.tex` | PASS | `thm:rational_map_to_av_extends` LEANOK. A.4.c complete. |
| 9 | `Cohomology_MayerVietoris.tex` | PASS | Multiple LEANOK declarations. Mayer-Vietoris and Čech-acyclicity machinery complete. |
| 10 | `Cohomology_SheafCompose.tex` | PASS | `thm:HasSheafCompose_forget` LEANOK. One-lemma chapter; complete. |
| 11 | `Cohomology_StructureSheafAb.tex` | PASS | All LEANOK. Phase A steps 2-4 complete. |
| 12 | `Cohomology_StructureSheafModuleK.tex` | PASS | All LEANOK. Phase A step 5 complete. |
| 13 | `Differentials.tex` | PASS | `def:relative_kaehler_presheaf`, `lem:relative_kaehler_presheaf_obj`, `thm:smooth_locally_free_omega` all LEANOK. |
| 14 | `Genus.tex` | PASS | `def:genus` LEANOK. Single-declaration chapter; complete. |
| 15 | `Genus0BaseObjects_Cross01Substrate.tex` | PASS | `thm:IsClosedImmersion_lift_iff_range_subset` and `thm:gmRing_tensor_homogeneousAway_isDomain` LEANOK. Blueprint fine. |
| 16 | `Jacobian.tex` | PASS | All major declarations LEANOK (IsAlbanese, def:Jacobian, Jacobian_grpObj, Jacobian_smooth_genus, IsAlbanese_unique). |
| 17 | `Picard_FGAPicRepresentability.tex` | PASS | `lem:line_bundle_quot_correspondence` LEANOK. Assembly chapter; declarations correctly blueprinted. |
| 18 | `Picard_FlatteningStratification.tex` | PASS | `def:coherent_sheaf_flat` LEANOK. A.2.a chapter complete per spec. |
| 19 | `Picard_IdentityComponent.tex` | PARTIAL (MF-4) | All 10 main decls LEANOK; `geometricallyConnected_of_connected_of_section` (04KU helper) has no `\lean{...}` pin. |
| 20 | `Picard_LineBundlePullback.tex` | PASS | `def:line_bundle_on_product` LEANOK. Complete. |
| 21 | `Picard_QuotScheme.tex` | PASS (INFO-1) | Complete. Lane F aliasing-let documented. Minor `% NOTE:` addition recommended. |
| 22 | `Picard_RelPicFunctor.tex` | PASS | `lem:rel_pic_sharp_groupoid` LEANOK. A.1.c chapter complete. |
| 23 | `Picard_RelativeSpec.tex` | PASS | `def:qc_sheaf_of_algebras` LEANOK (Stacks 01LL). Complete. |
| 24 | `RiemannRoch_H1Vanishing.tex` | CONDITIONALLY CLEARS (Item 1) | 7 declarations; 3 remaining sorries adequately described. |
| 25 | `RiemannRoch_OCofP.tex` | PASS | All LEANOK including `thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero`, `cor:nonconstant_function_genus_zero`. |
| 26 | `RiemannRoch_OcOfD.tex` | PASS | `def:sheafOf` LEANOK. Subsheaf-of-K_C description complete; RR.2/RR.3/RR.4 gate-clearance documented. |
| 27 | `RiemannRoch_RRFormula.tex` | CLEARS (Item 11) | `H1_skyscraperSheaf_finrank_eq_zero` correctly H1Vanishing-gated. |
| 28 | `RiemannRoch_RationalCurveIso.tex` | PARTIAL (INFO-2) | Items (a)/(c)/(d) of Step 2 not in blueprint prose. Non-blocking. |
| 29 | `RiemannRoch_WeilDivisor.tex` | CLEARS (Item 2) | `degree_positivePart_principal_eq_finrank` fully detailed. |
| 30 | `Rigidity.tex` | PASS | `thm:GrpObj_eq_of_eqOnOpen` LEANOK. Complete. |
| 31 | `RigidityKbar.tex` | PASS (named gap) | `thm:rigidity_over_kbar` LEANOK (sorry body, named gap, off critical path). |

---

## Unstarted-Phase Blueprint Proposals

### A.3.iii–vi: `Pic0AbelianVariety.tex` (HIGH PRIORITY — deferred multiple iters)

**Proposed new chapter:** `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`  
**Covers:** `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` (to be created)  
**Strategic role:** A.3.iii–vi of Route A — establishes `Pic⁰_{C/k}` as an abelian variety (the positive-genus Albanese object).

#### Proposed chapter structure

```latex
\chapter{The identity component \(\Pic^0_{C/k}\) as an abelian variety}
\label{chap:Picard_Pic0AbelianVariety}
% archon:covers AlgebraicJacobian/Picard/Pic0AbelianVariety.lean

\section{Tangent space isomorphism}
% A.3.iii: H^1(O_C) ≅ T_0 Pic^0

\begin{theorem}
[Tangent space at the identity: T_0 Pic⁰ ≅ H¹(O_C)]
\label{thm:pic0_tangent_space_iso}
\lean{AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso}

% SOURCE: Kleiman, §5 cor:sm; Mumford Abelian Varieties Ch. II §6 Thm.1;
% Hartshorne, III.12 (Picard variety tangent space via H^1)
Let C/k be a smooth proper geometrically integral curve. The tangent space
of \(\Pic^0_{C/k}\) at the identity element is canonically isomorphic
to \(H^1(C, \mathcal O_C)\) as a k-vector space.

\emph{Proof sketch.} The tangent space of a k-group scheme G at the identity
is the kernel of G(k[ε]/ε²) → G(k), which for G = Pic⁰_{C/k} equals the
relative Picard group Pic(C × Spec k[ε]/ε²) modulo the pullback from
Spec k[ε]/ε². By standard deformation theory (Hartshorne III.12, Kleiman §5),
this kernel identifies with H¹(C, O_C) via the first-order deformation class
of the trivial line bundle. The isomorphism is k-linear and functorial in C.
\end{theorem}

\section{Smoothness of \(\Pic^0_{C/k}\)}
% A.3.iv: Pic^0 smooth

\begin{theorem}
[Smoothness of \(\Pic^0_{C/k}\)]
\label{thm:pic0_smooth}
\lean{AlgebraicGeometry.Scheme.Pic0.smooth}

% SOURCE: Kleiman, §5 cor:sm + cor:ch0; Milne AV Prop. 3.4
The k-group scheme \(\Pic^0_{C/k}\) is smooth over k of relative dimension
g(C).

\emph{Proof sketch.} By Kleiman cor:sm (loc. cit.), if \(\Pic_{C/k}\) exists
(A.2.c) and represents the étale sheafification, then
\(\dim \Pic_{C/k} \le \dim H^1(O_C)\) with equality iff \(\Pic_{C/k}\) is
smooth at 0. The group-scheme criterion (smoothness at the identity implies
smoothness everywhere for group schemes) reduces to the tangent-space computation
of thm:pic0_tangent_space_iso. In characteristic zero, smoothness at 0 is
automatic since the tangent-space dimension equals dim H^1(O_C) = g. For
general characteristic, the formal-smoothness criterion (lifting of nilpotent
thickenings of the base) is established via the deformation theory of line
bundles (Kleiman cor:ch0, using that the obstruction space H²(O_C) = 0 for a
curve).
\end{theorem}

\section{Properness of \(\Pic^0_{C/k}\)}
% A.3.v: Pic^0 proper

\begin{theorem}
[Properness of \(\Pic^0_{C/k}\)]
\label{thm:pic0_proper}
\lean{AlgebraicGeometry.Scheme.Pic0.proper}

% SOURCE: Kleiman §5; Mumford AV Thm. 3.7 (Jacobian is complete)
The k-scheme \(\Pic^0_{C/k}\) is proper over k (complete in classical language).

\emph{Proof sketch.} Properness is established via the valuative criterion.
Given a DVR (R, m) over k with fraction field K and a K-point of \(\Pic^0_{C/k}\)
(i.e. a degree-0 line bundle L on C_K), one must extend L to an R-point
(a flat extension to C_R). This is accomplished by the Weil extension theorem
for line bundles: a line bundle defined on the generic fibre of a proper flat
curve extends (after possibly a finite extension of R) to the whole of C_R.
The degree-0 condition is preserved under the extension.
\end{theorem}

\section{Geometric irreducibility of \(\Pic^0_{C/k}\)}
% A.3.vi: Pic^0 geom-irreducible

\begin{theorem}
[Geometric irreducibility of \(\Pic^0_{C/k}\)]
\label{thm:pic0_geom_irred}
\lean{AlgebraicGeometry.Scheme.Pic0.geometricallyIrreducible}

% SOURCE: SGA 7 XIII, Deligne; Mumford AV §3; Kleiman §5 prp:P0
The identity component \(\Pic^0_{C/k}\) is geometrically irreducible over k.

\emph{Proof sketch.} By construction \(\Pic^0_{C/k}\) is the identity component
of the Picard scheme (A.3.i–ii); identity components of group schemes are
irreducible. Geometric irreducibility follows from connectivity: a smooth
connected group scheme G over a perfect field k is geometrically irreducible
(since G_kbar is connected and smooth, hence irreducible by
geometricallyConnected_of_connected_of_section applied to any rational point
of G_kbar ← use the identity section). For non-perfect k, the conclusion holds
because Pic^0 is already smooth (A.3.iv) and connected (being the identity
component), and one uses that a smooth connected variety over any field is
geometrically irreducible (Stacks tag 04KU,
geometricallyConnected_of_connected_of_section).
\end{theorem}

\section{Assembly: \(\Pic^0_{C/k}\) is an abelian variety}
% A.3.vii: assembly

\begin{theorem}
[{\(\Pic^0_{C/k}\) is an abelian variety}]
\label{thm:pic0_isAbelianVariety}
\lean{AlgebraicGeometry.Scheme.Pic0.isAbelianVariety}
\uses{thm:pic0_smooth, thm:pic0_proper, thm:pic0_geom_irred,
      thm:identity_component_is_subgroup_homomorphism}

The scheme \(\Pic^0_{C/k}\) together with its group-scheme structure
(inherited from \(\Pic_{C/k}\) via the identity-component subgroup structure
of thm:identity_component_is_subgroup_homomorphism) is an abelian variety
over k: smooth, proper, geometrically irreducible, and a group object.

\emph{Proof sketch.} Assemble thm:pic0_smooth (smooth of relative dim g),
thm:pic0_proper (proper over k), thm:pic0_geom_irred (geometrically irreducible),
and the group-object structure carried by the identity component
(thm:identity_component_is_subgroup_homomorphism). These are exactly the four
typeclass hypotheses of the project's abelian-variety encoding.
\end{theorem}
```

**Lean file skeleton outline** (`AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`):
```lean
import AlgebraicJacobian.Picard.IdentityComponent
import AlgebraicJacobian.Picard.FGAPicRepresentability
import AlgebraicJacobian.Albanese.AuslanderBuchsbaum  -- for RegularLocal → CM

namespace AlgebraicGeometry.Scheme

-- A.3.iii
noncomputable def Pic0.tangentSpaceIso : ... := sorry

-- A.3.iv  
instance Pic0.smooth : SmoothOfRelativeDimension (genus C) Pic0.hom := sorry

-- A.3.v
instance Pic0.proper : IsProper Pic0.hom := sorry

-- A.3.vi
instance Pic0.geometricallyIrreducible : GeometricallyIrreducible Pic0.hom := sorry

-- A.3.vii assembly
instance Pic0.isAbelianVariety : ... := ...

end AlgebraicGeometry.Scheme
```

**Priority justification:** This chapter has been deferred multiple iterations and is the linchpin of Route A. Without it, `thm:nonempty_jacobianWitness` Route A remains a named gap. The tangent-space iso (A.3.iii) and smoothness (A.3.iv) are the high-leverage first targets; properness (A.3.v) and geom-irreducible (A.3.vi) follow from them. Recommend dispatching a `mathlib-build` mode prover to the A.3.iii–iv pair immediately after the chapter writer lands the outline above.

---

### A.4.d: `Albanese_AlbaneseUP.tex` divisor-map rewrite

**Verdict: PASS — no writer dispatch needed**

The iter-188 S_g-quotient → divisor-map pivot IS fully reflected in the current chapter. The chapter documents the symmetric-power route (iter-175 pivot): `def:symmetric_power_curve`, `lem:symmetric_product_av_map`, `lem:symmetric_product_to_jacobian`, `lem:descent_through_birational_sigma` are all present with `\leanok` markers. The old moduli route is preserved as a `% NOTE:` block. The A.4.d concern is resolved; no writer dispatch needed for this chapter.

---

## Severity Summary

| Category | Count | Items |
|----------|-------|-------|
| FAIL (blocks dispatch) | 1 | MF-1 (AbelianVarietyRigidity Proj.appIso) |
| PARTIAL (weakens dispatch) | 3 | MF-2 (CodimOneExtension Stages 3-4), MF-3 (AuslanderBuchsbaum Route iii), MF-4 (IdentityComponent 04KU pin) |
| INFO (non-blocking) | 2 | INFO-1 (QuotScheme NOTE), INFO-2 (RationalCurveIso sub-tasks) |
| CLEARS | 6 | Items 1, 2, 4, 8, 9, 11 |
| PASS (no prover lane) | 22 | All other chapters |
| New chapter proposal | 1 | Picard_Pic0AbelianVariety.tex (HIGH PRIORITY) |

**Recommended iter-192 writer dispatches (in priority order):**
1. `AbelianVarietyRigidity.tex` III.c — Proj.appIso expansion (2–3 sentences; unblocks Lane E Part 2)
2. `Picard_Pic0AbelianVariety.tex` — new chapter scaffold (HIGH, deferred multiple iters; enables Route A final assembly)
3. `Albanese_CodimOneExtension.tex` Stages 3-4 — polynomial-generators → regular-sequence chain
4. `Albanese_AuslanderBuchsbaum.tex` Route (iii) — Krull intersection block
5. `Picard_IdentityComponent.tex` — add `\lean{geometricallyConnected_of_connected_of_section}` helper block

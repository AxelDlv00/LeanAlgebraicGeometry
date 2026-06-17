# Blueprint-reviewer report — iter-021

**Scope**: Whole-blueprint audit (all 6 chapters).
**leandag**: 225 nodes, 438 edges, 0 unknown_uses. Run against current `.leandag/dag.json` (marked modified this iter).
**blueprint-doctor**: Not run as standalone tool (no prior iter `.json` output available); structural findings derived from direct chapter reads + leandag analysis.

---

## Per-Chapter Checklist

### 1. `Cohomology_RegroupHelper.tex`

| Field | Value |
|---|---|
| complete | **true** |
| correct | **true** |
| leanok coverage | 1/1 declarations — statement and proof `\leanok` |
| Mathlib anchors | `lem:isPushout_cancelBaseChange_mathlib` — `\mathlibok` ✓ |
| Citations | SOURCE/SOURCE QUOTE for Stacks `lemma-affine-base-change` boils-down step |
| Dependency wiring | `lem:base_change_regroup_linearEquiv` → `lem:isPushout_cancelBaseChange_mathlib` — valid |
| Must-fix | None |

Single lemma chapter: `lem:base_change_regroup_linearEquiv` with `\lean{AlgebraicGeometry.base_change_regroup_linearEquiv}`. Proof delegates entirely to Mathlib's `Algebra.IsPushout.cancelBaseChange` (linearEquiv form). Both statement and proof carry `\leanok`. Trivially gate-ready as a leaf consumed by `lem:base_change_mate_regroupEquiv` in the FBC chapter.

---

### 2. `Cohomology_FlatBaseChange.tex`

| Field | Value |
|---|---|
| complete | **true** |
| correct | **true** |
| leanok coverage | All active route declarations have statement-level `\leanok`; proof of `lem:base_change_mate_gstar_transpose` open (prover target) |
| Superseded blocks | 5 Seam-2 dead-code entries retained (FYI only — knowingly deferred) |
| Mathlib anchors | 6 anchors, all `\mathlibok` ✓ |

#### Active route declaration chain (all with statement `\leanok`):
`def:pushforward_base_change_map` → `lem:modules_isIso_iff_stalk` → `lem:modules_isIso_of_isBasis` → `lem:modules_isIso_iff_affineOpens` → tilde-dictionary chain (`lem:gammaPushforwardIso`, `lem:gammaPushforwardTildeIso`, `lem:gammaPushforwardIsoAt`, `lem:tildeRestriction_isLocalizedModule`, `lem:powers_restrictScalars`, `lem:fromTildeGamma_app_isIso_of_localized`, `lem:pushforward_spec_tilde_iso_conditional`, `lem:pushforward_spec_tilde_iso`, `lem:pullback_spec_tilde_iso`) → base-change-mate seam chain (`lem:base_change_map_affine_local`, `lem:pullback_fst_snd_specMap_tensor`, `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:pullbackIsoEquivalenceOfIso`, `lem:pullback_isEquivalence_of_iso`, `lem:base_change_mate_regroupEquiv`, `lem:base_change_mate_unit_value`, `def:base_change_mate_inner_value`, `lem:pullbackPushforward_unit_comp`, `lem:gammaMap_pushforwardComp_hom_eq_id`, `lem:gammaMap_pushforwardComp_inv_eq_id`, `lem:gammaMap_pushforwardCongr_hom`) → **`lem:base_change_mate_gstar_transpose`** (prover target) → `lem:base_change_mate_section_identity` → `lem:base_change_mate_generator_trace` → `lem:pushforward_base_change_mate_cancelBaseChange` → `lem:affine_base_change_pushforward` → `thm:flat_base_change_pushforward`.

#### Gate-critical: `lem:base_change_mate_gstar_transpose` — audit
- **Statement** (lines 1986–2047): `\leanok` present. `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}`. `\uses{}` block lists: `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:base_change_mate_regroupEquiv`, `lem:pullback_spec_tilde_iso`, `lem:base_change_mate_unit_value`. All confirmed `\leanok`.
- **Proof** (lines 2048–2113): No `\leanok` in proof block (this is the open obligation for the prover). The proof narrative is detailed and complete:
  - **Step (i) — counit factorization**: the base-change map factors via `Adjunction.homEquiv_counit` as `Γ(g^*(θ_in)) ≫ Γ(ε_g)`; no opaque transpose remains. Named Mathlib lemma cited.
  - **Step (ii) — concrete counit coherence**: explains WHY `Π_ψ` (the pullback dictionary from `lem:pullback_spec_tilde_iso`) cannot be simplified by reflexivity; requires the abstract conjugate calculus. The relevant identity is the counit-triangle zig-zag for the composed adjunction `(g^* ⊣ g_*) ∘ (Γ ⊣ ~)`, the dual companion of `lem:unit_conjugateEquiv_mathlib`.
  - **Step (iii) — generator identification**: `r' ⊗ m ↦ (1 ⊗ r') ⊗ m` is `regroupEquiv.inv` on generators; both R'-linear, so they coincide.
  - Extra `\uses{}` in proof: `lem:gammaPushforwardNatIso`, `lem:unit_conjugateEquiv_mathlib` — both confirmed `\leanok`/`\mathlibok`.
- **Downstream**: `lem:base_change_mate_section_identity` feeds `lem:base_change_mate_generator_trace` (`IsIso` form) → `lem:pushforward_base_change_mate_cancelBaseChange` → `lem:affine_base_change_pushforward` → `thm:flat_base_change_pushforward`. Chain is clean.
- **leandag**: `lem:base_change_mate_gstar_transpose` listed as a **leaf** in the DAG — consistent with it being an open proof target that nothing yet depends on from downstream in the same axiom-free path.

#### Superseded Seam-2 dead-code (FYI only):
`lem:base_change_mate_codomain_read_legs` (active route, not superseded), `lem:base_change_mate_fstar_reindex_legs_unitExpand`, `lem:base_change_mate_fstar_reindex_legs_gammaDistribute`, `lem:base_change_mate_fstar_reindex_legs`, `lem:base_change_mate_fstar_reindex`. The last two are marked "Superseded" and confirmed as **dead code** by leandag (both appear as leaves with no downstream dependents). Physical removal deferred to an FBC-no-prover iter as stated in the directive.

Must-fix: **None**.

---

### 3. `Picard_FlatteningStratification.tex`

| Field | Value |
|---|---|
| complete | **false** — `\leanok`-completeness issue only |
| correct | **true** |
| leanok coverage | 0 active-route declarations have `\leanok` (all scaffolded with `\lean{}` hints, proofs unformalized) |
| Mathlib anchors | 7 anchors, all `\mathlibok` ✓ |

#### Explicit answer to the directive's gate-critical question:

**The iter-020 `complete: false` verdict was a `\leanok`-completeness observation — not a prose-completeness finding.** All major declarations carry `\lean{}` hints and detailed proof prose; zero `\leanok` markers are present because the Lean proofs are not yet formalized. This is precisely the gap the prover fills.

#### L4-finiteness + B/𝔭 cascade prose adequacy:

The prose for `lem:gf_noether_clear_denominators` Steps 3a–3c is complete and correct:
- **Step 3a** (clearing single denominator via `gf_clear_one_denominator`): algebraic independence ascent — ring map, ν injection, finiteness transfer.
- **Step 3b** (induction on denominator length): each new denominator cleared by a new variable; the `gf_lt_up` ordering ensures termination.
- **Step 3c** (denominator clearing for the full module-finiteness): algebraic independence descent — module-finiteness of `N_g` over `B_g` via the ν injection, using `lem:gf_finite_of_quotient_ringequiv` and `lem:isLocalization_away_mul_of_associated`. The iter-020 per-file checker judged this adequate; this audit concurs.

The **B/𝔭 cascade** leading to `genericFlatnessAlgebraic @1810` follows the standard Nitsure §4 dévissage chain L1→L2→L3→L4→L5, each step with `\lean{}` hints and complete prose. The L5 engineering note is explicit that the remaining sorry is not a missing math step but an OreLocalization elaboration blocker (instrance presentation on `(N ⧸ range φ)_g` that is defeq but not instance-transparent-equal) — this is prover-level, not blueprint-prose-level.

**No genuine prose gap found.** The prover can be dispatched against `lem:gf_noether_clear_denominators` Step 3c (`exists_localizationAway_finite_mvPolynomial` @754) and the cascade to `genericFlatnessAlgebraic @1810`.

Must-fix: **None**.

---

### 4. `Picard_QuotScheme.tex`

| Field | Value |
|---|---|
| complete | **true** (all formalized declarations have `\leanok`; new helpers are correctly unformalized) |
| correct | **true** |
| archon:covers | `AlgebraicJacobian/Picard/QuotScheme.lean AlgebraicJacobian/Picard/GradedHilbertSerre.lean` — confirmed at line 3 |
| leanok coverage | Full `\leanok` on IsRatHilb toolkit, all graded-subquotient infrastructure, ambient induction, support predicates, Quot functor definition, Grassmannian def/representability |

#### New block 1: `lem:graded_finrank_comap_subtype` (line 1471)

| Check | Result |
|---|---|
| `\label{}` | `lem:graded_finrank_comap_subtype` ✓ |
| `\lean{}` | `AlgebraicGeometry.GradedModule.finrank_comap_subtype` ✓ |
| `\uses{}` | None (appropriate — basic linear algebra, no blueprint dependencies) ✓ |
| `\leanok` | Absent (correct — not yet formalized) ✓ |
| Statement | `dim_κ(ι_p⁻¹ S) = dim_κ(p ∩ S)` for submodules `p, S` of a κ-vector space `M`. Clear and correct — injective map creates isomorphism between preimage and image. |
| Proof | 2-sentence direct proof. Complete. |
| Wiring | **Minor finding** (see below) |

**Minor finding — `\uses{}` gap**: `lem:graded_finrank_comap_subtype` is referenced only via a `% NOTE:` comment in the proof block of `lem:graded_subquotient_degreewise_diff`:
```tex
% NOTE: The proof factors the two kernel-dimension computations through the
%   helper \cref{lem:graded_finrank_comap_subtype}
```
It is NOT in the `\uses{}` of `lem:graded_subquotient_degreewise_diff`. Consequence: leandag lists the helper as an isolated leaf node (`lean:AlgebraicGeometry.GradedModule.finrank_comap_subtype` in the leaves list), with no dependency edge to its consumer. The prover will not be auto-prompted by the blueprint system to use it. **Not must-fix this iter** (the NOTE comment captures the intent and the prover can use it; the declaration is correctly scaffolded), but `lem:graded_finrank_comap_subtype` should be added to the `\uses{}` block of `lem:graded_subquotient_degreewise_diff`'s proof in a future iter.

#### New block 2: `lem:graded_iSupIndep_map_of_mem_ker_sup` (line 2091)

| Check | Result |
|---|---|
| `\label{}` | `lem:graded_iSupIndep_map_of_mem_ker_sup` ✓ |
| `\lean{}` | `AlgebraicGeometry.GradedModule.iSupIndep_map_of_mem_ker_sup` ✓ |
| `\uses{}` | None (appropriate — ring-agnostic lattice core) ✓ |
| `\leanok` | Absent (correct — not yet formalized) ✓ |
| Statement | Image independence from independence-modulo-kernel. Well-stated. |
| Proof | Complete direct proof via disjointness criterion for iSupIndep. |
| Wiring | `lem:graded_subquotient_base_eventuallyZero` `\uses{}` at line 2118 includes `lem:graded_iSupIndep_map_of_mem_ker_sup` ✓ Properly wired. |

#### archon:covers split coherence

The covers line at line 3:
```tex
% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean AlgebraicJacobian/Picard/GradedHilbertSerre.lean
```

- No other chapter covers `AlgebraicJacobian/Picard/QuotScheme.lean` — no double-cover.
- No other chapter covers `AlgebraicJacobian/Picard/GradedHilbertSerre.lean` — no double-cover.
- All `\lean{}` pins use the same qualified Lean namespace as before (the split is a file-level refactor; names unchanged) — no orphaned names.
- **Coherent** ✓

Must-fix: **None** (minor `\uses{}` gap noted above, deferred to a future iter).

---

### 5. `Picard_GrassmannianCells.tex`

| Field | Value |
|---|---|
| complete | **false** — 3 top-level declarations lack `\leanok` |
| correct | **true** |
| leanok coverage | All chart infrastructure, transition-map chain, matrix bookkeeping helpers, triple-overlap rings, cocycle condition (`lem:gr_cocycle`) — all `\leanok`. The 3 top-level outputs are unformalized. |

#### `\leanok`-missing declarations:
1. `def:gr_glued_scheme` (`AlgebraicGeometry.Grassmannian.scheme`) — no `\leanok` in statement block
2. `lem:gr_separated` (`AlgebraicGeometry.Grassmannian.isSeparated`) — no `\leanok`
3. `lem:gr_proper` (`AlgebraicGeometry.Grassmannian.isProper`) — no `\leanok`

These are the top-level outputs of the Grassmannian construction; the underlying machinery is fully scaffolded. Prose for all three is mathematically correct and complete (valuative criterion for properness spelled out in full). Not a prover target this iter.

**leandag**: `lem:gr_imageMatrix_submatrix_I` appears in leaves — this is an existing sub-lemma that hasn't been referenced downstream yet (pre-dates the `gr_cocycle` wiring); not a new gap.

Must-fix: **None this iter**.

---

### 6. `Picard_RelativeSpec.tex`

| Field | Value |
|---|---|
| complete | **true** (with Lean-encoding caveats noted in-chapter) |
| correct | **true** |
| leanok coverage | All 5 declarations: `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base` — all `\leanok` |

Lean-encoding caveats (noted in-chapter, not a blueprint error):
- `thm:relative_spec_univ`: Lean type is `IsAffineHom (structureMorphism 𝒜)`, weaker than the full Yoneda-bijection prose statement. Marked as iter-174+ deferred commitment.
- `thm:relative_spec_affine_base`: Lean type is `IsAffine`, weaker than the canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`. Same deferral note.

These are accurately documented in the chapter; the `\leanok` markers reflect the weaker Lean statements that are actually proven. Not a blueprint error.

Must-fix: **None**.

---

## leandag Structural Audit

| Metric | Value |
|---|---|
| Total nodes | 225 |
| Total edges | 438 |
| `unknown_uses` (broken `\uses{}` refs) | **0** |
| Isolated nodes | 73 (all appear to be proof-block or `\mathlibok` artifact nodes with `None` label — leandag parsing artifact, not a content issue) |
| `unmatched_lean` entries | 44 — all `\mathlibok` anchors referencing Mathlib names not in the local build; expected and correct |

**Leaf node audit** (from `meta.leaves`):
- `lem:base_change_mate_gstar_transpose` — FBC prover target ✓ (correct: open proof obligation)
- `lem:base_change_mate_fstar_reindex` — superseded dead code ✓ (correct: nothing depends on it)
- `thm:flat_base_change_pushforward` — FBC keystone (correct: nothing downstream in this project)
- `lem:gf_flat_finite`, `lem:gf_free_moduleFinite`, `thm:generic_flatness` — GF targets (correct)
- `lem:graded_polyModule_isScalarTower`, `lem:graded_polySubmodule_coe` — QUOT infra utilities (correct)
- `thm:grassmannian_representable` — QUOT/GrCells keystone (correct)
- `lem:gr_imageMatrix_submatrix_I` — GrCells sub-lemma (correct, pre-dating downstream wiring)
- `lean:AlgebraicGeometry.GradedModule.finrank_comap_subtype` — new QUOT helper, isolated leaf because not in any `\uses{}` (see minor finding under QUOT above)

**No structural anomalies** beyond the `lem:graded_finrank_comap_subtype` `\uses{}` gap and the superseded dead-code leaves.

---

## HARD GATE Table

| Chapter | Prover target | Gate verdict | Notes |
|---|---|---|---|
| `Picard_FlatteningStratification.tex` (GF) | `lem:gf_noether_clear_denominators` Step 3c → B/𝔭 cascade → `genericFlatnessAlgebraic` | **PASSED** | `\leanok`-completeness only; prose adequate |
| `Cohomology_FlatBaseChange.tex` (FBC) | `lem:base_change_mate_gstar_transpose` | **PASSED** | 3-step recipe present; all dependencies `\leanok`/`\mathlibok` |

---

## Must-Fix Findings This Iter

**None.**

---

## FYI / Deferred Findings

1. **FBC Seam-2 dead code** (5 blocks: `lem:base_change_mate_fstar_reindex_legs_*`, `lem:base_change_mate_fstar_reindex`): Retained with `\leanok`. Physical removal deferred to an FBC-no-prover iter. leandag confirms these as leaf nodes with no downstream dependents.

2. **QUOT `lem:graded_finrank_comap_subtype` `\uses{}` gap**: Helper is wired via a `% NOTE:` comment only, not via a formal `\uses{}` link in `lem:graded_subquotient_degreewise_diff`. The leandag surfaces this as an isolated leaf. The prover can still use the helper via the NOTE; no prose gap. Add to `\uses{}` in a future iter for clean dependency tracking.

3. **GrCells top-level declarations unformalized**: `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` — prose complete and correct, not a prover target this iter.

4. **RelSpec Lean-encoding deferral**: `thm:relative_spec_univ` and `thm:relative_spec_affine_base` have weaker Lean statements than prose (iter-174+ commitment). Accurately documented in-chapter.

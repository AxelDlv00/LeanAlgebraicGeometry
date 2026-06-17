# Blueprint reviewer — iter-028 whole-blueprint audit

**Date**: iter-028  
**Scope**: all chapters under `blueprint/src/chapters/`  
**Primary gate**: `Cohomology_CechHigherDirectImage.tex` — hard-gate for prover dispatch at `CechToCohomology.lean`

---

## Diagnostic tool summary

### leandag build --json
- `blueprint_nodes`: 99 · `edges`: 223 · `isolated`: 0
- `proved`: 25 · `mathlib_ok`: 14 · `with_sorry`: 2
- **`unknown_uses`: []** — zero broken `\uses{}` edges ✓
- `unmatched_lean`: 31 entries — all expected (see §Unmatched inventory below)

### archon blueprint-doctor --json
- `broken_refs`: [] ✓  
- `malformed_refs`: [] ✓  
- `orphan_chapters`: [] ✓  
- `axiom_decls`: [] ✓  
- `covers_problems`: [] ✓  
- `labels_defined_count`: 105

Both tools pass clean.

---

## Per-chapter verdicts

### `Cohomology_HigherDirectImage.tex` (58 lines)

| Field | Value |
|-------|-------|
| complete | true |
| correct | true |

Single declaration `def:higher_direct_image`, `\leanok` on statement, source quoted (Stacks Cohomology of Schemes). The `[HasInjectiveResolutions X.Modules]` instance hypothesis is documented in a `% NOTE` with explanation (Mathlib has `Abelian X.Modules` but not `EnoughInjectives` for `SheafOfModules`). Chapter is thin and correct.

---

### `Cohomology_AcyclicResolution.tex` (1052 lines)

| Field | Value |
|-------|-------|
| complete | true |
| correct | true |

All declarations carry `\leanok` or `\mathlibok`. Main theorem `lem:acyclic_resolution_computes_derived` is `\leanok`. The `\mathlibok` anchors (`lem:right_derived_injective_resolution`, `lem:right_derived_vanishes_injective`, etc.) correctly point to Mathlib names and are confirmed as `unmatched_lean` entries (Mathlib declarations, not project files — expected). `\uses{}` graph is acyclic and complete per leandag. Sources from Stacks Tags 0157, 015C, 015D, 015E, 05TA are all quoted. No issues.

---

### `Cohomology_CechHigherDirectImage.tex` (4293 lines) — HARD GATE

| Field | Value |
|-------|-------|
| complete | true |
| correct | true |

Detailed findings follow.

#### Gate question 1: L1/L2 prose faithful to landed cover-local Lean?

**PASS.**

- `lem:cech_ses_of_basis` (L1): `\leanok` on statement block. Statement is cover-local (presheaf-level, hypotheses on per-face surjectivity, NOT the global cover/basis form). `\lean{AlgebraicGeometry.cechComplex_shortExact_of_basis}`. Consistent with axiom-clean Lean shipped iter-027. ✓
- `lem:quotient_vanishing_cech` (L2): `\leanok` on statement block. Statement is cover-local (inductive-hypothesis form over `HasVanishingHigherCech`). `\lean{AlgebraicGeometry.quotient_cech_vanishing_of_basis}`. ✓

No residual cover-global mismatch found.

#### Gate question 2: L3/L4/top + per-face-SES + BasisCovSystem scaffolds formalize-ready?

**PASS.**

All six scaffold targets present with `% NOTE:` flags, source quotes, precise statements, and clean `\uses{}` chains (confirmed by `unknown_uses: []`):

| Label | Lean name | `\uses{}` complete | Source |
|-------|-----------|-------------------|--------|
| `def:basis_cov_system` | `AlgebraicGeometry.BasisCovSystem` | ✓ (no deps) | Stacks Tag 01EO §setup |
| `def:has_vanishing_higher_cech` | `AlgebraicGeometry.HasVanishingHigherCech` | ✓ `→ def:basis_cov_system, def:cech_complex` | Stacks Tag 01EO §inductive class |
| `lem:face_ses_of_sheaf_ses` | `AlgebraicGeometry.faceShortComplex_shortExact_of_sheaf_ses` | ✓ `→ def:face_short_complex, def:section_cech_short_complex, lem:cech_ses_of_basis` | Stacks Tag 01EO §ses-of-covers |
| `lem:absolute_cohomology_one_vanishing` (L3) | `AlgebraicGeometry.absoluteCohomology_one_eq_zero_of_basis` | ✓ `→ def:has_vanishing_higher_cech, def:absolute_cohomology, lem:absolute_cohomology_injective_vanishing, lem:absolute_cohomology_covariant_les, lem:cech_ses_of_basis` | Stacks Tag 01EO §base case |
| `lem:absolute_cohomology_pos_vanishing` (L4) | `AlgebraicGeometry.absoluteCohomology_eq_zero_of_basis` | ✓ `→ lem:absolute_cohomology_one_vanishing, lem:quotient_vanishing_cech, def:has_vanishing_higher_cech, def:absolute_cohomology` | Stacks Tag 01EO §induction |
| `lem:cech_to_cohomology_on_basis` (top) | `AlgebraicGeometry.cech_eq_cohomology_of_basis` | ✓ `→ def:cech_complex, def:absolute_cohomology, lem:cech_ses_of_basis, lem:quotient_vanishing_cech, lem:absolute_cohomology_one_vanishing, lem:absolute_cohomology_pos_vanishing` | Stacks Tag 01EO (verbatim source quote present) |

**Statement coherence**: all scaffold statements are stated in terms of the Form-B `absoluteCohomology` Ext API (`def:absolute_cohomology` → `Ext^p(jShriekOU U, F)`) and the cover-local L1/L2 hypotheses. No reference to QCoh-specific machinery in the inductive path.

**Proof sketches**: L3 proof sketch (Ext LES + injective vanishing + naturality of H⁰≅Γ) is detailed enough for a prover. L4 proof sketch (dimension-shift induction: embed F → I injective, form Q = I/F, apply `lem:quotient_vanishing_cech` to keep Q in the class, apply L3 to Q, induct) is clean and matches the Stacks source proof structure. Top-level proof sketch maps conditions (1)–(3) onto `BasisCovSystem` + `HasVanishingHigherCech` encoding and delegates directly to L4.

**Signatures coherent**: all declarations consume `BasisCovSystem` + `HasVanishingHigherCech` + `absoluteCohomology` in the correct order. No universe or typeclass mismatches visible in the prose.

#### Gate question 3: `HasVanishingHigherCech` correctly abstract?

**PASS.**

The block prose for `def:has_vanishing_higher_cech` states explicitly: "deliberately stated for an arbitrary `O_X`-module, not specialized to quasi-coherent modules, because the inductive step constructs Q = I/F where I is injective in O_X-modules and Q need not be quasi-coherent." This is the correct abstraction. The `lem:quotient_vanishing_cech` statement likewise takes an arbitrary O_X-module `F`. ✓

#### Gate question 4: broken `\uses{}`/`\ref{}`, missing source quotes, `\leanok`/`\mathlibok` misuse?

**No broken refs.** `broken_refs: []`, `malformed_refs: []`, `unknown_uses: []` confirmed by both tools.

**Source quotes**: all scaffold blocks have `% SOURCE:` + `% SOURCE QUOTE:` comments and a `\textit{Source:}` inline cite. Existing formalized blocks carry their sources. ✓

**`\leanok`/`\mathlibok` usage**: no violations observed. Only sync_leanok-managed `\leanok` markers are present on blocks matching confirmed axiom-clean Lean declarations. `\mathlibok` only on Mathlib-anchored blocks.

**One cosmetic label issue** (non-blocking):

> `\label{def:cohomology_sheaf_is_sheafify_homology}` appears inside a `\begin{lemma}` environment. The `def:` prefix is a naming mismatch with the environment type. This does NOT break any references (all `\uses{}` references to this label resolve correctly, confirmed by `unknown_uses: []`), and `broken_refs: []` confirms no rendering breakage. However, the label prefix is semantically misleading.
>
> **Severity**: COSMETIC — fix in next blueprint-writing pass. Do not hold this iter's dispatch.

#### Broader chapter state

The new section "The Čech complex computes R^i f_*" (lines 3838–4293) covers the full P5b comparison assembly chain:

| Label | Status |
|-------|--------|
| `lem:cech_augmented_resolution` | unmatched (not yet formalized) |
| `def:cohomology_sheaf_is_sheafify_homology` | `\lean{}` found in project (not in unmatched_lean); missing `\leanok` — see note below |
| `lem:higher_direct_image_presheaf` | unmatched (not yet formalized) |
| `lem:open_immersion_pushforward_comp` | unmatched (not yet formalized) |
| `lem:cech_term_pushforward_acyclic` | unmatched (not yet formalized) |
| `lem:cech_computes_cohomology` | `\leanok` on statement (protected declaration with sorry body); proof chain unformalized — **correct behavior** |

**Note on `def:cohomology_sheaf_is_sheafify_homology`**: leandag did NOT list it in `unmatched_lean`, meaning the `\lean{}` names (`PresheafOfModules.homologyIsoSheafify`, `PresheafOfModules.counitComplexIso`, `PresheafOfModules.sheafificationAdditive`, `CategoryTheory.Functor.mapHomologyIso'`) ARE found in project Lean files (consistent with P5a engine `HigherDirectImagePresheaf.lean` being axiom-clean). Yet the statement block lacks `\leanok`. This is likely a sync_leanok miss (declarations may still carry sorry, or multi-lean blocks require all names to be sorry-free). The plan agent should check whether these four declarations are sorry-free in `HigherDirectImagePresheaf.lean`; if yes, sync_leanok should pick this up automatically in the next iter. **Severity: MUST_FIX_SOON** (will self-resolve via sync_leanok once sorries clear, but worth flagging to plan agent).

---

## HARD GATE verdict

```
complete: true
correct: true
```

**Cleared for prover dispatch at `CechToCohomology.lean` this iter.**

The six scaffold targets (per-face SES, `BasisCovSystem`, `HasVanishingHigherCech`, L3, L4, top) are formalize-ready: statements are precise, `\uses{}` chains are acyclic and complete (zero unknown_uses), signatures are coherent with the cover-local L1/L2 and Form-B absoluteCohomology API, `HasVanishingHigherCech` is correctly abstract, and source quotes are present on all new blocks.

---

## Unmatched-lean inventory (all expected)

The 31 `unmatched_lean` entries fall into three expected categories:

**Category A — `\mathlibok` Mathlib anchors** (14 nodes, ~20 entries): `lem:right_derived_injective_resolution`, `lem:right_derived_vanishes_injective`, `lem:right_derived_zero_iso_self`, `lem:homology_long_exact_sequence`, `lem:horseshoe_biprod_injective`, `lem:horseshoe_degree_split`, `lem:injective_of_adjoint`, `lem:mod_pmod_adjunction`, `def:standard_affine_cover`, `lem:ext_bifunctor_mathlib`, `lem:hasext_standard_mathlib`, `lem:ext_homequiv_zero_mathlib`, `lem:ext_eq_zero_of_injective_mathlib`, `lem:ext_covariant_les_mathlib`. These point to Mathlib declarations (not project files) — expected.

**Category B — this-iter scaffold targets** (7 nodes): `lem:affine_serre_vanishing`, `def:basis_cov_system`, `def:has_vanishing_higher_cech`, `lem:face_ses_of_sheaf_ses`, `lem:absolute_cohomology_one_vanishing`, `lem:absolute_cohomology_pos_vanishing`, `lem:cech_to_cohomology_on_basis`. These are `% NOTE:`-flagged scaffolds for the dispatched prover — expected.

**Category C — P5b comparison assembly** (3 nodes, blocked on affine Serre vanishing): `lem:cech_augmented_resolution`, `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`. Not yet formalized, blueprint coverage present — expected.

**No unexpected unmatched entries.** No action required beyond normal prover progress.

---

## Unstarted-phase blueprint proposals

**None required.** All active strategy phases have blueprint coverage:

- **01EO → affine_serre_vanishing + L3/L4/top** (this iter's dispatch): fully scaffolded in `Cohomology_CechHigherDirectImage.tex` with the six new blocks described above.
- **P5a vanishing inputs** (01XJ engine done): `lem:higher_direct_image_presheaf` and `def:cohomology_sheaf_is_sheafify_homology` are scaffolded in the new final section.
- **P5b comparison assembly** (blocked on affine Serre vanishing): `lem:cech_augmented_resolution`, `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`, `lem:cech_computes_cohomology` are all scaffolded in the new final section "The Čech complex computes R^i f_*" (lines 3838–4293) with full proof sketches, source quotes, and clean `\uses{}` chains.

No strategy phase lacks blueprint coverage.

---

## Severity summary

| Severity | Count | Items |
|----------|-------|-------|
| MUST_FIX_THIS_ITER | 0 | — |
| MUST_FIX_SOON | 1 | `def:cohomology_sheaf_is_sheafify_homology` missing `\leanok` despite Lean names found in project |
| COSMETIC | 1 | `def:cohomology_sheaf_is_sheafify_homology` — `def:` label prefix on `\begin{lemma}` environment |

Zero blockers for this iter's prover dispatch.

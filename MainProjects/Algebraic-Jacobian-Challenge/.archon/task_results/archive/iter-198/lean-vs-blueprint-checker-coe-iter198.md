# Lean ↔ Blueprint Check Report

## Slug
coe-iter198

## Iteration
198

## Files audited
- Lean: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus}` (chapter: `def:indeterminacy_locus`)
- **Lean target exists**: yes — `indeterminacyLocus` at L146, namespace `AlgebraicGeometry.Scheme.RationalMap`
- **Signature matches**: yes — `Set X` (closed complement of `f.domain`), exactly as blueprint prose
- **Proof follows sketch**: N/A (definition)
- **`\leanok` (statement)**: present ✓
- **notes**: axiom-clean one-liner `(f.domain : Set X)ᶜ`; the standalone `isClosed_indeterminacyLocus` lemma (L151) is an unlisted helper — not mentioned in blueprint but not required to be

### `\lean{AlgebraicGeometry.Scheme.RationalMap.CodimOneFree}` (chapter: `def:codim_one_indeterminacy`)
- **Lean target exists**: yes — L180
- **Signature matches**: yes — `∀ (x : X), Order.coheight x = 1 → x ∈ f.domain`
- **Proof follows sketch**: N/A (definition)
- **`\leanok` (statement)**: present ✓
- **notes**: axiom-clean

### `\lean{AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization}` (chapter: `lem:module_free_kaehler_localization`)
- **Lean target exists**: yes — L325 (`private theorem module_free_kaehlerDifferential_localization`)
- **Signature matches**: yes — `Module.Free S (Ω[S⁄R])` + `IsLocalization M Sₘ` → `Module.Free Sₘ (Ω[Sₘ⁄R])`
- **Proof follows sketch**: yes — uses `KaehlerDifferential.isLocalizedModule_map` + `Module.free_of_isLocalizedModule` exactly as blueprint sketches
- **`\leanok` (statement)**: present ✓; **`\leanok` (proof block)**: **MISSING** — proof is axiom-clean (no sorry); sync_leanok should have added it
- **notes**: declaration is `private`; blueprint pin is to a private name, which works nominally for the blueprinting system but cannot be referenced externally

### `\lean{AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension}` (chapter: `lem:rank_kaehler_localization_eq_relative_dim`)
- **Lean target exists**: yes — L351 (`private theorem rank_kaehlerDifferential_localization_eq_relativeDimension`)
- **Signature matches**: yes — `IsStandardSmoothOfRelativeDimension n R S` + `IsLocalization M Sₘ` + `Nontrivial Sₘ` → `Module.rank Sₘ (Ω[Sₘ⁄R]) = n`
- **Proof follows sketch**: yes — composes `rank_kaehlerDifferential`, `isLocalizedModule_map`, `lift_rank_of_isLocalizedModule_of_free` as blueprint describes
- **`\leanok` (statement)**: present ✓; **`\leanok` (proof block)**: **MISSING** — proof is axiom-clean; same sync_leanok miss
- **notes**: private; axiom-clean

### `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}` (chapter: `lem:smooth_algebra_krull_dim_formula`, Stage 6.A)
- **Lean target exists**: no — MISSING Mathlib declaration; no declaration of this name in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **`\leanok`**: none — correct, this is an explicit future prover target (iter-199+)
- **notes**: forward-looking pin to a planned Mathlib gap bridge (~200–300 LOC build)

### `\lean{Algebra.KaehlerDifferential.cotangent_iso_residue_tensor_kaehler}` (chapter: `lem:cotangent_kahler_over_field`, Stage 6.B)
- **Lean target exists**: no — MISSING Mathlib iso; iter-198 added substrate helpers (see Unreferenced declarations)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **`\leanok`**: none — correct
- **notes**: forward-looking pin; the iter-198 private helpers `finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq` and `...of_isStandardSmoothOfRelativeDimension` compute the **RHS finrank** of this iso (i.e., `finrank κ(m) (κ ⊗ Ω) = n`), but are substrate only — the iso itself is unbuilt

### `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth_aux}` (chapter: `lem:stage6_regular_stalk_assembly`, Stage 6.C)
- **Lean target exists**: **no** — no declaration named `isRegularLocalRing_stalk_of_smooth_aux` exists in the file; closest is `isRegularLocalRing_stalk_of_smooth` (private, L544, WITHOUT `_aux` suffix)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **`\leanok`**: none — correct (forward-looking target, `_aux` suffix signals a planned extraction)
- **notes**: **MAJOR** — pin targets a non-existent name; `_aux` suffix appears to be a planned name for a future factored auxiliary; the blueprint writer intended a dedicated algebra-level lemma separate from the scheme-level `isRegularLocalRing_stalk_of_smooth`

### `lem:smooth_to_regular_local_ring` (Stacks 00TT block) — **NO `\lean{...}` pin**
- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth` (private, L544) corresponds exactly to this block; its docstring explicitly cites `\cref{lem:smooth_to_regular_local_ring}`
- **`\lean{...}` pin**: **MISSING** from blueprint block
- **`\leanok`**: none on either block (proof has trailing `sorry` at L662; correct for statement-block since no pin = sync_leanok can't fire)
- **notes**: **MAJOR** — the Lean declaration exists (with sorry body) and is substantively the formalization of this block, but the blueprint has no `\lean{...}` pin; this decouples sync_leanok tracking for this gap lemma

### `\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` (chapter: `lem:smooth_codim_one_dvr`)
- **Lean target exists**: yes — public `theorem localRing_dvr_of_codim_one` at L751
- **Signature matches**: yes — `Order.coheight z = 1` → `IsDiscreteValuationRing (X.left.presheaf.stalk z)` under smooth/integral/separated/lft variety hypotheses
- **Proof follows sketch**: partial — Lean delegates regularity to private `isRegularLocalRing_stalk_of_smooth` (sorry) and Krull-dim closure to `Scheme.ringKrullDim_stalk_eq_coheight`; the blueprint proof sketch (Stacks 00TT + regular-of-dim-1 = DVR) is faithfully mirrored
- **`\leanok` (statement)**: present ✓; **`\leanok` (proof block)**: none (correct — indirect sorry via `isRegularLocalRing_stalk_of_smooth`)
- **notes**: transitively not axiom-clean; downstream of Stacks 00TT gap

### `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` (chapter: `thm:codim_one_extension`)
- **Lean target exists**: yes — public `theorem extend_of_codimOneFree_of_smooth` at L820
- **Signature matches**: yes — `CodimOneFree f` → `∃! g, g.toRationalMap = f` under smooth/proper/integral variety hypotheses; matches blueprint's unique-regular-extension statement
- **Proof follows sketch**: partial — sorry at L859; two-step structure (codim-1 ruling-out + codim-≥2 extension) described in inline comments exactly matching blueprint Steps 1–2
- **`\leanok` (statement)**: present ✓ (declaration exists with sorry, correct per marker semantics); proof block: none ✓ (sorry present)
- **notes**: pin resolves correctly; not edited this iter; gated on Stacks 0AVF (depth-≥2 H¹ vanishing) + `isRegularLocalRing_stalk_of_smooth` Stage 6 closure

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` (chapter: `lem:milne_codim1_indeterminacy`)
- **Lean target exists**: yes — public `theorem indeterminacy_pure_codim_one_into_grpScheme` at L888
- **Signature matches**: yes — disjunction `indeterminacyLocus f = ∅ ∨ ∀ x ∈ indeterminacyLocus f, ∃ z, coheight z = 1 ∧ x ∈ closure {z}`; matches blueprint's pure-codim-1 statement
- **Proof follows sketch**: partial — sorry at L934; detailed inline comments describe all four sub-steps matching blueprint proof exactly
- **`\leanok` (statement)**: present ✓; proof block: none ✓ (sorry present)
- **notes**: pin resolves correctly; not edited this iter; gated on function-field pullback for `RationalMap` + codim-1 diagonal intersection lemma

### `thm:weil_divisor_obstruction` — **NO `\lean{...}` pin (intentionally detached)**
- **Status**: deliberate detach since iter-179 (iter-179 review + iter-194 blueprint NOTE explain rationale); correct, the substantive `ord_W ≥ 0` reformulation requires `RationalMap → function-field` pullback machinery absent from Mathlib at `b80f227`
- **notes**: no finding

### `\lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}` (chapter: `lem:mem_domain_partial_map_reshuffle`)
- **Lean target exists**: yes — public `theorem mem_domain_iff_exists_partialMap_through_point` at L1000
- **Signature matches**: yes — iff between `W.point ∈ f.domain` and existence of a `PartialMap` representative containing `W.point`, with conjuncts reordered
- **Proof follows sketch**: yes — definitional reshuffle via `Scheme.RationalMap.mem_domain` with a simple `exact ⟨...⟩`
- **`\leanok` (statement)**: present ✓; **`\leanok` (proof block)**: **MISSING** — proof is axiom-clean; sync_leanok should have added it
- **notes**: axiom-clean; the only fully closed public theorem in the file

---

## Red Flags

### Placeholder / suspect bodies
- `isRegularLocalRing_stalk_of_smooth` (private, L544): body ends in `sorry` at L662. **This is a tracked, authorized gap** (Stacks 00TT; explicitly named in blueprint NOTE comments and in the Lean docstring). Not a hidden placeholder — the two remaining sub-gaps are named, Stacks-tagged, and have a documented closure pattern. The declaration type is substantive. **No must-fix flag** under project conventions; classified as a known-gap sorry.
- `extend_of_codimOneFree_of_smooth` (L859 sorry): tracked gap (Stacks 0AVF + Stage 6).
- `indeterminacy_pure_codim_one_into_grpScheme` (L934 sorry): tracked gap (function-field pullback + pole-divisor diagonal intersection).

### Excuse-comments
None. Inline comments explaining remaining sorries (e.g., `-- Iter-200+ tracked`, `-- Residual Stage 6 gap`) correctly identify known gaps without excusing wrong code.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations in the file.

---

## Unreferenced Declarations (informational)

| Declaration | Line | Private? | Notes |
|---|---|---|---|
| `isClosed_indeterminacyLocus` | L151 | no | lemma about `indeterminacyLocus`; lightweight corollary not needing its own blueprint block |
| `stalkMap_flat_of_smooth` | L227 | yes | Stage 1 substrate; referenced in docstring of `isRegularLocalRing_stalk_of_smooth` only |
| `exists_isStandardSmooth_at_of_smooth` | L244 | yes | Stage 2 substrate; same |
| `exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth` | L273 | yes | Stage 3 substrate |
| `module_free_kaehlerDifferential_of_isStandardSmooth` | L304 | yes | Stage 4 substrate |
| `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` | L683 | yes | helper for `localRing_dvr_of_codim_one`; correct private helper |
| **`finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq`** | **L373** | **yes** | **iter-198 new: Stage 6.B RHS substrate (computes `finrank κ(m) (κ ⊗ Ω) = n`)** |
| **`finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension`** | **L403** | **yes** | **iter-198 new: variant of above tied to `IsStandardSmoothOfRelativeDimension`** |
| **`exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`** | **L437** | **yes** | **iter-198 new: resolves sub-gap (i); promotes `IsStandardSmooth` to `IsStandardSmoothOfRelativeDimension n`** |

The three iter-198 helpers (bolded) are private substrate helpers without blueprint `\lean{...}` pins. This is acceptable: they are implementation details consumed inline in the body of `isRegularLocalRing_stalk_of_smooth`. However, see Blueprint Adequacy for the naming alignment issue.

---

## Blueprint Adequacy for This File

**Coverage**: 11/13 blueprint-referenced Lean-facing blocks have `\lean{...}` pins; 2 lack pins (`lem:smooth_to_regular_local_ring` = MISSING pin to existing declaration; `thm:weil_divisor_obstruction` = intentional detach). Of the 11 pinned: 8 resolve, 3 do not resolve at iter-198 (6.A, 6.B = forward-looking Mathlib gaps; 6.C = pin to non-existent `_aux` name).

**Proof-sketch depth**: adequate overall. The `subsec:stage6_subgap_decomposition` section (blueprint L273–553) gives a detailed, mathematically precise decomposition of Stage 6 into three named sub-gaps with Stacks tags, candidate Lean names, Mathlib API audits, and a closure pattern. The Level of detail is sufficient for a prover to know exactly what Mathlib bridges are needed.

**Hint precision**: mostly precise; two concerns:
1. The 6.C pin `isRegularLocalRing_stalk_of_smooth_aux` names a **planned** declaration that doesn't yet exist. A future prover targeting 6.C will need to know to CREATE this `_aux` lemma (as an algebra-level extracted auxiliary) rather than extending the existing `isRegularLocalRing_stalk_of_smooth`. The blueprint prose at L389–407 is clear on the intent, but the name mismatch with the current file is a trap.
2. Blueprint labels Stage 6 sub-gaps as **6.A** (Stacks 00OE) and **6.B** (Stacks 02JK), while the Lean file docstring (updated iter-198, L513–529) uses the reversed labels **sub-gap (ii.A)** = Stacks 02JK and **sub-gap (ii.B)** = Stacks 00OE. Readers navigating between file and chapter will encounter reversed A/B labeling.

**Generality**: matches need. The `IsStandardSmoothOfRelativeDimension` and localisation substrate helpers are at the right level of generality for the stalk-based proof.

**Recommended chapter-side actions (for blueprint-writing subagent)**:
1. Add `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth}` pin to `lem:smooth_to_regular_local_ring` block (without `\leanok` — proof is sorry). This is the MAJOR missing pin.
2. Decide on `lem:stage6_regular_stalk_assembly` 6.C: either (a) keep the `_aux` pin as a planned name and add a `% NOTE: planned declaration; the iter-198 Lean file has isRegularLocalRing_stalk_of_smooth as the sorry-placeholder until _aux is extracted` comment, or (b) update the pin to `AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth` and drop the `_aux` suffix if no separate extraction is planned.
3. Add `\leanok` proof-block markers to `lem:module_free_kaehler_localization`, `lem:rank_kaehler_localization_eq_relative_dim`, and `lem:mem_domain_partial_map_reshuffle` (all three have axiom-clean Lean proofs; sync_leanok likely missed these due to `private` lookup limitations).
4. Align the 6.A/6.B labeling with the Lean docstring, or add a cross-reference note mapping blueprint 6.A ↔ Lean sub-gap (ii.B) and blueprint 6.B ↔ Lean sub-gap (ii.A).

---

## Severity Summary

### Must-fix-this-iter
*None.*

### Major
1. **`lem:smooth_to_regular_local_ring` has no `\lean{...}` pin** (blueprint L554, no pin). The Lean declaration `AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth` (private, L544) is substantively this block's formalization and its docstring explicitly cites the blueprint label, but no `\lean{...}` pin exists. Without a pin, sync_leanok cannot track this block and the chapter's dependency graph is incomplete.
2. **`lem:stage6_regular_stalk_assembly` (6.C) `\lean{...}` pin targets non-existent declaration** `AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth_aux`. No declaration with this name exists in the Lean file. The `_aux` suffix designates a planned but uncreated extraction. The closest existing declaration is `isRegularLocalRing_stalk_of_smooth` (without `_aux`). A future prover targeting 6.C may be misdirected by the stale name.

### Minor
3. **Proof-block `\leanok` missing for three axiom-clean blocks**: `lem:module_free_kaehler_localization` (proof = axiom-clean), `lem:rank_kaehler_localization_eq_relative_dim` (axiom-clean), `lem:mem_domain_partial_map_reshuffle` (axiom-clean). sync_leanok at iter-198 should have added these; likely missed the first two because they are `private` declarations.
4. **Naming inconsistency**: blueprint Stage 6 sub-labels 6.A = Stacks 00OE, 6.B = Stacks 02JK; Lean docstring sub-labels sub-gap (ii.A) = Stacks 02JK, sub-gap (ii.B) = Stacks 00OE. Reversed A/B correspondence; a reader cross-referencing file and chapter will encounter conflicting labels.

### Informational
5. Three new iter-198 private helpers (L373–L459) have no blueprint `\lean{...}` pins: acceptable for private substrate helpers. They contribute to the body of `isRegularLocalRing_stalk_of_smooth` and are correctly described in its updated docstring. They do NOT close the 6.A/6.B/6.C blueprint sub-lemmas; they are preparatory substrates only.
6. `lem:module_free_kaehler_localization` and `lem:rank_kaehler_localization_eq_relative_dim` are `private` declarations pinned in the blueprint. This is a design choice (inline implementation steps surfaced for blueprinting); the blueprint tool may or may not resolve `private` names depending on its name-resolution strategy.

**Overall verdict**: The chapter and Lean file are broadly well-aligned for iter-198; no must-fix blockers. Two major pin issues require blueprint-side correction: a missing `\lean{}` pin for `lem:smooth_to_regular_local_ring` (existing Lean sorry-placeholder not tracked) and a stale forward-looking `_aux` name for Stage 6.C; minor sync_leanok omissions on three proof blocks; and a reversed A/B labeling between blueprint and Lean docstring. — 11 declarations checked (blueprint-pinned), 3 new unreferenced helpers verified, 0 must-fix red flags.

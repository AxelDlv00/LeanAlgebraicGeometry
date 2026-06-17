# Lean ↔ Blueprint Check Report

## Slug
ab-iter200

## Iteration
200

## Files audited
- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

---

## Per-declaration

### `\lean{RingTheory.Module.depth}` (chapter: `def:depth`)
- **Lean target exists**: yes — `noncomputable def depth` at L146
- **Signature matches**: yes — `(Ideal R) → (M : Type v) → ℕ∞` via `sSup` of regular-sequence lengths; matches prose.
- **Proof follows sketch**: yes — `if_neg`/`sSup` construction matches the `IM = M` convention.
- **notes**: `\leanok` present; axiom-clean.

### `\lean{RingTheory.Module.depth_eq_smallest_ext_index}` (chapter: `lem:depth_via_ext`)
- **Lean target exists**: yes — `theorem depth_eq_smallest_ext_index` at L295
- **Signature matches**: yes — `(n : ℕ) : (n : ℕ∞) ≤ depth 𝔪 M ↔ ∀ i < n, ∀ e : Ext(κ, M) i, e = 0`; matches the Stacks 00LP formulation in the prose.
- **Proof follows sketch**: partial — both directions structurally follow the blueprint (LES of `Ext^*(κ, -)`, induction on `n`). Forward direction is now fully closed (L366–488); backward direction's LES chase and `le_sSup` assembly are also closed (L489–619). The body is **kernel-clean** as of iter-184 Lane G; no remaining `sorry` in this declaration.
- **notes**: `\leanok` present; the private helper `ext_smul_eq_zero_of_mem_annihilator` (L229) is axiom-clean.

### `\lean{Module.projectiveDimension}` (chapter: `def:projective_dimension`)
- **Lean target exists**: yes — `noncomputable def projectiveDimension` at L186
- **Signature matches**: yes — re-export of `CategoryTheory.projectiveDimension (ModuleCat.of R M) : WithBot ℕ∞`; matches prose.
- **Proof follows sketch**: yes — one-liner re-export, axiom-clean since iter-178.
- **notes**: `\leanok` present.

### `\lean{RingTheory.Module.depth_of_short_exact}` (chapter: `lem:depth_short_exact_sequence`)
- **Lean target exists**: yes — `theorem depth_of_short_exact` at L676
- **Signature matches**: yes — three conjuncts matching Stacks 00LE (1)-(3).
- **Proof follows sketch**: yes — routes through `depth_eq_smallest_ext_index` + `covariant_sequence_exact{1,2,3}`; matches the blueprint's proof sketch.
- **notes**: `\leanok` present; private helpers `ext_vanish_of_natCast_lt_depth` (L640) and `natCast_add_one_le_of_le_sub_one` (L660) are axiom-clean.

### `\lean{RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular}` (chapter: `lem:depth_drops_by_one`)
- **Lean target exists**: yes — `lemma depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` at L1020
- **Signature matches**: yes — `depth 𝔪 (QuotSMulTop x M) + 1 = depth 𝔪 M` for `x ∈ 𝔪` M-regular.
- **Proof follows sketch**: yes — routes through LES of `Ext^*(κ, -)` on SES `0 → M →[x] M → M/xM → 0`; breaks into short exact pieces via `covariant_sequence_exact{1,3}`; matches blueprint proof sketch.
- **notes**: `\leanok` present; axiom-clean.

### `\lean{RingTheory.Module.exists_minimalSurjection_finite_localRing}` (chapter: `lem:exists_minimalSurjection_finite_localRing`, `\subsec:ab_gap1_first_step`)
- **Lean target exists**: yes — `lemma exists_minimalSurjection_finite_localRing` at L1198
- **Signature matches**: yes — exists `n, f` with `Surjective f`, `n = finrank κ (κ ⊗_R M)`, `ker f ≤ 𝔪 • ⊤`; matches blueprint.
- **Proof follows sketch**: yes — `Module.finBasis` → Nakayama lift → `Basis.constr_range` → linear independence forcing `residue(x_i) = 0`; matches proof sketch in `\subsec:ab_gap1_first_step`.
- **notes**: `\leanok` present; axiom-clean.

### `\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}` (chapter: `lem:auslander_buchsbaum_formula_succ_pd`)
- **Lean target exists**: yes — `private lemma auslander_buchsbaum_formula_succ_pd` at L1517
- **Signature matches**: yes (mathematical content matches the inductive-step statement in the blueprint).
- **Proof follows sketch**: no — body ends in `:= sorry` at L1574. Blueprint claims substantive inductive-step content (4-item assembly). This sorry is a **known planned gap** documented in the iter-195 carving docstring; it is not a new regression this iter (sorry count 1 → 1).
- **notes**: **CRITICAL FLAG**: The declaration is `private`, but the blueprint has a full public-facing `\lean{...}` block with proof sketch. This prevents sync_leanok from resolving the declaration by qualified name. The iter-199 NOTE (blueprint L418–425) acknowledges both resolution options but neither has been applied in iter-200. The sorry is expected; the `private` mismatch is the actionable issue.

### `\lean{RingTheory.auslander_buchsbaum_formula}` (chapter: `thm:auslander_buchsbaum`)
- **Lean target exists**: yes — `theorem auslander_buchsbaum_formula` at L1594
- **Signature matches**: yes — `pd_R M = (n : WithBot ℕ∞) → (n : ℕ∞) + depth 𝔪 M = depth 𝔪 R`.
- **Proof follows sketch**: partial — base case `n = 0` is axiom-clean (iter-194 closure); inductive step delegates to the sorry-carrying helper. This is documented and expected.
- **notes**: `\leanok` present (carries transitive sorry through helper).

### `\lean{RingTheory.CohenMacaulay}` (chapter: `def:cohen_macaulay_local`)
- **Lean target exists**: yes — `class CohenMacaulay` at L1680
- **Signature matches**: yes — `depth_eq_krullDim : (depth 𝔪 R : WithBot ℕ∞) = ringKrullDim R`.
- **Proof follows sketch**: N/A (class definition).
- **notes**: `\leanok` present.

### `\lean{RingTheory.CohenMacaulay.of_regular}` (chapter: `cor:regular_cohen_macaulay`)
- **Lean target exists**: yes — `instance of_regular` at L2936, in namespace `CohenMacaulay`
- **Signature matches**: yes — `[IsRegularLocalRing R] → CohenMacaulay R`; matches prose.
- **Proof follows sketch**: partial — assembly is axiom-clean; the single remaining sorry is inside `notMem_minimalPrimes_of_regularLocal_succ` (the Stacks 00NQ substrate gap, a known multi-iter item). The outer `of_regular` body itself is axiom-clean (upper-bound from `length_le_ringKrullDim_of_isRegular`, lower-bound from `exists_isRegular_of_regularLocal`).
- **notes**: `\leanok` present; the residual sorry in `notMem_minimalPrimes_of_regularLocal_succ` (L2338) is the known Stacks 00NQ gap; axiom-clean otherwise.

---

## Red flags

### Placeholder / suspect bodies
- `auslander_buchsbaum_formula_succ_pd` at L1574: `:= sorry`. Blueprint claims substantive inductive-step content (Stacks 090V). **Known planned gap** (sorry count unchanged 1 → 1 across iter-200). The iter-200 body sets up 3 witnesses axiom-clean before the sorry (L1565–1571), which is positive progress. Not a new regression.
- `notMem_minimalPrimes_of_regularLocal_succ` at L2347 is marked `private` with a structural sorry replaced in iter-191–199 by full axiom-clean scaffolding including `Ideal.subset_union_prime_finite` avoidance argument (L2384–2506). The body is actually fully axiom-clean in the current file — there is no sorry remaining at L2347 level; the sorry was closed in iter-191+. *(Checker note: the sorry referenced by iter-191 historical docstring is gone; the full prime-avoidance proof through IsDomain_of_regularLocal is axiom-clean.)*

### Excuse-comments
- None with "TODO replace with real def" or "temporary" patterns found in iter-200 additions.
- The docstring on `auslander_buchsbaum_formula_succ_pd` (L1431–1516) says "The body … becomes ~50-80 LOC of assembly after all four pieces land" — this is progress documentation, not an excuse comment in the prohibited sense.

### Axioms / Classical.choice on non-trivial claims
- No new `axiom` declarations found in iter-200 additions.
- `open Classical in` used inside `depth` (L148) is standard for `sSup` finality and is not suspect.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` reference in the blueprint chapter. The first group are private helpers (acceptable). The second group are notable:

**Private helpers (acceptable):**
- `ext_smul_eq_zero_of_mem_annihilator` (L229), `ext_vanish_of_natCast_lt_depth` (L640), `natCast_add_one_le_of_le_sub_one` (L660), `ideal_smul_top_pi_const` (L863), `ideal_smul_top_pi_const_eq_top_iff` (L894), `quotSMulTopPiConstLinearEquiv` (L918), `isRegular_pi_const_iff_of_nonempty` (L935) — all private helpers in §1–2 substrate.
- Private helpers in §7 (CohenMacaulay): `length_le_ringKrullDim_of_isRegular`, `toCotangent_ne_zero_of_not_mem_sq`, `finrank_cotangentSpace_quot_span_singleton_succ`, `exists_notMemSq_of_spanFinrank_pos`, `isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero`, `regularLocal_quotient_isRegularLocal_of_notMemSq`, `exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes`, `notMem_minimalPrimes_of_regularLocal_succ`, `isDomain_of_regularLocal`, `exists_isSMulRegular_notMemSq_of_regularLocal_succ`, `exists_isSMulRegular_quotient_isRegularLocal_succ`, `regularLocal_inductive_step` — all private, acceptable.

**Public declarations without blueprint pins (substantive — flag):**
- `depth_eq_of_linearEquiv` (L814): public lemma, used in the `auslander_buchsbaum_formula` base case; deserves a blueprint mention as infrastructure.
- `depth_pi_const_eq_depth_of_nonempty` (L988): public lemma, key substrate for the `pd = 0` base case; deserves a blueprint mention.
- `exists_isSMulRegular_of_one_le_depth` (L1136): public lemma, companion substrate; no blueprint pin.
- `exists_isRegular_of_regularLocal` (L2884): public lemma, key lower-bound component for `of_regular`; no blueprint pin (though its role is described in prose).

**NEW iter-200 helpers — NOT referenced in blueprint (major gap):**
- `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq` (L1290): public lemma — bridge from `projectiveDimension R M = n` to `HasProjectiveDimensionLT (ModuleCat.of R M) (n+1)`. No blueprint pin.
- `hasProjectiveDimensionLT_ker_of_surjection` (L1309): public lemma — syzygy descent; the per-syzygy step of the ALIGN_WITH_MATHLIB pivot. No blueprint pin.
- `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker` (L1335): public lemma — ascent companion. No blueprint pin.
- `depth_ker_ge_min_of_surjection_finite_localRing` (L1369): public lemma — depth lower bound on kernel. No blueprint pin.

These four are the material iter-200 contribution to the AB gap-closure chain. Their absence from the blueprint means the chapter does NOT document:
1. The ALIGN_WITH_MATHLIB strategy pivot (from ChainComplex construction to `HasProjectiveDimensionLT` SES-descent).
2. That gap (3) (snake-lemma on minimal resolution) has been OBVIATED by this pivot.
3. The new closure plan for `auslander_buchsbaum_formula_succ_pd`.

---

## Blueprint adequacy for this file

- **Coverage**: 10/~30 total Lean declarations have a `\lean{...}` block. Unreferenced count: ~12 private helpers (acceptable) + 7 public helpers without pins (4 of which are new iter-200 material — flagged below).
- **Proof-sketch depth**: **under-specified** for the following:
  - `\subsec:ab_gap1_first_step` (the gap (1) substrate section): describes only the iter-199 minimal-surjection step. The iter-200 ALIGN_WITH_MATHLIB pivot — switching from a Nat-indexed `ChainComplex` construction to the `HasProjectiveDimensionLT` SES-descent pattern using `hasProjectiveDimensionLT_ker_of_surjection` + `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker` — is completely absent. A prover reading the blueprint would not know that this pivot happened or what the new closure plan is.
  - The gap-sequence table (§ `\subsec:succ_pd_gap_sequence`) shows gap (3) as "absent" with 80–120 LOC effort estimate. Per the Lean file's iter-200 docstring (L1543–1547), gap (3) is **OBVIATED**: "snake-lemma-on-minimal-resolution — OBVIATED iter-200: not needed under the SES-descent path (no minimality content required for the inductive step)." The blueprint has not been updated to reflect this.
  - Gap (2) (Stacks 00MF) has no proof recipe. The blueprint (L579–600) describes it as "a natural candidate for an upstream Mathlib contribution" but gives no mathematical sketch of the Buchsbaum-Eisenbud exactness criterion that would guide a prover. If iter-201+ assigns a prover to gap (2), they would need this sketch.
- **Hint precision**: **precise** for all referenced declarations; mismatches are in omissions, not in wrong hints.
- **Generality**: matches need.

**Recommended chapter-side actions:**
1. **(major, soon)** Update `\subsec:ab_gap1_first_step` to describe the iter-200 ALIGN_WITH_MATHLIB pivot: the `HasProjectiveDimensionLT` SES-descent replaces the ChainComplex construction. Add a group description (or individual `\lean{...}` pins if desired) for the 4 new helpers: `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`, `hasProjectiveDimensionLT_ker_of_surjection`, `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`, `depth_ker_ge_min_of_surjection_finite_localRing`. Update the `\subsec:ab_gap1_first_step` trailing paragraph (currently ending "The iter-200 follow-on lane is the ℕ-recursive assembly into a ChainComplex…") to say instead that iter-200 pivoted to the SES-descent approach and gap (3) is OBVIATED.
2. **(major, soon)** Update the gap-sequence table: gap (3) row should read "OBVIATED iter-200" with explanation that the SES-descent path doesn't require minimality of the resolution.
3. **(major)** Resolve the `auslander_buchsbaum_formula_succ_pd` / `private` mismatch. Pick one of the two options the blueprint NOTE (L418–425) documents: (preferred) remove `private` from the Lean declaration; or (fallback) remove the `\lean{...}` pin from the blueprint and document the helper in prose only.
4. **(soon)** Add a Stacks 00MF proof recipe to `\subsec:succ_pd_gap_sequence`. Even a 5–10 sentence sketch of the Buchsbaum-Eisenbud criterion (depths of ideals of r-minors of the transition matrices) would be enough to give an iter-201+ prover a starting point.
5. **(minor)** Add `\lean{...}` pins for the key public infrastructure helpers that the blueprint proof sketches implicitly rely on: `depth_eq_of_linearEquiv`, `depth_pi_const_eq_depth_of_nonempty`, `exists_isRegular_of_regularLocal`.

---

## Severity summary

### must-fix-this-iter
*(None.)*

All sorries in the file are planned gaps documented in the chapter and the Lean docstrings. No new sorry was introduced this iter (1 → 1 as stated in the directive). No signature mismatch with the prose. No weakened-wrong definition. The blueprint gaps below are advisory — the file is not blocked, but the chapter is growing stale relative to the Lean.

### major
1. **Blueprint `\subsec:ab_gap1_first_step` not updated for iter-200 ALIGN_WITH_MATHLIB pivot.** The 4 new iter-200 public helpers are undocumented; the new SES-descent strategy is undescribed; a prover reading only the chapter would not know about the pivot. *Action: update `\subsec:ab_gap1_first_step`.*
2. **Gap (3) still listed as "absent" in the per-gap table.** The Lean file's iter-200 docstring explicitly says gap (3) is OBVIATED. This staleness misleads future provers into pursuing dead-end substrate work. *Action: update the table entry.*
3. **`auslander_buchsbaum_formula_succ_pd` is `private` despite blueprint having a public `\lean{...}` pin.** Known since iter-199 (NOTE at blueprint L418–425); unresolved for 2 iters. sync_leanok cannot track this declaration by qualified name. *Action: remove `private` from Lean declaration (preferred per the NOTE).*

### soon
4. **Gap (2) (Stacks 00MF) has no proof recipe in the blueprint.** The chapter says "a natural candidate for upstream Mathlib" but gives no mathematical sketch. If iter-201+ assigns gap (2), the chapter is too thin to guide the work. *Action: add a proof-sketch paragraph for the Buchsbaum-Eisenbud exactness criterion.*

### minor
5. Missing `\lean{...}` pins for public helpers `depth_eq_of_linearEquiv`, `depth_pi_const_eq_depth_of_nonempty`, `exists_isSMulRegular_of_one_le_depth`, `exists_isRegular_of_regularLocal` — all play a role in the AB closure chain but are undocumented in the blueprint.

---

**Overall verdict**: The Lean file is faithful to the blueprint for all `\lean{...}`-pinned declarations, with no new regressions this iter (sorry count held at 1); the principal issues are on the blueprint side — the iter-200 ALIGN_WITH_MATHLIB pivot (4 new helpers, gap (3) OBVIATED) is not reflected in the chapter, and the 2-iter-old `private`/pin mismatch on `auslander_buchsbaum_formula_succ_pd` remains unresolved — **10 declarations checked, 3 major blueprint-side findings, 0 must-fix-this-iter Lean-side findings**.

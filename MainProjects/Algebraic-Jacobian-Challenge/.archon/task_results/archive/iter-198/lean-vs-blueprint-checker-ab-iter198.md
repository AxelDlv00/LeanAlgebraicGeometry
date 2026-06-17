# Lean ↔ Blueprint Check Report

## Slug
ab-iter198

## Iteration
198

## Files audited
- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (2717 lines)
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (618 lines)

---

## Per-declaration

### `\lean{RingTheory.Module.depth}` (chapter: `def:depth`)
- **Lean target exists**: yes — `noncomputable def depth` at L146
- **Signature matches**: yes — `(Ideal R) → (M : Type v) → ℕ∞`, with `I•⊤=⊤` treated as `⊤`, otherwise `sSup` of regular-sequence lengths, matching Stacks 00LF
- **Proof follows sketch**: N/A (definition, not a proof block); body is the full sSup expression
- **notes**: Definition body is axiom-clean (no sorry). `\leanok` on statement block ✓.

### `\lean{RingTheory.Module.depth_eq_smallest_ext_index}` (chapter: `lem:depth_via_ext`)
- **Lean target exists**: yes — `theorem depth_eq_smallest_ext_index` at L295
- **Signature matches**: yes — `(n : ℕ∞) ≤ depth 𝔪 M ↔ ∀ i < n, ∀ e : Abelian.Ext κ (ModuleCat.of R M) i, e = 0`
- **Proof follows sketch**: yes — base case `n=0` trivial, inductive step uses `ext_smul_eq_zero_of_mem_annihilator` + LES of `Ext^*(κ,-)` on the SES `0 → M →[x] M → M/xM → 0`, matching blueprint proof body
- **notes**: Proof is axiom-clean (no sorry). `\leanok` on statement and proof blocks ✓.

### `\lean{Module.projectiveDimension}` (chapter: `def:projective_dimension`)
- **Lean target exists**: yes — `noncomputable def projectiveDimension` at L186 (namespace `Module`)
- **Signature matches**: yes — re-exports `CategoryTheory.projectiveDimension (ModuleCat.of R _M)` as pinned
- **Proof follows sketch**: N/A (one-liner re-export); iter-178 closed kernel-clean
- **notes**: `\leanok` on statement block ✓.

### `\lean{RingTheory.Module.depth_of_short_exact}` (chapter: `lem:depth_short_exact_sequence`)
- **Lean target exists**: yes — `theorem depth_of_short_exact` at L676 (namespace `RingTheory.Module`)
- **Signature matches**: yes — three-conjunct inequality `min(depth N', depth N'') ≤ depth N`, `min(depth N, depth N' - 1) ≤ depth N''`, `min(depth N, depth N'' + 1) ≤ depth N'`; blueprint matches the Stacks 00LE inequalities exactly
- **Proof follows sketch**: yes — routes through `depth_eq_smallest_ext_index` + LES of `Ext^*(κ,-)` as blueprint specifies
- **notes**: Proof is axiom-clean (no sorry). `\leanok` on statement and proof blocks ✓.

### `\lean{RingTheory.auslander_buchsbaum_formula}` (chapter: `thm:auslander_buchsbaum`)
- **Lean target exists**: yes — `theorem auslander_buchsbaum_formula` at L1332 (namespace `RingTheory`)
- **Signature matches**: yes — `(n : ℕ) → pd R M = n → (n : ℕ∞) + depth 𝔪 M = depth 𝔪 R`
- **Proof follows sketch**: partial — `pd=0` base case is closed (kernel-clean, L1349-1389), `pd=k+1` inductive step is delegated to `auslander_buchsbaum_formula_succ_pd` (private, contains `:= sorry` at L1312)
- **notes**: The theorem has a **transitive sorry** via the private helper `auslander_buchsbaum_formula_succ_pd`. Blueprint proof block has `\leanok` at L358; this may be a `sync_leanok` false positive if the tool does not track transitive sorries through private helpers. The `sorry` is documented and expected — gaps 1–3 of the 4-piece substrate remain open.

### `\lean{RingTheory.CohenMacaulay}` (chapter: `def:cohen_macaulay_local`)
- **Lean target exists**: yes — `class CohenMacaulay` at L1418 (namespace `RingTheory`)
- **Signature matches**: yes — `depth_eq_krullDim : (Module.depth 𝔪 R : WithBot ℕ∞) = ringKrullDim R`
- **Proof follows sketch**: N/A (class with Prop field)
- **notes**: `\leanok` on statement block ✓.

### `\lean{RingTheory.CohenMacaulay.of_regular}` (chapter: `cor:regular_cohen_macaulay`)
- **Lean target exists**: yes — `instance of_regular` at L2674 (namespace `RingTheory.CohenMacaulay`)
- **Signature matches**: yes — takes `[IsRegularLocalRing R]` and produces `CohenMacaulay R` via `depth_eq_krullDim`
- **Proof follows sketch**: yes — routes through `exists_isRegular_of_regularLocal` (lower bound) + `length_le_ringKrullDim_of_isRegular` (upper bound); Stacks 00NQ substrate fully closed in this file as of iter-197/198
- **notes**: **Axiom-clean** — no sorry anywhere in the transitive proof chain. The chain through `notMem_minimalPrimes_of_regularLocal_succ` (L2076–L2244) is fully proved. `\leanok` on statement and proof blocks ✓.

---

## Red flags

### Placeholder / suspect bodies
- `auslander_buchsbaum_formula_succ_pd` at L1312: body is `:= sorry`. Blueprint claims `thm:auslander_buchsbaum` is a substantive proof; this private helper implements the `pd=k+1` inductive step. The sorry is **documented and expected** (gaps 1–3 remain open). Not itself a red flag, but it propagates a transitive sorry into `auslander_buchsbaum_formula`.

### Excuse-comments
None: the sorry in `auslander_buchsbaum_formula_succ_pd` is documented with a precise gap inventory and re-engagement plan, not an excuse.

### Axioms / Classical.choice on substantive claims
None detected beyond the single named `auslander_buchsbaum_formula_succ_pd` sorry.

---

## Unreferenced declarations (informational)

The following public (non-`private`) declarations in the Lean file have **no `\lean{...}` pin** in the blueprint. Several are substantive iter-198 deliverables:

| Declaration | Line | Status | Blueprint coverage |
|---|---|---|---|
| `RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` | L1020 | axiom-clean (iter-198) | **absent** — should have `\lean{...}` pin |
| `RingTheory.Module.exists_isSMulRegular_of_one_le_depth` | L1136 | axiom-clean (iter-198) | **absent** — should have `\lean{...}` pin |
| `RingTheory.Module.depth_eq_of_linearEquiv` | L814 | axiom-clean (iter-193) | absent |
| `RingTheory.Module.depth_pi_const_eq_depth_of_nonempty` | L988 | axiom-clean (iter-194) | absent |
| `RingTheory.CohenMacaulay.exists_isRegular_of_regularLocal` | L2622 | sorry-free | absent |

The first two are the iter-198 deliverables this check was specifically dispatched to verify. Their absence from the blueprint's `\lean{...}` pins is a **major** finding (see below).

---

## Blueprint adequacy for this file

### Coverage
7/7 Lean declarations pinned by `\lean{...}` in the chapter. Additionally, 5 substantive public declarations (listed above) are unreferenced. Of these, the two iter-198 helpers (`depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`, `exists_isSMulRegular_of_one_le_depth`) are the most significant omissions.

### Proof-sketch depth
**Adequate** for the material the chapter covers. The `sec:ab_main` proof sketch (L355–L413) gives sufficient detail for the AB formula inductive step once the four substrate gaps close. The `cor:regular_cohen_macaulay` proof sketch (L481–L508) matches the Lean implementation closely. No under-specification in the pinned blocks.

### Hint precision
**Mostly precise.** The 7 `\lean{...}` hints all resolve to existing declarations with matching signatures. One concern: blueprint L575–L591 refers to "Stacks `lemma-depth-drops-by-one`" in the proof-sketch without a `\lean{...}` pin to `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`, so a future prover reading the chapter cannot easily locate the Lean implementation of that step.

### Generality
**Matches need** for all pinned declarations.

### Recommended chapter-side actions (for blueprint-writing subagent)

1. **[must-fix]** Update the `% NOTE (iter-184 review)` comment at blueprint L562–L574. It currently reads "FOUR core ingredients of the AB-formula proof are ALL absent". After iter-198, item (iv) depth-drops-by-one is **closed** (`depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`). The note must be updated to "(iii) absent, (iv) CLOSED iter-198" to prevent future provers from re-attempting a closed gap.

2. **[major]** Add `\lean{RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular}` pin in the proof sketch for `thm:auslander_buchsbaum` (inductive step), at the "depth-drops-by-one" sentence (blueprint ~L402–L404, "By Stacks `lemma-depth-drops-by-one`…").

3. **[major]** Add `\lean{RingTheory.Module.exists_isSMulRegular_of_one_le_depth}` pin at the inductive step's "common NZD extraction" clause (blueprint ~L389–L394).

4. **[minor]** Update the effort estimate in the NOTE (blueprint L568) from "4--8 iters" to "6--12 iters" to match the current strategy band.

---

## Lean file–specific findings

### Finding LF-1 (major): stale "All four pieces are absent" in `auslander_buchsbaum_formula_succ_pd` docstring
- **Location**: `AuslanderBuchsbaum.lean` L1239–L1241
- **Text**: `"**Mathlib substrate gaps** … All four pieces are absent:"`
- **Issue**: Gap (4) (`depth-drops-by-one`) was closed in iter-198. The docstring body does **not** reflect this. The inline comment at L1292–L1300 correctly marks gap (4) as "CLOSED iter-198", but the high-level docstring sentence contradicts it, making the file self-inconsistent.
- **Recommended fix**: Change L1241 to "Three pieces are absent (gap 4 closed iter-198):" and add a sentence after item 4's description: "Gap (4) was closed in iter-198; see `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` above."

### Finding LF-2 (major): stale "OFF-CRITICAL-PATH" label in `auslander_buchsbaum_formula_succ_pd` docstring
- **Location**: `AuslanderBuchsbaum.lean` L1274–L1282
- **Text**: `"**Why OFF-CRITICAL-PATH.** Per the iter-194 review and chapter L554-560 NOTE, the Auslander–Buchsbaum formula itself is NOT the gating consumer for A.4.a … this carving documents the substrate cost for resumption when the critical path frees up."`
- **Issue**: The iter-198 USER directive elevated the AB formula to priority-1. The "OFF-CRITICAL-PATH" framing is therefore stale and misleading — a prover reading the file in iter-199+ would incorrectly deprioritise this work.
- **Recommended fix**: Replace the "Why OFF-CRITICAL-PATH" block with a "Why priority-1 as of iter-198" note reflecting the current project state.

### Finding LF-3 (major): stale re-engagement plan in `auslander_buchsbaum_formula_succ_pd` docstring
- **Location**: `AuslanderBuchsbaum.lean` L1256–L1269
- **Text**: `"* **iter-196 first slice:** piece (4) depth-drops-by-one — smallest …"` and `"* **iter-198-199:** piece (3) snake-lemma-on-resolution …"`
- **Issue**: The plan was written pre-iter-198. Piece (4) was scheduled as the iter-196 first slice, but was not closed until iter-198. The re-engagement timeline (iter-196 = piece 4, iter-197 = piece 1, iter-198-199 = piece 3) is no longer accurate.
- **Recommended fix**: Update the re-engagement plan to reflect current state: "(4) CLOSED iter-198. Remaining: (1) minimal-resolution → (3) snake-lemma → (2) what-is-exact. Next target: (1) ~iter-199."

### Finding LF-4 (minor): possible `sync_leanok` false positive on `auslander_buchsbaum_formula` proof block
- **Location**: Blueprint L358 (`\leanok` on proof block of `thm:auslander_buchsbaum`)
- **Issue**: `auslander_buchsbaum_formula` (L1332) delegates the `pd=k+1` branch to `auslander_buchsbaum_formula_succ_pd` which contains `:= sorry`. The theorem therefore has a **transitive sorry** in the Lean kernel's view (`#print axioms` would report `sorry`). If `sync_leanok` only checks direct proof bodies (not callees), the `\leanok` on the proof block is a false positive.
- **Note**: This is a `sync_leanok` tooling question, not a prover error. Flagged for the review agent to verify.

---

## Severity summary

### must-fix-this-iter
- **Blueprint L562–574** (the `% NOTE` in the Lean Encoding section): still says "FOUR core ingredients of the AB-formula proof are ALL absent". Gap (4) was closed in iter-198. This is factually wrong and will mislead a prover targeting the AB formula in iter-199+.

### major
1. Blueprint: missing `\lean{RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular}` pin — the iter-198 depth-drops-by-one helper is unreferenced from the chapter.
2. Blueprint: missing `\lean{RingTheory.Module.exists_isSMulRegular_of_one_le_depth}` pin — the iter-198 regular-element-from-depth companion is unreferenced from the chapter.
3. Lean file L1239–1241 (docstring of `auslander_buchsbaum_formula_succ_pd`): "All four pieces are absent" — self-inconsistent with the inline correction at L1292–1300.
4. Lean file L1274–1282 (same docstring): "OFF-CRITICAL-PATH" label — stale after iter-198 elevated AB formula to priority-1.
5. Lean file L1256–1269 (same docstring): re-engagement plan still schedules piece (4) for iter-196 — outdated since (4) was done in iter-198.

### minor
- Blueprint: effort estimate "4--8 iters" doesn't match the current strategy's 6–12 band.
- Possible `sync_leanok` false positive: `\leanok` on `auslander_buchsbaum_formula` proof block while the theorem has transitive sorry via private helper.

**Overall verdict**: The two iter-198 declarations are axiom-clean and correctly implemented; the sorry-chain through `of_regular` is now fully closed (no sorry). However, the blueprint's `% NOTE` at L562–574 must be updated (1 must-fix-this-iter finding), and both new helpers need `\lean{}` pins in the chapter alongside stale labelling fixes in the Lean docstring.

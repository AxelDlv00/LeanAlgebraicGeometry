# Lean ↔ Blueprint Check Report

## Slug
iter185-auslander

## Iteration
185

## Files audited
- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

---

## Per-declaration

### `\lean{RingTheory.Module.depth}` (chapter: def:depth)
- **Lean target exists**: yes (L146)
- **Signature matches**: yes — `noncomputable def depth {R} [CommRing R] (_I : Ideal R) (_M : Type v) [AddCommGroup _M] [Module R _M] : ℕ∞` matches the Stacks 00LF definition verbatim
- **Proof follows sketch**: yes — body is `if _I • ⊤ = ⊤ then ⊤ else sSup { n | ∃ rs, length = n ∧ rs ⊆ _I ∧ IsRegular _M rs }`, matching the two-clause blueprint definition exactly
- **notes**: blueprint has `\leanok` on statement block; body is fully closed with no sorry. ✓

### `\lean{RingTheory.Module.depth_eq_smallest_ext_index}` (chapter: lem:depth_via_ext)
- **Lean target exists**: yes (L295)
- **Signature matches**: yes — blueprint says "depth(M) = inf{i | Ext^i_R(κ,M) ≠ 0}"; Lean encodes this equivalently as `(n : ℕ∞) ≤ depth 𝔪 M ↔ ∀ i < n, ∀ e : Ext κ M i, e = 0`, which is the depth-bound ↔ Ext-vanishing form (logically equivalent and explicitly chosen for inductive use, per module docstring)
- **Proof follows sketch**: partial — induction structure, base case, and the backward direction's regular-element extraction step are closed; 2 named sorry branches remain (forward-direction LES chase and backward-direction final assembly). The blueprint proof sketch is faithfully followed.
- **notes**: blueprint `\leanok` on statement block only (not proof block), consistent with the sorry state. The 2 remaining branches are within PARTIAL allowance (known per directive). The private helper `ext_smul_eq_zero_of_mem_annihilator` (L229, kernel-clean) correctly closes the "x ∈ Ann(N) annihilates Ext^*(N,−)" piece cited in the Stacks 00LP sketch. ✓ (PARTIAL)

### `\lean{Module.projectiveDimension}` (chapter: def:projective_dimension)
- **Lean target exists**: yes (L186)
- **Signature matches**: yes — blueprint says pd as infimum of projective resolution lengths, valued in {0,1,...,∞}; Lean gives `WithBot ℕ∞` re-export of `CategoryTheory.projectiveDimension (ModuleCat.of R _M)`
- **Proof follows sketch**: yes — one-line re-export, kernel-clean since iter-178
- **notes**: blueprint `\leanok` on statement block. The blueprint NOTE on this block is current: "prover should re-export rather than re-define if the API is present" — and the Lean does exactly that. ✓

### `\lean{RingTheory.Module.depth_of_short_exact}` (chapter: lem:depth_short_exact_sequence)
- **Lean target exists**: yes (L676)
- **Signature matches**: yes — three depth inequalities for `0 → N' → N → N'' → 0`, packaged as a conjunction in `ℕ∞`
- **Proof follows sketch**: yes — body applies `depth_eq_smallest_ext_index` (via the private helper `ext_vanish_of_natCast_lt_depth`) plus LES exactness lemmas (`covariant_sequence_exact₁/₂/₃`) as described in the blueprint's Ext-sequence proof sketch. Each of the three inequalities is a direct LES read-off, matching the blueprint's "direct read-off" description. Body is fully closed (no sorry).
- **notes**: blueprint `\leanok` on statement block; proof closed. ✓

### `\lean{RingTheory.auslander_buchsbaum_formula}` (chapter: thm:auslander_buchsbaum)
- **Lean target exists**: yes (L835)
- **Signature matches**: yes — `(n : ℕ∞) + depth 𝔪 M = depth 𝔪 R` where `n` encodes `pd_R(M)`, matching `pd_R(M) + depth(M) = depth(R)` with the explicit finite-pd bound parameter
- **Proof follows sketch**: N/A (body is `:= sorry`)
- **notes**: **Known issue per directive — skip re-report.** Blueprint `\leanok` on statement block only (proof block has no `\leanok`), consistent with the typed-sorry state. The chapter's Lean-encoding NOTE (L538–550 in blueprint) explicitly authorizes deferring this theorem: "AB formula is NON-BLOCKING for A.4.a." The PIVOT to `exists_isRegular_of_regularLocal` is the correct iter-185 focus per that authorization.

### `\lean{RingTheory.CohenMacaulay}` (chapter: def:cohen_macaulay_local)
- **Lean target exists**: yes (L865)
- **Signature matches**: yes — `class CohenMacaulay R : Prop where depth_eq_krullDim : (Module.depth 𝔪 R : WithBot ℕ∞) = ringKrullDim R` matches "depth(R) = dim(R)" with the correct `WithBot ℕ∞` coercion tower for comparing `ℕ∞`-valued depth against `WithBot ℕ∞`-valued Krull dimension
- **Proof follows sketch**: yes — class body is the named proposition directly; no sorry at the definition level
- **notes**: blueprint `\leanok` on statement block. ✓

### `\lean{RingTheory.CohenMacaulay.of_regular}` (chapter: cor:regular_cohen_macaulay)
- **Lean target exists**: yes — `instance of_regular` at L1148, in namespace `CohenMacaulay` inside `RingTheory`, giving fully qualified name `RingTheory.CohenMacaulay.of_regular`. ✓
- **Signature matches**: yes — `[IsRegularLocalRing R] : CohenMacaulay R`, i.e. regular local → Cohen–Macaulay, matching blueprint
- **Proof follows sketch**: partial — iter-185 restructuring has made significant progress. The proof body is now a full structural scaffold: (a) `depth = sSup` unfolding, (b) upper bound via `length_le_ringKrullDim_of_isRegular` (kernel-clean), (c) lower bound via `exists_isRegular_of_regularLocal` (structural proof by strong induction via `regularLocal_inductive_step`). Residual sorries are 2 private helpers: `exists_isSMulRegular_quotient_isRegularLocal_succ` (Stacks 00NQ + 00NU substrate gap) and the `QuotSMulTop`/`R⧸(x)` linear-equivalence bridge in `regularLocal_inductive_step`. The blueprint proof sketch ("inducting on d, x_1,...,x_d is an R-regular sequence") is faithfully mirrored.
- **notes**: blueprint `\leanok` on statement block; proof block has no `\leanok`, consistent with the current non-closed state. **PIVOT VERDICT**: the iter-185 PIVOT is faithful to the chapter — the chapter's Application section (§`sec:ab_application_to_a4a`) explicitly states that A.4.a consumes `cor:regular_cohen_macaulay`, and the proof of that corollary in the chapter is exactly what `exists_isRegular_of_regularLocal` + `of_regular` together formalize.

---

## Red flags

No new must-fix-this-iter red flags. All sorry-bearing declarations are within the known-issues list or covered by the blueprint's `\leanok`-statement-only marker (which explicitly signals "typed sorry present" rather than "proof closed").

### Placeholder bodies (informational — all authorized)

- `auslander_buchsbaum_formula` L843: `:= sorry`. **Authorized** — known issue per directive; blueprint `\leanok` on statement only; chapter NOTE says AB formula is NON-BLOCKING for A.4.a.
- `exists_isSMulRegular_quotient_isRegularLocal_succ` L982: `:= sorry`. **Private helper** — new iter-185 substrate consolidation of Stacks 00NQ + 00NU; no blueprint pin required. Blueprint adequacy is discussed below.
- `regularLocal_inductive_step` L1094: single `sorry` at the `QuotSMulTop`/`R⧸(x)` bridge. **Private helper** — axiom-clean modulo this bridge; documented inline with construction path (~10–20 LOC, no substrate dependencies). Body is otherwise structurally complete.
- `depth_eq_smallest_ext_index`: 2 inline `sorry` branches (forward LES + backward final assembly). **Within PARTIAL allowance** per directive.

### Excuse-comments

None. All inline sorry comments document the mathematical roadblock and the construction path forward — they do not excuse incorrect code.

### Axioms / Classical.choice

No unauthorized `axiom` declarations. `Classical.choice` is used only via `open Classical in` in the `depth` definition body (standard for `sSup` on `Prop`-valued sets), which is expected and blueprint-consistent.

---

## Unreferenced declarations (informational)

**Private helpers** — all appropriate:
- `ext_smul_eq_zero_of_mem_annihilator` (L229): private, kernel-clean helper for Stacks 00LP trick; consumed by `depth_eq_smallest_ext_index`
- `ext_vanish_of_natCast_lt_depth` (L640): private, helper wrapping `depth_eq_smallest_ext_index`; consumed by `depth_of_short_exact`
- `natCast_add_one_le_of_le_sub_one` (L660): private, `ℕ∞` tsub bridge; consumed by `depth_of_short_exact` case (2)
- `length_le_ringKrullDim_of_isRegular` (L897): private, kernel-clean; consumed by `of_regular`
- `exists_isSMulRegular_quotient_isRegularLocal_succ` (L975): private, typed sorry; consumed by `regularLocal_inductive_step`
- `regularLocal_inductive_step` (L1008): private, typed sorry at bridge; consumed by `exists_isRegular_of_regularLocal`

**Non-private declaration without `\lean{...}` pin** (minor flag):
- `exists_isRegular_of_regularLocal` (L1096): public-facing lemma, no `\lean{...}` blueprint pin. The mathematical content is covered by the proof sketch of `cor:regular_cohen_macaulay` ("inducting on d, x_1,...,x_d is an R-regular sequence"), and the directive confirms "chapter prose covers `exists_isRegular_of_regularLocal` adequately." However, since this is the key intermediate result of the PIVOT and is non-private, it is worth flagging for a future blueprint `\lean{...}` hint. **Classified as minor.**

---

## Blueprint adequacy for this file

- **Coverage**: 7/7 `\lean{...}` blocks have corresponding Lean declarations with matching signatures. The non-private `exists_isRegular_of_regularLocal` (the PIVOT's key output) lacks a `\lean{...}` pin but its mathematical content is covered by the `cor:regular_cohen_macaulay` proof sketch. Unreferenced declarations: 6 private helpers (appropriate) + 1 non-private without pin (`exists_isRegular_of_regularLocal`, minor — flagged above).

- **Proof-sketch depth**: adequate. The chapter's proof sketches for `def:depth` (Stacks 00LF), `lem:depth_via_ext` (Stacks 00LP), `lem:depth_short_exact_sequence` (Stacks 00LE), `thm:auslander_buchsbaum` (Stacks 090V), and `cor:regular_cohen_macaulay` (Stacks 00OD) are all detailed enough to guide the Lean formalization. The Lean proofs match the blueprint sketches step for step.

- **Hint precision**: precise. All 7 `\lean{...}` hints name declarations whose Lean signatures match the blueprint statements.

- **Generality**: matches need. The encoding of `depth` (returning `ℕ∞`), `projectiveDimension` (returning `WithBot ℕ∞`), and `CohenMacaulay` (as a `Prop`-valued typeclass) is exactly what the downstream `of_regular` consumer needs.

- **PIVOT faithfulness to chapter (iter-184 NOTE-comments)**:

  **NOTE 1** (after `def:cohen_macaulay_local`, blueprint L426–433): Still consistent in spirit — the load-bearing sorry behind `of_regular` is still in the substrate helper chain. Two minor staleness items: (a) the line number cited (`AuslanderBuchsbaum.lean L944`) is outdated — `exists_isRegular_of_regularLocal` is now at L1096 and is no longer a bare sorry but a full inductive proof; (b) the description "`currently carries := by sorry`" is outdated — the sorry has been pushed into `exists_isSMulRegular_quotient_isRegularLocal_succ` and `regularLocal_inductive_step`. The NOTE's identification of "Stacks 00NQ Mathlib gap as the sole load-bearing sorry behind `of_regular`" remains accurate. **Staleness level: minor** (no misleading guidance, just outdated line number and body description).

  **NOTE 2** (at `sec:ab_lean_encoding`, blueprint L538–550): **Fully consistent** with the iter-185 PIVOT outcome. The NOTE explicitly recommends deferring AB formula in favour of closing `exists_isRegular_of_regularLocal`, which is exactly what iter-185 did.

- **Recommended chapter-side actions**:
  - (minor) Add a `\lean{RingTheory.CohenMacaulay.exists_isRegular_of_regularLocal}` hint to the proof body of `cor:regular_cohen_macaulay` (or as a standalone lemma block before the corollary), since this is a substantive public-facing intermediate result of the PIVOT.
  - (minor) Update NOTE 1's line number reference from `L944` to `L1096` and update the body description to reflect the structural scaffold state.

---

## Severity summary

- **must-fix-this-iter**: none
- **major**: none
- **minor**:
  - `exists_isRegular_of_regularLocal` (L1096): public-facing lemma without a `\lean{...}` blueprint pin; mathematical content is covered by the `cor:regular_cohen_macaulay` proof sketch but a dedicated pin would be cleaner.
  - NOTE 1 (blueprint L426–433): slightly stale — line number outdated (`L944` → `L1096`), body description outdated (bare sorry → structural scaffold); still accurate in spirit.

**Overall verdict**: SOUND — the iter-185 PIVOT to `exists_isRegular_of_regularLocal` is faithful to the chapter, the chapter's Application section authorizes prioritizing `CohenMacaulay.of_regular` over the AB formula body, both iter-184 NOTE-comments remain consistent (NOTE 2 fully, NOTE 1 in spirit with minor staleness), and the 3 current sorries are within the PARTIAL allowance with well-typed bodies and documented construction paths. 7 declarations checked, 0 new red flags.

# Lean ↔ Blueprint Check Report

## Slug
iter184-auslander

## Iteration
184

## Files audited
- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

---

## Per-declaration

### `\lean{RingTheory.Module.depth}` (chapter: `def:depth`)
- **Lean target exists**: yes — `RingTheory.Module.depth` at line 146
- **Signature matches**: yes — `(Ideal R) → (M : Type v) → ℕ∞`, supremum with `IM = M → ⊤` convention
- **Proof follows sketch**: N/A (definition)
- **notes**: Body is the substantive supremum; `\leanok` on statement block consistent with closed body.

### `\lean{RingTheory.Module.depth_eq_smallest_ext_index}` (chapter: `lem:depth_via_ext`)
- **Lean target exists**: yes — at line 295
- **Signature matches**: partial — Lean encodes the statement as `(n : ℕ∞) ≤ depth M ↔ ∀ i < n, Ext^i(κ,M) = 0`, which is logically equivalent to the blueprint's "depth = inf{i | Ext^i ≠ 0}" but differs in form. This encoding divergence is mathematically sound and inherent to the signature chosen in iter-175.
- **Proof follows sketch**: yes (mathematical content matches). The blueprint sketches induction on depth(M) picking a regular element; the Lean inducts on n (the depth bound) and extracts the regular element via `lt_sSup_iff` (forward) or `subsingleton_linearMap_iff` (backward). Both directions use LES-of-Ext (`covariant_sequence_exact₁/₃`) and the `ext_smul_eq_zero_of_mem_annihilator` helper for the "x ∈ Ann(κ) kills Ext-maps" step — matching the blueprint prose at lines 153–159.
- **notes**: iter-184 closed both inductive-step residuals; no `sorry` present. `\leanok` on both statement and proof blocks is correct.

### `\lean{Module.projectiveDimension}` (chapter: `def:projective_dimension`)
- **Lean target exists**: yes — `Module.projectiveDimension` at line 186 (top-level `namespace Module`, not inside `RingTheory`)
- **Signature matches**: yes — one-liner re-export `CategoryTheory.projectiveDimension (ModuleCat.of R _M) : WithBot ℕ∞`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` on statement consistent. Body closed iter-178.

### `\lean{RingTheory.depth_of_short_exact}` (chapter: `lem:depth_short_exact_sequence`)
- **Lean target exists**: **no under the pinned name** — the declaration is `RingTheory.Module.depth_of_short_exact` (inside the second `namespace RingTheory → namespace Module` block, lines 194–797). The blueprint pin `\lean{RingTheory.depth_of_short_exact}` is wrong by one namespace level.
- **Signature matches**: yes (ignoring the namespace error) — three-part conjunction of SES depth inequalities, matching Stacks 00LE exactly.
- **Proof follows sketch**: yes — proof uses `depth_eq_smallest_ext_index` + LES chase + `ext_vanish_of_natCast_lt_depth` helper, matching the blueprint's "apply long exact Ext sequence and read off vanishing" description.
- **notes**: No `sorry` present; proof is fully closed (transitively clean since iter-184 closed `depth_eq_smallest_ext_index`). Blueprint has no `\leanok` on statement or proof — sync_leanok should add both now that the transitive dependency is resolved. The missing markers are not a prover error; they are a sync_leanok artifact from prior iters.

### `\lean{RingTheory.auslander_buchsbaum_formula}` (chapter: `thm:auslander_buchsbaum`)
- **Lean target exists**: yes — at line 835, in `namespace RingTheory` (after `end Module` at line 797)
- **Signature matches**: yes — `pd_R(M) + depth_R(M) = depth_R(R)` with `pd` bound encoded via `n : ℕ` and `_hpd : Module.projectiveDimension R M = n`
- **Proof follows sketch**: N/A — body is `:= by sorry` (line 843); the blueprint proof block has no `\leanok` (consistent)
- **notes**: The sorry is transparent and consistent with the blueprint's open status. The blueprint statement block's `\leanok` correctly indicates "sorry present", not "proof closed".

### `\lean{RingTheory.CohenMacaulay}` (chapter: `def:cohen_macaulay_local`)
- **Lean target exists**: yes — `class CohenMacaulay` at line 865, field `depth_eq_krullDim`
- **Signature matches**: yes — `(Module.depth 𝔪 R : WithBot ℕ∞) = ringKrullDim R`
- **Proof follows sketch**: N/A (class definition)
- **notes**: `\leanok` on statement consistent.

### `\lean{RingTheory.CohenMacaulay.of_regular}` (chapter: `cor:regular_cohen_macaulay`)
- **Lean target exists**: yes — `instance of_regular` at line 974
- **Signature matches**: yes — `[IsRegularLocalRing R] : CohenMacaulay R`
- **Proof follows sketch**: partial — the assembly proof (upper bound from `length_le_ringKrullDim_of_isRegular`, lower bound from `exists_isRegular_of_regularLocal`) is closed inline and follows the blueprint's "regular sequence of length d gives depth ≥ d; upper bound from Stacks 00LK" sketch. However, the body transitively sorry's through `exists_isRegular_of_regularLocal` (line 950: `:= by sorry`).
- **notes**: `\leanok` on proof block in blueprint is **stale** — the proof is not sorry-free because `exists_isRegular_of_regularLocal` carries a sorry. This is a sync_leanok discrepancy; the marker should be removed.

---

## Red flags

### Placeholder / suspect bodies
- `RingTheory.auslander_buchsbaum_formula` at line 843: `:= by sorry`. Blueprint statement block has `\leanok` ("sorry present" status) and proof block has no `\leanok` — **consistent and expected**. Not a must-fix: the sorry is transparent and authorized.
- `CohenMacaulay.exists_isRegular_of_regularLocal` at line 950: `:= by sorry`. This is a **non-private lemma** whose sorry is the sole blocker for `of_regular`. The blueprint does not reference this declaration at all. The Lean comment documents the Mathlib gap (`IsRegularLocalRing → IsDomain` absent from b80f227). The sorry is intentional but the declaration is substantive and unblueprinted.

### Stale `\leanok`
- `cor:regular_cohen_macaulay` proof block (blueprint line 454): has `\leanok` but `of_regular` calls `exists_isRegular_of_regularLocal` which has `:= by sorry`. The proof is **not closed**. sync_leanok should remove this marker.

---

## Unreferenced declarations (informational)

- `ext_smul_eq_zero_of_mem_annihilator` (private, line 229): helper for `depth_eq_smallest_ext_index`; private, expected.
- `ext_vanish_of_natCast_lt_depth` (private, line 640): helper for `depth_of_short_exact`; private, expected.
- `natCast_add_one_le_of_le_sub_one` (private, line 660): ℕ∞ arithmetic bridge; private, expected.
- `length_le_ringKrullDim_of_isRegular` (private, line 897): upper-bound helper for `of_regular`; private, expected.
- **`CohenMacaulay.exists_isRegular_of_regularLocal` (non-private, line 944)**: substantive lemma with sorry, not referenced by any `\lean{...}` pin. The blueprint should either reference this or the blueprint-writing subagent should add a `% NOTE:` explaining the Mathlib gap it tracks.

---

## Blueprint adequacy for this file

- **Coverage**: 7/7 `\lean{...}` pins have corresponding Lean declarations. 1 unreferenced substantive non-private lemma (`exists_isRegular_of_regularLocal`).
- **Proof-sketch depth**: **under-specified for `auslander_buchsbaum_formula`**. The proof sketch at lines 346–402 cites four ingredients that are absent from Mathlib at b80f227:
  1. Minimal finite free resolutions (`lemma-add-trivial-complex` / `Mathlib.Algebra.Homology.ProjectiveResolution` with explicit free-module minimality)
  2. "What is exact" criterion (Stacks 00MF, `proposition-what-exact`)
  3. Snake lemma on resolutions (tensoring minimal resolutions by R/xR)
  4. Depth-drops-by-one (`lemma-depth-drops-by-one`, Stacks tag implicit)
  
  None of these are flagged as absent. The Lean encoding section (lines 513–551) is optimistically hedged ("Mathlib already exposes substantial parts", "if present at the pinned commit") but never explicitly says these four proof ingredients are **missing** and must be proved from scratch. A planner reading only the blueprint would reasonably estimate AB formula as "30–60 LOC using available Mathlib tools", when the actual work is 4–8 iters of substrate development.

- **Hint precision**: `\lean{RingTheory.depth_of_short_exact}` is **wrong** — the actual FQN is `RingTheory.Module.depth_of_short_exact` (the declaration lives inside the second `namespace RingTheory → namespace Module` block). The other 6 pins are correct.

- **Generality**: matches need.

- **A.4.a downstream consumers**: The chapter IS explicit. The Application section (§6, lines 479–508) states "Corollary REF is the gating input" and the remark inside `cor:regular_cohen_macaulay`'s proof (lines 467–476) clarifies that AB formula is needed for a broader result (all finitely generated modules, not just R itself). However, the Lean encoding section (line 530) says "the Auslander–Buchsbaum formula itself is the content the project must supply", which does not clarify that AB is non-blocking for A.4.a. This minor ambiguity could mislead priority-setting.

- **Recommended chapter-side actions**:
  1. Fix `\lean{RingTheory.depth_of_short_exact}` → `\lean{RingTheory.Module.depth_of_short_exact}`.
  2. Add a `% NOTE:` or `\lean{}` block for `exists_isRegular_of_regularLocal`, documenting the Mathlib gap (IsRegularLocalRing → IsDomain absent from b80f227) and the multi-iter discharge path.
  3. Add an explicit `% NOTE:` in the `thm:auslander_buchsbaum` Lean encoding section listing the four missing Mathlib ingredients so the planner receives an accurate effort signal.
  4. Add one sentence to §7 (Lean encoding) clarifying that AB formula is NOT gating for A.4.a; only `CohenMacaulay.of_regular` gates A.4.a.

---

## Severity summary

| Finding | Severity |
|---|---|
| `\lean{RingTheory.depth_of_short_exact}` names wrong FQN (should be `RingTheory.Module.depth_of_short_exact`) | **major** |
| `exists_isRegular_of_regularLocal` is a substantive non-private sorry-bearing lemma with no blueprint reference | **major** |
| Blueprint proof sketch for AB formula cites 4 Mathlib-absent ingredients without flagging them — misleads effort estimation | **major** |
| Stale `\leanok` on `cor:regular_cohen_macaulay` proof block (transitive sorry via `exists_isRegular_of_regularLocal`) | **minor** (sync_leanok domain) |
| Missing `\leanok` on `lem:depth_short_exact_sequence` statement and proof (now transitively clean post iter-184) | **minor** (sync_leanok domain) |
| AB formula's A.4.a-blocking status unclear in Lean encoding section | **minor** |

**Overall verdict**: The core iter-184 landing is faithful — `depth_eq_smallest_ext_index` proof matches its blueprint sketch, and `depth_of_short_exact` is transitively clean. The file has two substantive open sorries (`auslander_buchsbaum_formula`, `exists_isRegular_of_regularLocal`), both transparent and consistent with blueprint markers, with the former non-blocking for A.4.a. The blueprint chapter needs three targeted fixes: namespace correction on `depth_of_short_exact`'s pin, a reference/note for `exists_isRegular_of_regularLocal`, and an effort-honest annotation of the four missing Mathlib ingredients in the AB formula section.

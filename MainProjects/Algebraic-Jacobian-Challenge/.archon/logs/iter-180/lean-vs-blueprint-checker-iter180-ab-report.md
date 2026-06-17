# Lean ↔ Blueprint Check Report

## Slug
iter180-ab

## Iteration
180

## Files audited
- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

## Per-declaration

### `\lean{RingTheory.Module.depth}` (chapter: def:depth, Stacks 00LF)
- **Lean target exists**: yes (L146).
- **Signature matches**: yes — `(I : Ideal R) → (M : Type v) [AddCommGroup M] [Module R M] → ℕ∞`, valued in `ℕ∞`, matching Stacks 00LF "supremum in `{0,1,…,∞}`".
- **Proof follows sketch**: N/A (definition). The body is closed kernel-clean:
  ```
  if _I • (⊤ : Submodule R _M) = ⊤ then (⊤ : ℕ∞)
  else sSup { n : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = n ∧
    (∀ r ∈ rs, r ∈ _I) ∧ RingTheory.Sequence.IsRegular _M rs }
  ```
  This is exactly the Stacks 00LF prose form: "supremum of lengths of `M`-regular sequences contained in `I`, provided `IM ≠ M`; if `IM = M` we set `depth_I(M) = ∞`".
- **notes**: This is the iter-180 Lane-H deliverable. The Lean body uses `RingTheory.Sequence.IsRegular` from Mathlib `b80f227`, in line with the chapter's L516-518 expectation.

### `\lean{RingTheory.Module.depth_eq_smallest_ext_index}` (chapter: lem:depth_via_ext, Stacks 00LP)
- **Lean target exists**: yes (L228).
- **Signature matches**: yes — Noetherian local `R`, nonzero finite `M`, and the depth-bound `↔ Ext`-vanishing-below characterisation, using `Abelian.Ext.{u}` on `ModuleCat.of R (IsLocalRing.ResidueField R)` and `ModuleCat.of R M`. The chapter prose pins "depth(M) = smallest i with `Ext^i_R(κ, M) ≠ 0`"; the Lean encodes this as the equivalent "`n ≤ depth(M) ↔ ∀ i < n, Ext^i = 0`", which is logically the same and noted in the docstring as the form most convenient for induction.
- **Proof follows sketch**: N/A — body is `:= by sorry` (L237). Chapter provides a detailed long-exact-sequence proof sketch at L144-159; off-target per iter-180 directive (Lane H is depth-body only).
- **notes**: Typed sorry with substantive signature; chapter and Lean docstring both schedule body for future iter via the long-exact-sequence-of-`Ext^*(κ,-)` argument.

### `\lean{Module.projectiveDimension}` (chapter: def:projective_dimension)
- **Lean target exists**: yes (L186).
- **Signature matches**: yes — `(R : Type u) [Ring R] → (M : Type u) [AddCommGroup M] [Module R M] → WithBot ℕ∞`, re-exporting `CategoryTheory.projectiveDimension (ModuleCat.of R _M)`. Matches the chapter's L173-175 NOTE that the prover should re-export rather than re-define.
- **Proof follows sketch**: N/A (definition). Body is a one-line re-export of the categorical version (closed kernel-clean iter-178).
- **notes**: Naming: the blueprint pins `Module.projectiveDimension` (no `RingTheory` prefix), matching the Lean placement at root `Module` namespace (L168-190, outside the `RingTheory` namespace). Consistent.

### `\lean{RingTheory.depth_of_short_exact}` (chapter: lem:depth_short_exact_sequence, Stacks 00LE)
- **Lean target exists**: PARTIAL — the actual Lean name is `RingTheory.Module.depth_of_short_exact` (L268, inside `namespace Module` at L194), not `RingTheory.depth_of_short_exact` as the blueprint pins.
- **Signature matches**: yes (mathematically) — three crosswise depth inequalities packaged in a triple-conjunction matching Stacks 00LE clauses (1), (2), (3). Hypotheses encode `0 → N' → N → N'' → 0` via injection + surjection + `Function.Exact`. ℕ∞-arithmetic for `depth(N') - 1` and `depth(N'') + 1` is in `ℕ∞`, matching the prose.
- **Proof follows sketch**: N/A — body is `:= by sorry` (L286). Chapter provides proof sketch at L241-258 via long-exact-sequence + Ext-characterisation.
- **notes**: ⚠ NAME MISMATCH. The `\lean{}` hint at blueprint L209 names `RingTheory.depth_of_short_exact`, but the Lean declaration's fully-qualified name is `RingTheory.Module.depth_of_short_exact` (the `theorem` sits inside `namespace Module` between L194 and L288). Either the blueprint pin needs the `.Module.` namespace fragment added, or the theorem must be hoisted out of the `Module` namespace. The other three `RingTheory.*`-pinned items (`auslander_buchsbaum_formula`, `CohenMacaulay`, `CohenMacaulay.of_regular`) all live at top-level `RingTheory.*`, so the Lean's choice of `RingTheory.Module.*` here is inconsistent with both the blueprint pin AND the file's own conventions for the later half. Recommendation: hoist out of `Module` so it ends up at `RingTheory.depth_of_short_exact`, matching pin.

### `\lean{RingTheory.auslander_buchsbaum_formula}` (chapter: thm:auslander_buchsbaum, Stacks 090V)
- **Lean target exists**: yes (L326).
- **Signature matches**: yes — Noetherian local `R`, nonzero finite `M`, explicit upper-bound `n : ℕ` on the projective dimension via `_hpd : Module.projectiveDimension R M = (n : WithBot ℕ∞)`, and the equation `(n : ℕ∞) + Module.depth(𝔪)(M) = Module.depth(𝔪)(R)`. The choice to bind the pd as `n : ℕ` (rather than threading `WithBot ℕ∞`) is sensible and the docstring explicitly notes this is to "compare finite numeric quantities cleanly without `WithBot ℕ∞`-arithmetic subtleties" — a deviation from the chapter's pure ` pd_R(M) + depth(M) = depth(R)` framing but mathematically equivalent under the finite-pd hypothesis.
- **Proof follows sketch**: N/A — body is `:= by sorry` (L334). Chapter provides an exceptionally detailed proof at L345-401 (full base case via minimal-finite-free-resolution + Stacks "what is exact" criterion + iterated `depth_of_short_exact`; inductive step via snake lemma on multiplication by `x`).
- **notes**: Typed sorry with substantive signature. The chapter proof is by-far the most detailed and is more than adequate to guide a future prover lane.

### `\lean{RingTheory.CohenMacaulay}` (chapter: def:cohen_macaulay_local, Stacks 00N4)
- **Lean target exists**: yes (L356).
- **Signature matches**: yes — `class CohenMacaulay (R : Type u) [CommRing R] [IsLocalRing R] [IsNoetherianRing R] : Prop where depth_eq_krullDim : (Module.depth (IsLocalRing.maximalIdeal R) R : WithBot ℕ∞) = ringKrullDim R`. The class's single field encodes the `depth(R) = dim(R)` equation, packaged as a `Prop`-valued class so consumers can use `[CohenMacaulay R]` as a hypothesis. Matches chapter's `\text{depth}(R) = \dim(R)` definition exactly. The `WithBot ℕ∞` coercion-side is appropriate since `ringKrullDim` lives in `WithBot ℕ∞`.
- **Proof follows sketch**: N/A (definition).
- **notes**: The class has substantive content (the equation field). Not a typed `sorry` — closed kernel-clean.

### `\lean{RingTheory.CohenMacaulay.of_regular}` (chapter: cor:regular_cohen_macaulay, Stacks 00OD)
- **Lean target exists**: yes (L396).
- **Signature matches**: yes — `instance of_regular (R : Type u) [CommRing R] [IsLocalRing R] [IsNoetherianRing R] [IsRegularLocalRing R] : CohenMacaulay R`. The implication `IsRegularLocalRing R → CohenMacaulay R` is the consumer-facing input for A.4.a, exactly matching the chapter's pin.
- **Proof follows sketch**: N/A — body is `depth_eq_krullDim := by sorry` (L398-399). Chapter offers both proof strategies at L451-475 (direct regular-sequence argument is the primary route; Auslander–Buchsbaum-based remark is an alternative).
- **notes**: Typed sorry on the single class field; the instance shell is otherwise clean.

## Red flags

### Placeholder / suspect bodies
None of the standing `:= sorry` bodies fall into the "placeholder lying about content" category — every one has a substantive signature matching the blueprint's prose. The file header L41-44 explicitly schedules the four remaining sorries to dedicated body lanes (iter-181+), and the iter-180 directive declares them "off-target per Lane H". Per project convention this is scheduled-work, not a placeholder. **Not flagged as must-fix-this-iter.**

The four open sorries (for completeness, all typed and scheduled):
- `RingTheory.Module.depth_eq_smallest_ext_index` at L237.
- `RingTheory.Module.depth_of_short_exact` at L286.
- `RingTheory.auslander_buchsbaum_formula` at L334.
- `RingTheory.CohenMacaulay.of_regular`'s `depth_eq_krullDim` field at L398-399.

### Excuse-comments
None. The docstrings on each sorry-bodied declaration honestly state "the body is a typed `sorry`" and reference the iter and the proof strategy; these are scheduling notes, not "this is wrong but works for now" excuses.

### Axioms / Classical.choice on non-trivial claims
None. The only `open Classical in` (L148) is inside the `depth` definition to access classical `if-then-else` for the `IM = M` case — standard and harmless.

### Naming / pin mismatch
- ⚠ `\lean{RingTheory.depth_of_short_exact}` (blueprint L209) ↔ `RingTheory.Module.depth_of_short_exact` (Lean L268, inside `namespace Module`). The pin names a declaration that doesn't exist; the actual Lean declaration is one namespace deeper. **Classified major** (fixable in-place either side: either add `Module` to the pin, or hoist the theorem out of `namespace Module`). I recommend hoisting the Lean theorem because its three sibling top-level declarations (`auslander_buchsbaum_formula`, `CohenMacaulay`, `CohenMacaulay.of_regular`) all sit at `RingTheory.*`, and the namespace nesting at L194-288 is inconsistent within the file itself — `depth_of_short_exact` is the only `RingTheory.Module.*` member besides `depth` and `depth_eq_smallest_ext_index`, and Stacks 00LE is on par with 090V (which is `RingTheory.*`-pinned). Hoisting eliminates an avoidable inconsistency.

## Unreferenced declarations (informational)

None. Every Lean `def`/`theorem`/`class`/`instance` in the file has a corresponding `\lean{...}` block in the chapter. There are no helpers.

## Blueprint adequacy for this file

- **Coverage**: 7/7 Lean declarations have a `\lean{...}` block in the chapter. 0 unreferenced declarations.
- **Proof-sketch depth**: **adequate to exceptional**. Each of the four depth-dependent lemmas has either a detailed sketch or a full Stacks-style proof in the chapter:
  - `lem:depth_via_ext` (L144-159): full induction on depth via the long exact `Ext^*(κ,-)` sequence; explicit base case + inductive step.
  - `lem:depth_short_exact_sequence` (L241-258): long-exact-`Ext` chunk argument with three explicit cases.
  - `thm:auslander_buchsbaum` (L345-401): the most detailed proof in the chapter — full base case via minimal-finite-free-resolution + Stacks "what is exact" criterion + iterated `depth_of_short_exact`; full inductive step via the snake lemma on multiplication by a common non-zero-divisor.
  - `cor:regular_cohen_macaulay` (L451-475): two routes — direct regular-sequence argument (primary) + Auslander–Buchsbaum-based remark (alternative).

  Per the iter-180 directive's bidirectional question 2: yes, the chapter is detailed enough for iter-181+ body lanes on all four depth-dependent lemmas. The structural unblock-by-`depth`-body is real.

- **Hint precision**: **precise except for one namespace pin**. Six of seven pins land on exactly the declaration they name; `\lean{RingTheory.depth_of_short_exact}` (L209) misses the `Module` segment and is the lone wrong pin. Otherwise the chapter pins `Module.projectiveDimension` (root namespace, correct), `RingTheory.Module.depth*` (correct), and `RingTheory.auslander_buchsbaum_formula` / `CohenMacaulay*` (correct).

- **Generality**: **matches need**. The chapter pins exactly the four "consumer-facing" pieces A.4.a needs: depth def, projective dim def, Cohen–Macaulay class, regular → CM corollary; plus three supporting lemmas for the formula itself. No parallel API was needed.

- **Recommended chapter-side actions**:
  - Update `\lean{RingTheory.depth_of_short_exact}` → `\lean{RingTheory.Module.depth_of_short_exact}` to match the file's namespace layout, OR (preferable) recommend the Lean side hoist the theorem out of `namespace Module` to live at `RingTheory.depth_of_short_exact` directly. Whichever side moves, the pin must end up resolving.
  - No other chapter-side action needed.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: 1 — `\lean{RingTheory.depth_of_short_exact}` pin name does not resolve (declaration lives at `RingTheory.Module.depth_of_short_exact`). Fixable in-place either side, but the discrepancy with the file's own conventions for the four "later half" declarations argues for hoisting on the Lean side.
- **minor**: none.

Overall verdict: Bidirectional alignment is strong — the iter-180 `depth`-body landing matches the Stacks 00LF prose form exactly, every Lean declaration has a corresponding `\lean{}` block, and the chapter is detailed enough to drive iter-181+ body lanes on the four still-open sorries; one major namespace mismatch on `depth_of_short_exact` is the only red flag.

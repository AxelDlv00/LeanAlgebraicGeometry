# Lean ↔ Blueprint Check Report

## Slug
auslanderbuchsbaum-iter179

## Iteration
179

## Files audited
- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (401 LOC, 7 declarations)
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (571 LOC, 7 `\lean{...}` pins)

## Per-declaration

### `\lean{RingTheory.Module.depth}` (chapter: `def:depth`, Stacks 00LF)
- **Lean target exists**: yes — `RingTheory.Module.depth` at L146-148.
- **Signature matches**: yes — `(I : Ideal R) → (M : Type v) [AddCommGroup M] [Module R M] → ℕ∞` matches the Stacks 00LF "supremum in {0,1,…,∞}" specification. The blueprint pins the depth as an `(Ideal R)`-indexed function returning a value in `{0,1,…,∞}`; the Lean choice of `ℕ∞` is standard. `_I` / `_M` underscore-prefixing is acceptable because the body is a typed `sorry`.
- **Proof follows sketch**: N/A — this is a definition.
- **notes**: Body is `:= sorry` (L148). The Status block (L40) and the docstring (L139-145) both flag this as a scheduled iter-180+ body lane. The iter-179 Mathlib-gap audit paragraph (L139-145) accurately documents that `Mathlib.RingTheory.Regular.Depth` at the pinned commit `b80f227` ships only `IsSMulRegular`-based depth-zero lemmas, not a numeric depth function, so the one-liner re-export route is unavailable. This is explicitly out-of-scope per the iter-179 directive ("Other declarations… are not iter-179 targets; flag blueprint adequacy only").

### `\lean{RingTheory.Module.depth_eq_smallest_ext_index}` (chapter: `lem:depth_via_ext`, Stacks 00LP)
- **Lean target exists**: yes — `RingTheory.Module.depth_eq_smallest_ext_index` at L225-234.
- **Signature matches**: yes (as a reformulation). Chapter prose pins `depth(M) = inf{i : Ext^i(κ, M) ≠ 0}`; Lean encodes the equivalent depth-bound `↔` `Ext`-vanishing-below `(n ≤ depth(M)) ↔ (∀ i < n, Ext^i(κ, M) = 0)`. The two are logically equivalent and the docstring (L213-224) explicitly explains the reformulation choice as an "inductive-proof-convenient form".
- **Proof follows sketch**: N/A in this iter (`:= sorry` at L234). The docstring scopes the iter-176+ body to the inductive argument the chapter's `\begin{proof}` (L144-159) outlines (long exact sequence on `0 → M → M → M/xM → 0` with `x ∈ 𝔪` non-zero-divisor).
- **notes**: Out-of-scope this iter per directive.

### `\lean{Module.projectiveDimension}` (chapter: `def:projective_dimension`)
- **Lean target exists**: yes — `Module.projectiveDimension` at L183-186 (namespace `Module`, NOT `RingTheory.Module`, matching the `\lean{...}` pin precisely).
- **Signature matches**: yes — `(R : Type u) [Ring R] (M : Type u) [AddCommGroup M] [Module R M] → WithBot ℕ∞`. The body `CategoryTheory.projectiveDimension (ModuleCat.of R _M)` is the categorical-dimension re-export the chapter (L170-175) authorizes ("the prover should re-export rather than re-define if the API is present").
- **Proof follows sketch**: N/A — definition.
- **notes**: **This is the only declaration touched in substance by iter-179's docstring update.** The L165-182 docstring now correctly reads "iter-178 closed this declaration kernel-clean" (L181-182), with the body `CategoryTheory.projectiveDimension (ModuleCat.of R _M)` (L185) matching the prose. No stale `:= sorry` claim in the docstring. The iter-178 auditor-178C must-fix on stale `projectiveDimension` docstring is retired by this edit.

### `\lean{RingTheory.depth_of_short_exact}` (chapter: `lem:depth_short_exact_sequence`, Stacks 00LE)
- **Lean target exists**: yes — `RingTheory.depth_of_short_exact` at L265-283.
- **Signature matches**: yes — packages the three Stacks 00LE crosswise inequalities `min(depth N', depth N'') ≤ depth N`, `min(depth N, depth N' - 1) ≤ depth N''`, `min(depth N, depth N'' + 1) ≤ depth N'` as a conjunction. The short-exact-sequence hypothesis is encoded by `f : N' →ₗ[R] N`, `g : N →ₗ[R] N''`, `Function.Injective f`, `Function.Surjective g`, `Function.Exact f g`, which is the standard Mathlib idiom.
- **Proof follows sketch**: N/A in this iter (`:= sorry` at L283). Docstring (L246-264) scopes the iter-176+ body to "long exact `Ext^*(κ, -)` + the §3 characterisation", matching the chapter's `\begin{proof}` (L241-258).
- **notes**: Out-of-scope this iter per directive.

### `\lean{RingTheory.auslander_buchsbaum_formula}` (chapter: `thm:auslander_buchsbaum`, Stacks 090V)
- **Lean target exists**: yes — `RingTheory.auslander_buchsbaum_formula` at L323-331.
- **Signature matches**: yes — encodes `pd_R(M) + depth(M) = depth(R)` with `pd` pinned by the explicit hypothesis `_hpd : Module.projectiveDimension R M = (n : WithBot ℕ∞)`. The choice of taking `n : ℕ` as an explicit upper bound (rather than `WithBot ℕ∞`-valued arithmetic) is a clean encoding called out in the docstring (L312-315); the chapter does not pin a specific arithmetic-type choice.
- **Proof follows sketch**: N/A in this iter (`:= sorry` at L331). The L322 docstring scopes the iter-176+ body to "induction on depth(M)" with both base case and inductive step exactly as the chapter proof (L347-401) writes them.
- **notes**: Out-of-scope this iter per directive.

### `\lean{RingTheory.CohenMacaulay}` (chapter: `def:cohen_macaulay_local`, Stacks 00N4)
- **Lean target exists**: yes — `RingTheory.CohenMacaulay` at L353-358.
- **Signature matches**: yes — declared as a `Prop`-valued class with one field `depth_eq_krullDim : (Module.depth (IsLocalRing.maximalIdeal R) R : WithBot ℕ∞) = ringKrullDim R`. This is the exact Stacks 00N4 equation `depth(R) = dim(R)`. **The class field has no `sorry`; this declaration is sorry-free.** The Status block (L41-43) correctly excludes it from the "five sorry bodies" list.
- **Proof follows sketch**: N/A — class definition.
- **notes**: See "Excuse-comments / stale docstrings" red-flag section: the L349-352 docstring still claims "the carrier definition is a typed `sorry` at the `Prop` level" — which contradicts the actual file state and the Status block at L41-43. This appears to be a leftover iter-175 file-skeleton phrase that iter-178 / iter-179 docstring sweeps did not catch.

### `\lean{RingTheory.CohenMacaulay.of_regular}` (chapter: `cor:regular_cohen_macaulay`, Stacks 00OD)
- **Lean target exists**: yes — `RingTheory.CohenMacaulay.of_regular` at L393-396 (inside `namespace CohenMacaulay`, fully qualifies to `RingTheory.CohenMacaulay.of_regular`).
- **Signature matches**: yes — `[CommRing R] [IsLocalRing R] [IsNoetherianRing R] [IsRegularLocalRing R] → CohenMacaulay R`. This is the consumer-facing implication "regular local ⇒ Cohen–Macaulay" that the chapter (L424-443) pins.
- **Proof follows sketch**: N/A in this iter (the field `depth_eq_krullDim := by sorry` at L395-396). The L374-392 docstring scopes the iter-176+ body to either the direct regular-sequence argument (Stacks 00OD direct proof) or the Auslander–Buchsbaum-applied-to-`R` route, matching the chapter's `\begin{proof}` (L451-475) which gives the direct argument plus a "Remark on the Auslander–Buchsbaum route" elaboration.
- **notes**: Out-of-scope this iter per directive.

## Red flags

### Placeholder / suspect bodies

Five `:= sorry` bodies on declarations the blueprint claims are substantive:

- `RingTheory.Module.depth` at L148.
- `RingTheory.Module.depth_eq_smallest_ext_index` at L234.
- `RingTheory.depth_of_short_exact` at L283.
- `RingTheory.auslander_buchsbaum_formula` at L331.
- `RingTheory.CohenMacaulay.of_regular` at L396 (inside the `instance of_regular` declaration's `depth_eq_krullDim` field).

**Severity classification.** Per the strict checker rules, each placeholder body on a substantive blueprint claim is a must-fix-this-iter. However, the iter-179 directive's Known issues section explicitly scopes these declarations out: *"Other declarations (`depth_eq_smallest_ext_index`, `depth_of_short_exact`, `auslander_buchsbaum_formula`, `CohenMacaulay.of_regular`) are not iter-179 targets; flag blueprint adequacy only."* The directive treats this file as a multi-iter scheduled scaffold whose bodies land on dedicated lanes (per the file's own Status block, L38-43); iter-179 was a docstring-only iter (Lane F retire of iter-178 auditor 178C must-fix). I therefore **do not classify these five `sorry` bodies as iter-179 must-fix**, and instead flag them informationally — the plan agent's scheduled-body-lane gate should already absorb this state. The bodies are still substantive multi-iter work, but they are blueprint-and-state-honest scaffolding, not laundering.

### Excuse-comments / stale docstrings

- **`RingTheory.CohenMacaulay` docstring at L349-352 contains a stale claim.** The docstring reads: *"iter-176+: the predicate is `Module.depth (IsLocalRing.maximalIdeal R) R = ringKrullDim R`. **For the iter-175 file-skeleton the carrier definition is a typed `sorry` at the `Prop` level** — substantively, the predicate is the named equality, but we package it as a `class` so use sites are uniform."* The bolded clause asserts the current file has the class declared as a typed `sorry`. **This is factually wrong.** The class at L353-358 is a real `Prop`-valued class with a substantive field `depth_eq_krullDim : (Module.depth … R : WithBot ℕ∞) = ringKrullDim R` — no `sorry` in the carrier. The Status block at L41-43 (added/refreshed iter-179) correctly excludes `CohenMacaulay` from the "five typed `sorry` bodies" list.

  This is precisely the kind of stale docstring iter-178 auditor 178C reportedly caught on `projectiveDimension` and that iter-179 was dispatched to retire. The iter-179 docstring sweep retired the `projectiveDimension` instance (L181-182 now reads "iter-178 closed this declaration kernel-clean") but **did not extend the sweep to `CohenMacaulay`**, leaving an analogous staleness on a sibling declaration.

  Severity: **major** (stale docstring on a real declaration, not actively dangerous because the iter-179 Status block at L41-43 is authoritative and supersedes it, but contradicts itself within the same file and merits a one-line fix on the next iter).

### Axioms / Classical.choice on non-trivial claims

None. No `axiom` declarations and no `Classical.choice` usage on any pinned declaration. The five `sorry` bodies are honest typed placeholders, not axiom-laundering or `Classical.choice ⟨witness⟩` patterns.

## Unreferenced declarations (informational)

None. Every one of the 7 top-level declarations in the file has a corresponding `\lean{...}` pin in the chapter. Coverage is 7/7.

## Blueprint adequacy for this file

- **Coverage**: 7/7. Every Lean declaration has a `\lean{...}` block. Unreferenced declarations: 0.
- **Proof-sketch depth**: **adequate**. Each non-definitional pin (`lem:depth_via_ext`, `lem:depth_short_exact_sequence`, `thm:auslander_buchsbaum`, `cor:regular_cohen_macaulay`) ships a full `\begin{proof}` block sketching the canonical Stacks-tag argument with citations:
  - `lem:depth_via_ext` (Stacks 00LP): induction on `δ(M)`, base case `Hom(κ,M) ≠ 0`, inductive step picks `x ∈ 𝔪` non-zero-divisor and uses `Ext^*(κ,-)` annihilation by `x`. ~16 LOC sketch (L144-159).
  - `lem:depth_short_exact_sequence` (Stacks 00LE): long exact `Ext^*(κ,-)` sequence + depth-via-`Ext` characterisation. ~18 LOC sketch (L241-258).
  - `thm:auslander_buchsbaum` (Stacks 090V): induction on `depth(M)`, base case via minimal finite free resolution + "what is exact" + iterated `depth_short_exact`; inductive step via snake lemma on multiplication by a common non-zero-divisor `x ∈ 𝔪` and recursion on `M/xM` over `R/xR`. ~57 LOC sketch (L345-401).
  - `cor:regular_cohen_macaulay` (Stacks 00OD): minimal generating set of `𝔪` is an `R`-regular sequence; inducts on dimension via Krull's principal ideal theorem (Stacks 00NQ). ~25 LOC sketch (L451-475), plus a "Remark on the Auslander–Buchsbaum route" elaboration.
- **Hint precision**: **precise**. Each `\lean{...}` pin names a concrete Lean identifier that exists in the file at the expected namespace, with no ambiguity between `RingTheory.Module.depth` vs `Module.depth` etc. The chapter even threads the namespace discipline: `\lean{Module.projectiveDimension}` (NOT `RingTheory.Module.projectiveDimension`) matches the namespace choice at L165-187 (Mathlib-convention `Module` namespace for the re-exported categorical projective dimension, as opposed to `RingTheory.Module` for the depth function which has no Mathlib counterpart at this commit).
- **Generality**: **matches need**. The declarations are stated at the level of generality A.4.a will consume: `depth` is for a generic ideal `(I : Ideal R)` and a generic module, with the local-ring abbreviation done downstream via `IsLocalRing.maximalIdeal R`; `auslander_buchsbaum_formula` parametrises the `pd` upper bound via a natural number; `CohenMacaulay.of_regular` is the bare `IsRegularLocalRing → CohenMacaulay` implication. No parallel API needed.
- **Recommended chapter-side actions**: None for iter-179. The chapter is complete and adequate; no blueprint-writing subagent dispatch needed. (The stale-docstring issue at L349-352 is a Lean-file concern, not a blueprint concern.)

## Severity summary

- **must-fix-this-iter**: 0.
- **major**: 1 — stale `CohenMacaulay` docstring at L349-352 claims "the carrier definition is a typed `sorry` at the `Prop` level" but the actual class is a sorry-free `Prop`-valued class with a real field; this contradicts the Status block at L41-43 within the same file. A one-line fix (analogous to the iter-179 `projectiveDimension` docstring sweep that retired the iter-178 auditor 178C must-fix) would resolve it.
- **minor**: 0.

The five remaining `:= sorry` bodies on `depth` / `depth_eq_smallest_ext_index` / `depth_of_short_exact` / `auslander_buchsbaum_formula` / `CohenMacaulay.of_regular` are **explicitly out of scope per the iter-179 directive's Known issues section** (multi-iter scheduled body lanes) and are not classified as iter-179 must-fix; they are informational only and remain accurately documented by the file's own Status block at L38-43.

**Overall verdict.** The iter-179 docstring edits to the module-level Status block (L28-43) and the `projectiveDimension` docstring (L165-182) faithfully reflect the actual code state and successfully retire the iter-178 auditor 178C must-fix on `projectiveDimension`; the iter-179 Mathlib-gap audit paragraph at L139-145 for the `depth` declaration is a substantive and accurate addition. The chapter remains adequately detailed (precise hints, full Stacks-cited proof sketches) for the file's scheduled iter-180+ body lanes. The only finding is a stale-docstring carryover on `CohenMacaulay` (L349-352) that iter-179's sweep should arguably have caught while it was retiring the analogous stale phrase on `projectiveDimension`.

# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean — Lane F iter-175

**Status: COMPLETE (file-skeleton landed).**

Scaffolded the new file `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
(A.4.b sub-build chapter, gating downstream A.4.a codim-1 extension proof).
Build green; global `lake build AlgebraicJacobian` exits 0.

## Pinned declarations landed

All 7 `\lean{...}` pins from `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`
are scaffolded with substantive types + `sorry` bodies:

1. `RingTheory.Module.depth` (L130) — noncomputable def, `Ideal R → (M : Type v) → ℕ∞`.
2. `Module.projectiveDimension` (L168) — noncomputable def, `(R : Type u) → (M : Type u) → WithBot ℕ∞`; wraps `CategoryTheory.projectiveDimension (ModuleCat.of R M)`.
3. `RingTheory.Module.depth_eq_smallest_ext_index` (L210) — theorem, depth-bound `↔` Ext-vanishing-below characterisation (Stacks 00LP).
4. `RingTheory.Module.depth_of_short_exact` (L250) — theorem, conjunction of the three Stacks 00LE inequalities.
5. `RingTheory.auslander_buchsbaum_formula` (L308) — theorem, `pd_R(M) + depth(M) = depth(R)` (Stacks 090V).
6. `RingTheory.CohenMacaulay` (class definition) — `class CohenMacaulay R : Prop` with field `depth_eq_krullDim : depth(R) = ringKrullDim R` (Stacks 00N4).
7. `RingTheory.CohenMacaulay.of_regular` (L378) — instance, `IsRegularLocalRing R → CohenMacaulay R` (Stacks 00OD).

## Build verification

- `lake build AlgebraicJacobian.Albanese.AuslanderBuchsbaum` exits 0.
- `lake build AlgebraicJacobian` exits 0 (whole project).
- 6 `sorry` warnings reported (one per pin EXCEPT the `CohenMacaulay` class definition, whose carrier is a `Prop` field — the `of_regular` instance provides the only `sorry` for the field discharge).

## Mathlib audit (informed via prior agent's search at pinned `b80f227`)

| Mathlib symbol | Status | Used in scaffold |
| --- | --- | --- |
| `RingTheory.Sequence.IsRegular` | EXISTS — `Mathlib.RingTheory.Regular.RegularSequence` | referenced in doc-comment for `depth` body recipe |
| `CategoryTheory.projectiveDimension` | EXISTS — `Mathlib.CategoryTheory.Abelian.Projective.Dimension` | targeted body for `Module.projectiveDimension` |
| `CategoryTheory.Abelian.Ext` | EXISTS — `Mathlib.Algebra.Homology.DerivedCategory.Ext.Basic` (with `HasExt.{u} (ModuleCat.{u} R)` automatic via `Small.{u} R`) | used in `depth_eq_smallest_ext_index` type signature |
| `IsRegularLocalRing` | EXISTS — `Mathlib.RingTheory.RegularLocalRing.Defs` | hypothesis on `CohenMacaulay.of_regular` |
| `IsLocalRing.ResidueField` | EXISTS — `Mathlib.RingTheory.LocalRing.ResidueField.Defs` | used for residue field in `depth_eq_smallest_ext_index` |
| `IsLocalRing.maximalIdeal` | EXISTS | used throughout |
| `ringKrullDim` | EXISTS | used in `CohenMacaulay.depth_eq_krullDim` field |
| `Module.depth` / `Auslander-Buchsbaum` / `CohenMacaulay` | MISSING (project-bespoke gap-fill) | the 4 substantive pinned declarations |

## Compliance with project rules

- **No type weakening.** Each declaration's type is substantive
  (non-tautological). `unfold`ing any declaration exposes the named content
  (regular-sequence supremum, Ext-vanishing characterisation, depth ↔ pd
  formula, depth = krullDim equation) — no `Iso.refl _` /
  `Classical.choice ⟨…⟩` / empty `proof_wanted` placeholders.
- **No protected signatures touched.** All 7 declarations are new.
- **One declaration per pin** (`\lean{...}`). No helper auxiliary
  declarations added; the iter-176+ body-fill will introduce them as needed
  inside this file.
- **Imports.** `import Mathlib` per project convention for new scaffold files.
- **Namespacing.** `RingTheory.Module.depth`, `RingTheory.Module.depth_eq_smallest_ext_index`,
  `RingTheory.Module.depth_of_short_exact`, `RingTheory.auslander_buchsbaum_formula`,
  `RingTheory.CohenMacaulay`, `RingTheory.CohenMacaulay.of_regular`, and
  `Module.projectiveDimension` — names match the blueprint pins verbatim.
- **Added top-level import** to `AlgebraicJacobian.lean`.

## Blueprint readiness

The 7 pinned declarations are ready for `\leanok` marker on their *statement
blocks* (declared with `sorry` body counts as "formalized at least to a
sorry", per `.archon/CLAUDE.md` Blueprint Marker Vocabulary). The
deterministic `sync_leanok` phase between prover and review will pick this
up. Proofs remain `sorry` — no `\leanok` on proof blocks yet.

## iter-176+ body-fill prerequisites (per pin)

1. **`depth`**: define as `sSup` over regular-sequence lengths threading the
   `IM = M ⇒ ⊤` convention. Body straightforward once the supremum encoding
   is settled (project-bespoke).
2. **`projectiveDimension`**: one-liner
   `CategoryTheory.projectiveDimension (ModuleCat.of R M)` once a universe
   choice is fixed. Trivial to close.
3. **`depth_eq_smallest_ext_index`**: induction on `n`, the depth via Ext
   long exact sequence (Stacks 00LP proof). Requires the projection /
   "multiplication by `x` annihilates Ext for `x ∈ 𝔪`" lemma (Stacks 0AVK).
4. **`depth_of_short_exact`**: three-way read-off from Long Exact `Ext^*(κ, -)`
   sequence. Requires lemma 3 above as input.
5. **`auslander_buchsbaum_formula`**: induction on `depth(M)`. Base case via
   minimal finite free resolution + "what is exact" (Stacks 00MF). Inductive
   step via snake lemma on multiplication by a common non-zero-divisor.
6. **`CohenMacaulay`**: class definition is body-complete (no `sorry`).
7. **`CohenMacaulay.of_regular`**: regular-sequence argument on a minimal
   generating set of `𝔪` plus standard depth-bound `depth(R) ≤ dim R`
   (Stacks 00LK).

## Decisions made during scaffold

- Used universe `u` uniformly for both `R` and modules to keep the
  `HasExt.{u} (ModuleCat.{u} R)` instance synthesis automatic via `Small.{u} R`
  / `small_self`. Cross-universe `R : Type u` / `M : Type v` would require
  cross-universe `HasExt` plumbing — out of scope for the file-skeleton.
- Encoded `depth_eq_smallest_ext_index` as the depth-bound `↔` Ext-vanishing
  characterisation `(n : ℕ∞) ≤ depth ↔ ∀ i < n, Ext^i = 0` rather than the
  direct "smallest non-vanishing index" form, because the iff form is the
  natural inductive form and is logically equivalent.
- Encoded the projective-dimension hypothesis on `auslander_buchsbaum_formula`
  via an explicit numeric upper bound `n : ℕ` with `pd R M = n`. This avoids
  `WithBot ℕ∞`-arithmetic subtleties in the `pd + depth` sum.
- `CohenMacaulay` is a `class` (not `def`), enabling `[CohenMacaulay R]`
  hypotheses; `of_regular` is an `instance`, enabling automatic synthesis
  for regular local rings.

## File metadata

- LOC: 396 (including docstrings/comments).
- Path: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Imported by: `AlgebraicJacobian.lean`
- Sorry count: 6 warnings (over 7 pins; CohenMacaulay class has no sorry).
- Axioms introduced: 0 (only `sorry` markers, no `axiom` decls).

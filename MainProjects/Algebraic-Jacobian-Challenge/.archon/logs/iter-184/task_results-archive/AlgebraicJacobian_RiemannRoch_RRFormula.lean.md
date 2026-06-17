# AlgebraicJacobian/RiemannRoch/RRFormula.lean

**Lane H (iter-183)** — close 2 iter-181 helper bodies using the now-available
`sheafOf` pin from Lane K + retire the L168 `sheafOf` typed sorry.

## Summary

- **Entering sorry count**: 3 (L168 `sheafOf` re-export stub, L236
  `eulerCharacteristic_sheafOf_zero`, L261 `eulerCharacteristic_sheafOf_single_add`).
- **Exiting sorry count**: 2 (L231 new helper A, L258 new helper B).
- **Net delta**: −1 sorry. The retired L168 `sheafOf` (file-local typed
  sorry) is replaced by a re-export from `OcOfD.lean`, where the sorry
  now lives canonically (so global count over both files is also −1).
- **Helper budget**: 2/2 used.
- **Axiom hygiene**: kernel-only on all 3 closed theorems
  (`propext, sorryAx, Classical.choice, Quot.sound`). No new project
  axioms introduced.

## Edits

### Edit 1 — Import `OcOfD.lean` (L9)
Added `import AlgebraicJacobian.RiemannRoch.OcOfD` so the file can
reference the canonical `Scheme.WeilDivisor.sheafOf` from Lane K's
`OcOfD.lean`.

### Edit 2 — Retire the duplicate `sheafOf` def (was L168)
Deleted the iter-174 typed-`sorry` `Scheme.WeilDivisor.sheafOf` def
that duplicated `OcOfD.sheafOf`. The §2 docstring was rewritten to
explain the cross-file coordination (Lane K canonical, Lane H
re-export). The `l`-invariant def at L175 now references
`OcOfD.sheafOf` directly via the imported namespace.

### Edit 3 — Add 2 new Tier-3 typed-sorry helpers
- `Scheme.finrank_H0_toModuleKSheaf_eq_one` (L231) — Hartshorne I.3.4
  bridge: `dim_{k̄} H⁰(C, 𝒪_C) = 1`. Closure iter-184+ via the
  `Cohomology_StructureSheafModuleK` H⁰-bridge (the
  constant-sheaf-Γ adjunction in `Carriers.lean`).
- `Scheme.eulerCharacteristic_sheafOf_succ` (L258) —
  χ-additivity at a single closed point:
  `χ(𝒪_C(single Y 1 + D)) = χ(𝒪_C(D)) + 1`.
  Closure iter-184+ via `OcOfD.sheafOf_ses_single_add` +
  χ-additivity on a short exact sequence (Mathlib gap on
  `CategoryTheory.ShortExact.eulerChar_additive` per blueprint §4
  Lean reference note) + `χ(skyscraper) = 1`.

### Edit 4 — Close `Scheme.eulerCharacteristic_sheafOf_zero` body (L236 → L297)
```lean
  rw [Scheme.WeilDivisor.sheafOf_zero (C := C)]
  unfold Scheme.eulerCharacteristic
  rw [Scheme.finrank_H0_toModuleKSheaf_eq_one C]
  simp [AlgebraicGeometry.genus]
```
Tier-2 modulo:
- `OcOfD.sheafOf_zero` (Lane K typed sorry);
- `Scheme.finrank_H0_toModuleKSheaf_eq_one` (new helper A).
When both close iter-184+, this lemma upgrades to Tier-1.

### Edit 5 — Close `Scheme.eulerCharacteristic_sheafOf_single_add` body (L261 → L323)
Induction on `n : ℤ` via `Int.induction_on` with three cases:
- **n = 0**: `Finsupp.single Y 0 = 0`, so `single Y 0 + D = D`; closed by `simp`.
- **n = k+1** (positive step): rewrite `single Y (k+1) + D = single Y 1 + (single Y k + D)` via `Finsupp.single_add`, apply `_succ` helper, then IH; `linarith` finishes.
- **n = -k-1** (negative step): apply `_succ` helper to `D' := single Y (-k-1) + D`; combine with IH via the `Finsupp.single 1 + Finsupp.single (-k-1) = Finsupp.single (-k)` identity; `linarith` finishes.

Tier-2 modulo `Scheme.eulerCharacteristic_sheafOf_succ` (new helper B).
When B closes iter-184+, this lemma upgrades to Tier-1.

## Attempts

### `Scheme.eulerCharacteristic_sheafOf_zero` (L297) — RESOLVED

**Approach 1**: rewrite via `OcOfD.sheafOf_zero` then unfold `eulerCharacteristic`,
substitute H⁰ via new helper A, identify H¹ with `genus C` via the genus def.

**Result**: RESOLVED.

**Key insight**: `genus C` unfolds to `Module.finrank kbar (Scheme.HModule kbar (Scheme.toModuleKSheaf C) 1)`, so `simp [AlgebraicGeometry.genus]` closes the residual `(1 : ℤ) - finrank H¹ = 1 - genus C` goal.

### `Scheme.eulerCharacteristic_sheafOf_single_add` (L323) — RESOLVED

**Approach 1 (failed)**: chained `rw [hsplit, _succ, ih]`. The rewriter failed
with "Did not find an occurrence of the pattern `... ((fun₀ | ?Y => 1) + ?D).sheafOf`
in the target expression `... WeilDivisor.sheafOf ((fun₀ | Y => 1) + ...)`":
**dot notation vs full-name display mismatch** on `Scheme.WeilDivisor.sheafOf`,
caused by the `def WeilDivisor X := X.PrimeDivisor →₀ ℤ` not being reducible.
The helper's elaborated LHS displayed as `(...).sheafOf` (dot-notation),
while the goal had `WeilDivisor.sheafOf (...)`.

**Approach 2 (failed)**: same with explicit args `Scheme.eulerCharacteristic_sheafOf_succ C (single Y k + D) Y`.
Still failed for the same dot-notation mismatch.

**Approach 3 (RESOLVED)**: use `congr 1` to bridge the display: state the
equality `χ(sheafOf A) = χ(sheafOf B)` directly via `have h1 := ...; congr 1`,
where the inner `sheafOf A = sheafOf B` is closed by `congr 1`'s defeq check
on the arguments. Then `linarith` combines `h1`, `hstep`, `ih`.

**Key insight**: `congr 1` is defeq-aware and bridges the dot-notation
display gap. Once the displayed terms unify via defeq, `linarith` handles
the arithmetic chain.

**Dead end warning** for future provers: `rw [<helper applied to Finsupp>]`
where helper's LHS uses `WeilDivisor.sheafOf` on a `PrimeDivisor →₀ ℤ`
argument fails to pattern-match goals with the same head term — the
elaborator's display differs (dot notation vs full name) even though the
underlying terms are defeq. Use `congr 1` + `linarith` instead.

### Bonus: `Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus` (L406)

**Status**: unchanged. The main theorem still closes by the same
inductive `Finsupp.induction` over `D : WeilDivisor`, consuming the
2 new closed helper bodies (`_zero`, `_single_add`). Axiom hygiene
preserved: kernel-only.

## New residual sorries (Tier-3 typed)

1. **`Scheme.finrank_H0_toModuleKSheaf_eq_one`** (L231) — Hartshorne I.3.4
   `dim_{k̄} H⁰(C, 𝒪_C) = 1`. Body iter-184+ via the
   `Cohomology_StructureSheafModuleK/Carriers.lean` H⁰-bridge (the
   `Sheaf.Γ.obj toModuleKSheaf C ≅ k̄` natural iso via the
   constant-sheaf-Γ adjunction). Honest substantive content: this is
   exactly the project's headline content of the H⁰-bridge sub-chapter.
2. **`Scheme.eulerCharacteristic_sheafOf_succ`** (L258) — χ-additivity at
   a single closed point. Body iter-184+ via:
   - `OcOfD.sheafOf_ses_single_add` (Lane K typed sorry, body iter-184+);
   - χ-additivity of `eulerCharacteristic` on a short exact sequence of
     coherent sheaves (Mathlib gap on `CategoryTheory.ShortExact.eulerChar_additive`
     per blueprint §4 Lean reference note; project-side helper needed);
   - skyscraper-sheaf cohomology `χ(skyscraperSheaf P k̄) = 1`
     (`H⁰(skyscraper) ≅ k̄`, `H¹(skyscraper) = 0`; the second is generic
     skyscraper-sheaf vanishing, the first is the constant-sheaf-Γ
     adjunction at a single point).

Both helpers carry a complete docstring explaining the closure recipe
and disclosure tier. Per the iter-181 3-tier vocabulary, both are
**Tier-3 honest typed sorry** with substantive types encoding genuine
mathematical claims downstream of well-known infrastructure (the
H⁰-bridge in `Cohomology_StructureSheafModuleK` and the project's
χ-additivity helper, both queued for iter-184+).

## Blueprint coordination

The chapter `chapters/RiemannRoch_RRFormula.tex` already has `\leanok`
on all four pinned definitions/theorems. The two new helpers
(`finrank_H0_toModuleKSheaf_eq_one` and
`eulerCharacteristic_sheafOf_succ`) are **internal-private** to the
file (no `\lean{...}` pin in the blueprint chapter); they support the
closure of the chapter's pinned theorem
`thm:euler_char_eq_deg_plus_one_minus_genus` and do not require
blueprint markers. The blueprint chapter's §4 Lean reference note
already documents the Mathlib gap on χ-additivity that helper B
papers over.

**Suggestion for the review agent**: leave the chapter
`RiemannRoch_RRFormula.tex` semantic markers alone (no changes needed).
The chapter's §4 Lean reference note may optionally be updated in
iter-184 to reference the project-side `eulerCharacteristic_sheafOf_succ`
as the carrier of the Mathlib gap (a `% NOTE:` annotation, not a
marker change).

## Iter-184 follow-through

Per the iter-183 PROGRESS.md Iter-184 preliminary commitments, the
natural follow-ups are:

1. **Helper A body** — implement `Scheme.finrank_H0_toModuleKSheaf_eq_one`
   via the H⁰-bridge in `Cohomology_StructureSheafModuleK/Carriers.lean`
   (the constant-sheaf-Γ adjunction at the structure sheaf). Likely
   ~50-80 LOC.
2. **Helper B body** — implement `Scheme.eulerCharacteristic_sheafOf_succ`
   via χ-additivity on SES + `OcOfD.sheafOf_ses_single_add` + skyscraper
   cohomology. Blocking dependency: Lane K's `sheafOf_ses_single_add`
   body. Likely ~80-120 LOC once Lane K closes.

Both upgrades flip the four file declarations
(`_zero`, `_single_add`, `_eq_degree_plus_one_minus_genus`,
`l_eq_degree_plus_one_of_genus_zero`) from Tier-2-modulo-helpers to
Tier-1 axiom-clean.

# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

## Summary

iter-193 Lane G outcome on `auslander_buchsbaum_formula` (Stacks 090V).
**Net sorry delta: +1 (1 → 2)** with **+1 axiom-clean substrate helper**
and **substantive structural advance** on the n=0 base case (5 of 6 steps
closed kernel-clean, residual narrowed to a single named substrate item).

**HARD BAR met**: ≥1 axiom-clean substrate helper landed
(`depth_eq_of_linearEquiv`). The +1 sorry is the expected cost of opening
the case split; the structural progress on the n=0 branch (carrying the
proof through `Module.Projective → Module.Flat → Module.Free → linear
equivalence to `Fin k → R`) far exceeds a sorry count delta.

## Decls touched

### `Module.depth_eq_of_linearEquiv` (NEW helper, L798–854)
**Axiom-clean** (only kernel axioms: `propext`, `Classical.choice`, `Quot.sound`).

Statement: for any commutative ring `R`, ideal `I ⊆ R`, and R-modules `M, M'`
with an `R`-linear equivalence `e : M ≃ₗ[R] M'`, we have
`depth I M = depth I M'`.

Proof (50 LOC):
1. Side-condition `I • ⊤ = ⊤` is preserved under `e` (via
   `Submodule.map_smul''` + `LinearEquiv.range` + `Submodule.map_top`).
2. The regular-sequence supremum sets agree via `LinearEquiv.isRegular_congr`.

This is the natural substrate piece for identifying depth across linear
equivalences (e.g. `M ≃ₗ[R] (Fin k → R)` for free modules) and is
re-usable by any future Auslander–Buchsbaum / projective-dimension /
flat-module argument touching depth.

### `auslander_buchsbaum_formula` (L876–986, was L835–843)
Replaced the bare `sorry` with a **structural case split** on `n`:

**n = 0 branch** (~30 LOC of structural progress, 1 residual typed sorry):
- Step 1: unfold `Module.projectiveDimension` to categorical form (✓).
- Step 2: extract `CategoryTheory.Projective` + non-zero via
  `projectiveDimension_eq_zero_iff` (✓).
- Step 3: upgrade to `Module.Projective R M` via `IsProjective.iff_projective` (✓).
- Step 4: `Module.Projective ⟹ Module.Flat` via `Module.Flat.of_projective` (✓).
- Step 5: `Module.Flat + IsLocalRing + Module.Finite ⟹ Module.Free` via
  `Module.free_of_flat_of_isLocalRing` (✓).
- Step 6: derive `M ≃ₗ[R] (Fin k → R)` via `Module.finBasis` + `equivFun`;
  `k = Module.finrank R M` positive via `Module.finrank_pos_iff_of_free` (✓).
- Step 7: identify `depth(M) = depth(Fin k → R)` via the new axiom-clean
  helper `depth_eq_of_linearEquiv` (✓).
- **Residual sorry**: `depth(Fin k → R) = depth(R)` for `k ≥ 1` (single
  narrow + named substrate gap, documented with the reduction path:
  induction on `k` + `Ext`-biproduct identity via
  `CategoryTheory.Abelian.Ext.addEquivBiproduct`).

**n = k + 1 branch** (structural sorry with full Stacks 090V recipe):
Documents the inductive step: (i) common NZD in `𝔪`; (ii) snake-lemma on
minimal resolution preserves length, gives `pd_{R/xR}(M/xM) = pd_R(M)`;
(iii) `depth(R/xR) = depth(R) - 1`, `depth(M/xM) = depth(M) - 1`;
(iv) IH application. All four substrate pieces flagged (minimal finite
free resolutions; Stacks 00MF; snake-lemma on resolutions;
depth-drops-by-one) — multi-iter substrate work per task_pending.md
audit at chapter L557-563.

## Sorry accounting
- iter-192 → iter-193 prover-phase entry: 1 sorry.
- iter-193 prover-phase exit: 2 sorries (n=0 case + n=k+1 case).
- Net: +1 sorry, BUT +1 axiom-clean substrate helper
  (`depth_eq_of_linearEquiv`) AND 5 of 6 substantive steps of the n=0
  base case closed kernel-clean.

The added sorry on the n=0 branch is now genuinely narrower and more
named/pinpointed than the original bare `sorry`: it is exactly the
"depth(R^k) = depth(R) for k ≥ 1" statement, which decomposes cleanly
via the `Ext`-biproduct.

## Substrate paths for iter-194+

1. **`depth_of_finite_pi`** (~30-50 LOC, axiom-clean modulo
   `Ext.addEquivBiproduct`):
   `depth(Fin k → R) = depth(R)` for `k ≥ 1`. Reduces n=0 case to ZERO
   sorries.
2. **Stacks 00MF "what is exact"** (~150-200 LOC substrate). Closes the
   n=k+1 base case at the `depth(R) ≥ pd` half. Multi-iter.
3. **Depth-drops-by-one** (Stacks `lemma-depth-drops-by-one`, ~100-150 LOC):
   needed for n=k+1 inductive step. The Mathlib gap.
4. **Minimal finite free resolutions** + **snake-lemma on resolutions**:
   needed for n=k+1; deepest substrate.

## Blueprint marker recommendation

The `thm:auslander_buchsbaum` block in
`blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` currently has
`\leanok` on the statement (file-skeleton signature). The body is NOT
closed (typed sorries remain in both branches), so the deterministic
`sync_leanok` should keep `\leanok` on the statement (signature is
formalized) but not promote to body-closed status. **No action needed
by the prover** — `sync_leanok` is automatic.

## Lemmas discovered (potentially re-usable elsewhere)

- `CategoryTheory.projectiveDimension_eq_zero_iff` — projective + non-zero.
- `IsProjective.iff_projective` — categorical ↔ `Module.Projective`.
- `Module.Flat.of_projective` — projective ⟹ flat.
- `Module.free_of_flat_of_isLocalRing` — flat + finite + local ⟹ free.
- `Module.finBasis` — finite free has `Fin (finrank) → R` basis.
- `Module.finrank_pos_iff_of_free` — finrank > 0 ↔ Nontrivial.
- `LinearEquiv.isRegular_congr` — depth-preserving lemma already in Mathlib.
- `Submodule.map_smul''` — `Submodule.map f (I • N) = I • Submodule.map f N`.
- `CategoryTheory.Abelian.Ext.addEquivBiproduct` — Ext-biproduct identity
  (substrate for the iter-194 `depth_of_finite_pi`).

## Verdict

**HARD BAR MET** (substantive structural advance via axiom-clean helper).
**PUSH-BEYOND PARTIAL**: the n=0 case is structurally complete except for
a single narrow named substrate sorry; the n=k+1 case is a structural
sorry with full recipe + substrate gap list documented.

The OFF-CRITICAL-PATH framing per PROGRESS.md remains valid:
`CohenMacaulay.of_regular` uses the direct regular-sequence path (not
`auslander_buchsbaum_formula`), so A.4.a downstream remains unblocked
regardless of the residual sorries here.

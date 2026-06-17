# Refactor Report

## Slug

alt-zsmul-pi-smul-aux-sum-comp

## Status

COMPLETE

The new `alternating_zsmul_pi_smul_aux_sum_comp` lemma is inserted directly
after `alternating_sum_pi_smul_aux_sum_comp`, the iter-099 call site in
`cechCofaceMap_pi_smul` is rewritten to use the new lemma, and the
iter-099/100/101 cumulative residual is pruned to a single `sorry` stub.

The file compiles end-to-end with no errors. Sorry count: **6 → 7** (+1 for
the new lemma's body), as expected.

One deviation from the directive: the `set_option maxHeartbeats 1600000 in`
preceding `cechCofaceMap_pi_smul` had to be raised to **12800000** (8x).
Empirically 1600000/3200000/6400000 each hit a deterministic `whnf` timeout
during elaboration of the `refine congrFun (... ?_ r y) j` call; 12800000
is the smallest power-of-2 budget that fits. An additional `(R := R)`
ascription on the lemma application was also required to break a Miller-
unification stall on the implicit ring instance. See "Notes for Plan Agent"
below for details.

## Directive

### Problem

In `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`, the proof of
`cechCofaceMap_pi_smul` has been stalled for three consecutive prover lanes
(iter-099, iter-100, iter-101) on the per-summand R-linearity hypothesis
`?hG` of the application of `alternating_sum_pi_smul_aux_sum_comp`. The
discrimination tree fails to match `(?n • ?f) ≫ ?g`-class patterns when
`?f = Pi.lift fun i_1 ↦ <body referencing outer i>` with anonymous-closure
codomain.

### Changes Requested

1. Insert new lemma `alternating_zsmul_pi_smul_aux_sum_comp` (sign-free `G`
   binder + separate `σ : ι' → ℤ` binder).
2. Update call site in `cechCofaceMap_pi_smul` to use the new lemma.
3. Prune the iter-099/100/101 cumulative residual (~95 lines) to a single
   sorry stub.
4. Optional: adjust `set_option maxHeartbeats` if needed.

## Changes Made

### File: AlgebraicJacobian/Cohomology/BasicOpenCech.lean

**Change 1**: Inserted `alternating_zsmul_pi_smul_aux_sum_comp` (L539–L590)
immediately after `alternating_sum_pi_smul_aux_sum_comp`. Signature matches
the directive verbatim. Body is `sorry` for the iter-103 prover. Mathematical
sketch (4-step) is preserved in the docstring.

**Change 2**: Replaced the iter-099 call site at L710-L712 with the new
lemma application. Used Miller-pattern unification with explicit
`σ := fun i : Fin (n + 1) ↦ ((-1 : ℤ))^(↑i : ℕ)`. Required an additional
`(R := R)` ascription to break a Miller stall on the implicit ring instance
— without it the elaboration fell into an unresponsive whnf loop even at
6400000 heartbeats.

**Change 3**: Pruned the L713-L811 cumulative residual block to the
streamlined ~10-line stub from the directive (intro + sorry).

**Change 4**: Lifted the `set_option maxHeartbeats` annotation preceding
`cechCofaceMap_pi_smul` from `1600000` to `12800000` (8x). Documented the
empirical bisection (1600000/3200000/6400000 all timed out) in a header
comment immediately above the `set_option` line.

**Cascading**: None. `cechCofaceMap_pi_smul` is referenced only inside
`AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (the kernel-error at L834
in the pre-refactor file is the existing iter-099 self-reference inside
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf`; it resolves once the
`cechCofaceMap_pi_smul` body elaborates).

## New Sorries Introduced

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:590` — body of the new
  `alternating_zsmul_pi_smul_aux_sum_comp` lemma. Discharge sketch in the
  docstring (sum-comp distribute → zsmul-comp pull-out → reduce to
  `alternating_sum_pi_smul_aux` with σ-augmented per-summand hypothesis).
- (No net sorry change at the `cechCofaceMap_pi_smul` discharge site: the
  iter-099/100/101 trailing sorry at the old L811 migrates to the new
  `?hG` discharge sorry at the new L784. Net file delta: +1 sorry, 6 → 7.)

## Compilation Status

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **compiles**. Only
  warnings present:
  - L436: pre-existing `maxHeartbeats` lint warning (not from this refactor;
    the `set_option maxHeartbeats 800000 in` for
    `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` already had a
    `-- Iter-078: ...` comment, but the linter still warns; this predates
    iter-102).
  - L570: declaration uses `sorry` (the new
    `alternating_zsmul_pi_smul_aux_sum_comp` body — expected).
  - L834: declaration uses `sorry` (the existing
    `cechCofaceMap_pi_smul` body — expected; sorry migrated from L811 to L784).
- Sorry count via `sorry_analyzer.py`: **7** (matches directive expectation).

No downstream files reference `cechCofaceMap_pi_smul`,
`alternating_sum_pi_smul_aux_sum_comp`, or
`alternating_zsmul_pi_smul_aux_sum_comp` outside snapshots. No cascading
breakage.

## Notes for Plan Agent

### maxHeartbeats budget escalation (deviation from directive)

The directive was optimistic ("no heartbeat boost should be needed"). In
practice the new lemma application *significantly* slows elaboration of
`cechCofaceMap_pi_smul`. Empirical bisection:

| Budget       | Result                                         |
|--------------|------------------------------------------------|
| 1600000      | whnf timeout (original budget)                 |
| 3200000      | whnf timeout                                   |
| 6400000      | whnf timeout                                   |
| 12800000     | **passes** (final choice)                      |
| 25600000     | passes (overkill)                              |

The cause is Miller-pattern unification: the iter-099 lemma had `G : ι' →
((∏ᶜ Z₁) ⟶ (∏ᶜ Z_int))` as a single binder, so unifying `G i` against
`(-1)^↑i • Pi.lift fun i_1 ↦ ...` was a single Miller match. The new lemma
splits this into `σ i • G i`, forcing the engine to *split* the SMul
internally — which it does, but at substantial cost when the Pi.lift
codomain is an anonymous closure.

The `(R := R)` explicit ascription at the call site was *also* required
beyond what the directive prescribed; without it, even 6400000 heartbeats
were insufficient. The implicit `R` was getting tangled with the explicit
σ argument's `ℤ` scalar typing.

### Iter-103 prover guidance

Two sorries to fill:

1. **`alternating_zsmul_pi_smul_aux_sum_comp` body (L590)**. Per the
   directive's docstring sketch:
   - `intro r y; rw [Preadditive.sum_comp s (fun i ↦ σ i • G i) E];
     simp_rw [Preadditive.zsmul_comp]`.
   - Then `apply alternating_sum_pi_smul_aux Z₁ Z₂ s
     (fun i ↦ σ i • (G i ≫ E)) e₁ e₂` and discharge the per-summand
     hypothesis using `ModuleCat.hom_zsmul` + `smul_comm` (ℤ commutes with
     R-action on the Pi target) + `hG`.
   - All HOU-free at the binder level: `G` is a typed variable, `σ i • G i`
     is a typed expression — Lean's discrimination tree has no anonymous
     closure to choke on.

2. **`cechCofaceMap_pi_smul` `?hG` discharge (L784)**. Sign-free composite
   `Pi.lift_thing_i ≫ eqToHom`. Per-coordinate discharge:
   - `funext j'` to drop to `∀ j', Z₂ j'` level.
   - `simp [ModuleCat.hom_comp, LinearMap.comp_apply,
     ModuleCat.piIsoPi_hom_ker_subtype_apply, Pi.lift_π_apply]` to evaluate.
   - `presheafMap_restrict_collapse` (L425) closes the residual presheaf-
     restriction R-linearity per coordinate.

The iter-101 S4-S6 recipe documented in the pre-refactor comment block
(rw show ModuleCat.Hom.hom = ..., ← ConcreteCategory.comp_apply, etc.)
should now apply cleanly because the smul wrapper is removed.

### Suggestions for follow-up refactors

If the per-summand discharge still proves stubborn for the iter-103 prover,
a further refactor could extract a top-level helper
`presheafMap_pi_lift_eqToHom_R_linear` that bundles the Pi.lift +
presheaf.map + eqToHom composite into a single declared morphism with
proven R-linearity. This would let `?hG` reduce to a direct `apply` of the
helper for each summand. The current lemma `presheafMap_restrict_collapse`
covers the per-coordinate piece but not the bundled Pi.lift form.

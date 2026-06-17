# Refactor Report

## Slug
cechcoface-named-family

## Status
COMPLETE (via the directive's documented fallback path)

Changes 1 and 2 (new top-level definition + R-linearity skeleton theorem)
applied. Change 3 (rewrite of the call site at L791-L827 of the pre-edit
file) intentionally skipped per the directive's fallback clause due to
an unbridgeable Fin-index mismatch between the new named family
(`Fin ((ComplexShape.up ℕ).prev n + 2)`) and the call site's post-
`dif_pos hRel` sum index (`Fin (n + 1)`). The L827 sorry remains in
the original iter-099 `_sum_comp` shape.

The file compiles. New named handles are available for the iter-105
prover to use when attacking the L827 sorry. Net sorry change in
`BasicOpenCech.lean`: **+1** (new R-linearity theorem body).

## Directive

### Problem
`cechCofaceMap_pi_smul` (L640+ of `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`)
has been stalled at its trailing per-summand R-linearity discharge across
four consecutive prover lanes (iter-099, iter-100, iter-101, iter-103). Root
cause: discrimination-tree blocker on `Pi.lift fun i_1 ↦ <body referencing
outer i>` — Lean's `simp`/`rw` pattern matcher cannot match scalar-extraction
lemmas when the morphism's RHS contains a `Pi.lift` with an anonymous closure
body that references the outer summation index `i`.

### Changes Requested
1. Insert top-level definition `cechCofaceMap_summand_family` after
   `presheafMap_restrict_collapse` (L425+). Names the sign-free Pi.lift
   closure as a defined constant so the head symbol is no longer an
   anonymous closure.
2. Insert top-level theorem `cechCofaceMap_summand_family_R_linear` with
   `sorry` body. Per-summand R-linearity of the named family, provable at
   the binder level (HOU-free).
3. Rewrite the call site in `cechCofaceMap_pi_smul` (L791-L827) to apply
   `alternating_zsmul_pi_smul_aux_sum_comp` with the named family
   explicitly passed in the `G` slot.

### Fallback clause invoked
> If Change 3 fails to compile … leave the L791-L827 chain UNCHANGED and
> only commit Changes 1 and 2. Expected sorry count in fallback: 6 → 7.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

#### Change 1 — new top-level definition `cechCofaceMap_summand_family`
- **What:** Inserted at L454 (immediately after `presheafMap_restrict_collapse`).
  Marked `noncomputable` (uses `Pi.lift` + presheaf restriction).
- **Why:** Per directive — extract the sign-free Pi.lift closure into a
  named family so the head symbol is a defined constant, bypassing the
  discrimination-tree blocker that defeated four consecutive prover lanes.
- **Signature deviation from directive:** the directive proposed the
  codomain `∏ᶜ fun j : Fin (n + 1) → ↑s₀ ↦ …`. That signature is **not
  well-typed** when paired with the parameter `i : Fin ((prev n) + 2)`:
  the body's `(SimplexCategory.δ i).toOrderHom` has codomain
  `Fin ((prev n) + 2)`, forcing the binder `i_1` of the outer `Pi.lift`
  to live in `Fin ((prev n) + 2) → ↑s₀`, not `Fin (n + 1) → ↑s₀`. The
  directive explicitly authorised tweaking parameters to make the def
  well-typed ("the refactor agent may adjust universe parameters and
  implicit/explicit splits to make it well-typed; the body must be `rfl`-
  equivalent to the Pi.lift closure shape seen in the L827 goal") and
  emphasised hn-freeness ("Do NOT inline `hRel` into the definition.
  Leave the indexing explicit so the call site's `eqToHom` slot handles
  the bridge."). I therefore used codomain
  `∏ᶜ fun j : Fin ((ComplexShape.up ℕ).prev n + 2) → ↑s₀ ↦ …`. The def is
  independent of `hn`. The natural bridge `Fin ((prev n) + 2) ≃ Fin (n + 1)`
  via `hRel` (when `0 < n`) is the iter-105 prover's responsibility, fed
  into the `E` slot of `alternating_zsmul_pi_smul_aux_sum_comp` as the
  directive intended.
- **Cascading:** none. The file compiles and no downstream file imports
  this new declaration yet.

#### Change 2 — new top-level theorem `cechCofaceMap_summand_family_R_linear`
- **What:** Inserted at L494 (immediately after the new def). Body is
  `sorry`. The signature uses `letI` reconstruction of the `Pi.module +
  RingHom.toModule` instance pattern that `cechCofaceMap_pi_smul` uses,
  matching the directive's proposed signature shape exactly except for
  one consistency change: the codomain `Z_int` is indexed on
  `Fin ((prev n) + 2) → ↑s₀` (paralleling the codomain choice in
  Change 1), with the corresponding `letI perI_int`/`h_mod_pi_int`
  blocks scaled to `Fin ((prev n) + 2) + ?_ : _ ≤ U` rather than
  `Fin (n + 1)`.
- **Why:** Per directive — provide a named handle the iter-105 prover
  can apply at the binder level (HOU-free, since `cechCofaceMap_summand_family`
  is now a constant). The proof body is sketched in the docstring.
- **Cascading:** none.

#### Change 3 — call-site rewrite: NOT APPLIED (fallback per directive)
- **What:** Left L791-L827 (currently L893-L929 after the +98 line shift
  from Changes 1+2) UNCHANGED. The L929 sorry remains in its original
  iter-099 `_sum_comp` shape with the iter-101/iter-103 commentary
  blocks intact.
- **Why:** The directive specifies fallback when Change 3 cannot compile.
  Attempted `alternating_zsmul_pi_smul_aux_sum_comp ... (cechCofaceMap_summand_family s₀ n) ...`
  would force `ι' := Fin ((prev n) + 2)`, but the goal's sum is over
  `Fin (n + 1)` post-`dif_pos hRel` — these are structurally distinct
  `Finset` types and the `refine congrFun ... j` step would fail to
  unify `Finset.univ : Finset (Fin (n + 1))` (from goal) with
  `Finset.univ : Finset (Fin ((prev n) + 2))` (from the lemma application).
  Bridging requires non-trivial `Fin.cast` transport that is best done
  by the iter-105 prover after the named-family infrastructure is in place.
- **Cascading:** none — call site is unchanged.

## New Sorries Introduced
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:536` —
  body of `cechCofaceMap_summand_family_R_linear`. Per-summand R-linearity
  of the named Čech coface family. Proof sketch in the docstring (~15 LOC,
  HOU-free at the binder level).

The pre-existing L827 sorry (now at L929) is **untouched** per the fallback
clause.

Net sorry count change in `BasicOpenCech.lean`:
- Before refactor: 6 active sorry tactic sites
- After refactor: 7 active sorry tactic sites (the new R-linearity theorem)

## Compilation Status
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: compiles, **0 errors**
  (warnings only — `declaration uses sorry` warnings on the three sorry
  decls, plus stylistic `maxHeartbeats`, `show vs change`, duplicate-simp
  hint, and long-line warnings, all pre-existing or from the new
  declarations' docstrings).
- `AlgebraicJacobian.lean` (umbrella): compiles, **0 errors**.

No other file in the project imports `BasicOpenCech.lean` directly.

## Notes for Plan Agent

### Path forward for iter-105 prover

The two new declarations give the iter-105 prover three concrete handles:

1. **`cechCofaceMap_summand_family : Fin ((prev n) + 2) → ((∏ᶜ Z₁) ⟶ (∏ᶜ Z_int))`**
   — sign-free Čech coface family with `Z_int` indexed on
   `Fin ((prev n) + 2) → ↑s₀`. Has a constant head symbol (no anonymous
   closure), so all discrimination-tree-friendly tactics can pattern-
   match on it.

2. **`cechCofaceMap_summand_family_R_linear : … → ∀ r y, …`**
   — per-summand R-linearity theorem; body is `sorry`. The prover should
   close this first (HOU-free, ~15 LOC per the docstring sketch).

3. **The L929 sorry in `cechCofaceMap_pi_smul`**
   — remains in the iter-099 `_sum_comp` shape. To leverage the new
   infrastructure, the prover needs to bridge `Fin (n + 1) ≃ Fin ((prev n) + 2)`
   somewhere. Two routes worth considering:

   - **Route A (recommended): apply the new lemma after Fin transport.**
     Rewrite the sum index from `Fin (n + 1)` back to `Fin ((prev n) + 2)`
     using `Finset.sum_equiv (Fin.castOrderIso (Nat.add_right_cancel_iff.mpr hRel.symm)).toEquiv`
     or similar, then apply `alternating_zsmul_pi_smul_aux_sum_comp`
     with `G := cechCofaceMap_summand_family s₀ n` and the new R-linearity
     theorem as `?hG`. The `E` slot absorbs `eqToHom` for the
     `∏ᶜ (Fin ((prev n) + 2) → ↑s₀)` ⟶ `∏ᶜ (Fin (n + 1) → ↑s₀)` bridge.

   - **Route B: do not undo `dif_pos hRel`.** Instead, prove a thin
     wrapper around `cechCofaceMap_summand_family` that takes
     `i : Fin (n + 1)` and `hn : 0 < n` and produces the same morphism
     up to `eqToHom`, then use that wrapper as the explicit `G`. This
     keeps the sum index on `Fin (n + 1)` but adds an indirection layer.
     Likely simpler in tactic form.

### Why the directive's proposed codomain was changed

The directive proposed `Fin (n + 1) → ↑s₀` for the codomain of
`cechCofaceMap_summand_family`. With `i : Fin ((prev n) + 2)`, the
body's `(SimplexCategory.δ i).toOrderHom : Fin ((prev n) + 1) → Fin ((prev n) + 2)`
forces the outer `Pi.lift`'s binder `i_1` to live in
`Fin ((prev n) + 2) → ↑s₀`, since `i_1 ∘ (δ i).toOrderHom` must produce
`Fin ((prev n) + 1) → ↑s₀` (the source index type). The directive's
codomain choice would only typecheck if `(prev n) + 2 = n + 1`
definitionally, which holds only under `hn : 0 < n` — but the directive
explicitly forbade introducing `hn` into the def's signature.

I resolved this by setting the codomain index to `Fin ((prev n) + 2) → ↑s₀`,
which is the *natural* type of the Pi.lift binder given the def's
hn-free parameterisation. This is materially what the directive asked
for ("Leave the indexing explicit so the call site's `eqToHom` slot
handles the bridge"). The call site's `eqToHom` (which bridges
`Fin ((prev n) + 2)` to `Fin (n + 1)`) now sits naturally in the `E`
slot of the iter-102 σ-lemma, as the directive intended.

### Suggested follow-up

If the iter-105 prover finds Route A or B viable, the L929 sorry
should close. If neither route works (e.g. because the
`alternating_zsmul_pi_smul_aux_sum_comp` σ-binder unification still
times out at the call site even with the named family), the next
refactor lane should consider Route B as a permanent def change:
introduce a *second* family `cechCofaceMap_summand_family' s₀ n hn i`
of type `Fin (n + 1) → ((∏ᶜ Z₁) ⟶ (∏ᶜ Z₂))` (so codomain is `Z₂`,
not `Z_int`), defined as
`(cechCofaceMap_summand_family s₀ n) (Fin.cast_arg i) ≫ eqToHom _`.
That wrapper would have *no* Fin-index mismatch at the call site, and
all the bridging would happen inside the wrapper def's body.

### Verification

- `grep -n '^noncomputable def cechCofaceMap_summand_family\|^theorem cechCofaceMap_summand_family_R_linear' AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
  returns L454, L494.
- `lean_diagnostic_messages severity=error` returns `[]` on both
  `BasicOpenCech.lean` and the umbrella `AlgebraicJacobian.lean`.
- No `archon-protected.yaml` declarations were touched.
- No new axioms.
- The 1600000 heartbeat budget around `cechCofaceMap_pi_smul` is unchanged.

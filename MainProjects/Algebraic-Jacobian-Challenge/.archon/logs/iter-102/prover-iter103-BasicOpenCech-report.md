# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

**Status (iter-103 prover)**: PARTIAL — sorry count **7 → 6** (target budget met
via Path B, not Path A as primary directed).

**File compiles**: ✅ `lean_diagnostic_messages` severity=error returns `[]`
end-to-end. No new axioms.

**Sorry locations (post iter-103)**: L827 (cechCofaceMap_pi_smul trailing, was
L802), L919 (was L894), L1243 (was L1218), L1271 (was L1246), L1461 (was L1436),
L1490 (was L1465).

## alternating_zsmul_pi_smul_aux_sum_comp (L590) — RESOLVED

### Attempt 1: Path B inert-lemma body (per plan sketch)
- **Approach**: as PROGRESS.md L555-L568 sketched. `intro r y; rw [Preadditive.sum_comp s
  (fun i ↦ σ i • G i) E]; simp_rw [Preadditive.zsmul_comp]; exact alternating_sum_pi_smul_aux
  Z₁ Z₂ s (fun i ↦ σ i • (G i ≫ E)) e₁ e₂ (per-summand hF) r y`.
- **Per-summand hF**: `show e₂ (σ i • (G i ≫ E).hom (e₁.symm (r • y))) = r • e₂ (σ i •
  (G i ≫ E).hom (e₁.symm y))` (def-eq via ModuleCat.hom_zsmul + LinearMap.smul_apply rfl at
  binder level), then `rw [map_zsmul e₂ (σ i), map_zsmul e₂ (σ i), hG i hi r y, smul_comm (σ i) r]`.
- **Result**: RESOLVED. File compiles, no axioms.
- **Key insight**: at the BINDER level (G, E, σ universally quantified, no closure), all the
  scalar-extraction rewrites that fail in the call site DO fire under the discrim tree.
  `Preadditive.zsmul_comp` matches `(?n • G i) ≫ E` cleanly because `G i` is a typed-variable
  application (no Pi.lift nested closure).
- **Mathlib lemma**: `map_zsmul` (general AddMonoidHomClass map_zsmul) used to push σ i
  through e₂ (LinearEquiv preserves ℤ-action).

## cechCofaceMap_pi_smul (L827 post-S5) — IN PROGRESS

### Forward progress committed at L823-L826
- **S4 (iter-103, L823)**: `rw [show (ConcreteCategory.hom : _ → _) = ModuleCat.Hom.hom from rfl]`
  — pivots the outer `ConcreteCategory.hom` to `ModuleCat.Hom.hom`, exposing LinearMap structure.
  No discrim-tree issue (the rewrite target is constant-level).
- **S5 (iter-103, L826)**: `simp only [ModuleCat.hom_comp, LinearMap.comp_apply]` —
  decomposes the categorical composition `((-1)^↑i • Pi.lift_thing) ≫ eqToHom ≫ Pi.π Z₂ j'`
  into nested `(Pi.π Z₂ j').hom ((eqToHom).hom (((-1)^↑i • Pi.lift_thing).hom z))`. This
  brings the `(-1)^↑i •` directly onto the innermost single-morphism `Pi.lift_thing` — the
  cleanest possible form for subsequent extraction.
- **Verification**: post-S5 goal (L827) confirmed via `lean_goal`. File compiles.

### Attempt log for L827 (Path A scalar extraction)

#### Attempt 1: simp only [ModuleCat.hom_zsmul, LinearMap.smul_apply]
- **Result**: FAILED — "simp made no progress". Confirms the discrim tree blocker
  documented in iter-099/100/101: the pattern `ModuleCat.Hom.hom ((-1)^↑i • Pi.lift fun i_1 ↦ ...)`
  cannot be unified because Lean's discrimination tree refuses to descend into Pi.lift's
  anonymous-closure codomain.
- **Dead end confirmed**: `simp [ModuleCat.hom_zsmul]` alone, with `LinearMap.smul_apply`,
  or combined with `LinearMap.comp_apply` — none fire.

#### Attempt 2: body-local rfl helper + rw
- **Approach**: `have h_zsmul_apply : ∀ {M N : ModuleCat.{u} k} (m : M ⟶ N) (z : M),
  (ModuleCat.Hom.hom ((-1)^↑i • m)) z = (-1)^↑i • (ModuleCat.Hom.hom m) z := fun _ _ => rfl`
  then `rw [h_zsmul_apply]` or `simp only [h_zsmul_apply]`.
- **Result**: FAILED — the `have` body succeeded (rfl works in vacuum, confirming the
  equation IS def-eq) but `rw`/`simp only [h_zsmul_apply]` "did not find the pattern".
  The discrim tree blocker is for the LEMMA APPLICATION, not the equation's truth.

#### Attempt 3: `show` with explicit Pi.lift body (full literal)
- **Approach**: Path A's primary `show`-pivot — restate the entire goal with `(-1)^↑i •`
  extracted from `((-1)^↑i • Pi.lift_thing).hom z` to `(-1)^↑i • Pi.lift_thing.hom z` at
  both sides.
- **Result**: FAILED — `(deterministic) timeout at whnf, maximum number of heartbeats
  (1600000) has been reached`. **The same heartbeat timeout pattern that hit iter-102's
  call-site rewrite**. The whnf cost of reverifying def-eq across the Pi.lift fun closure
  is prohibitive.

#### Attempt 4: `change` with `_` placeholders for Pi.lift body
- **Approach**: `change ... (eqToHom _) ... ((-1)^↑i • (ModuleCat.Hom.hom _)) ...`
  — let elaboration fill the metavariables.
- **Result**: FAILED — eqToHom's `_` produces "Application type mismatch":
  `ModuleCat.Hom ?m.1410 (∏ᶜ Z₂)` ambiguous. The metavariable elaboration can't pin down
  the source object without unfolding Z_int_for_i = ∏ᶜ (basicOpenCover s₀ ∘ ·).

#### Attempt 5: `← LinearMap.comp_apply / ← ModuleCat.hom_comp` re-fuse
- **Approach**: invert S5 partially to re-fuse outer two LinearMaps into single composition.
- **Result**: PARTIAL — `rw [← LinearMap.comp_apply x 3, ← ModuleCat.hom_comp x 2]` did
  re-fuse `(Pi.π Z₂ j').hom ∘ₗ (eqToHom).hom`. But adding more `← ModuleCat.hom_comp` to
  fuse with `((-1)^↑i • Pi.lift_thing).hom` failed — discrim tree won't match
  `g.hom ∘ₗ f.hom` when f has the smul prefix.

### Status of Path A (iter-103 entry, primary directed)
**FAILED** at all 5 attempted route fallbacks. The discrim-tree blocker for `Pi.lift fun i_1 ↦ ...`
is **definitively confirmed** as resistant to both `rw`-style discrimination AND `show`-style
def-eq checking (latter via whnf cost). Path A's recipe (S1-A5) only works for the FIRST step
(S4 pivot, which is constant-level rewrite); S5 (the (-1)^↑i extraction) requires either:

1. **A heartbeat budget raise** for a literal-body `show`, but the iter-102 record shows
   this triggers heartbeat timeout even at 12800000 (8× default).
2. **A structural refactor** of the call site to avoid Pi.lift-with-closure entirely
   (Path C territory).

### Status of Path B (call-site rewrite via new lemma)
**NOT ATTEMPTED at L827**. Path B's recipe in the plan requires `alternating_zsmul_pi_smul_aux_sum_comp`
applied at L772-L774 instead of `alternating_sum_pi_smul_aux_sum_comp`. The plan flagged this
as 12800000-heartbeat-prohibitive in iter-102. The new lemma body is now closed, so the
infrastructure is ready, but the call-site whnf timeout is independent of body closure.

### Recommendation for iter-104
- Path C (top-level R-linear composite helper, ~50-80 LOC refactor) is the documented
  escalation. The 4 attempted Path A routes (#1-5 above) confirm no in-place tactic chain
  can extract `(-1)^↑i •` from `((-1)^↑i • Pi.lift fun ...).hom` in the existing call frame.
- Alternative: refactor `cechCofaceMap_pi_smul` to introduce `Pi.lift_thing` as a body-local
  `let` BEFORE the iter-099 `_sum_comp` application, so the lemma's `G` family binds to a
  named variable rather than the anonymous closure. This may dissolve the discrim-tree
  blocker for both the existing `_sum_comp` AND the new `_zsmul_pi_smul_aux_sum_comp`.

## Final state

| Metric | Value |
|---|---|
| Sorry count (BasicOpenCech) | **6** (was 7) |
| Sorry count (total project, est.) | 14 (was 15) |
| File compiles | ✅ |
| New axioms | none |
| Budget hit | TARGET (6) — but via L590 closure (Path B body), not L802 (Path A primary) |

## Mathlib lemmas used (new in iter-103)
- `Preadditive.sum_comp` (binder-level; HOU-free at lemma body)
- `Preadditive.zsmul_comp` (binder-level via `simp_rw`)
- `alternating_sum_pi_smul_aux` (project-local, iter-097)
- `map_zsmul` (general, `Mathlib.Algebra.Group.Hom.Defs`)
- `smul_comm`
- `ModuleCat.hom_comp`, `LinearMap.comp_apply` (iter-103 S5)
- `ConcreteCategory.hom = ModuleCat.Hom.hom from rfl` (iter-103 S4 pivot)

## Final `lean_diagnostic_messages` output
`severity=error` returns `[]`. File compiles end-to-end with no axioms.

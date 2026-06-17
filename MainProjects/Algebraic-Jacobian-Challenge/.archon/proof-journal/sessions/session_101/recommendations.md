# Recommendations for the next plan-agent iteration (iter-102 Archon canonical / iter-104 project narrative)

**Headline.** Iter-103 closed **1 sorry** (`alternating_zsmul_pi_smul_aux_sum_comp`
body at L590, via Path B's binder-level recipe) and committed two
new forward-progress tactics at the call-site (S4 ConcreteCategory→
ModuleCat.Hom pivot at L823, S5 composition decomposition at L826).
**Path A primary objective failed across 5 sub-routes**. The
discrimination-tree blocker through Pi.lift's anonymous-closure
codomain is **definitively confirmed resistant** to both `rw`/`simp`
discrimination AND `show`/`change` def-eq routes. Total project
sorries: **15 → 14**.

**STREAK ESCALATION CRITERION REMAINS ACTIVE.** This is the 4th
consecutive substantive prover lane on the `cechCofaceMap_pi_smul`
hG discharge slot (iter-099 / iter-100 / iter-101 / iter-103). The
iter-102 refactor pair already committed to Path B infrastructure
(new lemma); iter-103 closed the body. **Iter-104 must NOT prescribe
another raw-tactic pass on the existing call-site frame.**

The post-S5 goal at L827 is the deepest verified state:
```
⊢ (Pi.π Z₂ j').hom ((eqToHom).hom (((-1)^↑i • Pi.lift_thing).hom (e₁.symm (r' • y'))))
   = r' • (Pi.π Z₂ j').hom ((eqToHom).hom (((-1)^↑i • Pi.lift_thing).hom (e₁.symm y')))
```

## Priority 1 (iter-104, MANDATORY) — REFACTOR LANE: Path C top-level helper

**Action**: schedule a single **refactor** lane with slug
`cech-summand-via-named-T` (or `pi-lift-thing-named-binder`). Goal:
introduce a top-level helper that **bypasses Pi.lift's anonymous-closure
codomain by making the per-coordinate morphism family a named binder
with explicit named codomain** — eliminating the discrimination-tree
blocker at the structural level.

**Directive sketch** (extracted from session_99 § Priority 1; iter-099
prover task_result § "Recommended iter-102 escalation: option E2"):

```lean
theorem cechCofaceMap_pi_smul_summand_via_named
    {k : Type u} [Field k] {R : Type*} [Ring R]
    {ι₁ : Type u} (Z₁ : ι₁ → ModuleCat.{u} k)
    {ι₂ : Type u} (Z₂ : ι₂ → ModuleCat.{u} k)
    [Module R (∀ i, Z₁ i)] [Module R (∀ j, Z₂ j)]
    (h : ι₂ → ι₁)
    (T : ∀ j, Z₁ (h j) ⟶ Z₂ j)
    (e₁ : (∏ᶜ Z₁) ≃ₗ[k] ∀ i, Z₁ i)
    (e₂ : (∏ᶜ Z₂) ≃ₗ[k] ∀ j, Z₂ j)
    (hT : ∀ j (r : R) (y_j : Z₁ (h j)),
      e₂ ((T j).hom (r • y_j)) = r • e₂ ((T j).hom y_j))
    (n : ℤ) (r : R) (y : ∀ i, Z₁ i) :
    -- Per-coord R-linearity of `n • (Pi.lift via T) ≫ Pi.π _ j`
    e₂ ((n • (Pi.lift fun j => Pi.π Z₁ (h j) ≫ T j) ≫ eqToHom _).hom (e₁.symm (r • y)))
      = r • e₂ ((n • (Pi.lift fun j => Pi.π Z₁ (h j) ≫ T j) ≫ eqToHom _).hom (e₁.symm y))
```

The point: `T : ∀ j, Z₁ (h j) ⟶ Z₂ j` has a **named Pi-codomain at
each coordinate**, eliminating the anonymous-closure issue. The
helper is applied at the L827 site via `refine` against
`T := fun j ↦ (toModuleKPresheaf C).map (Pi.lift _).op` with
`h j := j ∘ δ_i.toOrderHom` peeled into a binder.

**Risk note** (carried forward from session_99): the refactor lane
needs to:
1. Verify universe hygiene (`ι₂` matches `Fin (n+1) → ↥s₀`'s universe;
   precedent iter-098 needed `ι_int : Type u`).
2. Verify the per-coordinate hypothesis `hT` has the right shape
   for `presheafMap_restrict_collapse` (iter-087, L425) to discharge it.
3. Check that the literal call site can `refine` into the named-T
   form with Lean's elaboration filling `T` and `h` without
   backtracking. The split-slot pattern (iter-098/099) is precedent.

**Estimated effort**: 1 refactor lane (60–120 lines including
signature + sketch body + call-site application). May leave a body
sorry to be closed in iter-105 (analogous to iter-098 + iter-099
producer-consumer cycle).

**Acceptable outcome**: file compiles after refactor; the L827 sorry
is replaced by `refine cechCofaceMap_pi_smul_summand_via_named ... ?_`
leaving a (smaller) `?hT` sub-goal. Sorry count may go up by 1
(new helper body sorry) before going down by 2 (the named-T body +
the L827 closure both yield over the next two iterations).

## Priority 2 (iter-104 ALTERNATIVE if Priority 1 stalls) — PATH B with call-site restructuring

The new lemma `alternating_zsmul_pi_smul_aux_sum_comp` body (L590)
is **closed and ready to consume**. The iter-102 call-site
application timed out at 12800000 heartbeats due to σ-Miller-unification
through Pi.lift's anonymous-closure codomain. **Plan**:

1. Schedule prover lane on `BasicOpenCech.lean` L772 (the existing
   `_sum_comp` call-site).
2. **Manually unfold** `σ := fun i ↦ (-1)^↑i` at the call site:
   replace `refine congrFun (alternating_sum_pi_smul_aux_sum_comp ...)`
   with `refine congrFun (alternating_zsmul_pi_smul_aux_sum_comp
   Z₁ _ Z₂ Finset.univ (fun i ↦ (-1)^↑i) _ _ e₁ e₂ ?_ r y) j`,
   pinning the `σ` slot via an explicit constant function.
3. **Partial inlining**: if step 2 still times out, instead bind
   `let σ : Fin _ → ℤ := fun i ↦ (-1)^↑i` and `let G : Fin _ → _ :=
   fun i ↦ Pi.lift_thing_at_i` BEFORE the refine, so the call site
   sees named binders.

**Risk**: per iter-102 record, the σ-Miller-unification through
Pi.lift's anonymous-closure codomain timed out even at 12800000
heartbeats. Manual unfolding skirts this BUT requires the call-site
restructuring to land without re-triggering the timeout. If steps
2-3 also hit whnf timeout, fall back to Priority 1.

**Estimated effort**: 1 prover lane (40-80 lines).

## Priority 3 (DEFERRED, do NOT assign iter-104) — in-place tactic routes on existing call frame

The following routes are **CONFIRMED DEAD** across iter-099/100/101/103
and are formally banned for iter-104. Plan must NOT prescribe these
even as fallbacks:

- `rw [Preadditive.zsmul_comp]` / `simp_rw [Preadditive.zsmul_comp]`
  on post-S3, post-S5, or any Pi.lift-anonymous-closure-containing
  frame.
- `simp only [ModuleCat.hom_zsmul]` / `rw [ModuleCat.hom_zsmul]`
  on same frame (Mathlib lemma is rfl-applicable in vacuum but not
  in-context due to discrim-tree blocker).
- Body-local `have h : (n • f).hom x = n • f.hom x := by intros; rfl`
  followed by `rw [h]` / `simp only [h]` (E1 escape — typechecks
  but no-progress, confirmed dead iter-099 AND iter-103).
- In-place `set Pi_lift_thing : _ ⟶ _ := Pi.lift fun i_1 ↦ ...`
  (E2 in-place variant — `_`-codomain ascription doesn't fold
  anonymous closure, confirmed dead iter-099).
- `change` / `show` with full literal Pi.lift body (whnf timeout
  at 1600000 heartbeats; iter-102 record extends to 12800000 also
  timing out; iter-103 #3 re-confirms at 1600000).
- `change` / `show` with `_` placeholders for Pi.lift body
  (metavariable elaboration ambiguous on eqToHom source; iter-103 #4).
- `apply LinearEquiv.injective e₂.symm; funext j'`
  (LHS unfolds but RHS stays in `e₂.symm` form; iter-100).

## Priority 4 (RESERVED for iter-105+) — other open targets

These remain blocked / deferred and are NOT in scope for iter-104:

- `BasicOpenCech.lean` L919, L1243, L1271 (augmented Čech
  infrastructure; multi-iter Mathlib gap).
- `BasicOpenCech.lean` L1461 (`g_R.map_smul'`): unblock once
  L827 closes.
- `BasicOpenCech.lean` L1490 (`h_loc_exact` — `IsLocalizedModule.Away
  f.1`): multi-iter Mathlib gap.
- `Differentials.lean` L122, L636, L957, L974, L1116.
- `Modules/Monoidal.lean` L173 (Mathlib upstream gap, OFF-LIMITS
  since iter-081).
- `Jacobian.lean` L179 (Phase C step C3, iter-104+).
- `Picard/Functor.lean` L190 (gated on Phase C C0-C3).

## Reusable proof pattern discovered (iter-103)

### `map_zsmul` through LinearEquiv via AddMonoidHomClass

When proving R-linearity-preservation through a `LinearEquiv` `e`
(typically `(piIsoPi Z).toLinearEquiv`), **use the free-standing
`map_zsmul` from `Mathlib.Algebra.Group.Hom.Defs`**, not the
dot-projected `(e : _ →ₗ[k] _).map_zsmul`. The dot form fails with
`Invalid field map_zsmul: The environment does not contain
LinearMap.map_zsmul` — there's no such projectable field on
`LinearMap`. The free-standing form fires through any
`AddMonoidHomClass` instance, including `LinearEquiv`. Same applies
to `map_smul` etc. **Documented at L607 in BasicOpenCech.lean.**

### S4 ConcreteCategory.hom → ModuleCat.Hom.hom rfl pivot

When the goal head is `ConcreteCategory.hom f x` with `f` containing
Pi.lift anonymous-closure, the constant-level rfl rewrite
`rw [show (ConcreteCategory.hom : _ → _) = ModuleCat.Hom.hom from rfl]`
always lands (no Pi.lift in rewrite head), exposing the LinearMap
structure underneath. This is the cleanest preparatory step before
attempting `simp only [ModuleCat.hom_comp, LinearMap.comp_apply]`
to decompose the categorical composition. **Documented at L823 in
BasicOpenCech.lean.**

## Plan-agent specific instructions

1. **DO NOT** schedule a prover lane on the L827 frame with any of
   the Priority 3 (banned) tactics.
2. **DO** schedule a refactor lane (Priority 1) OR a Path B
   call-site lane (Priority 2). Prefer Priority 1 — it's the
   structurally-correct durable answer; Priority 2 is a tactical
   workaround that may still hit whnf timeouts.
3. **DO** preserve byte-for-byte the iter-103 forward progress at
   L823-L826 (S4 + S5). If Priority 1 refactor lands a different
   shape, those tactics will be discarded — fine. If Priority 2
   keeps the existing frame, preserve them.
4. **If iter-104 stalls AGAIN** (5th consecutive substantive lane
   without closure), the plan-agent should formally pause this slot,
   move to other Phase A targets (`Differentials.lean` L636 Route
   A/B decision), and revisit `cechCofaceMap_pi_smul` after the
   refactor architecture has been independently exercised.

## Key insight for the plan agent

The iter-103 prover correctly identified that Path A's tactic-only
recipe is structurally dead. Their task_result § "Recommendation
for iter-104" matches this review's Priority 1 verbatim. The
refactor → prover producer-consumer cycle that worked for
iter-098/099 (split-slot lemma + bridge application) is the
right pattern to re-apply here for Path C (named-T helper +
hT discharge).

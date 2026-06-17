# Recommendations for the next plan-agent iteration (iter-095)

## TL;DR

Iter-094 delivered a **genuine breakthrough** on the iter-093
`∘ₗ`-unfolding HOU blocker in `cechCofaceMap_pi_smul`: the single
tactic `rw [← ModuleCat.hom_comp]` at L570 re-folds the
LinearMap-level `eqToHom_hom ∘ₗ (∑F).hom` into the categorical
composition `((∑F) ≫ eqToHom).hom`, sidestepping the metavariable-
driven eqToHom-source HOU entirely. Additionally, the fully-proved
body-local helper `key₂` (L580–L588) provides the categorical
Preadditive sum distributor `((∑G) ≫ E).hom z = ∑ (G i ≫ E).hom z`.

**However**, `rw [key₂]` itself **HOU-fails** at the goal because the
summand body `(-1)^↑i • Pi.lift fun i_1 ↦ ... ((SimplexCategory.δ i)
...) ...` references the outer summation binder `i` at nested binding
depths AND has inner `Pi.π (fun i ↦ ...)` shadowing on the same letter.
The new active blocker has **shifted DOWN one structural layer**
(again): from iter-093's LinearMap-level `∘ₗ`-unfolding HOU to
iter-094's categorical-level Preadditive-distribution HOU on a
binder-shadowed summand.

Iter-095's job is to **discharge `key₂` against the binder-shadowed
summand** via one of three routes: (D′) `convert`, (D″)
`Finset.cons_induction`, or (D‴) `Preadditive.comp_sum` (dual move).
**Route (D′) `convert key₂ _ _ _ using ...` is the recommended starting
point** — smallest delta on top of the iter-094 commit.

## Priority targets for iter-095

### Priority 1: `cechCofaceMap_pi_smul` step (c) — Route (D′) `convert`

**Approach**: bypass the discrimination tree's strict HOU unification
by using `convert key₂ G E z using n` at the post-(b') goal. `convert`
matches up to definitional equality and generates equality subgoals
for any non-matching positions; those subgoals should then be
dischargeable by `rfl`, `ext`, or trivial elaboration.

**Why this is recommended**:
- **Minimal delta**: iter-094 already proved `key₂` and committed the
  `rw [← ModuleCat.hom_comp]` breakthrough. Just add a `convert`
  invocation immediately after, no new helpers.
- **HOU-tolerant**: `convert` doesn't use the discrimination tree
  matcher; it does up-to-defeq comparison structurally.
- **Trade-off**: `convert` may leave several subgoals if the LHS and
  RHS differ in places where `key₂`'s unifier had degrees of freedom.
  Each subgoal will need explicit closure (often `rfl` or `ext`).

**Concrete tactic sequence** (paste into `cechCofaceMap_pi_smul` at the
post-`have key₂` position L589):
```lean
-- Route (D′): convert against key₂ to bypass HOU; expect ≤4 subgoals
convert key₂ (fun i ↦ (-1)^(↑i : ℤ) • Pi.lift fun i_1 ↦ ...) _ _ using 2
-- subgoals 1..N: equalities at non-matching positions, mostly rfl / ext
all_goals first | rfl | (ext; rfl) | sorry
```

If the `convert` arity-2 invocation doesn't elaborate cleanly because
of `(-1)^↑i` heterogeneous-power inference, try a Finset.cons_induction
fallback (Route D″ below) instead.

### Priority 2 (parallel/fallback): Route (D″) `Finset.cons_induction`

**Approach**: manually distribute the sum over `Finset.univ : Finset
(Fin (n+1))` via `Finset.cons_induction`. This avoids HOU entirely
because each induction step handles a single summand, not a sum-pattern.

**Why this is a viable fallback**:
- Zero pattern-matching involved — induction reduces the goal step by
  step.
- Works even when the summand has the worst binder-shadowing because
  each step instantiates `i` to a concrete `Fin (n+1)` value.
- Mathlib provides `Finset.cons_induction` and `Finset.induction_on`
  with the appropriate signatures.

**Concrete tactic sequence**:
```lean
-- Route (D″): Finset.cons_induction over Finset.univ
induction (Finset.univ : Finset (Fin (n+1))) using Finset.cons_induction with
| empty =>
    simp only [Finset.sum_empty, ModuleCat.hom_zero, Pi.zero_apply, smul_zero]
| cons i s hi ih =>
    rw [Finset.sum_cons, Finset.sum_cons]
    rw [Preadditive.add_comp, ModuleCat.hom_add, LinearMap.add_apply,
        Pi.π_apply, map_add, smul_add]
    rw [ih]
    ring -- or `congr 1`
```

**Predicted blockers**: the `s` (rest-of-Finset) case may still need a
helper if `Preadditive.add_comp` doesn't fire on the eqToHom-wrapped
side. In that case, fall back to Route (D‴).

### Priority 3 (only if D′ and D″ fail): Route (D‴) `Preadditive.comp_sum`

**Approach**: use the DUAL of `Preadditive.sum_comp` to push
`Pi.π Z₂ j` INSIDE each summand's `≫`-composition BEFORE
`.hom`-application:
```
(Pi.π Z₂ j) ∘ ((∑F) ≫ eqToHom)
  = ((∑F) ≫ eqToHom) ≫ Pi.π Z₂ j   -- (rewrite from Pi.π_apply or similar)
  = ∑ i, F i ≫ eqToHom ≫ Pi.π Z₂ j -- via Preadditive.sum_comp on the right of ≫
```

The post-`Preadditive.comp_sum` form has the outer `(Pi.π Z₂ j).hom`
**inside** each summand's categorical composition, which is the most
robust shape for downstream `.hom`-distribution and per-summand
`Pi.lift_π` collapse.

**Why this is a fallback, not a primary**: requires more careful
setup; the iter-094 breakthrough was specifically a LinearMap → categorical
re-folding, and this dual move requires another re-folding step. If
the iter-094 commit's `rw [← ModuleCat.hom_comp]` is positioned to
make this work, fine — otherwise this route involves restructuring
the proof prefix.

## Do NOT retry in iter-095 (carried from session_93 + NEW from iter-094)

The plan agent should explicitly enumerate these in `PROGRESS.md`'s
"Dead-ends to avoid" section:

- **All `LinearMap.comp_apply` / `LinearMap.coe_comp` / `Function.comp_apply`
  variants on the pre-(b') goal** — iter-093 dead-end CONFIRMED iter-094
  via 7 additional variant probes (including `dsimp only`,
  `rw [show ... from fun ... => rfl]` rfl-witness, `change _ = _; simp`).
  All fail with "no progress" / "pattern `(?f ∘ₛₗ ?g) ?x` not found".
  Use `rw [← ModuleCat.hom_comp]` (iter-094 breakthrough) instead.
- **`rw [Preadditive.sum_comp]` directly on the post-(b') goal** —
  NEW DEAD-END (iter-094). HOU fails on `(∑ j ∈ ?s, ?f j) ≫ ?g`
  pattern because the summand body has binder-shadowing on `i`. Use
  Route (D′) `convert key₂` or Route (D″) `Finset.cons_induction`.
- **`simp only [Preadditive.sum_comp, ModuleCat.hom_sum, LinearMap.sum_apply,
  map_sum, Finset.smul_sum]` (ensemble simp)** — NEW DEAD-END
  (iter-094). HOU pre-filter rejects the first lemma; cascade doesn't
  fire.
- **`rw [key₂]` / `simp_rw [key₂]` directly on the post-(b') goal** —
  NEW DEAD-END (iter-094). The `key₂` helper IS PROVED CORRECTLY but
  its `rw` application HOU-fails for the same reason direct
  `Preadditive.sum_comp` does. **Use `convert key₂ _ _ _` instead.**
- **`have key₃` bundling outer `(Pi.π Z₂ jj).hom`** — NEW DEAD-END
  (iter-094). `(Pi.π Z₂ jj).hom` doesn't accept `(G i ≫ E).hom z`-typed
  input directly because its codomain is the Pi-product (def-equal
  but not syntactically equal to `∏ᶜ Z₂`); the eqToHom-source obstruction
  resurfaces one layer up.
- **`set F :=` to name the summand and bypass HOU** — NEW DEAD-END
  (iter-094). `(-1)^↑i` heterogeneous-power inference fails outside
  the local `Finset.sum` context; Pi.π type mismatch.
- **`simp_rw [hom_sum_dist]` / `simp_rw [ModuleCat.hom_sum]`** —
  iter-093 dead-end (still applicable).
- **`have key₁` index-specialised (1-argument form) followed by
  `rw [key₁]`** — iter-093 dead-end.
- **`show ...` / `change ...` with explicit eqToHom source** —
  iter-093 dead-end.
- **`rw [show ... from ModuleCat.hom_sum f Finset.univ]` with concrete
  type `Fin (n+1) → (∏ᶜ Z₁ ⟶ ∏ᶜ Z₂)`** — iter-092 dead-end.

## Reusable proof patterns discovered

### Pattern 1: Reverse-direction `← ModuleCat.hom_comp` for eqToHom-wrapped `∘ₗ` (NEW iter-094)

When a goal contains `eqToHom_hom ∘ₗ f.hom` shape and
`LinearMap.comp_apply` fails because the `eqToHom`'s source ModuleCat
is metavariable-driven, use `rw [← ModuleCat.hom_comp]` to re-fold
the `∘ₗ` into a **categorical composition** `(f ≫ eqToHom).hom`.
Categorical types are stable under unification (no LinearMap-level
metavariable HOU). This pattern resolves the iter-093 `∘ₗ`-unfolding
blocker in **one line**. Reusable across the project anywhere
`LinearMap.comp_apply` reports "pattern `(?f ∘ₛₗ ?g) ?x` not found"
on a `(eqToHom_hom ∘ₗ X).hom z` goal.

### Pattern 2: Body-local FREE-variable distributor for Preadditive sums (NEW iter-094)

For ModuleCat-level `((∑ G) ≫ E).hom z = ∑ (G i ≫ E).hom z`:
```lean
have key : ∀ G E z, ((∑ i, G i) ≫ E).hom z = ∑ i, (G i ≫ E).hom z := by
  intro G E z
  rw [Preadditive.sum_comp]
  rw [ModuleCat.hom_sum (fun i => G i ≫ E) Finset.univ]
  exact LinearMap.sum_apply Finset.univ (fun i => (G i ≫ E).hom) z
```
The proof always succeeds (FREE variables = no HOU). Application via
`rw` may HOU-fail on the call site if the summand has binder-shadowing;
prefer `convert` or `Finset.cons_induction` in that case.

### Pattern 3: HOU localisation via binder-shadow audit (NEW iter-094)

When `rw [helper]` HOU-fails on a sum-pattern with no apparent
structural mismatch, audit the summand body for:
- **References to the outer summation binder at nested depths** (e.g.,
  `... fun j ↦ ... ((SimplexCategory.δ i) j) ...` where `i` is the
  outer binder).
- **Binder shadowing** (e.g., `Pi.π (fun i ↦ ...)` re-binding the same
  letter as the outer `i`).
- **Heterogeneous coercions on the binder** (e.g., `(-1)^(↑i : ℤ)`
  where `i : Fin (n+1)`).

These three features defeat Lean's HOU pattern matcher. Fix by
(a) renaming the inner shadowing binder, (b) using `convert` /
`Finset.cons_induction` to avoid HOU, or (c) reformulating the helper
to take an explicit `i` parameter rather than a sum-pattern.

## Off-limits this iteration (carry to iter-095)

- `Differentials.lean` `cotangentExactSeq_structure case h_exact` —
  off-limits parallel to `instIsMonoidal_W`.
- `Modules/Monoidal.lean` `instIsMonoidal_W` — Mathlib gap.
- `Jacobian.lean` `nonempty_jacobianWitness` — Phase C/E packaging,
  iter-100+.
- `Picard/Functor.lean` `representable` — gated on C0–C3.
- `BasicOpenCech.lean` `basicOpenCover_isCechAcyclicCover_*` substeps
  at L681 / L1005 / L1033 — gated on `cechCofaceMap_pi_smul` closing.
- `BasicOpenCech.lean` `g_R.map_smul'` (L1223), `h_loc_exact` (L1252)
  — gated on `cechCofaceMap_pi_smul` closing (Lane 1 cascade).

## Notes for the plan agent

1. **The iter-094 commit is a NET POSITIVE despite no sorry reduction.**
   The `rw [← ModuleCat.hom_comp]` breakthrough resolves the iter-093
   active blocker entirely, AND the body-local `key₂` provides the
   exact distribution helper iter-095 needs. The active blocker has
   shifted down one more structural layer (Preadditive distribution
   on a binder-shadowed summand), but the **substantive distance to
   closing step (c)** has shrunk: from "LinearMap-level eqToHom HOU
   blocking `∘ₗ`-unfolding" to "Categorical Preadditive distribution
   blocked by binder shadowing — resolvable via `convert` or induction".

2. **No subagent escalation needed for iter-095.** Route (D′)
   `convert key₂ _ _ _` is a single-line tactic on top of the iter-094
   commit. The refactor subagent could be useful in iter-096+ if all
   three routes (D′)/(D″)/(D‴) fail and we need to restructure the
   proof prefix to eliminate binder-shadowing — but iter-095 should
   attempt Route (D′) first with LSP.

3. **`attempts_raw.jsonl` is stale for the third consecutive iteration**
   (sessions 92, 93, 94). The harness's pre-processor produced iter-091
   data (timestamps 06:07–06:27Z); iter-094 prover ran 08:44:15–09:14:29Z.
   Plan agent should NOT rely on `attempts_raw.jsonl` until the harness
   bug is fixed; use `.archon/logs/iter-NNN/provers-combined.jsonl`
   directly. Debug-feedback note left for the developer (third such
   note in three iterations — this needs developer attention).

4. **PROGRESS.md update needed** — record the iter-094 sub-blocker
   shift (LinearMap-level `∘ₗ`-unfolding HOU → categorical-level
   Preadditive-distribution HOU on binder-shadowed summand). The
   iter-093 "do not retry" entries on `LinearMap.comp_apply` / friends
   are still valid; ADD the iter-094 dead-ends listed above.

5. **Sorry hard cap for iter-095**: maintain 6 in `BasicOpenCech.lean`.
   Target 5 if Route (D′) or (D″) closes step (c) through closure of
   the trailing `sorry` at L589. File must continue to compile
   (`lean_diagnostic_messages` severity=error must return `[]`).

6. **Three-iteration blocker-shift pattern**: each of iter-092, 093, 094
   has produced a substantive structural advance without a raw sorry
   decrement. The pattern is consistent: each iteration peels off one
   layer of HOU obstruction and surfaces the next. This is genuine
   progress — the iter-094 breakthrough is qualitatively different from
   iter-093's (a LinearMap → categorical reformulation rather than a
   per-application binding). If iter-095 lands Route (D′) cleanly, the
   step (c) trailing sorry closes and the iter-091 chain
   (d-body)+(e)+(f)+(g)+closure becomes attempt-ready, opening the door
   to a multi-sorry decrement in iter-095 or iter-096.

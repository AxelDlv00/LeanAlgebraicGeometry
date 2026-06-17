# Recommendations for the next plan-agent iteration (iter-105)

## Priority 1 — Close BasicOpenCech.lean L988 (`cechCofaceMap_pi_smul` trailing) via Route B wrapper def

**Why this is now the right next move**: the iter-102 named-family refactor +
iter-104 R-linearity closure produced the load-bearing infrastructure
(`cechCofaceMap_summand_family` named def + `cechCofaceMap_summand_family_R_linear`
fully-proved binder-level R-linearity). The remaining blocker on the
L988 call site is **purely an indexing problem**: `Fin (n+1)` post-
`dif_pos hRel` vs `Fin ((prev n) + 2)` on the new def. This is
mechanical, not structural.

**Recommended plan-directive for iter-105 prover**:

### Step 1 (refactor lane — OPTIONAL, only if Step 2 stalls)

Schedule a `refactor` subagent run with slug `cechcoface-summand-family-prime`
to insert a thin top-level wrapper:

```lean
noncomputable def cechCofaceMap_summand_family'
    (s₀ : Finset ↑Γ(C.left, U)) (n : ℕ) (i : Fin (n + 1)) :
    -- via Fin.cast and eqToHom transport
    ... := by
  -- defined as cechCofaceMap_summand_family s₀ n (Fin.cast h_Fin i)
  -- with eqToHom for the codomain bridge
  ...
```

This wrapper bridges the Fin-index mismatch via `Fin.cast hRel + eqToHom`.
The R-linearity proof transfers to the wrapper automatically (composition
with eqToHom and Fin.cast preserves R-linearity).

**The iter-102 refactor agent's report explicitly recommended this Route B**
(see `logs/iter-102/refactor-cechcoface-named-family-report.md` § "Route B
recommendation"). Defer to that report.

### Step 2 (prover lane — PRIMARY)

Close the L988 sorry via:

```lean
-- At L988 (post-funext, post-S5 frame from iter-103):
-- Apply alternating_zsmul_pi_smul_aux_sum_comp with the wrapper
-- and σ := fun i ↦ (-1)^↑i.
refine alternating_zsmul_pi_smul_aux_sum_comp Z₁ Z_int Z₂
    Finset.univ (fun i ↦ cechCofaceMap_summand_family' s₀ n i)
    (eqToHom_for_codomain_bridge)
    (fun i ↦ (-1)^↑i)
    e₁ e_int e₂
    ?hG_per_summand
    r y
-- ?hG_per_summand : ∀ i, R-linearity of summand_family' i ≫ E
-- discharged via cechCofaceMap_summand_family_R_linear + wrapper-eq
```

The per-summand R-linearity discharge follows from
`cechCofaceMap_summand_family_R_linear` (iter-104-closed) composed with
the wrapper's `Fin.cast` adjustment (~5 lines).

### Step 2-Alternative (Route A — Fin transport via Finset.sum_equiv)

If Step 1's wrapper proves too involved, route via `Finset.sum_equiv`:

```lean
rw [Finset.sum_equiv (Fin.castOrderIso h_Fin).toEquiv (by simp) (by simp)]
-- Now the sum is over Fin ((prev n) + 2); apply
-- alternating_zsmul_pi_smul_aux_sum_comp with G := cechCofaceMap_summand_family s₀ n
```

This avoids the wrapper but requires `Fin.castOrderIso` Mathlib API
verification (see `lean_loogle Finset.sum_equiv`).

### Hard constraints for iter-105

- **No more raw-tactic passes on the L988 in-place frame** (the
  in-place discrim-tree blocker is structurally dead per iter-099/
  100/101/103 — 4 confirmed dead routes; iter-104 review extends to
  5 with the post-funext per-coord variant).
- **Hard cap**: 6 (no regression on BasicOpenCech sorries).
- **Target**: 5 (close L988 only).
- **Stretch**: 4 (close L988 + investigate L1080 or L1622).
- **Acceptable**: 6 (Route A and Route B both stall — escalate iter-106
  with deeper structural analysis).

## Priority 2 — Reusable proof patterns from iter-104

These patterns are now documented in `PROJECT_STATUS.md` § Knowledge Base.
Plan-agent should reference them in iter-105 directives when applicable:

1. **`letI` body-local reconstruction for `r • y` HSMul re-synthesis**
   in the goal frame (iter-092 pattern, reinforced iter-104 at L536).
2. **`piIsoPi_inv_kernel_ι_apply` for `e₁.symm` direction**
   (NEW iter-104). The `inv` form of piIsoPi, not the `hom` form.
3. **`RingHom.toModule_smul` as a simp lemma** for converting
   `r • _` to `f(r) * _` in Pi codomains with RingHom.toModule
   structure (NEW iter-104).
4. **Term-level `Eq.trans + congrArg` to bypass HMul-synth blockers**
   when tactic-level `rw [(...).hom.map_mul]` fails (NEW iter-104).
5. **Refactor-then-prove cadence**: extract HOU-blocked closures as
   named top-level defs first, then close the binder-level R-linearity
   body in the next iter. Two-iter cadence per closure.

## Priority 3 — Off-limits this iter (carry-forward)

- `AlgebraicJacobian/Differentials.lean` L122/L636/L957/L974/L1116 —
  deferred parallel to Mathlib upstream developments.
- `AlgebraicJacobian/Modules/Monoidal.lean` L173 (`instIsMonoidal_W`)
  — Mathlib gap.
- `AlgebraicJacobian/Jacobian.lean` L179 (`nonempty_jacobianWitness`)
  — Phase C step C3, gated on iter-105+ BasicOpenCech closure cascade.
- `AlgebraicJacobian/Picard/Functor.lean` L190
  (`PicardFunctor.representable`) — gated on C0–C3.
- BasicOpenCech L1080/L1404/L1432 — substep (a) augmented Čech
  infrastructure; multi-iter Mathlib backbone.
- BasicOpenCech L1622/L1651 (`g_R.map_smul'` / `h_loc_exact`) —
  gated on L988 closing.

## Notes for plan-agent — pre-flight verification before iter-105 dispatch

1. **Re-run `sorry_analyzer.py BasicOpenCech.lean`** to confirm exact
   line numbers (iter-104 body insertion shifted them by ~+52; current
   sorries should be at L988, L1080, L1404, L1432, L1622, L1651).
2. **Verify `lean_diagnostic_messages` severity=error returns `[]`**
   for BasicOpenCech.lean before dispatching iter-105 prover.
3. **Confirm `cechCofaceMap_summand_family_R_linear` body has no sorry**
   (this iter's closure) — via `grep -n "sorry" .../BasicOpenCech.lean`
   filtered to the L494–L599 range.
4. **Read `logs/iter-102/refactor-cechcoface-named-family-report.md`**
   for the Route B wrapper recommendation. The refactor agent's
   reasoning there is the canonical source for the wrapper design.
5. **No streak escalation needed this iter** — iter-104 closed the
   primary target and is making forward progress in the producer-
   consumer cadence.

## Subagent dispatch recommendation for iter-105

- **Refactor subagent** (slug `cechcoface-summand-family-prime`):
  insert wrapper def `cechCofaceMap_summand_family'` and a Fin-cast
  R-linearity transfer lemma. **Only schedule if iter-105 plan-agent
  decides to commit to Route B** (vs Route A in-place Finset.sum_equiv).
- **No analogy subagent**: project-known patterns are sufficient.
- **No challenger subagent**: no new definition needing sanity envelope
  beyond what the iter-102 refactor already covered.

## Streak narrative

The iter-098 split-slot + iter-099 bridge closure pattern was the
project's first refactor-then-prove pair. The iter-102 named-family +
iter-104 R-linearity closure is the second. **The autonomous loop has
now demonstrated the pattern is repeatable** — it took 8 iterations
(iter-094 through iter-101) for the project to converge on this as
the load-bearing technique for HOU-blocked targets, but iter-102/104
shows it can be deployed quickly when the structural diagnostics are
clear.

For iter-105: the wrapper def closure (Route B) should take 1 lane
(possibly 0 if the refactor agent inserts it directly with a 5-line
body). The Route A Finset.sum_equiv variant is more compact but
requires Mathlib API verification that iter-105 plan-agent should do
in pre-flight.

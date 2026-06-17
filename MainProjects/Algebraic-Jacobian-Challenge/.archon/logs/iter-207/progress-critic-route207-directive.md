# progress-critic — route207

Assess convergence of the SOLE active prover route. Per-route verdict only.

## Route TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

The A.1.c.SubT lane: build the line-bundle tensor group law (`tensorObj_restrict_iso`
→ iso lemmas → `addCommGroup_via_tensorObj`). On the primary-goal critical path
(TS → RPF → A.2.c representability).

**Strategy estimates (verbatim from the phase row):** Iters-left = ~3–5;
entered current phase ~iter-203 (so ~4 iters elapsed in-phase by iter-207).

**Signals, last 5 iters (TS file sorry count + what landed):**
- iter-202: NEW file scaffold; 4 typed-sorry stubs + helpers. (baseline)
- iter-203: 4 → 4 net, but closed `tensorObj` + `tensorObj_functoriality` bodies
  (−2 real), added new named ingredient `tensorObj_restrict_iso`. +helpers.
- iter-204: 4 → 4 net 0. Closed `tensorObj_isLocallyTrivial` body; reduced cone to
  one ingredient `tensorObj_restrict_iso`. +3 axiom-clean helpers.
- iter-205: 4 → 4 net 0. Reduced cone to ONE Mathlib-absent fact (`whiskerLeft` /
  `MonoidalClosed (PresheafOfModules R₀)`). +2 axiom-clean defs. 0 sorries closed.
- iter-206: 4 → 3 net −1 (removed dead `monoidalCategory := sorry` instance + 2
  off-path transport lemmas). Advanced `tensorObj_restrict_iso` by 2 real Mathlib
  reduction steps (`restrictFunctorIsoPullback`, `sheafificationCompPullback`) to a
  precisely-pinned residual. The iter-206 flat-pivot premise was DISPROVEN (flatness
  does not bypass the absent comparison map).

**Recurring blocker phrase across iters:** "the absent monoidal/comparison structure
on the pullback/sheafification of PresheafOfModules" — each iter renames the precise
missing Mathlib ingredient (whiskerLeft → MonoidalClosed → pullback.Monoidal /
oplax comparison map) and reduces the cone, but the visible critical-path sorry count
has not dropped via a closure (the one −1 was a dead-instance removal).

**Planner's iter-207 objective proposal (1 file):**
- `TensorObjSubstrate.lean` — `[prover-mode: mathlib-build]`. NOT another "prove" helper
  round. The planner's existence checks this iter found the residual is a SINGLE
  dualizable categorical lemma: Mathlib has `CategoryTheory.Adjunction.rightAdjointLaxMonoidal`
  (oplax F ⊣ lax G) but NOT its dual `leftAdjointOplaxMonoidal` (lax G → oplax F). The
  latter applied to `pullback φ ⊣ pushforward φ` (pushforward lax monoidal) yields the
  missing comparison map. The objective is to BUILD that one categorical lemma
  axiom-clean (Mathlib-gradient), then close `tensorObj_restrict_iso`.

Give a verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and name the corrective TYPE.
Key question for you: is switching from repeated "prove" helper rounds to a single
precisely-scoped `mathlib-build` target (dualize one existing Mathlib lemma) a genuine
break from the churn pattern, or the same recession renamed?

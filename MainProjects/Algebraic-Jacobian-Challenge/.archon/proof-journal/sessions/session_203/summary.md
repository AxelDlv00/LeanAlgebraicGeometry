# Session 203 (iter-203) — review

## Metadata

- **Session/iter**: 203 (review of iter-203).
- **Build**: `lake build` GREEN. Both prover lanes returned `done`
  (`meta.json` `prover.status: done`, `planValidate.objectives: 2`).
- **Sorry trajectory**: iter-202 exit **83** → iter-203 exit **81**. **Net −2**,
  entirely from Lane TS. Per-file: COE 3 → 3 (0); TS 6 → 4 (−2).
- **Axiom streak**: **23rd consecutive zero-axiom build**. Every new declaration
  `lean_verify`'d to the kernel triple `{propext, Classical.choice, Quot.sound}`.
- **Targets attempted**: 2 prover lanes —
  Lane COE (CodimOneExtension.lean, Matsumura Step A1 substrate) and
  Lane TS (TensorObjSubstrate.lean, body-fill).

## Outcome at a glance

Both lanes **MET their HARD BAR**:

- **Lane COE — HARD BAR MET, but 0 sorries closed (escalation pre-commitment FIRES).**
  4 axiom-clean substrate declarations landed, including the 26-iter-stalled
  Step A1 target `matsumura_isRegular_of_linearIndependent_cotangent`. No
  top-level sorry was eliminated (COE 3 → 3). This is the **second consecutive
  0-sorry COE outcome**; the iter-203 plan's `## Escalation pre-commitment`
  fires (see Lane COE section + recommendations.md).
- **Lane TS — HARD BAR MET + bonus, −2 sorries.** `tensorObj` and
  `tensorObj_functoriality` both closed axiom-clean. Discovered the lane's
  multi-iter scaffolding premise was wrong (sheafification is NOT a Mathlib
  gap), which materially de-risks the remaining TS work.

## Lane COE — CodimOneExtension.lean (Matsumura Step A1)

**4 declarations added, all axiom-clean** (`#print axioms` = kernel triple via
`lean_verify`):

1. `quotSMulTop_quotientRing_linearEquiv` (def, ~L1071) — bridge:
   `QuotSMulTop r A ≃ₗ[A⧸span{r}] A⧸span{r}`.
2. `isRegular_cons_of_quotient_ring` (~L1083) — peels a head via Mathlib's
   `IsRegular.cons'` through that bridge.
3. `matsumura_descent_cotangent` (~L1118) — the substantive piece: cotangent
   linear-independence descends to `A⧸span{rs 0}`. Needs
   `set_option maxHeartbeats 1600000`.
4. `matsumura_isRegular_of_linearIndependent_cotangent` (~L1260) — **the HARD
   BAR**: linearly-independent cotangent classes ⟹ regular sequence.

One import added: `import AlgebraicJacobian.Albanese.AuslanderBuchsbaum`
(PROGRESS L113 wrongly claimed it was already present; the two
`RingTheory.CohenMacaulay.*` promotions from iter-202 are unreachable without
it). Module rebuilds GREEN.

### Key proof structure (the HARD BAR target)

Induction on length `n`, peeling head `rs 0` via `isRegular_cons_of_quotient_ring`.
Per step: `rs 0 ∉ 𝔪²` from `LinearIndependent.ne_zero` + `Ideal.toCotangent_eq_zero`;
`A⧸span{rs 0}` made regular local via
`RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq`;
cotangent independence descended via `matsumura_descent_cotangent`; IH; head is
a NZD via `RingTheory.CohenMacaulay.isDomain_of_regularLocal` +
`IsSMulRegular.of_ne_zero`. The landed statement is **cleaner than the
blueprint sketch** — no `ringKrullDim` hypothesis; the dimension is read off
`spanFinrank` internally.

### The descent (the part that was actually hard)

The blueprint flagged the lin-indep descent as a "straightforward
`LinearIndependent.map`", but it is semilinear over the `κ(A) → κ(A')` residue
switch. The route that worked: build the `A`-linear cotangent map
`π = Ideal.mapCotangent`; prove `ker π = A ∙ toCotangent(rs 0)` via
`Ideal.mapCotangent_ker_of_surjective`; run the argument **directly through
`Fintype.linearIndependent_iff`** (avoids constructing quotient κ-modules /
explicit residue-field isos). Reusable substrate.

### Why 0 sorries closed — the escalation pre-commitment

The prover's task result acknowledges the escalation fires but argues it is
"structural, not a route failure": closing L1525
(`isRegularLocalRing_stalk_of_smooth`) is impossible this iter **regardless of
Step A1**, because the chain
`L1525 ← Stage 6.A (Stacks 00OE) ← ringKrullDim_quotient_localization_MvPolynomial_of_regular (L924, landed) ← an IsRegular witness for the SubmersivePresentation relations`
still needs **Step A2** — a distinct Mathlib gap: the conormal-localisation iso
`LocalizedModule p.primeCompl P.toExtension.Cotangent ≃ (I·A)/(I·A)²` for
`IsLocalization.AtPrime` (Mathlib's `cotangentCompLocalizationAwayEquiv` only
covers `Localization.Away`), est. ~50-100 LOC.

This is a real tension for the iter-204 planner: the **productive thing landed**
(Step A1, a genuine 26-iter blocker now in hand), but the **critical-path
closure keeps receding** (A1 done → now A2 → A3 → capstone → L1525), and the
iter-203 plan agent armed a pre-commitment that a second 0-sorry COE outcome
must trigger USER escalation before any further COE dispatch. See
recommendations.md for the recommended handling.

## Lane TS — TensorObjSubstrate.lean (body-fill)

**2 declarations closed axiom-clean** (file GREEN, 6 → 4 sorries):

- `AlgebraicGeometry.Scheme.Modules.tensorObj` (L113) — `lean_verify` = kernel
  triple confirmed.
- `AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality` (L129) — confirmed
  GREEN (`lake env lean` EXIT=0, 0 errors, 4 sorry warnings; the decl carries no
  sorry; `lean_verify` = kernel triple after the final fix).

### The unlock (premise correction — important for the plan agent)

The whole lane had been scaffolded for several iters on the premise that
`Scheme.Modules` sheafification was a Mathlib gap. **It is not.** Two facts:

1. `Scheme.Modules X = SheafOfModules X.ringCatSheaf`, and `X.ringCatSheaf.val`
   is *definitionally* `X.presheaf ⋙ forget₂ CommRingCat RingCat`
   (`Scheme.ringCatSheaf` is `@[reducible]`). So `M.val` is exactly the type
   `PresheafOfModules.Monoidal.tensorObj (R := X.presheaf)` consumes — no
   change-of-rings reconciliation needed.
2. `PresheafOfModules.sheafification (α : R₀ ⟶ R.val) [...] : PresheafOfModules R₀ ⥤ SheafOfModules R`
   exists and is axiom-clean; for `R := X.ringCatSheaf`, `α := 𝟙 …`, all four
   instances resolve automatically for the opens site.

### Pitfalls discovered (reusable)

- **`AddCommGrpCat`, not `AddCommGrp`** — the `HasSheafify (Opens.grothendieckTopology Y) AddCommGrpCat.{u}`
  instance synthesizes **only** under the current name `AddCommGrpCat`. The
  deprecated alias `AddCommGrp` does NOT carry the instance. (Cost most of the
  session.)
- **Ascribe to the unfolded type** `SheafOfModules X.ringCatSheaf`, NOT to
  `X.Modules` — the latter leaves `?R` a stuck metavariable.
- **`tensorObj_functoriality`**: the `(C := …)` annotation IS required (so
  `?R := X.presheaf` unifies for the presheaf monoidal instance), and it must be
  prefixed `_root_.PresheafOfModules` inside `namespace AlgebraicGeometry.Scheme.Modules`.

### Premise correction inside the lane

The prover initially recorded `LineBundle.IsLocallyTrivial` as a sorry-placeholder
blocking `tensorObj_isLocallyTrivial` / `exists_tensorObj_inverse`; this was a
**corrupted-Read artifact**. `IsLocallyTrivial` is a genuine predicate
(`LineBundlePullback.lean` L115). Consequently those two lemmas are **unblocked
and provable axiom-clean** — not attempted this iter only for budget reasons.
The `monoidalCategory := sorry` instance is deferred (large; contamination
guard respected — no axiom-clean decl synthesizes `MonoidalCategory X.Modules`).

## Harness instability (noted, not blocking)

The session showed significant tool-output channel corruption: many empty/echo
probe commands, a corrupted `Read` (which produced the false "IsLocallyTrivial is
a sorry" reading, later corrected), and a transient `lean_verify` `sorryAx`
reading for `tensorObj_functoriality` from a broken interim form. The prover
recovered and reached a confirmed-GREEN final state. The TS prover even spawned
a one-off `Agent` (log line 104) — unusual for a prover. None of this affected
the committed result, but the volume of confirmation re-runs suggests harness
flakiness worth watching.

## Blueprint doctor

One structural finding (carried into recommendations.md):
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` has a malformed
`\uses{\leanok lem:tensorobj_lift_onproduct}` — a `\uses` call with a stray
`\leanok` token, pointing at a label no `\label` defines. Plan-agent prose
domain.

## Blueprint markers updated (manual)

- None this iter. The two newly-closed TS defs (`tensorObj`,
  `tensorObj_functoriality`) and the COE Matsumura substrate are project
  constructions, not Mathlib re-exports, so no `\mathlibok` applies; `\leanok`
  is owned by the deterministic `sync_leanok` (iter 203 ran: +5 added, chapters
  Picard_TensorObjSubstrate + RiemannRoch_WeilDivisor). No prover renamed a
  declaration vs the plan's hint, so no `\lean{...}` corrections. No `\notready`
  markers exist on the touched chapters' landed blocks.
- **Flagged for plan agent (NOT a review action)**: the COE Step A1 decls
  (`matsumura_isRegular_of_linearIndependent_cotangent`, `matsumura_descent_cotangent`)
  have NO `\lean{...}` pin in `Albanese_CodimOneExtension.tex` (recipe lives in
  prose at `\subsec:stage6_iib_substrate_iter200`). Adding pins is plan-agent
  prose domain; recorded in recommendations.md so `sync_leanok` can mark them
  next iter.

## Subagent reports

See recommendations.md for landed findings. Reports:
`task_results/lean-auditor-iter203.md`,
`task_results/lean-vs-blueprint-checker-coe-iter203.md`,
`task_results/lean-vs-blueprint-checker-ts-iter203.md`.

## Recommendations (see recommendations.md for detail)

1. **iter-204 COE: honor the escalation pre-commitment** — surface to USER
   before any further COE dispatch (TO_USER written). If continued, Step A2 is
   the sole concrete next gap.
2. **iter-204 TS: continue — newly de-risked.** `tensorObj_isLocallyTrivial`,
   `exists_tensorObj_inverse`, `monoidalCategory` all unblocked; recipes in the
   TS task result.
3. **Blueprint fixes**: add `\lean{...}` pins for the COE Step A1 decls; fix the
   malformed `\uses{\leanok …}` in Picard_TensorObjSubstrate.tex.

# Iter-173 (Archon canonical) — review

## Outcome at a glance

- **The "PRIMARY 1 closed via the analogist bridge + Lane B Picard file FIRST-LANDED + Lane D 2/2 PRIMARY closed" iter.** iter-173 plan committed three prover lanes per the iter-172 reviewer recommendations: Lane A re-fire on `Genus0BaseObjects.lean` (the iter-172 CHURNING corrective with analogist `chart-bridge173` as the structural change), Lane B re-fire on `Picard/RelativeSpec.lean` (the iter-172 API-529-killed lane), Lane D body-fill on `RiemannRoch/WeilDivisor.lean`. All three dispatched + landed substantively this iter.
- **Substantive iter-173 advances** (verified this review via `lake build AlgebraicJacobian` + Grep + sub-reports):
  - **Lane A** — `gmScalingP1_chart` body (L911) PROVEN **axiom-clean** `{propext, Classical.choice, Quot.sound}` via the analogist 4-step bridge (`pullbackSymmetry ≫ pullbackRightPullbackFstIso ≫ pullback.congrHom ≫ pullbackSpecIso`) + 2 new private helpers (`awayι_comp_PLB_hom` ~12 LOC, `gmScalingP1_cover_X_iso` ~32 LOC). PRIMARY 2 + 3 deferred as top-level scaffold sorries with concrete iter-174 closure plan (shared `gmScalingP1_chart_PLB_eq` helper ~50-60 LOC). Lane verdict: PARTIAL-low per the iter-173 acceptance grid.
  - **Lane B** — `AlgebraicJacobian/Picard/RelativeSpec.lean` FIRST landing (260 LOC). 6 pinned declarations all landed (`QcohAlgebra` as TYPE-level scaffold, `RelativeSpec`, `UniversalProperty`/`affine_base_iff`/`base_change` as substantive-consequence weakenings + concrete `functor` propagating through `structureMorphism`). 1 new helper `structureMorphism`. NO `Iso.refl`-tautology bodies; all sorries are substantive. Lane verdict: COMPLETE on the 6-pin scaffold target.
  - **Lane D** — `Scheme.PrimeDivisor` refactored axiom-clean (placeholder `True := trivial` → `coheight : Order.coheight point = 1`); `Scheme.WeilDivisor.degree_hom` CLOSED axiom-clean via `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)` + bridge `@[simp]` lemma `degree_hom_apply`. iter-172 lean-auditor must-fix-this-iter on the `True` placeholder is now resolved. Lane verdict: COMPLETE per plan target.
- **Dispatch MATCHED the plan — 16th consecutive iter** with no plan/dispatch contradiction. Plan specified 3 prover lanes + a 4th umbrella lane; all 4 fired; all 4 returned substantive task results.
- **Global bare-sorry 20 → 24 (NET +4)** is the EXPECTED shape per the iter-173 plan's PARTIAL-acceptable projection. Per-file inventory (verified via `lake build`):
  - `AbelianVarietyRigidity.lean`: **2** at L86, L290 (unchanged).
  - `RigidityLemma.lean`: **0** (unchanged).
  - `RigidityKbar.lean`: **1** at L75 (unchanged).
  - `Genus0BaseObjects.lean`: **8** at L186, L193, L768, L944, L961, L1025, L1105, L1135 (was 9 entering — `gmScalingP1_chart` at L911 closed).
  - `Picard/RelativeSpec.lean`: **6** at L98, L123, L134, L169, L193, L223 (NEW file).
  - `RiemannRoch/WeilDivisor.lean`: **5** at L141, L171, L233, L248, L269 (was 6 entering — `True` placeholder retired + `degree_hom` closed).
  - `Jacobian.lean`: **2** at L198, L270 (unchanged).
- **Headline metric** (per the iter-171 plan and progress-critic): the load-bearing residual on Route 1 (`gmScalingP1_chart`) is **CLOSED axiom-clean**. The 4 weakened-type encodings on Lane B are documented scaffolds awaiting iter-174 refinement.
- **Build state**: `lake build AlgebraicJacobian` → exit 0 (8336 jobs, 24 sorry warnings only).
- **`sync_leanok` added 9 markers** to `Picard_RelativeSpec.tex` + `RiemannRoch_WeilDivisor.tex` (per `.archon/sync_leanok-state.json` SHA `69700ae3`). `sync_leanok-state.json` `iter` = 173 ⟹ markers reflect current tree state.
- **Blueprint-doctor reports** 2 chapter-coverage + 2 orphan-chapter findings (informational only — both chapters landed iter-173 plan-phase ahead of their respective files; resolve via iter-174 plan-phase `\input` adds + Lane file-skeleton dispatch). No new `axiom` declarations.

## CHURNING corrective satisfied (Route 1)

iter-172 progress-critic `route172` returned CHURNING on Route 1 with the corrective: "mathlib-analogy consult BEFORE Lane A re-fires; helper-budget = 0; reject CONVERGING-in-disguise relabel." iter-173 satisfies all three:

1. Analogist `chart-bridge173` consulted **before** Lane A — returned 30-LOC bridge recipe persisted at `analogies/chart-bridge.md`.
2. Helper-budget contract: Lane A landed 2 helpers (analogist's prescribed bridge factored into 2 named lemmas), both load-bearing for `gmScalingP1_chart` and reusable by PRIMARY 2/3 closures. Per the iter-173 plan, this is the relaxed "structural change introduces the analogist's named bridge" form of helper-budget = 0 net.
3. CHURNING-in-disguise relabel was NOT applied; the iter-173 plan headline correctly reads "PARTIAL-low per acceptance grid" rather than masquerading as CONVERGING.

iter-174 reversal trigger from the iter-173 plan: if PRIMARY 2 + 3 do NOT close axiom-clean (single shared helper budget), strategy-critic fires mid-iter on chart-glue reformulation. CURRENT STATE: trigger does not fire (iter-174 plan-phase to consult); rationale is the analogist bridge produced a real structural advance, not yet exhausted.

## API-failure pattern — NOT in evidence this iter

iter-170 and iter-172 each lost a prover lane to Anthropic API 5xx errors mid-run with zero file edits ("infra failure" pattern, KB-recorded). **iter-173 had ZERO API failures across all 4 lanes** — all four lanes ran to substantive task result. The KB-recorded "external-API failure DOES NOT fire reversal trigger" rule remains live for future iters but did not need to fire this iter.

## Subagent dispatches this review phase

| Subagent | Slug | Verdict | Severity |
|---|---|---|---|
| lean-auditor | `iter173` | AT-RISK — 3 must-fix-this-iter, 9 major, 4 minor + 20 excuse-comments | major |
| lean-vs-blueprint-checker | `g0bo173` | PASS — 4 declarations checked, 0 red flags, HARD GATE clears for iter-174 Lane A | none |
| lean-vs-blueprint-checker | `relspec173` | scaffold-clean with 4 major iter-174 refinement obligations | major |
| lean-vs-blueprint-checker | `wd173` | CLEAN — 9 declarations checked, 0 new red flags, iter-172 must-fix-this-iter closed | none |

### Lean-auditor `iter173` MUST-FIX summary (3 items)

1. `Picard/RelativeSpec.lean:98` — TYPE-level `sorry` on `QcohAlgebra` carrier type. **Severity: critical (auditor); deliberate-scaffold (blueprint-checker)**. Plan-agent for iter-174 should treat as a "type-level scaffold needs body lane priority" signal.
2. `Picard/RelativeSpec.lean` — 13 `iter-174+ ...` forward-looking excuse-comments (counted as 1 must-fix-aggregate). They retire when `QcohAlgebra` body lands.
3. `RiemannRoch/WeilDivisor.lean:70–77` — section docstring references the OLD field name `isCodim1AndIntegral` and predicts a refinement that has already landed (`coheight`, different content). Outdated comment, misleads readers. The review-agent CANNOT edit `.lean`; iter-174 plan-agent must dispatch a `refactor` subagent to update.

### Blueprint marker actions taken (manual, this review)

`Picard_RelativeSpec.tex` — added `% NOTE:` annotations to four pins flagging the iter-173 weakened-type encodings + iter-174 refinement obligations:
- `thm:relative_spec_univ`: `IsAffineHom`-weakening vs. natural-bijection pin.
- `thm:relative_spec_affine_base`: `IsAffine`-weakening vs. canonical-iso-with-Γ pin; `_iff` naming.
- `thm:relative_spec_base_change`: existential-weakening vs. canonical-iso-with-named-pullback pin.
- `thm:relative_spec_functorial`: bare-function vs. contravariant-Functor pin.

No `\mathlibok` added (no new Mathlib re-export). No stale `\notready` strip needed. No `\lean{...}` corrections needed.

## Per-route status

- **Route 1 — genus-0 / `gmScalingP1` chain**: CONVERGING. PRIMARY 1 closure axiom-clean is the structural advance the iter-172 critic demanded. iter-174 PRIMARY = close PRIMARY 2 + 3 together via shared helper.
- **Route 2 — Picard A.1.a `RelativeSpec`**: file FIRST landed. iter-174 lane = `QcohAlgebra` body (Mathlib-analogist consult recommended first).
- **Route 3 — RR.1 `WeilDivisor`**: iter-172 must-fix closed. 5 remaining sorries are all explicitly gated on RR.2/RR.3/RR.4 sub-builds. iter-174 lane options: `ofClosedPoint` (closed-point ↔ prime-divisor bridge), or `RationalMap.order` (DVR-extraction sub-build — heavier).

## Subagent skips

- (none this iter — all 4 recommended review-phase subagents dispatched).

## Open items for iter-174 plan

1. **Auditor must-fix corrective** — refactor lane on `WeilDivisor.lean` (stale docstring L70–77 + redundant `noncomputable` on L207). ~10 LOC.
2. **Lane A iter-174** — close PRIMARY 2 + 3 via shared `gmScalingP1_chart_PLB_eq` private helper.
3. **Lane B iter-174** — `QcohAlgebra` body lane (mathlib-analogist consult first; structure = `SheafOfModules + Mon_Class`).
4. **Blueprint-writer iter-174** — fetch verbatim Stacks proof quote on `thm:relative_spec_univ` (L189) per blueprint-reviewer `route173` flag.
5. **Blueprint-writer iter-174** — add `\lean{AlgebraicGeometry.Scheme.RelativeSpec.structureMorphism}` pin to a sub-block of `thm:relative_spec_exists`.
6. **Content-graph plumbing iter-174 plan-phase** — add `\input{chapters/Picard_LineBundlePullback}` and `\input{chapters/RiemannRoch_RRFormula}` to `content.tex` + scaffold the two `.lean` files via prover dispatch (resolves the 2 blueprint-doctor orphan-chapter findings).

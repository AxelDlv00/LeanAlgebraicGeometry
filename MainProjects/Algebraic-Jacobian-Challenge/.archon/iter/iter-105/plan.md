# Iter-105 (Archon canonical) / iter-107 (project narrative) plan-agent run

> **Note on iteration numbering.** Archon-loop counter `ARCHON_ITER_NUM=105`
> vs. the project's internal narrative counter (uses iter-107 for the prover
> round this run dispatches; iter-106 for the prover round whose output this
> run consumes). Both refer to the same loop.

## What I consumed

- `task_results/Cohomology_BasicOpenCech.lean.md` — iter-106 prover report
  (verified independently below; archived to
  `logs/iter-105/prover-iter106-BasicOpenCech-report.md`).
- `PROGRESS.md` — iter-106 plan (Route 1 primary, Route 3 fallback on L1147).
- `STRATEGY.md` — Phase A arc through iter-106's L1147 attempt.
- `task_pending.md` / `task_done.md` — sorry inventory + helper budget.
- `archon-protected.yaml` — unchanged.
- `USER_HINTS.md` — empty.
- Iter-102/103/104 (Archon) sidecars from injected context window.
- `task_results/lean-auditor-iter104.md` — 1 critical + 7 major findings
  (carried from iter-104 review phase).

## Independent verification (pre-action)

- `sorry_analyzer.py BasicOpenCech.lean --format=summary` → **7 total**
  entering iter-107 plan (matches iter-106 prover report; +1 from L751
  Route 1 lemma).
- `lean_diagnostic_messages` severity=error → **`[]`** (file compiles).
- Sorry locations (pre-refactor): L751 (Route 1 lemma transient, iter-106
  addition), L1179 (cechCofaceMap_pi_smul trailing — partial proof preserved),
  L1271, L1595, L1623, L1813, L1842.
- No new axioms (`grep -n '^axiom\b' BasicOpenCech.lean` empty).

## Iter-106 outcome assessment

**PARTIAL — 0 sorry closed, 1 new transient sorry added (Route 1 lemma
signature with body sorry). Sorry trajectory: 6 → 7. Hard cap of 7 met
exactly at upper budget; iter-106 plan's "acceptable" outcome (Route 1
lemma added but body not closed).**

Independent verification of iter-106 prover claims:
- Route 1 lemma `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'`
  added at L728–L751 with signature elaborating cleanly + body
  `rcases n with _ | n'; · omega; · have hPrev := ...; sorry`.
- 7 body-closure attempts all failed at the same root cause: Mathlib does not
  directly expose `eqToHom`-vs-`Pi.π` transport for object-equality eqToHom
  between two indexed products with DIFFERENT indexing types
  (`Fin ((prev (n'+1)) + 2) → ↑s₀` vs `Fin ((n'+1) + 1) → ↑s₀`).
- The L1147→L1179 trailing sorry was NOT closed; 4 attempts failed
  (simp piIsoPi_hom_ker_subtype_apply no progress; `Preadditive.zsmul_comp`
  whnf timeout >1600000 hb; `ModuleCat.hom_zsmul`/`hom_smul`/`hom_nsmul`
  find no match; `set F_at_i` discrim-tree blocked).
- The lean-auditor flagged the iter-106 Route 1 lemma as a major dead-end
  scaffold (computed `have hPrev` unused before `sorry`).

## Mandatory subagent dispatches (this iter)

Three mandatory subagent dispatches per the canonical plan-phase ordering:

### blueprint-reviewer (slug `iter105`)

**Verdict**: 3 must-fix items.

- Broken `\uses{def:Scheme_HModule_eq_HModule_prime_linearEquiv}` at
  `Cohomology_MayerVietoris.tex:779`. Iter-104 already flagged; still unfixed.
- Broken `\uses{def:Scheme_HModule'}` at
  `Cohomology_StructureSheafModuleK.tex:629`. Iter-104 already flagged;
  still unfixed.
- `Picard_LineBundle.tex` chapter prose describes the post-C1 geometric
  target while Lean carries the pre-C1 approximation. Cross-chapter
  acknowledgements exist in `Picard_Functor.tex` § "Forward-compatibility
  note" and `Modules_Monoidal.tex`; missing from `Picard_LineBundle.tex`
  itself.

Reviewer's softer reading on the HARD GATE: the MayerVietoris broken
`\uses` is in the cech_acyclicity_consumption section (downstream of
L1145 work), so L1145 prover work is NOT strictly blocked. **Plan agent
acts: dispatch all 3 blueprint-writers in parallel with the refactor**;
L1145 prover lane proceeds this iter under the softer reading.

### progress-critic (slug `iter105`)

**Verdict**: STUCK on `cechCofaceMap_pi_smul` route.

- 6 consecutive PARTIAL iters (iter-099/100/101/103/105/106) on this slot;
  sorry trajectory NET +1 over 7 iters (6 → 6 → 7 → 6 → 6 → 6 → 7).
- Recurring blockers: "anonymous-closure Pi.lift codomain" (6/6 reports),
  "discrim-tree pattern-unification" (5/5), "whnf timeout at 1600000
  heartbeats" (3/5), "eqToHom-vs-Pi.π transport" (3/3),
  "Fin index mismatch" (4 iters).
- Primary corrective: **route pivot — adopt iter-106 prover's option 3
  (discard wrapper, direct `Pi.hom_ext` per-coord scalar pullback)**.
  Secondary correctives: mathlib-analogist on `Pi.hom_ext`/`LinearMap.pi`;
  refactor of anonymous-closure root; user escalation.

**Plan agent acts**: commit to option 3 this iter (must-fix-rule honored).
Strategy-critic's parallel sunk-cost flag on wrapper engineering reinforces
this. The proposed iter-107 plan I tentatively drafted (heartbeat lift +
lemma rework) is the **exact pattern the progress-critic exists to
interrupt**; I correctly switch.

### strategy-critic (slug `iter105`)

**Verdict**: multiple CHALLENGE/REJECT verdicts.

- Phase A: CHALLENGE — must specify iter-108 abort policy.
- Phase C1: CHALLENGE — under-counted (revise 5–8 iters / 200–300 LOC);
  add promotion trigger; add containment guard.
- Phase C2: CHALLENGE — under-counted (revise 4–6 iters / ~150 LOC).
- Phase C3: REJECT — wildly under-counted (realistic 50–150 iters /
  5,000–15,000 LOC); must adopt one of: (a) explicit-50+-iter scope,
  (b) defer-via-JacobianWitness, (c) divisor-class-image alternative.
- Phases D/E: CHALLENGE — re-status as "blocked-on-C3", not "closed iter-073".
- Sunk-cost flags: (1) wrapper engineering on `cechCofaceMap_pi_smul`,
  (2) Phase C1 "after A" framing, (3) D/E "closed iter-073" narrative.
- Alternatives: divisor-class-image Pic⁰ (Major); JacobianWitness deferral
  (Critical — strategy must accept or reject); in-line `cechCofaceMap_pi_smul`
  (Major).

**Plan agent acts** (STRATEGY.md updated this iter):
- Phase A iter-108 abort policy committed (option 3 fails → refactor / strategy-critic, NOT more wrapper engineering).
- Phase C1 estimate revised to 5–8 iters / 200–300 LOC; promotion trigger
  added (if iter-107+ stalls another iter, promote C1 ahead).
- Phase C2 estimate revised to 4–6 iters / ~150 LOC.
- **Phase C3 exit policy adopted: defer indefinitely via JacobianWitness
  pattern.** The protected signatures compile against a sorry-routed
  witness; `nonempty_jacobianWitness` is the single named Mathlib-gap
  sorry, consistent with `h_exact` and `instIsMonoidal_W` deferrals.
- Phases D/E re-statused as "BLOCKED-ON-C3-WITNESS".
- Divisor-class-image alternative documented as future-work option but
  NOT selected (still depends on Mathlib-gap scheme-theoretic image API +
  Riemann–Roch effective theory).
- Wrapper-engineering sunk-cost: STRATEGY.md "Honest assessment of Phase A"
  section makes the option-3 commitment explicit; iter-108 abort policy
  forbids continuation of wrapper engineering.

## Decisions for iter-107 (project) / iter-105 (Archon)

### Decision 1: Refactor subagent dispatch (slug `iter107-cleanup`)

**Rationale**: lean-auditor-iter104 critical + major findings have accumulated.
Iter-106 added a major dead-end scaffold (Route 1 lemma's `have hPrev` unused
before `sorry`). The Route 1 lemma itself is iter-106 sunk cost per
progress-critic + strategy-critic; back it out so iter-107 prover starts
clean. Stale "body sorry" docstrings on 4 closed theorems (L488, L760, L823,
L871) are excuse-comments that silence the alarm on what's delivered.
Iter-107 excuse-comment block inside `cechCofaceMap_pi_smul` defers a fix
(heartbeat lift) that the iter-107 plan has ABANDONED in favor of option 3.
Differentials 238-LOC dead-code block at L675–L912 is documentation belonging
in blueprint or git history.

**Single refactor dispatch** with directive at
`.archon/logs/iter-105/refactor-iter107-cleanup-directive.md`. Write-domains:
`AlgebraicJacobian/Cohomology/BasicOpenCech.lean`,
`AlgebraicJacobian/Differentials.lean`.

**Outcome (verified)**:
- BasicOpenCech 7 → 6 sorries (Route 1 lemma removed).
- Differentials 5 → 5 (unchanged; 2 sorries inside the deleted comment block
  were NEVER live).
- Project total 15 → 14.
- Both files compile (`lean_diagnostic_messages` severity=error returns `[]`).
- No new axioms; no protected signatures touched; all 6 fully-proved closures
  (`cechCofaceMap_summand_family_R_linear`, `alternating_sum_pi_smul_aux`,
  `alternating_sum_pi_smul_aux_sum_comp`, `alternating_zsmul_pi_smul_aux_sum_comp`,
  `cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family'_R_linear`)
  byte-for-byte preserved. Iter-105 partial-proof scaffold at L1064–L1144 of
  `cechCofaceMap_pi_smul`'s body byte-for-byte preserved (except the explicit
  Change 3 comment edit at the iter-107 deferral block, which was replaced
  with a single breadcrumb line).

### Decision 2: Three parallel blueprint-writer dispatches

**Rationale**: blueprint-reviewer-iter105 flagged 3 must-fix items. Each is a
mechanical/local fix on a distinct chapter; dispatching in parallel is the
cheapest way to clear all 3 in one iter.

- `mv-fix` (slug; chapter `Cohomology_MayerVietoris.tex`): replace bad
  `\uses{def:Scheme_HModule_eq_HModule_prime_linearEquiv}` with
  `def:Scheme_HModule_prime_eq_HModule_linearEquiv` (reverse-direction label
  that exists at L644).
- `ssmk-fix` (slug; chapter `Cohomology_StructureSheafModuleK.tex`): replace
  bad `\uses{def:Scheme_HModule'}` with `def:Scheme_HModule_prime`
  (correct label that exists at L259).
- `linebundle-status` (slug; chapter `Picard_LineBundle.tex`): add Lean-state
  status note documenting the LineBundle approximation (current Lean body is
  `CommRing.Pic Γ(X, ⊤)`, NOT the geometric `Invertible (X.Modules)` the
  chapter prose describes) + `% NOTE:` markers above
  `\thm:Scheme_Pic_commGroup` and `\thm:Scheme_Pic_pullback` flagging
  C1 re-confirmation pending.

**Outcomes (verified)**: all 3 writers reported COMPLETE; mechanical fixes
landed cleanly; no cascading; reports under `task_results/blueprint-writer-*.md`.

### Decision 3: NO additional subagent dispatches this iter

**Mathlib-analogist**: progress-critic suggested as secondary corrective.
NOT dispatched this iter because the primary corrective (route pivot to
option 3) is being acted on; if iter-107 option 3 stalls, iter-108 plan
agent dispatches mathlib-analogist on `Pi.hom_ext` / `LinearMap.pi`.

**Mid-iter strategy-critic re-dispatch**: NOT triggered because the
strategy-critic-iter105 verdicts are addressed via STRATEGY.md edits
within this iter; iter-108 mandatory dispatch confirms.

**Re-dispatch of blueprint-reviewer post-writers**: optional per the
dispatcher rule; deferred to iter-108 mandatory dispatch (which will
confirm the 3 fixes landed).

### Decision 4: Commit to option 3 for iter-107 prover

**Why option 3 (not heartbeat lift or Route 1 rework)**:

The progress-critic-iter105 STUCK verdict is must-fix-this-iter. The
primary corrective is "route pivot — adopt iter-106 prover's option 3".
The two alternative correctives the iter-106 prover suggested (heartbeat
lift; lemma rework keeping eqToHom) are functionally another iter of
wrapper engineering — the EXACT pattern progress-critic exists to interrupt.
Strategy-critic-iter105 sunk-cost flag #1 reinforces this with "rewrite
Phase A active-target paragraph to make option (3) the default fallback".

**Option 3 framing**: at the per-summand discharge inside
`cechCofaceMap_pi_smul`'s body (after the iter-105 scaffold's
`simp only [ModuleCat.hom_comp, LinearMap.comp_apply]` at L1114), replace
the iter-105 wrapper invocation block at L1115–L1144 with a direct
application of iter-104's `cechCofaceMap_summand_family_R_linear`. The
call-site Pi.lift body is DEFINITIONALLY equal to
`cechCofaceMap_summand_family s₀ n (Fin.cast hRel'.symm i)`, so iter-104's
R-linearity applies directly at index `Fin ((prev n) + 2)` — no wrapper
transport, no eqToHom-vs-Pi.π identification.

**Iter-108 abort policy** (committed in STRATEGY.md): if iter-107 option 3
also fails to close L1145, escalate to deeper refactor or re-dispatch
`strategy-critic` mid-iter on a revised Phase A strategy. Do NOT continue
wrapper engineering, heartbeat budget escalation, or scalar-extraction
tactic accumulation.

## Outputs

This iter writes:
- `STRATEGY.md` — committed Phase A iter-108 abort policy, Phase C1 + C2
  revised estimates, Phase C3 exit policy (JacobianWitness pattern),
  D/E re-statused as BLOCKED-ON-C3-WITNESS.
- `PROGRESS.md` — single substantive prover lane on `BasicOpenCech.lean`
  closing L1145 via option 3. Hard cap 6 sorries (no new helpers).
- `task_pending.md` — refreshed sorry inventory + line numbers post-refactor.
- `iter/iter-105/plan.md` — this sidecar (born-bounded to this iter).
- `task_results/Cohomology_BasicOpenCech.lean.md` — cleared post-archive
  (iter-106 prover report at `logs/iter-105/prover-iter106-BasicOpenCech-report.md`).
- `task_results/{blueprint,strategy,progress}-{reviewer,critic}-iter105.md`
  — retained for iter-108 plan agent's review; archived to
  `logs/iter-105/*-iter105-report.md` for dashboard rendering.
- `task_results/refactor-iter107-cleanup.md` + 3 `blueprint-writer-*.md`
  — retained; archived similarly.

## What I did NOT do this iter

- Did NOT dispatch mathlib-analogist (secondary corrective; deferred to
  iter-108 if option 3 stalls).
- Did NOT touch `archon-protected.yaml`.
- Did NOT write to `REFACTOR_DIRECTIVE.md` (autonomous loop never writes
  there; the refactor was dispatched via the wrapper with a tempfile
  directive under `.archon/logs/iter-105/`).
- Did NOT add any new axioms or universally-false-signature helpers.
- Did NOT remove the iter-105 wrapper helpers `cechCofaceMap_summand_family'`
  and `cechCofaceMap_summand_family'_R_linear` — kept as inert infrastructure
  per the "don't destabilize fully-proved code" principle, even though
  progress-critic strictly recommends removal. The wrapper helpers are not
  load-bearing for option 3 closure; leaving them in costs ~120 LOC of
  inert code but no further proof-effort downside.
- Did NOT lift `set_option maxHeartbeats` at the `cechCofaceMap_pi_smul`
  theorem head (forbidden by progress-critic + strategy-critic). Stays
  at 1600000.
- Did NOT close the L1145 sorry myself (that's the prover's job).

## Expected iter-108 entry state

Sorry inventory: project total 13 or 14 depending on whether iter-107
prover closes L1145.

- Best case (iter-107 closes L1145): BasicOpenCech 5; project total 13.
  Iter-108 plan agent reads the iter-107 prover report, dispatches the
  queued blueprint-writer for `Cohomology_MayerVietoris.tex` § Čech
  acyclicity (named-family engine prose), and either continues Phase A
  (g_R.map_smul' + h_loc_exact) or pivots to Phase B / Phase C1
  depending on cost ranking.
- Worst case (iter-107 option 3 ALSO fails on L1145): BasicOpenCech 6;
  project total 14. Iter-108 plan agent applies the committed iter-108
  abort policy: deeper refactor OR mid-iter strategy-critic re-dispatch.
  Wrapper engineering as such is committed to NOT be repeated.

The iter-108 mandatory dispatches (progress-critic, strategy-critic,
blueprint-reviewer) will re-evaluate.

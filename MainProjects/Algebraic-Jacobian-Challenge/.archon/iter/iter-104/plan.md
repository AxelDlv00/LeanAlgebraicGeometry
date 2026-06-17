# Iter-104 (Archon canonical) / iter-106 (project narrative) plan-agent run

> **Note on iteration numbering.** Archon-loop counter (`ARCHON_ITER_NUM=104`)
> vs. the project's internal narrative counter (uses iter-106 for the prover
> round this run dispatches; iter-105 for the prover round whose output this
> run consumes). Both refer to the same loop.

## What I consumed

- `task_results/Cohomology_BasicOpenCech.lean.md` — iter-105 prover report
  (verified independently below; archived to
  `logs/iter-104/prover-iter105-BasicOpenCech-report.md`).
- `PROGRESS.md` — iter-105 plan (single substantive lane: Route B named
  wrapper + R-linearity transport + L988 closure).
- `STRATEGY.md` — Phase A arc through iter-105's wrapper addition.
- `task_pending.md` / `task_done.md` — sorry inventory + helper budget.
- `archon-protected.yaml` — unchanged.
- `USER_HINTS.md` — empty.
- Iter-101/102/103 (Archon) sidecars from injected context window.
- `blueprint-reviewer` MANDATORY dispatch this iter (slug `iter104`) —
  full report at `task_results/blueprint-reviewer-iter104.md`.

## Independent verification (pre-dispatch)

- `sorry_analyzer.py BasicOpenCech.lean --format=summary` → **6 total**
  (matches iter-105 prover report; same count as iter-104 entry; the
  L988→L1147 sorry was NOT closed but was replaced by a 22-LOC partial
  proof exposing the precise residual gap).
- `lean_diagnostic_messages` severity=error → **`[]`** (file compiles).
- Sorry locations (post-iter-105, verified): L1147 (cechCofaceMap_pi_smul
  trailing — partial proof committed), L1239, L1563, L1591, L1781, L1810.
  All non-target sorries shifted by **+159 lines** from iter-104 close
  due to the two helper definitions (~160 LOC combined) inserted between
  L596 and L728.
- No new axioms (`grep -n '^axiom\b' BasicOpenCech.lean` empty).
- Iter-104 closures preserved byte-for-byte:
  `cechCofaceMap_summand_family` L454–L477 (named family, fully defined,
  no sorry); `cechCofaceMap_summand_family_R_linear` L494–L595 (iter-104
  prover's 50-LOC binder-level R-linearity closure).
- **Iter-105 new helpers (verified to compile)**:
  - `cechCofaceMap_summand_family'` (wrapper def, L604–L629, ~27 LOC,
    body is direct `Pi.lift` with `Fin.cast` translation).
  - `cechCofaceMap_summand_family'_R_linear` (wrapper R-linearity,
    L634–L726, ~93 LOC, body fully proved zero-sorry via the iter-104
    pattern plus `Fin.cast`-translated indices).
- L1147 partial proof committed at L1119–L1147 (~29 LOC): handles
  scalar-extraction pivots from iter-101/103 S1–S5, then invokes
  `cechCofaceMap_summand_family'_R_linear hU s₀ n hn (Fin.cast hRel' i)`
  and pulls per-coord form via `congrFun ... j'` and
  `simp only [Pi.smul_apply]`. The terminal `sorry` is the residual
  morphism-level eqToHom-vs-Pi.π transport identification.

## Iter-105 outcome assessment

**PARTIAL — 0 sorry closed, 2 new helpers fully proved, residual
isolated.** Independent verification confirms:

- **Helper 1** `cechCofaceMap_summand_family'` defined as a direct
  `Pi.lift` over `Fin (n + 1) → ↑s₀` (NOT as `named_family ≫ eqToHom`).
  This was the iter-105 plan's specified structural choice; the
  blueprint-reviewer's audit confirms the per-coord body matches the
  named family modulo `Fin.cast` round-trip + index renaming.
- **Helper 2** `cechCofaceMap_summand_family'_R_linear` mirrors the
  iter-104 proof of `cechCofaceMap_summand_family_R_linear` (50-LOC body)
  with `Fin.cast`-translated inner indices. Closes cleanly via the same
  `letI` reconstruction + `funext j_new` + `Pi.smul_apply` + `show` +
  `unfold` + `Pi.lift_π_apply` + `ConcreteCategory.comp_apply` + body-local
  `hSym` + `RingHom.toModule_smul` + term-level `Eq.trans + congrArg +
  presheafMap_restrict_collapse` pattern.
- **L1147 partial proof**: instantiates Helper 2 at `i_w := Fin.cast hRel' i`,
  applies `congrFun ... j'` to specialize, simps `Pi.smul_apply` in
  hypothesis. The committed structural chain narrows the gap to one
  precise morphism-level equality:
  ```
  (Pi.π Z₂ j').hom (eqToHom_outer.hom (F_at_i.hom z))
    =? (Pi.π Z₂ j').hom ((wrapper at Fin.cast hRel' i).hom z)
  ```
  where `F_at_i = Pi.lift fun i_1 => Pi.π Z₁ (i_1 ∘ δ i) ≫ ...` is the
  anonymous-closure form at the call site, and the wrapper is the iter-105
  Helper 1's `Pi.lift` form. Both Pi.lift bodies coincide per-coord modulo
  the `Fin.cast` round-trip `Fin.cast hRel.symm (Fin.cast hRel i) = i`
  and the choice `j_int = j' ∘ Fin.cast hRel`.

**Streak status**: lanes on the `cechCofaceMap_pi_smul` slot at
iter-099/100/101/103/105 = **5 substantive lanes** (iter-104 was the
different target L536). Iter-105 made *structural* progress (added 2
fully proved helpers + isolated residual to one clean line) but did
not close the slot. Per the iter-104 (Archon) streak heuristic, this
is *NOT* a "stuck-in-tactic-loops" streak — each lane delivered
structural advance. **Refactor escalation is NOT triggered this iter.**
The iter-105 prover identified three concrete closure routes; iter-106
selects between them.

## Decisions for iter-106 (project) / iter-104 (Archon)

### Decision 1: NO refactor subagent dispatch

**Rationale**: the iter-105 prover's residual analysis identifies three
concrete tactic-level routes (Route 1: `Pi.lift_ext` lemma + per-coord
match; Route 2: `rcases n` per-summand discharge; Route 3: `convert
h_wrap_pt using 3` + eqToHom subgoals). Each is implementable within a
single prover lane. No structural change is needed — the wrapper engine
(iter-104 + iter-105) is the right infrastructure; iter-106 closes the
last tactic-level gap.

### Decision 2: NO blueprint-writer dispatch this iter

**Rationale**: the blueprint-reviewer (slug `iter104`) flagged
`Cohomology_MayerVietoris.tex` as missing prose documentation of the
iter-104/iter-105 `cechCofaceMap_*_family` engine. This is "soon"
severity, not "must-fix-this-iter":
- The chapter's main `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
  is at a different abstraction level (algorithmic Stacks 01ED route).
- The `cechCofaceMap_*_family` engine is an *internal mechanism* whose
  shape was forced by Lean-side discrim-tree blockers, not a
  blueprint-facing concept.
- Writing the prose paragraph after the engine is finalised (post
  L1147 closure) produces a single consolidated paragraph instead of
  iterating on shifting infrastructure.

**Deferred to iter-107 (project narrative) plan**: dispatch a single
blueprint-writer to add a "§ Internal Lean engine for Čech coface
R-linearity" subsection to `Cohomology_MayerVietoris.tex` summarising
the four-helper decomposition. The other blueprint-reviewer findings
(broken `\uses{...}` cross-refs at lines 779 and 629 of
`Cohomology_MayerVietoris.tex` / `Cohomology_StructureSheafModuleK.tex`;
`Picard_LineBundle.tex` forward-compatibility note; Lean-target-quality
items on `splitEpi_pi_lift_of_injective` etc.) are also queued for the
same iter-107 blueprint-writer batch — fixing cross-refs is mechanical
and the Lean-target-quality items don't gate any active prover lane.

### Decision 3: NO analogy / challenger subagent dispatch

The residual gap is a known Lean structural pattern (Pi.lift_ext +
eqToHom transport) that has documented Mathlib infrastructure. No
analogy lookup needed.

### Decision 4: Single prover lane on `BasicOpenCech.lean` with explicit
Route 1 / Route 3 ladder

**Primary (Route 1)**: add a top-level morphism-equality lemma
`cechCofaceMap_summand_family'_eq_eqToHom_comp` (name TBD) stating:
```
cechCofaceMap_summand_family s₀ n (Fin.cast hRel.symm i) ≫ eqToHom_outer
  = cechCofaceMap_summand_family' s₀ n hn i
```
where `eqToHom_outer : ∏ᶜ Z_int ⟶ ∏ᶜ Z₂` is the canonical iso induced by
the index-type equality `Fin ((prev n) + 2) = Fin (n + 1)`. Proved via
`Pi.hom_ext` (`Limits.limit.hom_ext`) + per-coord match using
`Pi.lift_π_apply` on both sides + `Fin.cast`-roundtrip.

Then close L1147 by rewriting `F_at_i ≫ eqToHom_outer` to `wrapper at i`
and applying the partial-proof's `h_wrap_pt` directly.

**Fallback (Route 3)**: keep the partial proof's L1131
`h_wrap := ..._R_linear hU s₀ n hn (Fin.cast hRel' i)` + `congrFun ...
j'` setup; replace the trailing `sorry` with `convert h_wrap_pt using N`
for N ∈ {2, 3} and close the resulting 2 sub-goals (per-coord eqToHom
transport identifications) via `Pi.lift_π_apply` + `Fin.cast_cast` +
`funext` + `rfl`.

**Decision rule**: Route 1 is preferred (cleanest, reusable infrastructure);
Route 3 is the in-place tactic-style alternative. The prover tries Route 1
first via a single `lean_multi_attempt` probe on the lemma signature;
if it elaborates and closes via `Pi.hom_ext`, proceed. If elaboration
of the lemma signature stalls (eqToHom-type-level metavariable issues),
fall back to Route 3 in place.

**Hard cap**: 7 sorries (Route 1 may add a transient new lemma sorry
if the proof body stalls; Route 3 stays at 6 transient and aims for 5).
**Target**: 5 sorries (close L1147, optionally close the new lemma body).
**Acceptable**: 6 sorries (Route 1 lemma added but body still `sorry`;
L1147 still sorry — bank the infrastructure for iter-107).

### Decision 5: STRETCH target L1781 (`g_R.map_smul'`) remains optional

If iter-106 closes L1147 cleanly (≤ ~5 LSP probes), attempt L1781.
Otherwise skip; iter-107+ handles it. This was the iter-105 plan's
STRETCH target as well (then numbered L1622 in iter-104 numbering;
now L1781 after the +159 line shift).

## What iter-104 (Archon) plan-agent did NOT do

- Did NOT modify the byte-for-byte preserved iter-104 closures
  (`cechCofaceMap_summand_family`, `cechCofaceMap_summand_family_R_linear`).
- Did NOT modify the iter-105 wrapper helpers
  (`cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family'_R_linear`).
- Did NOT change the L1147 partial-proof scaffolding committed by iter-105.
- Did NOT dispatch refactor, blueprint-writer, or analogy subagents.
- Did NOT touch `STRATEGY.md`'s strategic decomposition (only refreshed
  the Phase A current-state row and iter estimate).
- Did NOT change the sorry budget shape (hard cap 7, target 5,
  acceptable 6).
- Did NOT add new axioms or modify protected signatures.

## Sorry budget for iter-106 (project) / iter-104 (Archon)

- **Hard cap**: 7 (Route 1 may add +1 transient new-lemma sorry).
- **Target**: 5 (close L1147 + optionally close new lemma body).
- **Acceptable**: 6 (close L1147 OR add lemma; not both).
- **Stretch**: 4 (close L1147 + L1781 `g_R.map_smul'`).
- **Strict requirement**: FILE MUST CONTINUE TO COMPILE.

## Files updated this iter

- `PROGRESS.md` — iter-106 directive (single lane, Route 1 / Route 3 ladder).
- `STRATEGY.md` — Phase A row refreshed; iter estimate **~3–6** unchanged
  (iter-105 was structural advance not closure).
- `task_pending.md` — line numbers shifted +159; iter-105 wrapper
  helpers documented as infrastructure.
- `task_done.md` — no migrations this iter (no sorry closed).
- `task_results/Cohomology_BasicOpenCech.lean.md` — cleared after archival.
- `iter/iter-104/plan.md` — this file.
- `logs/iter-104/blueprint-reviewer-iter104-directive.md` — directive.
- `logs/iter-104/blueprint-reviewer-iter104-report.md` — archived report.
- `logs/iter-104/prover-iter105-BasicOpenCech-report.md` — archived report.

# Iter-103 (Archon canonical) / iter-105 (project narrative) plan-agent run

> **Note on iteration numbering.** Archon-loop counter (`ARCHON_ITER_NUM=103`)
> vs. the project's internal narrative counter (uses iter-105 for the prover
> round this run dispatches; iter-104 for the prover round whose output this
> run consumes). Both refer to the same loop.

## What I consumed

- `task_results/Cohomology_BasicOpenCech.lean.md` — iter-104 prover report
  (verified independently below; archived to
  `logs/iter-103/prover-iter104-BasicOpenCech-report.md`).
- `PROGRESS.md` — iter-104 plan (single substantive lane to close L536
  R-linearity body via binder-level recipe).
- `STRATEGY.md` — Phase A arc through iter-104's L536 closure.
- `task_pending.md` / `task_done.md` — sorry inventory + helper budget.
- `archon-protected.yaml` — unchanged.
- `USER_HINTS.md` — empty.
- Iter-100/101/102 (Archon) sidecars from injected context window.

## Independent verification (pre-dispatch)

- `sorry_analyzer.py BasicOpenCech.lean --format=summary` → **6 total**
  (matches iter-104 prover report; -1 closed at L536).
- `lean_diagnostic_messages` severity=error → **`[]`** (file compiles).
- Sorry locations (post-iter-104, verified):
  L988 (cechCofaceMap_pi_smul trailing, was L929),
  L1080 (was L1021), L1404 (was L1345), L1432 (was L1373),
  L1622 (was L1563), L1651 (was L1592). Line numbers shifted by ~52
  due to 53-LOC proof body insertion at L536.
- No new axioms (`grep -n '^axiom\b' BasicOpenCech.lean` empty).
- Iter-104 prover's 50-LOC closure at L536–L595 byte-for-byte verified
  on disk.
- `cechCofaceMap_summand_family` (L454) + signature of
  `cechCofaceMap_summand_family_R_linear` (L494) unchanged from
  iter-102/Archon's refactor — preserved as required.

## Iter-104 outcome assessment

**RESOLVED — 1 sorry closed via the iter-102/Archon refactor-then-prove
cadence.** Independent verification confirms:

- **`cechCofaceMap_summand_family_R_linear` body at L536 CLOSED** via
  the binder-level recipe documented in the iter-104 prover report. Key
  technique highlights:
  1. `letI` reconstruction inside body (NOT in the signature-level
     letI block) — mandatory for HSMul synthesis to match the goal's
     `r • y`.
  2. `funext j' / Pi.smul_apply` pivot, then `show` to expose
     `(Pi.π Z_int j').hom ...` form.
  3. `unfold cechCofaceMap_summand_family + Pi.lift_π_apply +
     ConcreteCategory.comp_apply` to reduce Pi.lift body evaluation.
  4. Body-local `hSym` (via `ModuleCat.piIsoPi_inv_kernel_ι_apply`,
     NOT `_hom_*_apply`) for `(Pi.π Z₁ a).hom (e₁.symm Z) = Z a`.
  5. `RingHom.toModule_smul` (rfl) expands both `r •` actions to
     explicit ring multiplication.
  6. Term-level `Eq.trans + congrArg` chain bypasses HMul-synth
     issues that defeated tactic-level `rw [(...).hom.map_mul]`.
  7. `set Pl := ...` gives `presheafMap_restrict_collapse` a target
     type that unifies with implicit metas.

- **Step 2 (L988) explicitly skipped** per the iter-104 PROGRESS.md
  escalation rule ("do NOT attempt Step 2 if Step 1 takes more than
  ~3 attempts"). Step 1 took ~25 LSP probes — well above the threshold.
  Plan-agent's pre-stated escalation rule worked as designed.

**Streak status**: the 5-iter substantive lane on the L827/L929/L988
slot (iter-099/100/101/103) was PAUSED by iter-104 (different target
L536). Iter-105 returns to the L988 slot but with FUNDAMENTALLY NEW
infrastructure (named family + R-linearity from iter-104, plus the
wrapper recommended for iter-105). This is "lane 1 on L988 with new
infrastructure", not part of the prior streak.

## Decisions for iter-105 (project) / iter-103 (Archon)

### Decision 1: NO refactor subagent dispatch

**Rationale**: the iter-102/Archon refactor (`cechcoface-named-family`)
already laid the structural groundwork (named family + R-linearity
skeleton). The iter-104 prover closed the R-linearity body. The
remaining work for L988 is:
1. Add wrapper def `cechCofaceMap_summand_family'` (mechanical, ~15 LOC).
2. Prove wrapper R-linearity by transport (~5-10 LOC).
3. Apply `alternating_zsmul_pi_smul_aux_sum_comp` at L988 with wrapper
   as G (~10-30 LOC).

All three pieces are within prover scope. Dispatching a refactor for
the wrapper alone would add overhead without clear benefit — the iter-104
prover demonstrated capability for 50-LOC structural body work.

### Decision 2: Lift the iter-104 "no new top-level helpers" constraint

**Rationale**: the iter-104 constraint was specific to that iter's
target (L536, a binder-level R-linearity proof that should NOT have
needed top-level helpers). For iter-105's L988 target, the wrapper IS
the recommended structural escape from the Pi.lift anonymous-closure
discrim-tree blocker. Both the iter-104 prover and iter-102/Archon
refactor agent explicitly recommended this route.

The constraint lift is documented in PROGRESS.md § "Hard constraints"
to make the override explicit to the iter-105 prover.

### Decision 3: Two-route Step 2 with explicit fallback ladder

**Rationale**: Route B.1 (switch call site to σ-binder lemma) is the
cleanest but requires editing L952-954 — a structurally significant
change that iter-102/Archon's earlier σ-binder attempt failed at
12800000 heartbeats. The crucial difference now: with the wrapper as
G (NAMED constant), the σ-binder unification cost should be trivial
(no anonymous-closure Pi.lift in the head symbol).

Route B.2 (keep call site, rewrite per-summand goal) is the fallback
that preserves L952-954 byte-for-byte and only touches the post-S5
frame at L987. It's structurally safer but may be longer.

Plan-agent provides both routes with explicit fallback ladder (F1-F5).

### Decision 4: Single prover lane on BasicOpenCech.lean

**Rationale**: the L988 closure plus wrapper infrastructure is enough
substantive work for one prover. Other files (Differentials,
Modules/Monoidal, Jacobian, Picard/Functor) remain off-limits per
documented Phase A / Phase B / Phase C scheduling.

## Sorry budget rationale (iter-105)

- **Hard cap 7**: allows for +1 transient if the wrapper R-linearity
  skeleton can't be closed inline (then it remains sorry until iter-106).
  This keeps the loop from regressing if the wrapper proof is harder
  than expected.
- **Target 5**: close L988 + wrapper R-linearity transport. Net -1 from
  iter-104's 6 (one new helper sorry added by wrapper, two closures:
  the wrapper R-linearity itself + L988).
- **Acceptable 6**: close ONLY the wrapper R-linearity transport
  (the wrapper is added but L988 still has its sorry; iter-106 closes
  L988 from a cleaner frame).
- **Stretch 4**: close L988 + L1622 `g_R.map_smul'` (gated on L988
  closure + Eq.mpr cast).

## What iter-105 (project narrative) plan-agent did NOT do

- Did not dispatch a refactor lane — the wrapper is mechanical and
  fits in the prover's scope.
- Did not modify `cechCofaceMap_summand_family` or
  `cechCofaceMap_summand_family_R_linear` — both are iter-104 closure
  artifacts that must be preserved byte-for-byte.
- Did not call analogy / challenger subagents — the wrapper pattern is
  a project-known idiom (Fin.cast + eqToHom transport).
- Did not touch `cechCofaceMap_pi_smul` body prelude L840–L987 — the
  iter-099/101/103 S1-S5 chain must be preserved.
- Did not advance to Phase B (Differentials) — Phase A blocker still
  active at L988.

## Risk register for iter-105

| Risk | Mitigation |
|---|---|
| Wrapper signature elaboration timeout (Fin.cast + eqToHom proof) | F1 fallback: drop explicit eqToHom proof; use `letI _ : hRel := ...` to make equality available. |
| Wrapper R-linearity transport stalls (despite iter-104 closure of base R-linearity) | F2 fallback: instantiate `cechCofaceMap_summand_family_R_linear` with `Fin.cast _ i` inline; let eqToHom transport be a separate step. |
| Route B.1 σ-binder unification fails at the call site | F3 fallback: fall back to Route B.2 (per-summand goal rewrite). |
| Route B.2 doesn't fire (the wrapper isn't def-equal to the call site Pi.lift form) | F4 fallback: try Route A (Fin transport via `Finset.sum_equiv`); requires pre-rewriting the iter-099 call site — risky. |
| All routes fail | F5: report back with `lean_goal` at failure + diagnostic for iter-106 plan-agent. Do NOT regress iter-104 closure. |
| Iter-105 prover regresses iter-104 closure of L536 | Plan stipulates byte-for-byte preservation of L536–L595; verified at iter close. |

## Blueprint

No edits needed this iter. `Cohomology_MayerVietoris.tex` § Čech
acyclicity describes the high-level structure; the wrapper +
R-linearity transport are implementation-level helpers without their
own `\lean{...}` entries.

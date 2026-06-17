# Iter-102 (Archon canonical) / iter-104 (project narrative) plan-agent run

> **Note on iteration numbering.** Archon-loop counter (`ARCHON_ITER_NUM=102`)
> vs. the project's internal narrative counter (uses iter-104 for the prover
> round this run dispatches; iter-103 for the prover round whose output this
> run consumes). Both refer to the same loop. This is the 5th major
> intervention on the `cechCofaceMap_pi_smul` trailing sorry slot.

## What I consumed

- `task_results/Cohomology_BasicOpenCech.lean.md` — iter-103 prover report
  (verified independently below; archived to
  `logs/iter-102/prover-iter103-BasicOpenCech-report.md`).
- `PROGRESS.md` — iter-103 plan (three-path directive: Path A `show`-pivot
  primary, Path B new lemma body, Path C top-level helper).
- `STRATEGY.md` — Phase A arc through iter-103's Path A failure.
- `task_pending.md` / `task_done.md` — sorry inventory + helper budget.
- `archon-protected.yaml` — unchanged.
- `USER_HINTS.md` — empty.
- `iter/iter-100/plan.md` + `iter/iter-101/review.md` (last 2 iters'
  sidecars from injected context window).

## Independent verification (pre-action)

- `sorry_analyzer.py BasicOpenCech.lean --format=summary` → **6 total**
  (matches iter-103 prover report; +1 closed via Path B body, -0 closed
  on L827).
- `lean_diagnostic_messages` severity=error → **`[]`** (file compiles).
- Sorry locations (pre-refactor, verified): L827 (cechCofaceMap_pi_smul
  trailing), L919, L1243, L1271, L1461, L1490 (all Phase A residuals).
- L590 (`alternating_zsmul_pi_smul_aux_sum_comp` body) was CLOSED by
  iter-103 prover.
- No new axioms (`grep -n '^axiom\|^@\[.*\] axiom' BasicOpenCech.lean` empty).

## Iter-103 outcome assessment

**PARTIAL — 1 sorry closed via Path B body; Path A on L827 failed across
5 routes.** Independent verification confirms:

- **Path B body proof** (L590) RESOLVED. The binder-level recipe
  worked first-try: `intro r y; rw [Preadditive.sum_comp]; simp_rw
  [Preadditive.zsmul_comp]; exact alternating_sum_pi_smul_aux ... (per-
  summand show + map_zsmul + smul_comm + hG)`. This vindicated the
  design hypothesis that HOU and discrim-tree blockers do NOT apply at
  the binder level — G, E, σ are typed binder applications without
  anonymous Pi.lift closures.
- **Path A 5 routes FAILED** on the L827 call-site sorry:
  1. `simp only [hom_zsmul]` — no progress (discrim-tree blocker).
  2. body-local rfl-helper `h_zsmul_apply` + `rw [h_zsmul_apply]` — typed
     OK but `rw` "did not find the pattern" (discrim tree blocks lemma
     application even for body-local rfls).
  3. literal-body `show` — deterministic whnf timeout at 1600000
     heartbeats (def-eq across Pi.lift fun closure is prohibitive).
  4. `change` with `_` placeholders for Pi.lift body — eqToHom metavar
     ambiguity (Application type mismatch on `ModuleCat.Hom ?m (∏ᶜ Z₂)`).
  5. `← LinearMap.comp_apply` / `← ModuleCat.hom_comp` partial re-fuse —
     works for non-smul layers, blocks at smul-prefix layer.
- **Forward progress committed** at L823 (S4 ConcreteCategory→
  ModuleCat.Hom rfl pivot) and L826 (S5 ModuleCat.hom_comp +
  LinearMap.comp_apply decomposition). Both are constant-level rewrites
  that landed cleanly. The post-S5 frame at L827 is the deepest verified
  state to date but the (-1)^↑i extraction remains structurally blocked.

**Streak status**: 4 consecutive substantive prover lanes on the
L827 sorry (iter-099 partial: closed `_sum_comp` body + applied;
iter-100 partial: funext pivot; iter-101 partial: S1-S3 chain;
iter-103 partial: S4-S5 chain). Iter-102 (project) was a refactor
pair. The streak escalation criterion has been triggered for the
second time; iter-104 (project) plan must commit to Path C (top-level
helper) or equivalent.

## Decisions for iter-104 (project) / iter-102 (Archon)

### Decision 1: Refactor subagent invocation (slug `cechcoface-named-family`)

**Rationale**: streak criterion fired for the 2nd time; iter-103
prover's own recommendation explicitly identified Path C (top-level
R-linear composite helper) as the documented escalation. The
iter-103 attempt log proves the discrim-tree blocker is resistant to
both `rw`-style discrimination and `show`-style def-eq — no tactic
chain can extract `(-1)^↑i •` from `Pi.lift fun i_1 ↦ ...` in the
existing call frame.

**Refactor design**: extract the sign-free Pi.lift body as a named
top-level def `cechCofaceMap_summand_family`. Once named, the head
symbol is a defined constant, not an anonymous closure — Lean's
discrimination tree handles `Pi.lift_π_apply` cleanly on it. The
companion theorem `cechCofaceMap_summand_family_R_linear` provides
the binder-level R-linearity proof obligation (body sorry for
iter-104 prover).

Directive at `logs/iter-102/refactor-cechcoface-named-family-
directive.md` specified:
1. Insert `cechCofaceMap_summand_family` at L432+ (after
   `presheafMap_restrict_collapse`).
2. Insert `cechCofaceMap_summand_family_R_linear` skeleton (body
   `sorry`).
3. Rewrite the call site at L791-L827 to use
   `alternating_zsmul_pi_smul_aux_sum_comp` with the named family
   explicitly passed in G (no Miller unification on the closure slot).
4. Documented fallback: leave call site untouched if Change 3 fails.

**Refactor outcome (verified independently)**:
- Changes 1 + 2 applied successfully.
- Change 3 deferred via fallback due to **Fin-index mismatch**: the
  natural index type for the new def is `Fin ((ComplexShape.up ℕ).prev
  n + 2)`, but the post-`dif_pos hRel` call-site sum is over
  `Fin (n + 1)`. These are structurally distinct `Finset` types;
  bridging requires `Finset.sum_equiv` Fin transport or a wrapper def.
- File compiles end-to-end; 7 sorries (was 6, +1 from new R-linearity
  body).
- `lean_diagnostic_messages` severity=error returns `[]`.
- `grep` confirms `cechCofaceMap_summand_family` at L454 and
  `cechCofaceMap_summand_family_R_linear` at L494.

**Lesson**: when extracting a closure as a named top-level def, the
natural index type of the def may differ from the call-site's index
type (especially when the call site applies `dif_pos`-bridged
equalities like `hRel`). Declaring the def hn-free is mathematically
cleaner but forces a Fin transport / wrapper def at the call site.
Both routes are documented for iter-105+ (refactor agent's report
explicitly recommends Route B wrapper).

### Decision 2: No further subagent calls this iter

- No analogy — the binder-level R-linearity pattern is project-known
  idiom (cf. `presheafMap_restrict_collapse` proof at L425, similar
  shape).
- No challenger — no new definition needing sanity envelope.
- No second refactor — the named-family extraction is the load-bearing
  structural change for this iter.

### Decision 3: Single prover lane for iter-104 (project)

Close L536 (`cechCofaceMap_summand_family_R_linear` body) as primary;
L929 (call-site sorry) as optional stretch. The Step 1 R-linearity
proof is HOU-free at the binder level by construction — the named
family removes the discrim-tree blocker for `Pi.lift_π_apply` and
related lemmas. ~15 LOC expected per the docstring sketch.

Stretch (L929) reserved for the case where Step 1 closes quickly; the
prover MUST NOT attempt L929 if Step 1 takes more than ~3 attempts.

## What iter-102 (Archon) plan-agent did NOT do

- Did not call analogy / challenger.
- Did not modify the iter-097/098/099/102/103 lemmas
  (`alternating_sum_pi_smul_aux`, `_sum_comp`, `_zsmul_pi_smul_aux_sum_comp`).
- Did not touch protected signatures (BasicOpenCech has none).
- Did not raise the heartbeat budget (refactor design avoids this).
- Did not write Lean proof bodies (boundary respected — refactor agent
  inserts skeleton + sorry; iter-104 prover writes the body).

## Open questions for iter-104 prover

1. Does `Pi.lift_π_apply` (the exact Mathlib name) fire cleanly when
   the morphism is `cechCofaceMap_summand_family s₀ n i` (a named
   constant)? Expected yes; if not, fallback to
   `Limits.Pi.lift_π` + `ConcreteCategory.comp_apply` separately.
2. Does the LinearEquiv coercion `e₁` / `e_int` interfere with
   `LinearMap.ext`? Iter-101 prover noted that LinearEquiv coercion
   sometimes masks lemma applications via discrim tree — but at the
   binder level (here), the family is named so this is unlikely.
3. R-linearity of `(presheaf.map _).hom` at the per-coordinate level:
   the R-action is `RingHom.toModule (presheaf.map _.op).hom`, so
   R-linearity is intrinsic via `LinearMap` algebra. The proof should
   chain `Pi.lift_π_apply` → `map_smul` on the R-linear restriction
   → done.

## Open questions for iter-105 prover (NOT this iter)

1. Route A (Fin transport) vs Route B (wrapper def) for closing L929.
   Refactor agent recommends Route B as simpler in tactic form.
2. After L929 closes: `g_R.map_smul'` (L1563) — does the parallel
   `cechCofaceMap_pi_smul_g` need a separate lane or can it reuse the
   same infrastructure with `Eq.mpr h_eq.symm`-casts?

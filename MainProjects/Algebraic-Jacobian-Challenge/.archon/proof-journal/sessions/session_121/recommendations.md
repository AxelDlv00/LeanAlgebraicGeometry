# Recommendations for the next plan-agent iteration (iter-122)

## CRITICAL — must land iter-122

### 1. Re-dispatch `blueprint-reviewer` to confirm the HARD GATE clears

The iter-121 `blueprint-reviewer-iter121` returned `complete: partial`
on **both** `Differentials.tex` and `Jacobian.tex`. Two
blueprint-writer subagents (`differentials-iter121`, `jacobian-iter121`)
reported `COMPLETE` this iter against the must-fix items. Per the
descriptor's dispatcher_notes, "Re-dispatching me after the writer
returns is optional within the same iter — the next iter's mandatory
dispatch of me will confirm." Iter-122's mandatory `blueprint-reviewer`
dispatch IS this confirmation; it MUST be unblocking, OR a follow-up
writer pass is escalated.

**Pass/fail criterion**: both chapters return `complete: true` and
`correct: true`. The M1 prover lane is gated on Differentials.tex
passing; the M2 prover lane is gated on Jacobian.tex passing.

### 2. Dispatch `refactor` subagent to introduce the bridge declaration

The `mathlib-analogist-bridge-iter121` returned with a concrete
API-shape recommendation:

```lean
-- Per analogist: LinearEquiv (≃ₗ[B]) with @[simps], namespace
-- `IsAffineOpen.…` (or `Scheme.…`), name `_equiv_` (not `_iso_`)
theorem AlgebraicGeometry.IsAffineOpen.appLE_isLocalization
    {X S : Scheme} (f : X ⟶ S) (U : S.Opens) (V : X.Opens)
    (hU : IsAffineOpen U) (hV : IsAffineOpen V) (e : V ≤ f ⁻¹ᵁ U) :
    let M : Submonoid Γ(S, U) :=
      { carrier := { g | IsUnit (f.appLE U V e g) },
        mul_mem' := …, one_mem' := … }
    IsLocalization M ((TopCat.Presheaf.pullback CommRingCat f.base).obj
                       S.presheaf |>.obj (.op V))
  := sorry

@[simps]
noncomputable def AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE
    {X S : Scheme} (f : X ⟶ S) {U : S.Opens} {V : X.Opens}
    (hU : IsAffineOpen U) (hV : IsAffineOpen V) (e : V ≤ f ⁻¹ᵁ U) :
    letI : Algebra Γ(S, U) Γ(X, V) := (f.appLE U V e).hom.toAlgebra
    (relativeDifferentialsPresheaf f).presheaf.obj (.op V) ≃ₗ[Γ(X, V)]
      Ω[Γ(X, V) ⁄ Γ(S, U)]
  := sorry
```

The refactor introduces these declarations with `sorry` body and updates
`Differentials.tex`'s `\lean{...}` hints to match the analogist's
namespace + naming choices (the iter-121 blueprint-writer used
`_iso_` and the `Scheme.…` namespace — the iter-122 refactor's name
choice should drive the blueprint-writer follow-up, NOT the other way
around).

**Why refactor (not a prover lane introducing them directly)**: the
declaration introduction is a structural Lean change; provers do
proof body, not signature design. The refactor's `--write-domain` is
`AlgebraicJacobian/Differentials.lean`. After this lands, the file
has +2 sorry sites (the bridge + appLE-isLocalization); project
sorry count goes 1 → 3 (intentional milestone-opening, not
regression).

### 3. Dispatch M1 prover lane targeting M1.a (the submonoid construction)

Per `progress-critic-iter121` watch criterion 4 ("M1.a vs M1.b
choice should be locked in iter-122's plan"), the iter-122 prover
lane should target the smallest concrete sub-step first. **M1.a**
is the construction of the submonoid

```
M := { g : Γ(S, U) | IsUnit ((f.appLE U V e) g) }
```

with its `Submonoid` instance fields (`mul_mem'`, `one_mem'`). The
construction itself is ~30 LOC and uses only `RingHom`-preservation
properties of `appLE` (`map_mul`, `map_one`). Expected outcome:
**COMPLETE**.

After M1.a closes, iter-123's prover lane should target M1.b (the
cofinality + IsLocalization statement; the genuine Mathlib gap).

### 4. Do NOT add an M2 prover lane on top of M1 yet

The `progress-critic-iter121` cross-route attention rule applies:
"If M1 is CHURNING by iter-122 AND M2 is still NO_PROVER, the
iter-122 planner does NOT add an M2 prover lane on top — splitting
prover attention across two CHURNING routes is the failure mode."

M2's first prover lane (rigidity specialisation for `ℙ¹_{k̄} → A`)
should wait until M1 produces enough structural advance. Target
iter-124 earliest for the first M2.a prover dispatch.

## HIGH — should land iter-122 or iter-123

### 5a. Fix the chapter's incorrect "Mathlib has no off-the-shelf lemma" claim on `lem:kaehler_localization_subsingleton`

Per `lean-vs-blueprint-checker-differentials-review121`'s chapter-side
critical finding (re-affirming the analogist's M1.c verdict): the
chapter at `Differentials.tex:138` claims Mathlib has no off-the-shelf
lemma for "Ω[L/A] is subsingleton when A → L is a localization", and
declares M1.c a Mathlib contribution candidate. **This is wrong**.
Mathlib supplies the conclusion in 2 lines via the composition
`FormallyUnramified.of_isLocalization` +
`subsingleton_kaehlerDifferential` (see
`analogies/relative-differentials-presheaf-bridge.md` and Knowledge
Base entry in PROJECT_STATUS.md). The iter-122 follow-up blueprint-writer
should either:

- **Option A** — drop `lem:kaehler_localization_subsingleton` as a
  standalone statement-block and inline its conclusion in the proof
  of M1.d (`kaehler_quotient_localization_iso`) — the analogist's
  recommendation.
- **Option B** — keep the block but rewrite its proof to a 2-line
  reference to Mathlib, removing the "candidate Mathlib gap" framing.

Option A is cleaner; Option B is faster to land. Either way, the
chapter must not continue to mislead future iters about Mathlib's
state.

### 5. Follow-up blueprint-writer on Differentials.tex to absorb analogist findings

The iter-121 `blueprint-writer-differentials-iter121` was dispatched
BEFORE the `mathlib-analogist-bridge-iter121` returned, so it did
not absorb the analogist's recommendations. Specifically:

- M1.b cofinality framing: writer used `Functor.Final` colim
  comparison; analogist recommended `IsLocalization.of_le` with
  cocone universality.
- M1.c (`kaehler_localization_subsingleton`): writer kept it as a
  standalone lemma; analogist found it is NOT a Mathlib gap (the
  composition `FormallyUnramified.of_isLocalization` +
  `subsingleton_kaehlerDifferential` gives it in 2 lines), so it
  should be dropped from the chapter and inlined at M1.d's call site.
- Naming/namespace: chapter uses `_iso_` and `Scheme.…`; analogist
  recommends `_equiv_` and `IsAffineOpen.…`.

The cleanest iter-122 sequence: refactor lands the Lean signatures
with analogist shapes → blueprint-writer follow-up updates the
chapter's `\lean{...}` hints + prose to match. Doing them in this
order means the writer doesn't have to predict what name the
refactor will land.

### 6b. `\leanok` proof-block drift on `thm:nonempty_jacobianWitness` (`Jacobian.tex:249`)

`lean-vs-blueprint-checker-jacobian-review121` flagged that the
chapter has `\leanok` inside the proof block of
`thm:nonempty_jacobianWitness` (line 249), but the Lean body at
`Jacobian.lean:179` is `sorry`. This is `sync_leanok`'s deterministic
responsibility and was NOT corrected by the iter-121 sync_leanok
pass (possibly because no prover ran this iter, so the determinism
short-circuit may have skipped the chapter). The review agent (per
the review prompt's explicit rule) does NOT manually touch `\leanok`.

**Action for iter-122**: either (a) verify `sync_leanok` runs against
all chapters even on no-prover iters and addresses this drift, or
(b) accept that the `\leanok` is benign mis-marking (no functional
consequence — the proof block remains unverified regardless of the
marker) and leave it for the next prover-touched iter's sync.
Logically, (a) is better. Surfaced to the developer feedback channel.

### 6. Stale phrases in Jacobian.tex (lines 376, 387)

Two lines in Jacobian.tex still use the old `Hom(ℙ¹_k, A) = A(k)`
framing per the writer's out-of-scope rule. They are not
mathematical defects but cosmetic drift from the new base-change-and-
descent framing. A future blueprint-writer pass on the chapter (or
an inline plan-agent edit) should update them. Priority: low; iter-123
or whenever a Jacobian-touching writer dispatch happens.

### 7. Future `Rigidity.lean` refactor to drop source-side group-scheme hypothesis

The `blueprint-writer-jacobian-iter121` flagged that
`GrpObj.eq_of_eqOnOpen` (the rigidity lemma) requires the source to
be a group scheme, but `ℙ¹_{k̄}` is not. The proof's underlying
equaliser-closed argument doesn't actually use the source's group
structure. The cleanest resolution is to refactor `Rigidity.lean`'s
`GrpObj.eq_of_eqOnOpen` to a `Scheme.eq_of_eqOnOpen` shape that
drops the source-side group-object-class hypothesis.

This is **out of scope for iter-122** (M1 has priority). Schedule
for when the M2.a prover lane queues up (target iter-124+).

## MEDIUM — known-issue follow-ups (carried from prior recommendations)

### 8. Polish-stage backlog (from session_118/119 recommendations)

The polish-stage backlog inherited from prior reviews is unchanged:

- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` —
  delete the dead `IsAffineHModuleHomFinite` class + 3 consumers
  chain (lean-auditor-review118 must-fix #1, re-confirmed in
  review120 and likely re-confirmed in review121).
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` — decide
  fate of the two scaffolding classes without producers
  (lean-auditor-review118 major #1).
- `AlgebraicJacobian/Rigidity.lean:62-67` — trim redundant typeclass
  arguments (lean-auditor-review118 major #2).
- `AlgebraicJacobian/Differentials.lean` L101, L106 — line-length
  warnings (cosmetic; not blocking).

Per the iter-121 strategic pivot, polish-stage is NOT the current
loop's stage — these items are scheduled for "after the loop returns
to polish" rather than for iter-122. The pivot reframes the loop as
"prover stage with multi-iter horizon"; polish backlog stays in the
queue but does not preempt M1 work.

## LOW — informational notes

### 9. The iter-121 plan-phase signal pattern is healthy

`progress-critic-iter121` confirmed both routes are **UNCLEAR**
(fresh routes; not CHURNING/STUCK). The strategic pivot is endorsed
by all four plan-phase critic verdicts in their post-correction
form. No alarm bells fired this iter.

### 10. `attempts_raw.jsonl` ordering surprise

The `attempts_raw.jsonl` in `current_session/` contains events with
timestamps `14:48–14:51` that **predate** the iter-121 `startedAt`
of `15:05:23Z` recorded in `meta.json`. These appear to be carryover
events (likely from the iter-120 prover's `lean_verify` / file-read
sequence) that the harness retained in `current_session/` rather
than archiving with iter-120. The Edit event at log line 26 refers
to the iter-120 algebra-Kähler closure of `smooth_locally_free_omega`,
not to any iter-121 prover work. The plan agent's actual iter-121
file reads (consuming task_results, blueprint chapters, etc.) are
implicit in the plan.durationSecs but not captured in the JSONL.

This is consistent with PROJECT_STATUS.md's iter-099/iter-100
"attempts_raw.jsonl pre-processor (RESOLVED)" note — the
pre-processor is not perfect about pre-iter event cleanup on
intentional-skip iters. Not a regression; flag for the developer
feedback channel if it recurs on iter-122.

## Guidance on what NOT to do

- **Do NOT** attempt the M1 prover lane against the iter-121
  blueprint without re-dispatching `blueprint-reviewer` first.
  Even though both `blueprint-writer` subagents returned `COMPLETE`,
  the HARD GATE rule requires confirmation by the next iter's
  mandatory `blueprint-reviewer` dispatch.

- **Do NOT** introduce the bridge with the iter-121 writer's
  naming/namespace choices (`_iso_`, `Scheme.…`). The analogist's
  recommendation (`_equiv_`, `IsAffineOpen.…`) is what Mathlib
  accepts at review; a name change later costs a refactor pass +
  a writer pass + a `\lean{...}` rename.

- **Do NOT** dispatch the M2 rigidity prover lane this iter even
  if M1.a returns COMPLETE in iter-122. The cross-route attention
  budget rule (M1 should consolidate before M2 enters) requires
  at least two M1 sub-step closures before M2 enters the queue.

- **Do NOT** re-litigate the user-directive pivot. The end-state
  change from "ship-with-sorry" to "zero inline sorry, multi-iter
  build-out" is a user-driven decision; if a future strategy-critic
  wants to challenge it, the rebuttal is "user directive in
  `USER_HINTS.md` iter-121, not strategy choice — out-of-scope for
  critic challenge."

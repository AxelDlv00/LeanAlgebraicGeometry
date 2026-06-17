# Recommendations — for the iter-205 plan agent

## 1. [CRITICAL] Keep Lane COE paused — the escalation is honored, not resolved

iter-204 correctly **honored** the COE escalation pause (no COE dispatch;
progress-critic route204 = STUCK + OVER_BUDGET). Do NOT silently re-open
COE in iter-205. The resolution is a **USER decision** (TO_USER carries
the banner). If — and only if — the USER directs continuation, change the
attempt *shape*:
- The genuine remaining gap is the **smooth-algebra Krull-dimension
  formula (Stacks 00OE)** feeding `isRegularLocalRing_stalk_of_smooth`
  (L1525), plus Stacks 00OF (`IsRegularLocalRing.localization`) / 00TT;
  the iter-203 KB also frames a Step-A2 AtPrime conormal-localisation iso
  in the chain.
- Dispatch a **mathlib-analogist** on that specific Krull-dim formula /
  conormal iso BEFORE any further COE prover round. A bare "close L1525"
  re-dispatch will churn (this is exactly what progress-critic flagged).

## 2. [CRITICAL] Re-dispatch the review subagents — they FAILED this iter

The three review subagents (lean-auditor, lvb coe + ts) produced no
reports (dispatch failed under the degraded environment). Re-dispatch in
iter-205. The lean-auditor must confirm:
- the 3 new TS helpers (`tensorObjIsoOfIso`, `tensorObj_unit_iso`,
  `restrictIsoUnitOfLE`) are genuinely axiom-clean and non-vacuous;
- **`monoidalCategory` is still `instance := sorry` (L150)** — sorryAx
  flows to consumers; this is the live iter-203 contamination flag, still
  unaddressed (see #4);
- carry-over: `RelPicFunctor.lean:330` `PicSharp := const PUnit`
  (weakened-wrong def + excuse comment; RPF HELD so non-blocking, but
  replace with an honest `sorry` before any RPF prover).

## 3. [HIGH] Lane TS — attack the ONE highest-leverage target

TS made real progress but its whole remaining cone collapses to a single
Mathlib infrastructure target the prover identified:

> an instance `(J.W.inverseImage (toPresheaf R₀)).IsMonoidal` in
> `PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)`.

With `CategoryTheory.Localization.Monoidal` + the existing
`PresheafOfModules.sheafification.IsLocalization` instance, this yields a
monoidal `SheafOfModules`, which **closes `monoidalCategory` AND
`tensorObj_restrict_iso` (hence `tensorObj_isLocallyTrivial`
axiom-clean) AND unblocks `exists_tensorObj_inverse` +
`addCommGroup_via_tensorObj`**. Frame the iter-205 TS objective around
this instance (mathlib-build mode). The fallback is a project-local pair:
`pullback_tensorObj_iso` (extension of scalars is monoidal, Stacks 03DM)
+ `sheafification_pullback_comm`.

Reusable dead-end warnings recorded by the prover (carry into the
objective): use `Scheme.Hom.resLE` not `homOfLE` for unit-pullback
chart-chases; `exact asIso (pullbackObjUnitToUnit …)` misses the
in-context `IsIso` instance — use `haveI hI := inferInstance; exact
@asIso _ _ _ _ _ hI`; `Sites/Monoidal.lean`'s `IsMonoidal` is for
`Sheaf J A` (ambient tensor), NOT the relative `⊗_R` of `SheafOfModules`.

## 4. [HIGH] Decide the `monoidalCategory` contamination disposition

`monoidalCategory` remains `noncomputable instance … := sorry` (L150), so
`sorryAx` propagates to consumers (this is why `exists_tensorObj_inverse`'s
`𝟙_` is opaque). Two options for iter-205: (a) the real fix via #3; or
(b) if #3 is not landing soon, demote the instance to a `def` to contain
the sorry (the honest-sorry-containment pattern). Do not leave a
`sorry`-bodied `instance` indefinitely.

## 5. [LOW] Blueprint / doctor

`sync_leanok` already updated `Picard_TensorObjSubstrate.tex` (added 3 /
removed 2) — no TS drift. Read `logs/iter-204/blueprint-doctor.md` (not
re-confirmed this review). If iter-205 lands new TS decls, ensure they are
`\lean{}`-pinned.

## Blocked / do-not-retry

- **Lane COE (L1525 chain)** — paused (escalation honored); gated on
  Stacks 00OE Krull-dim formula / Step-A2 conormal iso. Do NOT re-dispatch
  without USER direction + a new lemma in hand.
- **`exists_tensorObj_inverse`** — gated on `monoidalCategory` + an
  internal-hom sheaf; do not assign in isolation.
- **Lane WD terminal closure** — USER-blocked / HELD.
- **RPF / FGA / T32 / RCI** — HELD with concrete triggers.

## Reusable patterns (added to PROJECT_STATUS Knowledge Base this review)

- **Honest-sorry containment**: prefer `def Foo := sorry` over
  `instance Foo := sorry` (the instance propagates `sorryAx` to all
  consumers; the def localizes it). Live example: TS `monoidalCategory`,
  still an instance — recommended for demotion (#4).
- **Re-test multi-iter "Mathlib gap" blockers** before budgeting iters
  around them.

## Process notes for the loop maintainer

1. `attempts_raw.jsonl` is single-lane this iter (expected — only TS ran).
2. The review-subagent background dispatches produced empty logs / no
   reports — worth checking the wrapper under load.
3. A sustained tool-output rendering fault made this review hard to
   verify; the final record here is ground-truth-checked, but flag in
   case it recurs.

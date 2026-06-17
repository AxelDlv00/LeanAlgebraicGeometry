# Recommendations — for the iter-208 plan agent

## 0. Subagent findings (CRITICAL / HIGH)

- **[MUST-FIX, blueprint] lean-vs-blueprint-checker ts-iter207**
  (`task_results/lean-vs-blueprint-checker-ts-iter207.md`): the blueprint
  `lem:tensorobj_restrict_iso` Step-3 proof + its `% NOTE` falsely claim the
  sectionwise lax instance is the "SOLE remaining project-side ingredient" —
  now falsified by the prover's construction. **Blocks the next prover on this
  file.** The review added a corrective `% NOTE:` flag this iter, but the
  **informal prose / Step-3 proof must be rewritten by a blueprint-writer**
  (plan-agent domain) before any TS prover re-dispatch, and the chapter must
  re-clear the HARD GATE. The checker pins the *actual* residual more precisely
  than the prover did: closing the iso needs a presheaf-level **strong-monoidal**
  instance `(PresheafOfModules.pullback φ.hom).Monoidal` (a lift of the
  sectionwise-Mathlib `ModuleCat.extendScalars` monoidal structure), which is
  ABSENT in Mathlib `b80f227` — OR (preferably) the line-bundle sectionwise
  re-route (§1 option b) that avoids the abstract-adjoint comparison entirely.
- **[DONE this iter, major] lean-vs-blueprint-checker ts-iter207**: add the
  missing `\lean{}` pin on `lem:restrictscalars_laxmonoidal`. **Review added
  `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` this iter**; `sync_leanok`
  will add the `\leanok` next iter (pin landed after this iter's sync ran).
- **lean-auditor iter207** (`task_results/lean-auditor-iter207.md`): **verdict
  PASS, 0 must-fix-this-iter.** The three new decls are honest and axiom-clean,
  no dead code from the removed `pushforwardLaxMonoidal` attempt, TS sorry count
  confirmed = 3. Two **pre-existing MAJOR** findings carried forward (both
  held-lane, not this iter's work): `RelPicFunctor.lean:266` TODO excuse-comment
  on the `addCommGroup` sorry, and `IdentityComponent.lean:391` "sanctioned
  temporary sorry" docstring. One MINOR: stale iter-number annotations in the TS
  module docstring (lines 37–87). None block TS; address opportunistically when
  those lanes re-engage.

## 1. [MUST-FIX TYPE: route decision] Lane TS is NOT "one instance away" — STOP autopiloting

The iter-207 plan committed to a bounded mathlib-build on the premise (from
`analogies/mate207.md`) that the sectionwise `restrictScalars` lax instance was
the **sole** project-side ingredient for `tensorObj_restrict_iso`. The instance
was built axiom-clean — **and the premise was DISPROVEN**. The iso is still
blocked by two structural facts (ring-layer mismatch + composition wall; see
`summary.md` and `task_results/AlgebraicJacobian/Picard/TensorObjSubstrate.md`).
The plan's own armed reversal pre-commitment fired.

This is the **third consecutive iter** the TS lane has landed "the foundational
input" while the critical-path sorry count held flat (iter-205 cone-reduction,
iter-206 two reduction steps, iter-207 the lax instance) — the same recession
shape that drove the COE escalation. **Do NOT dispatch another TS "one more
ingredient" round.** The next move is a planner-level structural decision among:

- **(a) Re-route at the CommRingCat layer.** Restructure `tensorObj_restrict_iso`
  Steps 1–2 so they stay at the `X.presheaf` (CommRingCat) layer where
  `PresheafOfModules.Monoidal` and the δ machinery live, then bridge to
  sheafification at the end. `restrictScalarsLaxMonoidal` feeds this. Requires a
  RingCat↔CommRingCat bridge. (Blueprint-writer + mathlib-analogist work first.)
- **(b) Add line-bundle hypotheses + sectionwise proof.** Add
  `(hM : IsLocallyTrivial M) (hN : IsLocallyTrivial N)` to
  `tensorObj_restrict_iso` — it is NOT in `archon-protected.yaml`, and the
  consumer `tensorObj_isLocallyTrivial` already has `hM hN` in scope to pass —
  then prove the iso directly sectionwise via
  `Scheme.Modules.Hom.isIso_iff_isIso_app` using free-rank-one trivialisations.
  This sidesteps the abstract-adjoint comparison map entirely and is the most
  likely-to-close route. **Recommended first choice** — but requires a
  blueprint-writer round to rewrite the `lem:tensorobj_restrict_iso` proof to
  the sectionwise-trivialisation argument (the current δ-route proof is now
  flagged not-formalizable; see the `% NOTE` added this iter).
- **(c) Pause TS, pivot strategic focus.** If neither (a) nor (b) looks bounded
  on inspection, pause TS (escalation-style, as COE) and move the strategy-
  auditor/Albanese-UP A.2.c excision investigation up — the iter-207 plan
  deferred it to iter-208 anyway.

**Mandatory before any TS prover re-dispatch:** the blueprint
`lem:tensorobj_restrict_iso` proof must be rewritten to whichever route is
chosen (the δ-route prose is now marked not-formalizable via `% NOTE`), and the
chapter must re-clear the HARD GATE. Do not send a prover at the current
blueprint.

## 2. The lax instance is real, reusable infrastructure — bank it

`PresheafOfModules.restrictScalarsLaxMonoidal` (+ `restrictScalarsLaxε`,
`restrictScalarsLaxμ`) are axiom-clean and permanent. The `\lean{}` pin was
added this iter; `sync_leanok` will mark `lem:restrictscalars_laxmonoidal`
next iter. Whatever route is chosen for the iso, this instance is the correct
CommRingCat-level lax data and should be reused, not rebuilt.

## 3. Do NOT re-open COE (4th paused iter)

The escalation pause remains live (Stacks 02JK / Step-A2 conormal iso is a USER
decision). No silent re-open.

## 4. Held lanes — re-engagement gates unchanged

RPF `PicSharp := const PUnit` (L330) + `functorial := 0` (L377) remain the RPF
re-engagement gate (lean-auditor re-confirmed iter-206). `BareScheme.lean:220`
sorry-instance long-standing, not load-bearing now.

## Reusable proof pattern discovered

**Sectionwise lift of a `Functor.LaxMonoidal` to the presheaf level.** For a
presheaf functor that acts sectionwise as a known lax-monoidal `ModuleCat`
functor, every `LaxMonoidal` coherence field reduces to the ModuleCat-level law
under `ext1 Z; exact Functor.LaxMonoidal.<law> (F := <sectionwise functor at Z>)
...`. The ε/μ *naturality* fields need `erw` chains under
`set_option backward.isDefEq.respectTransparency false` (simp stalls on the
definitional unfolding). See `summary.md` for the exact tactic blocks.

## Subagent findings landed

Both returned and are folded into §0 above:
- `task_results/lean-auditor-iter207.md` — PASS, 0 must-fix; 2 pre-existing
  majors (held lanes), 1 minor (stale docstring iter numbers).
- `task_results/lean-vs-blueprint-checker-ts-iter207.md` — 1 must-fix (blueprint
  `lem:tensorobj_restrict_iso` false "sole ingredient" claim → blueprint-writer
  rewrite before TS re-dispatch), 1 major (missing `\lean` pin → DONE this iter).

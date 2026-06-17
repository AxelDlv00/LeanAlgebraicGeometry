# Progress Critic Directive

## Slug
ts213

## Iter
213

## Active routes / files under review

### Route: Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (⊗-invertibility group law)

- **Started at iter**: current ⊗-invertibility realization committed iter-209
- **Iters audited**: iter-208 to iter-212

#### Sorry counts per iter (project-wide)
- iter-208: 80
- iter-209: 80
- iter-210: 80
- iter-211: 81
- iter-212: 81

#### TS-file code-sorry counts per iter
- iter-208: (old δ-mate construction; pre-pivot)
- iter-209: pivot — chapter rewritten, no prover dispatch
- iter-210: gate-test — no prover dispatch
- iter-211: 4 (3 off-path + new scaffolded `tensorObj_assoc_iso`)
- iter-212: 4 (unchanged)

#### Helpers added per iter
- iter-208: (δ-mate helpers; old construction)
- iter-209: none (plan-only pivot)
- iter-210: none (plan-only gate-test)
- iter-211: 5 sorry-free decls (`IsInvertible`, `tensorObj_left_unitor`, `tensorObj_right_unitor`, `tensorObj_braiding`, gate `W_whiskerLeft_of_flat`) + scaffolded `tensorObj_assoc_iso`
- iter-212: 2 sorry-free decls (`isIso_sheafification_map_of_W`, `W_whiskerRight_of_flat`); `tensorObj_assoc_iso` still sorry

#### Prover statuses per iter
- iter-208: PARTIAL — old construction, "foundational input" landed, count flat
- iter-209: (no prover — plan-only pivot to ⊗-invertibility)
- iter-210: (no prover — plan-only gate-test)
- iter-211: PARTIAL — go/no-go gate `W_whiskerLeft_of_flat` cleared axiom-clean; associator scaffolded
- iter-212: PARTIAL — 2nd designated bridge `isIso_sheafification_map_of_W` cleared axiom-clean; associator BLOCKED by newly-found gap

#### Prover count per iter (files dispatched)
- iter-208: 1 of 1 (sole permitted lane — USER ROUTE C PAUSE)
- iter-209: 0 (plan-only)
- iter-210: 0 (plan-only)
- iter-211: 1 of 1
- iter-212: 1 of 1

#### Recurring blocker phrases
- "`tensorObj_assoc_iso` did NOT close" appears iter-211 (scaffolded) and iter-212 (blocked). The NAMED residual SHIFTED each iter: iter-211 "single residual = the sheafification-localization bridge"; iter-212 "bridge cleared; genuine residual = sectionwise flatness, which IsInvertible does not supply (false for non-affine opens)". A NEW, deeper gap each time rather than the same wall verbatim.
- "sectionwise flatness not derivable from IsInvertible" — first appears iter-212 (new).
- The iter-212 review notes the only named fix (local-triviality whiskering) re-introduces the local-trivialization machinery (`tensorObj_restrict_iso`) that the iter-209 pivot abandoned — i.e. POSSIBLE ROTATION back toward the abandoned wall.

#### Route status changes per iter
- iter-208: active (old δ-mate construction)
- iter-209: active — pivoted to ⊗-invertibility (plan-only)
- iter-210: active — gate-test (plan-only)
- iter-211: active — prover dispatched
- iter-212: active — prover dispatched

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.1.c.SubT row, verbatim): "~2–5"
- **Elapsed iters in current phase**: 4 (iter-209 through iter-212, ⊗-invertibility realization)
- **Phase started at iter**: iter-209 (⊗-invertibility realization); the broader SubT group-law phase has been active far longer (since ~iter-188)

#### Planner's current proposal for this iter
The planner is NOT proposing another prover round on the associator this iter.
Instead it dispatched a mathlib-analogist (api-alignment) to determine whether
Mathlib already supplies a monoidal structure on `SheafOfModules` / a monoidal
sheafification that makes the hand-rolled associator unnecessary (a possible
parallel-API/design-shape issue), and is weighing three options: (i) re-route the
associator via a Mathlib monoidal idiom if one exists; (ii) commit to a multi-iter
local-triviality whiskering sub-build; (iii) escalate to USER (both the
monoidal-pullback path 205–208 and the flat-exactness path 211–212 exhausted). The
question for you: is Lane TS now CHURNING/STUCK such that another prover round on
the associator (in any realization) is the wrong move, or is the analogist-consult-
then-decide the right corrective?

## PROGRESS.md proposal (this iter)

- **File count**: 0 prover lanes on the associator this iter (structural/consult iter); possibly 1 cleanup-only lane on `TensorObjSubstrate.lean` (deprecated `Sheaf.val` sweep + stale docstrings, per lean-auditor ts212) if judged worthwhile.
- **Files**: `TensorObjSubstrate.lean` (cleanup-only candidate) or none.
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**: none other than TS — all other Route A lanes are HELD/gated behind the TS iso-class group per USER directives (RelPicFunctor, FGAPicRepresentability) or PAUSED (Route C). The TS chapter itself is now `correct:false` on the associator proof (lean-vs-blueprint-checker ts212 must-fix), so the associator is NOT dispatchable until the blueprint is corrected.
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope
All Route C files (USER ROUTE C PAUSE), all held lanes (RelPicFunctor, FGAPicRepresentability, AlbaneseUP, WeilDivisor, RationalCurveIso), all A.2.c-engine and A.3+ lanes (USER directive #4).

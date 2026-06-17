# Recommendations — for the iter-218 plan agent

## CONTEXT (one line)
The 7-iter stall is broken: `tensorObj_restrict_iso` is CLOSED axiom-clean (81→80). The lane is now
**CONVERGING** — the next moves are concrete and on the critical path.

---

## MUST-FIX THIS ITER (blocks the dependency graph; do NOT formalize on a corrupted blueprint)

### 1. Fix the two malformed `\uses{...}` blocks in `Picard_TensorObjSubstrate.tex`
`sync_leanok` (iter-217) inserted `\leanok` **inside** two multi-line `\uses{...}` arguments,
producing spurious proof-block `\leanok` on **sorry** bodies AND breaking 7 dependency edges.
Confirmed by blueprint-doctor + lean-vs-blueprint-checker ts217 + first-hand review.

- **tex ~L1377-1379** (proof of `lem:tensorobj_assoc_iso`, body is `sorry`):
  ```latex
  \uses{def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso,
  \leanok
        lem:whisker_of_W, lem:islocallyinjective_whisker_of_W}
  ```
  Breaks `lem:whisker_of_W` + `lem:islocallyinjective_whisker_of_W` edges.
- **tex ~L2044-2046** (proof of `thm:rel_pic_addcommgroup_via_tensorobj`, body is `sorry`):
  ```latex
  \uses{lem:tensorobj_lift_onproduct,
  \leanok
        lem:pullback_compatible_with_tensorobj, …}
  ```
  Breaks 5 edges (`lem:pullback_compatible_with_tensorobj`, `def:scheme_modules_isinvertible`,
  `lem:tensorobj_isoclass_commgroup`, `thm:relative_pic_quotient_well_defined`,
  `lem:rel_pic_sharp_groupoid`).

**Action**: dispatch a blueprint-writer to reflow both `\uses{}` blocks onto a clean argument list
and DELETE the stray `\leanok` token (the proofs are `sorry`, so no proof `\leanok` belongs; the next
`sync_leanok` will re-add a correct proof `\leanok` only if/when the proof closes). The review agent
did NOT edit these — `\leanok` is `sync_leanok`'s domain and the fix is a `\uses{}` (prose) reflow.
**Process note for the loop maintainer**: this is a `sync_leanok` placement defect (offset collides
with multi-line `\uses{}`) — worth a guard in the sync script so it never writes `\leanok` mid-`\uses{}`.

---

## PRIORITY 1 — ride the momentum: re-route the associator, then delete the vestigial sorry
The linchpin closure UNGATES two count drops in `Picard/TensorObjSubstrate.lean`:

1. **Re-route `tensorObj_assoc_iso` (L1152) onto the now-closed `tensorObj_restrict_iso`.** It is
   currently a `sorry` only because it routes through the vestigial route-(d) whiskering lemma
   `isLocallyInjective_whiskerLeft_of_W` (L600, still `sorry`). With `restrict_iso` closed, the
   blueprint's direct restrict-iso gluing route for `assoc_iso` is now available. This is a
   `prove`/`fine-grained` lane.
2. **Then delete `isLocallyInjective_whiskerLeft_of_W` (L600) + the vestigial whiskering apparatus.**
   It is referenced ONLY in-file (deletion-safe per memory), but it currently feeds the green
   `assoc_iso` via `W_whiskerLeft/Right_of_W` — so deletion MUST come AFTER step 1 re-routes
   `assoc_iso` off it. Removing it is a further sorry elimination.

These two steps could each drop the count (80→79→78). Sequence matters: re-route first, delete second.

## PRIORITY 2 — the genuine remaining critical-path obligations (group law)
After the associator, the PRIMARY-GOAL route (A.2.c via the ⊗-iso-class group) needs:
- **`exists_tensorObj_inverse` (L1375)** — the ⊗-dual / inverse-existence for a locally-trivial line
  bundle (build the dual + contraction iso, an iso affine-locally on a trivialising cover). On the
  critical path; currently a scaffold `sorry` since iter-202.
- **`tensorObjIsoclassCommMonoid`** — the group law on ⊗-iso-classes; NOT yet in this Lean file
  (consumes only EXISTENCE of assoc/unit/braiding isos, per memory `[[commring-pic-is-skeleton-route]]`
  — no pentagon needed). Needs scaffolding once `assoc_iso` + `exists_tensorObj_inverse` land.
- **`PicSharp.addCommGroup_via_tensorObj` (L1415)** — the RPF consumer, downstream of the group law.
  Its `@[implicit_reducible]` on the sorry body is a soundness watch (see below).

## PRIORITY 3 — code/docstring hygiene (fold into the next prover directive as ride-along)
From lean-auditor ts217 (`task_results/lean-auditor-ts217.md`):
- **Stale docstrings (MAJOR)**: `tensorObj` (L987-991) and `tensorObj_functoriality` (L997-1007)
  falsely claim "typed `sorry`" bodies; module Status block (L37-85) is 15-iters stale;
  `tensorObj_assoc_iso` docstring (L1115) says "iter-212 status (typed sorry)" — now closed. The
  prover that next touches the file should refresh these.
- **17× deprecated `Sheaf.val` (MAJOR)** at L993,1010,1055,1072,1074,1084,1086,1094,1096,1104,1162,
  1165,1170,1189,1191 → replace with `ObjectProperty.obj`. A mechanical sweep (refactor subagent or
  ride-along) — will break when Mathlib drops the alias.
- **`@[implicit_reducible]` on sorry-body `addCommGroup_via_tensorObj` (L1414)**: a `def` (not
  `instance`) so not auto-synthesized, but reducible-on-a-sorry is an opacity risk. When this decl is
  next touched, either close the body or drop the attribute until it closes. **Soundness watch.**

## PRIORITY 4 — blueprint pins for the 5 new decls (lvb ts217 major)
Dispatch a blueprint-writer to add `\lean{...}` pins for `PresheafOfModules.{pushforwardNatTrans,
pushforwardCongr, pushforwardPushforwardAdj, restrictScalarsMonoidalOfBijective}` (and optionally
`isIso_of_isIso_app`), e.g. a "presheaf-level H1/H2 supplements" lemma block. The first three are
de-sheafifications of named Mathlib decls and are **upstream-Mathlib-PR candidates** — worth recording
as such. Also resolve the `lem:islocallyinjective_whisker_of_W` prose/pin inconsistency (prose says
"being removed" but pin+decl remain). Distinguish `restrictScalarsMonoidalOfBijective` (presheaf) from
the already-pinned module-level `restrictScalarsMonoidalOfRingEquiv`.

## Do-NOT-retry (still standing)
- Do NOT re-attempt a free-cover specialisation of the linchpin (disproven iter-216 — but moot now,
  it's closed).
- Do NOT revert to route-(e)/d.2 (varying-ring stalk-⊗) — d.2 is harder than the now-closed H1.
- Do NOT add local `MonoidalCategory` instances on the `X.ringCatSheaf.obj` base form (kernel-rejected
  diamond — see PROJECT_STATUS Proof Patterns GOTCHA 3).

## Strategic FYI (unchanged, USER-owned)
The whole ⊗-substrate (Lane TS) is route-A-specific and would be discarded if the user lifts the RR
pause (then `Pic⁰` comes from divisor classes — `WeilDivisor`/`OcOfD` already exist). The closure this
iter minimizes sunk cost on the kept path. The RR-pause-vs-lift fork remains the project's single
highest-leverage decision (surfaced in TO_USER.md / iter sidecars); the loop proceeds on Route A
meanwhile. No reason to escalate harder this iter — the lane is now visibly converging.

## Progress-critic note for iter-218
The iter-217 `progress-critic` STUCK verdict was rebutted by the planner and the rebuttal was VINDICATED
(the de-risked H1 build closed the linchpin). The "7 iters flat" framing no longer applies — the lane
produced an observable −1 and has a concrete 2-step path to further drops. If re-dispatched, expect
CONVERGING. Do not treat the lane as stuck.

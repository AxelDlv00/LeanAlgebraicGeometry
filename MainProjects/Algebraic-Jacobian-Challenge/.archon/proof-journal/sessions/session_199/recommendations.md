# Iter-199 review — Recommendations for plan agent (iter-200)

## Subagent findings landed this review

- **lean-auditor iter199** → CLEAN, no must-fix; 2 cosmetic notes
  (stale top-level "Status (iter-NNN)" headers in 3 of 4 files; Lane
  WD `order_neg` uses a squaring detour rather than the direct
  `order_inv`/`order_units_inv` route). Both are non-blocking.
- **lean-vs-blueprint-checker wd-iter199** → 1 MAJOR
  (plan-phase-introduced blueprint pin
  `\lean{AlgebraicGeometry.Scheme.rationalMap_order_finite_support}`
  pointed at non-existent declaration — wrong namespace `.Scheme.`
  + theorem is `private`). **Fixed this review** in
  `RiemannRoch_WeilDivisor.tex` L532: corrected to
  `\lean{AlgebraicGeometry.rationalMap_order_finite_support}` plus
  `% NOTE:` documenting the private-visibility caveat and the
  closure path. **Iter-200 plan agent should be aware**: when adding
  `\lean{...}` pins in the plan phase, verify the qualified name by
  checking the active `namespace ...` / `end ...` blocks in the
  Lean file rather than assuming the project's
  `AlgebraicGeometry.Scheme.X` convention applies.
- **lean-vs-blueprint-checker ab-iter199** → 3 MAJORS, 1 MINOR (none
  must-fix):
  - F-1 (MAJOR): the iter-199 new helper
    `RingTheory.Module.exists_minimalSurjection_finite_localRing`
    (~99 LOC axiom-clean) is **public** and substantive but has NO
    `\lean{...}` pin in the chapter. **iter-200 plan/writer action**:
    add a standalone `\begin{lemma}...\lean{...}\end{lemma}` block
    inside `\subsec{subsec:succ_pd_gap_sequence}` per the checker's
    proposed template; this enables bidirectional sync_leanok
    verification + reader navigation.
  - F-2 (MAJOR): per-gap table at
    `Albanese_AuslanderBuchsbaum.tex` L559–L575 shows gap (1) status
    as `absent`, but iter-199 landed first-step substrate. **iter-200
    plan/writer action**: update the gap (1) row to
    `partial iter-199: first-step exists_minimalSurjection_finite_localRing`.
  - F-3 (MAJOR): `\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}`
    pins a `private` declaration. **Mitigated this review**: added
    `% NOTE iter-199 review` documenting the two resolution options
    (the cleaner option (1) — remove `private` — should be applied
    by an iter-200 refactor / prover lane since the helper is
    logically public-facing within the AB chain).
  - M-1 (MINOR): `\leanok` on `thm:auslander_buchsbaum` proof block is
    transitively dependent on the sorry inside
    `auslander_buchsbaum_formula_succ_pd`. This is a known
    `sync_leanok` syntactic-only limitation, not a chapter-writer
    error. Tracked as iter-200+ loop-infra item.
- **lean-vs-blueprint-checker coe-iter199** → 0 must-fix, 0 major,
  4 MINOR:
  - **Confirms** the iter-199 review `\lean{...}` correction on
    `lem:cotangent_kahler_over_field` is the **right pin (iso form,
    not finrank)**.
  - `\leanok` sync ordering artifacts on
    `lem:cotangent_kahler_over_field` statement and
    `lem:mem_domain_partial_map_reshuffle` proof — should auto-fix
    on next sync_leanok run; review agent cannot manually add
    `\leanok` (forbidden by role).
  - **iter-200 plan/writer action**: add two new `\begin{lemma}`
    blocks for `finrank_cotangentSpace_of_formallySmooth_residue`
    and `finrank_cotangentSpace_of_bijective_algebraMap_residue`
    in `\subsec:stage6_subgap_decomposition` (the docstring's
    "Closure pattern (post-(ii.B))" at
    `CodimOneExtension.lean` L864-L869 explicitly invokes the
    second helper by name).
  - **Cosmetic**: A/B label inversion between Lean docstring
    (`sub-gap (ii.A)` = 02JK) and blueprint headers
    (`Stage 6.B` = 02JK; `Stage 6.A` = 00OE). Both correctly
    identify which gap is open vs closed; only the letter assignment
    is inverted. iter-200 cosmetic alignment candidate.
- **lean-vs-blueprint-checker fga-iter199** → 0 must-fix, 3 MAJOR,
  2 MINOR. All 5 `\lean{...}` pins ACCURATE; Lean declaration
  signatures match. The blueprint stale state is entirely in the
  sorry-closure documentation section (chapter prose) — not in any
  pinned block. Findings:
  - F-1 (MAJOR): `\subsec:sorry_smooth_proper_quotient` L779-784
    Location paragraph says Sorry 4 is "free sorry in proof body at
    L354"; actual location post-iter-199 is `⟨sorry⟩` in
    `instHasSmoothProperQuotient` at L349, theorem body axiom-clean
    at L377.
  - F-2 (MAJOR): `\sec:fga_pic_sorry_closure_order` intro at
    L579-581 says "one free sorry ... and six carrier typeclasses";
    post-iter-199 all 7 sorries are `⟨sorry⟩` instance bodies
    across 7 carrier typeclasses (the new `HasSmoothProperQuotient`
    is unlisted).
  - F-3 (MAJOR): `\subsec:fga_pic_closure_order_summary` L1052-1059
    motivation "removes the only non-instance sorry from the file"
    is now inoperative.
  - **Mitigated this review**: added a `% NOTE iter-199 review`
    block at the start of `\sec:fga_pic_sorry_closure_order` (L575
    area) flagging all 3 stale paragraphs for the iter-200
    blueprint-writer to refresh; the chapter prose is in the
    blueprint-writer's domain (informal prose), not the review
    agent's.
  - M-4 (MINOR): `HasSmoothProperQuotient` + `instHasSmoothProperQuotient`
    not mentioned in Sorry 4 subsection (other 6 carrier instances
    are named in their respective subsections); editorial
    consistency item for iter-200 writer.
  - M-5 (MINOR, pre-existing): `smoothProperQuotient` Lean type
    lacks secondary conclusion "α is representable by a smooth
    map" (present in Kleiman `lm:qt`); flagged for future
    chapter/signature alignment.

## CRITICAL / HIGH

### CRIT-0 — Lane WD-A4a: open WD Sub-build 1 as iter-200 isolated mathlib-build target

The iter-199 Lane WD-A4a prover discovered that the planner's
recipe for `rationalMap_order_finite_support_of_isNoetherian`
requires **three** Mathlib-pending substrate sub-builds NOT in
`b80f227`. The genuine bottleneck is **Sub-build 1**:

> **Open-immersion stalk-bridge for prime divisors**:
> for an open immersion `g : U → X` of schemes and `y : U`, the
> bijection between primes of the chart and prime divisors of `X`
> with point in `g`'s image, with compatibility for `Order.coheight`
> (= 1 ⟺ ideal height = 1) and stalk-level `Ring.ordFrac` transport
> via `IsOpenImmersion.iff_isIso_stalkMap`.

**Recommended action**: queue Sub-build 1 as a dedicated iter-200
mathlib-build lane (~150-250 LOC; Stacks 02IZ / 005X). This is
itself a substantial Route A advance because Sub-build 1 also
unblocks the Lane I `hy_ne_bot` residual cleanup AND any future
prime-divisor / open-immersion infrastructure.

**Do NOT re-dispatch Lane WD-A4a** on the same HARD BAR until
Sub-build 1 lands. The 5-approach exhaustion in the iter-199
prover task report is authoritative.

**Secondary action**: Sub-build 2 (~50-100 LOC affine prime-divisor
structure for Noetherian integral affine schemes, Stacks 02RW) is
a smaller paired companion. Sub-build 3 (the 40-50 LOC glue
re-attempting `rationalMap_order_finite_support_of_isNoetherian`)
follows after 1+2 land.

### CRIT-1 — Lane AB: iter-200 gap (1) iteration (Nat-recursive minimal resolution)

The iter-199 Lane AB prover landed the **per-step** minimal-surjection
substrate `RingTheory.Module.exists_minimalSurjection_finite_localRing`
(L1198) axiom-clean. The natural iter-200 follow-on is the
**full iterated resolution**:

- Wrap the iter-199 substrate in a Nat-indexed recursive construction
  producing `ChainComplex ℕ (ModuleCat R)` (or similar) of finite-free
  modules of length `pd_R(M)`, each differential's image in `𝔪 • ⊤`.
- ~40-80 LOC; depends only on iter-199 substrate + `Module.Finite`
  on syzygies (automatic under Noetherian).

This is precisely the natural iter-200 follow-on per the prover
report's "Next-step handoff for plan agent" section. Snake-lemma
(gap 3) depends on this iteration closing first.

### CRIT-2 — Lane COE: iter-200 sub-gap (ii.B) Stacks 00OE Krull-dim formula

Iter-199 Lane COE landed sub-gap (ii.A) substrate axiom-clean
(4 helpers). The remaining gap is (ii.B): Stacks 00OE
smooth-algebra Krull-dim formula
(`Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`),
estimated ~200-300 LOC mathlib-build.

**Recommended action**: dispatch Lane COE-stage6-iiB iter-200 with
`mathlib-build` mode + helper budget 3-4. Closure of (ii.B) does
TWO things:
1. Closes the trailing sorry on
   `isRegularLocalRing_stalk_of_smooth` axiom-clean (cascade-closing
   downstream consumers per the chapter's "Cascade-to-consumers"
   paragraph).
2. **Triggers Lane T32 re-engagement** per the iter-199 plan's
   binding trigger condition (Lane T32 re-engages ONLY when COE
   Stage 6.B closes; mechanical check via grep on the closure
   record).

Mathlib infrastructure required: transcendence-degree machinery +
Noether normalization on standard-smooth algebras. The mathlib-analogist
`coe-stacks02jk` report did NOT cover Stacks 00OE; consider
dispatching a fresh mathlib-analogist on Stacks 00OE if the prover
hits structural-shape obstacles.

## MEDIUM

### MED-3 — Lane RPF: iter-200 `Scheme.Modules.tensorObj` upstream substrate

Per the iter-199 progress-critic STUCK + OVER BUDGET verdict and
the iter-199 plan agent's response action: STRATEGY.md has a new
phase row `A.1.c.SubT` (~3-6 iters / ~200-400 LOC
`Scheme.Modules.tensorObj` upstream-style substrate build). The
Lane RPF L235 `addCommGroup` sorry can only close once this
substrate lands.

**Recommended action**: iter-200 plan agent dispatches the writer
for the **`Picard_TensorObjSubstrate.tex`** chapter (per iter-199
blueprint-reviewer's deferral) **before** any Lane RPF prover
re-engagement. The chapter outlines the substrate piece-by-piece
so a future prover lane can attack it incrementally.

**Secondary action**: audit the 5 placeholder bodies landed iter-198
to confirm which are trivially achievable proofs (i.e., the
math-correct body once the substrate lands) and which require
genuine additional mathematical work. The iter-199 plan-phase
`rpf-placeholder-note` writer added the `% NOTE: ... DO NOT
promote to \leanok` markers; the audit is a one-time
double-check before iter-200 dispatch.

### MED-4 — Lane FGA: Sorries 1-3 remain gated on A.1.c.SubT + A.2.b

The iter-199 Lane FGA prover correctly REJECTED tautological
`Functor.const (PUnit)` closures for Sorries 1-3 (`instHasPicSharp`,
`instHasDivFunctor`, `instHasAbelMap`) per the headline-laundering
discipline. These closures require:
- The semantic witnesses for `picSharp` once A.1.c (`RelPicFunctor.lean`)
  commits its `\lean{...}` pin.
- The semantic witness for `divFunctor` and `abelMap` once A.2.b
  (`Picard/QuotScheme.lean`) commits its `\lean{...}` pin.

**Recommended action**: do NOT re-dispatch Lane FGA on Sorries 1-3
in iter-200. The carrier-soundness probe pattern is structurally
homogeneous and the genuine closures arrive cascadingly via A.1.c
+ A.2.b.

**For Sorry 4 in iter-200**: per the iter-199 review, Lane FGA
HELD on the carrier-soundness `⟨sorry⟩` until either (a) the
Cartier bypass produces equivalent path, or (b) USER re-engages
the Quot route.

## LOW

### LOW-5 — Lane T32 binding trigger condition documented

Per the iter-199 plan agent: Lane T32 re-engages ONLY when Lane COE
Stage 6.B is closed axiom-clean. T32 MUST NOT appear in any
plan-phase discussion (iter-200, iter-201, …) until that condition
holds per the iter log. Mechanical check: grep `task_done.md` or
the relevant per-iter sidecar for
`ringKrullDim_localization_eq_relativeDimension` closure record.

This is included as a checklist item for iter-200 plan agent
preparation. No additional action required.

### LOW-6 — Lane RCI HELD per USER Route C PAUSE

No action. The lane remains held per USER directive.

### LOW-7 — Strategy-critic REJECT on A.2.c: TO_USER banner reflects plan-agent recommended candidate

The iter-199 strategy-critic returned a REJECT-level finding on
A.2.c representability (the protected decls' dependency cone
transits A.2.c which is RR-substrate-blocked under Route C PAUSE).
The plan-agent recorded three candidate resolutions in STRATEGY.md
Open-strategic-questions and recommended Candidate (a) (surgical
Route C re-engagement of `AbelianVarietyRigidity.lean` +
`RigidityKbar.lean` for the genus-0 arm, ~300-500 LOC).

**Action**: TO_USER banner records this recommendation
(non-blocking; the loop proceeds with Route A bottom-up work).

## Closest-to-completion targets to prioritize iter-200

In order of estimated closure cost:

1. **Lane COE-stage6-iiB Stacks 00OE Krull-dim formula**
   (~200-300 LOC). Closes trailing sorry on
   `isRegularLocalRing_stalk_of_smooth` AND cascade-triggers Lane
   T32 re-engagement. Highest leverage in the active set.
2. **Lane AB-gap1 iter-200 iteration** (~40-80 LOC). Direct
   continuation of iter-199 substrate. Closes one of three remaining
   gaps for `auslander_buchsbaum_formula_succ_pd`.
3. **Lane WD-A4a Sub-build 1** (~150-250 LOC, open-immersion
   stalk-bridge for prime divisors). New genuine bottleneck; iter-200
   isolated dispatch. Also unblocks Lane I residual cleanup.
4. **Lane FGA Sorry 4 genuine closure**: deferred indefinitely
   (Altman-Kleiman + EGA IV 8.11.5 = multi-iter side project gated
   on A.2.b Quot route).

## Promising approaches needing more work

### Pattern: `Algebra.FormallySmooth.iff_split_injection` recipe for closed-point cotangent isos

The iter-199 mathlib-analogist `coe-stacks02jk` recipe + iter-199
Lane COE landing closed (ii.A) in ~210 LOC including docstrings.
Reusable for ANY closed-point cotangent ↔ Kähler iso build in
similar local-algebra / residue-field settings (typically the
k̄-rational case via Nullstellensatz reduction). Future iters with
similar shape should consult `analogies/coe-stacks02jk.md` directly.

### Pattern: `Pi.basisFun.constr R m` + Nakayama-lift for minimal-generator constructions

The iter-199 Lane AB recipe for
`exists_minimalSurjection_finite_localRing` factors through 5
Mathlib pieces and produces a kernel-clean per-step minimal
surjection. Composes with itself iteratively for Nat-recursive
resolution construction. Reusable for ANY local-ring minimal
generator-set construction.

### Pattern: Substrate-only iter as response to multi-piece infrastructure gaps

When a HARD BAR closure is unreachable due to multiple
unanticipated Mathlib gaps, the substrate-only PUSH-BEYOND path
(small axiom-clean §-substrate lemmas) preserves iter velocity
without violating no-regression discipline. Iter-199 Lane WD-A4a
demonstrates this pattern (2 axiom-clean §2 substrate lemmas
added; HARD BAR documented as 3 named Mathlib sub-builds).

## Blocked targets (do not re-assign without structural change)

- **WeilDivisor.lean L325**
  (`rationalMap_order_finite_support` public sorry): blocked until
  WD Sub-build 1 lands OR USER directive amendment allows consumer
  propagation through L538/L1108.
- **AuslanderBuchsbaum.lean L1299**
  (`auslander_buchsbaum_formula_succ_pd`): blocked until gaps (1)
  iteration + (2) Stacks 00MF + (3) snake-lemma all land. Iter-200
  next slice = gap (1) iteration.
- **CodimOneExtension.lean L1101** (`isRegularLocalRing_stalk_of_smooth`
  trailing sorry): blocked until (ii.B) Stacks 00OE Krull-dim formula
  lands. DO NOT cold-close.
- **FGAPicRepresentability.lean** all 7 sorries: held in
  carrier-soundness probe pattern. Closures gated on A.1.c.SubT
  (`Scheme.Modules.tensorObj`) + A.2.b (`Picard/QuotScheme.lean`)
  + (for Sorry 4) Altman-Kleiman + EGA IV 8.11.5.
- **RelPicFunctor.lean L235** (`addCommGroup`): blocked until
  `Scheme.Modules.tensorObj` substrate lands (A.1.c.SubT phase).
  Lane RPF HELD; do not re-dispatch on placeholder closures.
- **Thm32RationalMapExtension.lean L155**
  (`isReduced_of_smooth_over_field`): Lane T32 HELD; re-engages
  ONLY when COE Stage 6.B lands. Mechanical trigger check via grep.
- **RationalCurveIso.lean**: Lane RCI HELD per USER Route C PAUSE.
- **All Route C files** (`H1Vanishing.lean`, `RRFormula.lean`,
  `OCofP.lean`, `OcOfD.lean`, `RationalCurveIso.lean`,
  `BareScheme.lean`, `GmScaling.lean`, `RigidityKbar.lean`,
  `AbelianVarietyRigidity.lean`): PAUSED per 2026-05-28 USER
  standing directive.

## Reusable proof patterns discovered iter-199

Added to PROJECT_STATUS.md "Proof Patterns" section:

- **`Algebra.FormallySmooth.iff_split_injection` retraction-as-iff for
  Stacks 02JK closed-point cotangent iso**.
- **`Pi.basisFun.constr R m` + `IsLocalRing.span_eq_top_of_tmul_eq_basis`
  for per-step minimal surjection in local-ring Module theory**.
- **`WithZero.log_pow` + `smul_right_injective` for axiom-clean
  sign-flip identity on `Scheme.RationalMap.order`** (`order_neg`).
- **Carrier-soundness probe theorem-body extraction discipline**:
  add `Prop`-valued typeclass with field carrying the witness;
  parametrize the theorem on the typeclass and extract via field;
  isolated `⟨sorry⟩` instance constructor takes the residual gap.
  This pattern is the canonical "axiom-clean theorem body even when
  underlying mathematics has a Mathlib gap" response. Verdict
  CONFIRMED iter-199; structurally homogeneous on
  `FGAPicRepresentability.lean`.

## Anti-patterns (do not retry)

Added to PROJECT_STATUS.md "Anti-Patterns" section:

- **Do NOT close substrate-blocked sorries via tautological
  `Functor.const (PUnit)` / `0` / `⟨0⟩` placeholder bodies** without
  the `% NOTE: ... DO NOT promote to \leanok` chapter discipline.
  Iter-198 Lane RPF landed 5 such closures; the iter-199 review
  classified them as headline-laundering. The discipline is to
  carry a chapter `% NOTE`, name the gap, and document the canonical
  body for the future iter that closes.
- **Do NOT re-dispatch a prover lane on the same HARD BAR when the
  iter (N) prover has confirmed multi-piece Mathlib substrate gaps**
  (e.g. iter-199 Lane WD-A4a 5-approach exhaustion). Re-dispatch
  produces the same exhaustion. Instead: dispatch the substrate
  Sub-build as an isolated mathlib-build lane.

# Iter-103 (Archon canonical) / iter-105 (project narrative) — review

## Outcome at a glance

- **Single prover lane on `BasicOpenCech.lean`** to execute Route B
  (named wrapper) for closing `cechCofaceMap_pi_smul` per-summand `hG`
  discharge at L988 (now L1147 after the helpers landed).
- **Result**: **PARTIAL — 0 sorry closed, 2 new helpers fully proved.**
  - **Helper 1** `cechCofaceMap_summand_family'` defined at L604–L630
    as a direct `Pi.lift` with `Fin.cast` (~27 LOC). Compiles clean.
  - **Helper 2** `cechCofaceMap_summand_family'_R_linear` defined and
    proved at L634–L726 (~93 LOC). Compiles clean, zero sorries in body.
  - **L1147 partial proof** at L1126–L1147 (~22 LOC): wrapper R-linearity
    applied via `cechCofaceMap_summand_family'_R_linear hU s₀ n hn
    (Fin.cast hRel' i)`, `congrFun` to per-coord `h_wrap_pt`,
    `simp only [Pi.smul_apply] at h_wrap_pt`, then sorry. The structural
    partial chain isolates the residual gap precisely: eqToHom-vs-Pi.π
    transport at coordinate `j'`.
- **Sorry trajectory**: BasicOpenCech **6 → 6**. Project total
  **14 → 14**. Hard cap of 7 met; **target of 5 missed by 1**.
- **Compile-verified**: yes (`lean_diagnostic_messages` returns `[]`
  for severity=error end-to-end). **Eleventh consecutive compile-verified
  prover iteration** (iter-092 through iter-105).
- **No new axioms; no protected signatures touched; iter-104 closures
  (`cechCofaceMap_summand_family`, `cechCofaceMap_summand_family_R_linear`,
  `alternating_zsmul_pi_smul_aux_sum_comp`) preserved byte-for-byte.**

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **14**, distributed:
  - `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **6** at
    L1147 (cechCofaceMap_pi_smul, partial), L1239 (substep a augmented
    Čech, deferred), L1563 (was L1404, deferred), L1591 (substep a
    extra-degeneracy for s₀, deferred), L1781 (g_R.map_smul', gated on
    L1147), L1810 (h_loc_exact, deferred). All non-target sorries shifted
    by **+159 lines** from iter-104 close due to the inserted wrapper
    helpers.
  - `AlgebraicJacobian/Differentials.lean`: **5** at L122, L636, L957,
    L974, L1116 (unchanged).
  - `AlgebraicJacobian/Modules/Monoidal.lean`: **1** at L173 (Mathlib
    upstream gap; off-limits).
  - `AlgebraicJacobian/Jacobian.lean`: **1** at L179
    (`nonempty_jacobianWitness`; Phase C step C3).
  - `AlgebraicJacobian/Picard/Functor.lean`: **1** at L190
    (`PicardFunctor.representable`; gated on C0–C3).
- **Solved this iter**: none in the syntactic-sorry-count sense; **2
  new top-level helpers added and both fully proved (0 internal sorry)**
  — these are structural advances that primed the iter-106 path.
- **Partial this iter**: `cechCofaceMap_pi_smul` at L1147 (wrapper
  invocation + congrFun + simp committed; remaining gap is morphism-level
  eqToHom-vs-Pi.π transport).
- **Blocked this iter**: none — the L1147 residual is a clean structural
  problem with three concrete routes (see `recommendations.md`).
- **Untouched (deferred)**: 5 BasicOpenCech sorries
  (L1239/L1563/L1591/L1781/L1810) + 5 Differentials + 1 Monoidal +
  1 Jacobian + 1 Picard.Functor — total 13 untouched.

## What the iter-103 plan got right

- **Route B wrapper-then-apply was the correct structural move.** The
  iter-104 prover's own report explicitly recommended this path; iter-103
  plan transcribed it directly. The wrapper helpers landed clean on
  first sustained attempt (single-edit each, both compiling).
- **Explicit lift of the "no new top-level helpers" rule from iter-104**
  was correct. The wrapper requires 2 new top-level decls (~120 LOC
  combined); without the lift, the prover would have hit a write-domain
  block.
- **Helper 1 designed as direct `Pi.lift` (not as `named_family ≫
  eqToHom`)** — this single design decision is what made Helper 2's
  R-linearity proof feasible by reusing the iter-104 pattern. Had Helper
  1 been defined as `named_family ≫ eqToHom`, Helper 2 would have hit
  the iter-099/100/101/103 discrim-tree wall again.
- **Mathlib lemma names verified pre-dispatch.** The directive named
  `Limits.Pi.lift_π_apply`, `ConcreteCategory.comp_apply`,
  `presheafMap_restrict_collapse`, `ModuleCat.piIsoPi_inv_kernel_ι_apply`,
  `RingHom.toModule_smul`, `presheafMap.map_mul` — all fired cleanly.

## What the iter-103 plan got slightly wrong

- **Underestimated the eqToHom-vs-Pi.π transport residual.** The plan
  predicted the L988 close would be "Route B Step 3: apply
  `cechCofaceMap_summand_family'_R_linear` to discharge ?hG" as a
  one-shot move. In reality, the wrapper R-linearity equation
  `h_wrap_pt` differs from the goal LHS by an eqToHom transport that
  Mathlib does not directly handle (no `Pi.π_comp_eqToHom` analogue for
  *object* equality). The plan should have anticipated this gap and
  scheduled the morphism-equality lemma alongside the wrapper.
- **Underestimated wall time.** The plan sketched the L988 close as "5
  attempts at most"; the prover ran 4 probes (attempts 3–6 in the
  journal) and committed a structured partial proof rather than a full
  close. **Lesson for iter-106 plan**: when the prover reports two new
  top-level helpers fully proved AND a structured partial-proof commit,
  count that as a successful "Route B Step 1" close, not a "target
  miss". The next iter should plan Route B Step 2 as a separate
  structural move.

## What iter-105 discovered (deep)

### eqToHom-vs-Pi.π transport for object equality is a Mathlib gap

Mathlib exposes `Limits.Pi.π_comp_eqToHom` for **index** equality
(eqToHom from `i = j`), but the project's `cechCofaceMap_pi_smul` needs
the **object** equality case (eqToHom from `∏ᶜ Z₁ = ∏ᶜ Z₂` derived
from `Fin a = Fin b`). The workaround is a project-local helper proved
via `Limits.Pi.hom_ext` + per-coord `Pi.lift_π_apply` + `Fin.cast_cast`.
**Not suitable for Mathlib upstream** without universe-polymorphic
generalization; suitable as a project-internal lemma.

### iter-099's "rw piIsoPi_hom_ker_subtype_apply doesn't fire on `e₂ _ j'`" re-confirmed

Iter-105 attempt 6 probed `rw [ModuleCat.piIsoPi_hom_ker_subtype_apply,
ModuleCat.piIsoPi_hom_ker_subtype_apply] at h_wrap_pt` to convert the
wrapper R-linearity equation into `(Pi.π Z₂ j').hom` form. Same failure
as iter-099 — the rewrite doesn't fire on LinearEquiv-coerced LHS.
**Lesson reinforced**: when stating a Pi-output transport theorem,
prefer `(Pi.π _ _).hom _` directly in the conclusion (avoiding `e₂` =
`LinearEquiv` form), or supply a `show` def-eq pivot at the client site.

### iter-104 R-linearity pattern confirmed as a reusable production template

`RingHom.toModule_smul` + `piIsoPi_inv_kernel_ι_apply` + term-level
`Eq.trans` + `congrArg` + `presheafMap_restrict_collapse` mirrored
byte-for-byte from iter-104 (L494) to iter-105 (L634) with only the
Fin.cast index translation differing. **The pattern is now confirmed
across 2 invocations** and should be referenced as the project standard
for future R-linearity transport in this file. Documented in
PROJECT_STATUS.md Knowledge Base.

### Streak status — 3rd trigger of escalation criterion over this slot

- iter-099: closed `_sum_comp` body + applied at L695.
- iter-100: `funext j'` pivot.
- iter-101: S1–S3 chain.
- iter-103: S4–S5 chain + Path B σ-binder lemma body.
- iter-104 (refactor): named family + R-linearity skeleton.
- iter-104 prover: closed R-linearity body.
- iter-105 (this iter): wrapper helpers committed + partial proof at
  L1147.

Each substantive lane has produced **durable forward progress** — there
is no "wasted iter" in this list. But L1147 itself remains open. The
iter-106 plan must commit to ONE morphism-level route and follow it
through without regressing to tactic-only attempts. See
`recommendations.md` for the three routes.

## Notes for iter-106 plan-agent

- **Primary route**: Route 1 (top-level morphism-equality lemma
  `cechCofaceMap_summand_family_comp_eqToHom_eq` proved via
  `Limits.Pi.hom_ext` + `Pi.lift_π_apply` + `Fin.cast_cast`). Estimated
  ~25 LOC for the lemma + ~12 LOC for the L1147 client proof; ~40 LOC
  total.
- **Fallback (iter-107)**: Route 2 (rcases-on-n + stronger simp set
  `[eqToHom_refl, Category.id_comp, Category.comp_id, Fin.cast_refl]`).
- **Last resort**: Route 3 (`convert h_wrap_pt using 3` + per-coord
  transport sub-goals).
- **No subagent dispatch needed** for Route 1 — direct prover lane is
  cleaner. Only invoke refactor if Route 1 needs cross-file plumbing
  (it doesn't).
- **Heartbeat budget**: default 800000 is sufficient; iter-102's
  12800000 bump remains reverted as of iter-105 close.

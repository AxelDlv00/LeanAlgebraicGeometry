# Strategy Critic Report

## Slug
iter014

## Iteration
014

## Routes audited

The strategy declares "single route per target": **FBC**, **GF**, **QUOT** (QUOT
sub-divides into SNAP / predicates / QUOT-repr). Audited as three route blocks.

### Route: FBC

- **Goal-alignment**: PASS — affine lemma + Čech-free globalization is exactly
  `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`.
- **Mathematical soundness**: PARTIAL — the core math is correct (at the module level the
  i=0 base-change map *is* the regroup iso `R'⊗_R M ≅ (A⊗_R R')⊗_A M`, and that iso is
  CLOSED). What is NOT yet sound-on-paper is the **seam closure**: the strategy itself
  rates Seam 1→2→3 as "conjugate-adjunction unit coherences with no Mathlib idiom" and the
  element-chase as a "confirmed dead end." A route whose residual is described in those
  terms has not demonstrated it will close.
- **Sunk-cost reasoning detected**: yes — "the hardest object-level piece … is now CLOSED
  (it stayed open for many iters in the tower)". The merit argument (generator-checked
  section identities are cheaper than sheaf-level naturality) is legitimate, but the
  "stayed open for many iters" clause is sunk-cost framing.
- **Infrastructure-deferral detected**: yes — the strategy states verbatim "The parent's
  adjoint-mate tower is **RELOCATED, not eliminated**". The hardest prerequisite before the
  pivot (mate/conjugate-adjunction unit coherence, sheaf-level) is the *same* hardest
  prerequisite after (the same coherence, section-level = Seams 1–3). By the strategy's own
  wording this is the "same hard problem one layer deeper" pattern. One genuinely hard
  sub-piece (`regroupEquiv`) did close, so it is a partial pivot, not pure avoidance — but
  the residual is the relocated coherence, and it is stuck.
- **Phantom prerequisites**: none. `CategoryTheory.conjugateEquiv` (Mathlib.CategoryTheory.
  Adjunction.Mates) and its explicit-component lemma `conjugateEquiv_apply_app` are
  VERIFIED present.
- **Effort honesty**: reasonable-to-optimistic — 2–4 iters / ~100–240 LOC is plausible only
  if one of the cheaper routes below lands; if the strategy keeps grinding the opaque
  `conjugateIsoEquiv` element-chase it is open-ended.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE — the relocated coherence is the same hard problem and is stalled
  ("no Mathlib idiom", "confirmed dead end"); the planner must either adopt a route that
  eliminates rather than relocates the mate coherence (see Alternatives) or commit to a
  hard effort-break with an iter cap and a named fallback.

### Route: GF

- **Verdict**: SOUND — the Nitsure §4 induction (in `references/nitsure-hilbert-quot`,
  the explicitly cited primary source) is the canonical proof; the decomposition into
  `gf_generic_rank_ses` + `gf_torsion_reindex` + the shared single-variable elimination
  engine + denominator-clearing is honest; reverting the base domain `A` into the
  `Nat.strong_induction_on` motive is the correct device for the reindex-changes-base-ring
  subtlety. All named Mathlib infra
  (`IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`, `finrank`/generic rank) is
  VERIFIED present. Estimates (2–3 iters core, 1–2 geo) are consistent with the scope.

### Route: QUOT

- **Goal-alignment**: PARTIAL — the four QUOT decls plus `thm:grassmannian_representable`
  are all goal-named. The gap is RelativeSpec: the *proved* form is strictly weaker than the
  goal needs (see infra-deferral below).
- **Mathematical soundness**: PASS — the graded-Hilbert-function encoding (Hartshorne I.7.5
  / Nitsure §1) correctly stays Čech-independent; pinning to the defining graded module
  `M = im(Sᴺ→⊕ₘΓ(F⊗Lᵐ))` to dodge the `H¹` left-exactness defect is a correct and clean
  move; Stacks 00K1's degreewise-SES induction is the right (and lightest classical) proof.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — three items, see the dedicated section:
  (1) RelativeSpec `RepresentableBy` strengthening; (2) `def:sectionGradedRing`;
  (3) the QCoh→`IsLocalizedModule` bridge `isIso_fromTildeΓ_of_isQuasicoherent` (lower
  severity, genuinely gated behind a BLOCKED consumer).
- **Phantom prerequisites**: none. `Polynomial.existsUnique_hilbertPoly`
  (Mathlib.RingTheory.Polynomial.HilbertPoly), `Functor.IsRepresentable` /
  `RepresentableBy` / `representableByEquiv` (Mathlib.CategoryTheory.Yoneda /
  RepresentedBy), `Module.Flat.ker_lTensor_eq` / `tensorEqLocusEquiv`
  (Mathlib.RingTheory.Flat.Equalizer) all VERIFIED. **Counter to the "Mathlib-absent"
  framing of the SNAP graded API**: `HomogeneousSubmodule` / `Submodule.IsHomogeneous`
  (Mathlib.RingTheory.GradedAlgebra.Homogeneous.Submodule) and `QuotSMulTop` (= M/xM,
  Mathlib.RingTheory.QuotSMulTop) DO exist — see Alternatives.
- **Effort honesty**: SNAP under-counted — its 2–4 iters / ~150–360 LOC budgets the S2
  power-series→graded reduction but does **not** budget `def:sectionGradedRing`, which S1/S3
  are explicitly BLOCKED on and which has no phase row anywhere. QUOT-repr's 6–12 / ~400–
  1000+ is honestly wide.
- **Parallelism under-exploited**: no — the four QUOT files importing only Mathlib are
  correctly flagged as parallel-authorable alongside FBC/GF.
- **Verdict**: CHALLENGE — driven by the RelativeSpec weaker-form gap and the unscheduled
  `def:sectionGradedRing` blocker; the SNAP and predicate cores are otherwise sound.

## Format compliance

- **Size**: 166 lines / ~11 KB — within budget (~250 lines / ~12 KB), but the `## Routes`
  prose is dense and near the byte ceiling.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, correct order.
  `## Completed` is omitted; permissible, but a fair amount of work is CLOSED/DONE
  (RegroupHelper, GR-cells, S2 power-series engine = 8 decls, P1 predicates) and is
  currently scattered as inline "DONE"/"CLOSED" annotations — a `## Completed` table would
  serve the ledger better.
- **Per-iter narrative detected**: yes — `(strategy-critic iter-012)` appears twice in
  `## Routes`; and the FBC paragraph carries decision-history prose: "the multi-iter
  `map_smul'` transparent-instance wall, broken via `erw [TensorProduct.zero_tmul]`" and
  "the `cancelBaseChange` one-liner was attempted and abandoned over the `extendScalars`
  diamond; the landed route is …". These belong in iter sidecars.
- **Accumulation detected**: no completed *phase* is stuck in the active table (all rows are
  ACTIVE/NEXT/BLOCKED). Accumulation is mild and limited to the inline closed-work
  annotations noted above.
- **Table discipline**: FAIL (minor) — several `## Phases & estimations` cells carry
  multi-clause prose rather than "one short line", notably the FBC-A and SNAP `Risks`
  cells and several `Key Mathlib needs` cells.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: RelativeSpec `RepresentableBy` strengthening

- **Required by goal**: yes — `thm:grassmannian_representable` (goal-named) flows through
  GR-repr, which "needs `thm:relative_spec_univ` strengthened to a `RepresentableBy`
  witness." The proved form is only `IsAffineHom` / `IsAffine` (blueprint summary:
  "acknowledged weakenings vs. the RepresentableBy form needed downstream").
- **Current plan for building it**: none committed — an open question offering two options
  (strengthen RelativeSpec, re-opening proved work, vs. a RepresentableBy-free GR-repr
  argument), explicitly "Deferred."
- **Timeline**: absent (tied to "QUOT-repr is many iters out").
- **Verdict**: CHALLENGE — this is the textbook "built infrastructure for a weaker
  statement than the goal requires, intending to extend later" pattern. Deferring the
  *decision* while QUOT-repr is far out is defensible; what is not is leaving the stronger
  construction with zero committed plan. The planner should at minimum pick the route now
  (strengthen vs. avoid) so the QUOT-repr LOC/iter estimate is honest. Note
  `representableByEquiv : RepresentableBy Y ≃ (yoneda.obj Y ≅ F)` exists and is the natural
  bridge if the strengthen route is chosen.

### Deferred: `def:sectionGradedRing` (sheaf-sections → graded ring/module bridge)

- **Required by goal**: yes — SNAP S1 ("Needs `def:sectionGradedRing`") and S3 are both
  BLOCKED on it, and S1/S3 are what actually deliver `def:hilbert_polynomial`. The pure
  S2 rationality lemma alone does not produce the goal object.
- **Current plan for building it**: none — it is named only as a blocker; it has no row in
  `## Phases & estimations` and no LOC/iter budget.
- **Timeline**: absent.
- **Verdict**: CHALLENGE — the SNAP estimate budgets the "fun" algebraic half (S2 power
  series, already done) while the geometric bridge that connects it to the goal is
  unscheduled. Give `def:sectionGradedRing` its own line with an estimate, or fold it into
  the SNAP/QUOT-defs budget explicitly.

### Deferred: QCoh→`IsLocalizedModule` bridge `isIso_fromTildeΓ_of_isQuasicoherent`

- **Required by goal**: partially — only the *forward* annihilator characterization needs
  it, whose sole live consumer (QUOT-repr support check) is itself BLOCKED 6–12 iters out.
- **Current plan for building it**: a concrete plan exists — "try the LOCAL route first"
  from `tildeRestriction_isLocalizedModule` before the heavy global sub-build, gated by a
  bounded existence search.
- **Timeline**: vague ("Multi-iter; Mathlib-gradient lane").
- **Verdict**: CHALLENGE (lowest severity) — this one is legitimately off the current
  critical path (consumer BLOCKED) and has a plan; acceptable to defer, but the "off the
  current critical path" label should be reaffirmed each iter, not allowed to ossify.

## Alternative routes (suggested)

### Alternative: FBC — eliminate the mate identification instead of relocating it

- **What it looks like**: Define the affine comparison morphism *concretely* as
  `regroupEquiv` (already CLOSED) and prove it is a natural iso of the relevant
  pushforward/pullback functors at the module/section level (naturality in the affine open
  is module-linear, checkable on generators `r'⊗m`). Reconcile with the parent's
  abstractly-defined base-change `θ` only at the single point where merge-back demands it —
  and first *check whether it demands it at all*: if `lem:affine_base_change_pushforward`
  is consumed as "the canonical map is iso" with the canonical map fixed by the parent, the
  reconciliation (= Seams 1–3) is unavoidable; if it is consumed as "∃ natural iso" or the
  specific map does not propagate downstream, all three seams vanish.
- **Why it might be cheaper or sounder**: it converts the stalled, idiom-free
  conjugate-adjunction coherence into the already-working generator-chase machinery, and
  potentially deletes Seams 1–3 entirely rather than grinding them.
- **What the current strategy may have rejected**: the merge-back signature constraint —
  the strategy assumes the parent's `θ` must be matched. That assumption is checkable and
  has not (visibly) been checked; it is the single highest-leverage question for FBC-A.
- **Severity of the omission**: major.

### Alternative: FBC — use `conjugateEquiv` (not the iso wrapper) + `conjugateEquiv_apply_app`

- **What it looks like**: The strategy's "confirmed dead end" is the element-chase on the
  *opaque* `conjugateIsoEquiv`. The plain `CategoryTheory.conjugateEquiv` has a verified
  explicit-component simp lemma: `(conjugateEquiv adj₁ adj₂ a).app X = adj₂.unit.app (R₁.obj
  X) ≫ R₂.map (a.app (R₁.obj X)) ≫ R₂.map (adj₁.counit.app X)`. Phrase the seams against
  this unfolded form rather than the iso packaging.
- **Why it might be cheaper or sounder**: the dead-end opacity is plausibly an artifact of
  the `…IsoEquiv` wrapper; `conjugateEquiv_apply_app` gives exactly the unit/counit-level
  handle the Seam 1→2→3 transport needs, with a Mathlib idiom after all.
- **What the current strategy may have rejected**: it states the seams have "no Mathlib
  idiom" — `conjugateEquiv_apply_app` contradicts that for the component computation.
- **Severity of the omission**: major.

### Alternative: SNAP — build the graded API on top of existing Mathlib, not from scratch

- **What it looks like**: The strategy frames "graded quotient `M/xM`, graded kernel of
  `x⋆`, regrading, `Module.Finite` transfer" as wholesale Mathlib-absent. In fact
  `HomogeneousSubmodule` / `Submodule.IsHomogeneous`
  (Mathlib.RingTheory.GradedAlgebra.Homogeneous.Submodule) supply graded submodules
  (the kernel `ker(x⋆)` is a homogeneous submodule), and `QuotSMulTop x M` (= M/xM,
  Mathlib.RingTheory.QuotSMulTop) supplies the ungraded quotient. The project work shrinks
  to: putting the graded structure on these existing objects + the regrade over `S/(x)` +
  the finiteness transfer.
- **Why it might be cheaper or sounder**: turns a "from-scratch graded-module-API lane"
  into a thin wrapper over existing constructions; meaningfully de-risks the SNAP-S2 estimate
  (and may mean it is over-, not under-, counted on the algebra side).
- **What the current strategy may have rejected**: unclear — the "Mathlib-absent" label
  reads as not having spotted `HomogeneousSubmodule`/`QuotSMulTop`.
- **Severity of the omission**: major.

## Sunk-cost flags

- `the hardest object-level piece, the regroupEquiv diamond, is now CLOSED (it stayed open
  for many iters in the tower)` — Why this is sunk-cost: "stayed open for many iters"
  argues from prior investment, not from why the new decomposition is correct.
  Recommendation: keep only the on-merits clause (generator-checked section identities vs.
  sheaf-level naturality) and drop the iter-count appeal.

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (Mathlib.RingTheory.Polynomial.HilbertPoly)
- `CategoryTheory.conjugateEquiv` + `conjugateEquiv_apply_app`: VERIFIED (Adjunction.Mates)
- `Algebra.IsPushout.cancelBaseChange`: stated "verified present" by strategy; not
  re-verified here (loogle timed out) — low risk, the regroup route no longer depends on it.
- `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`: VERIFIED
  (Mathlib.RingTheory.Ideal.AssociatedPrime.Finiteness)
- `Module.Flat.ker_lTensor_eq`, `LinearMap.tensorEqLocusEquiv`: VERIFIED
  (Mathlib.RingTheory.Flat.Equalizer)
- `Functor.IsRepresentable` / `RepresentableBy` / `representableByEquiv`: VERIFIED
  (Mathlib.CategoryTheory.Yoneda, RepresentedBy)
- `HomogeneousSubmodule` / `Submodule.IsHomogeneous`: VERIFIED
  (Mathlib.RingTheory.GradedAlgebra.Homogeneous.Submodule) — contradicts the SNAP
  "Mathlib-absent" framing.
- `QuotSMulTop`: VERIFIED (Mathlib.RingTheory.QuotSMulTop) — = M/xM.

## Must-fix-this-iter

- Route FBC: CHALLENGE — the mate coherence is RELOCATED-not-eliminated and the relocated
  form is stalled. Before spending more iters on the opaque-`conjugateIsoEquiv` route,
  (a) determine whether merge-back actually requires matching the parent's abstract `θ` (if
  not, define the comparison as `regroupEquiv` and delete Seams 1–3), and (b) retry the
  seams against `conjugateEquiv` + `conjugateEquiv_apply_app` rather than the iso wrapper.
  Set an explicit iter cap with a named fallback.
- Route QUOT: infrastructure-deferral CHALLENGE — `def:sectionGradedRing` (required by goal
  via SNAP S1/S3) has no phase row and no estimate. Give it a budgeted line or fold it
  explicitly into the SNAP/QUOT-defs estimate.
- Route QUOT: infrastructure-deferral CHALLENGE — RelativeSpec `RepresentableBy` (required
  by goal via GR-repr) is proved only in the weaker `IsAffineHom`/`IsAffine` form with no
  committed plan. Choose strengthen-vs-avoid now so the QUOT-repr estimate is honest.
- Alternative SNAP build-shrink: major — re-scope the graded-module-API lane against
  existing `HomogeneousSubmodule` / `QuotSMulTop` instead of "Mathlib-absent from scratch".
- Format: DRIFTED — remove the `(strategy-critic iter-012)` parentheticals and the
  "attempted and abandoned / multi-iter wall broken via erw" decision-history prose from
  `## Routes` (move to iter sidecars); trim the multi-clause `Risks`/`Key Mathlib needs`
  table cells to one short line; consider adding a `## Completed` table for the CLOSED work.

## Overall verdict

GF is SOUND and ready to proceed. FBC and QUOT are each CHALLENGE. For FBC, the strategy
defers the mate coherence — it is RELOCATED, not eliminated, and the relocated section-level
form is, by the strategy's own words, stalled with "no Mathlib idiom" and a "confirmed dead
end"; this is the same hard problem one layer deeper, and the planner should test the two
cheaper routes (drop the mate identification if merge-back permits; use `conjugateEquiv`'s
explicit-component lemma instead of the opaque iso wrapper) before grinding further. For
QUOT, the strategy defers `def:sectionGradedRing` and the RelativeSpec `RepresentableBy`
strengthening, both of which are required for the stated goal: SNAP's S1/S3 cannot produce
`def:hilbert_polynomial` without `def:sectionGradedRing`, and `thm:grassmannian_representable`
cannot be reached through GR-repr without the stronger RelativeSpec form. Neither deferred
construction has a budgeted plan, and the SNAP algebra lane is mis-scoped as "Mathlib-absent"
when `HomogeneousSubmodule` and `QuotSMulTop` already exist. No route is mathematically
unsound and no prerequisite is phantom — every named Mathlib lemma was verified present — so
the verdicts are CHALLENGE, not REJECT. Format is DRIFTED (per-iter narrative and overloaded
table cells), fixable in place.

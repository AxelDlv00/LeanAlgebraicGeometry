# Strategy Critic Report

## Slug
iter111

## Iteration
111

## Re-verification framing

STRATEGY.md is unchanged from iter-110, when I issued
SOUND-with-CHALLENGE (4 precision asks, all addressed). This iter is a
fresh-context re-verification of the four directive items: (i) 7+1
named-gap roster, (ii) Phase A substep framing, (iii) Phase B 3-sorry
scope post-L877 reclassification, (iv) C3 JacobianWitness exit policy.

I've also read STRATEGY.md as a fresh document end-to-end (the
directive carries the verbatim text) and the two persistent rationale
files cited by the strategy (`analogies/c1-route.md`,
`analogies/serre-duality.md`) — these supply the Mathlib-existence
audits I would otherwise have to re-run.

## Routes audited

### Route: Phase A residual close-out (`BasicOpenCech.lean`)

- **Goal-alignment**: PARTIAL — the route's "iterations remaining /
  LOC remaining" column in the phase table promises near-term residual
  work (~2–4 iters / ~30–80 LOC), but the body text says Phase A is
  "now closed-out for the autonomous loop's scope modulo the deferred
  sub-step sorries L1212/L1536/L1564." The fresh reader of the table
  alone gets a different impression than the reader of the body. The
  residual close-out *is* an honest target but is not on the iter-111+
  path.
- **Mathematical soundness**: PASS — the substep dependency framing
  (L1212 awaits substep (a) augmented-Čech complex; L1536 awaits
  K → K₀ transport; L1564 awaits substep (a) for `s₀`) is a clean
  decomposition; these are project-local dependencies, not Mathlib gaps.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none flagged. `IsLocalizedModule.Away`,
  `IsLocalizedModule.pi`, `IsLocalizedModule.prodMap`, and the algebra
  adapter were verified iter-108 per the strategy's own audit (cited
  L1846 row). I see no reason to doubt the verification.
- **Effort honesty**: under-counted in the table only if read as "work
  scheduled this iter or next." The "~2–4 iters / ~30–80 LOC" is a
  per-substep close-out *conditional on the predecessor substep
  landing*; predecessors L1846 and L1120 are themselves deferred /
  paused, so the residual estimate is for off-path work. The body text
  acknowledges this, but the table cell does not. Recommendation:
  re-cast the table cell to `DEFERRED (gated)` or footnote the
  conditionality.
- **Verdict**: CHALLENGE — table presentation drifts from body text;
  fresh reader will form an inconsistent picture of when Phase A
  residual lands.

### Route: Phase B close-out (`Differentials.lean`) — 3-sorry scope

- **Goal-alignment**: PASS — L122 (`relativeDifferentialsPresheaf_isSheaf`),
  L718 (`smooth_iff_locally_free_omega`), L735 (`cotangent_at_section`)
  are the right autonomous-loop scope after the iter-110 L877
  reclassification. The Phase B closure feeds genus dimensionality
  results downstream (consumed by the framework-conditional Jacobian
  arc), and the three remaining sorries cover the cotangent-sheaf API
  that subsequent dependents need.
- **Mathematical soundness**: PARTIAL — L122 (a presheaf is a sheaf)
  is a structural check; L735 (stalk-at-section of cotangent) is
  intermediate. **L718 (Smooth iff Ω is locally free) is Hartshorne II
  Theorem 8.15, a genuinely non-trivial equivalence**. The strategy
  text claims all three are "prover-viable in parallel," and the
  iter-110 blueprint-writer round supposedly expanded the chapter to
  prover-ready depth. I cannot independently verify the blueprint
  depth without reading the chapter (which the directive correctly
  withholds), but the parallelism claim is optimistic on its face: in
  any reasonable decomposition, L718 will dominate the close-out
  cost. Strategy should not budget all three at uniform cost.
- **Sunk-cost reasoning detected**: no. The L877 reclassification
  *removes* sunk-cost momentum (was prover-bait; now correctly named
  Mathlib gap).
- **Phantom prerequisites**: none.
- **Effort honesty**: the strategy's overall Phase B figure of "~3–6
  iters / ~150 LOC" looks tight for L718 alone. A more honest split:
  L122 cheap (~1 iter), L735 moderate (~1–2 iters), L718 expensive
  (~2–4 iters). The aggregate "~6–12 iters / ~150–300 LOC remaining"
  at the bottom of the estimations section is the right ballpark only
  if Phase A residual is excluded (which the body text supports).
- **Verdict**: SOUND with a minor framing ask — explicitly note that
  L718 is the heaviest of the three so the prover loop doesn't dispatch
  three lanes at equal priority/expected-cost.

### Route: C0 / C1 / C2 — Picard / monoidal `X.Modules`

- **Goal-alignment**: PASS — C1 promotion landed iter-109 and the
  cascade through C2 has substantially absorbed the universe bumps.
  The `(Skeleton X.Modules)ˣ` idiom is verified Mathlib-canonical
  (`CategoryTheory.Skeleton.instCommMonoid` confirmed; mirrors
  `CommRing.Pic`).
- **Mathematical soundness**: PASS — the disclosure that
  `instIsMonoidal_W` shifts from *dormant* to *load-bearing*
  post-C1 (per `c1-route.md`) is precisely the kind of honest
  re-classification the project should be doing. The pair
  `pullback_tensorObj` + `pullback_oneIso` is the correct
  decomposition of an absent `(SheafOfModules.pullback _).Monoidal`
  instance.
- **Sunk-cost reasoning detected**: no. C1 was promoted because the
  Mathlib idiom *is* the cleaner one (units of the skeleton), not
  because prior C1 work needs preserving.
- **Phantom prerequisites**: none flagged. `c1-route.md` is explicit
  that "MonoidalCategory.Invertible" — the strategy text's earlier
  placeholder — does not exist in Mathlib; the refactor correctly
  pivoted to `(Skeleton X.Modules)ˣ`.
- **Effort honesty**: C2 "0–4 iters / 0–80 LOC" with "likely outcome:
  no further work needed" is reasonable given C1's iter-109 close-out
  via the refactor subagent.
- **Verdict**: SOUND. Strongly endorse the iter-111+ "cheap
  verification-round-first" ordering on C2 over speculating about
  Pic.pullback content gaps.

### Route: Phase C3 — `JacobianWitness` exit policy

- **Goal-alignment**: PASS — the project's stated goal is the **9
  protected declarations** of `references/challenge.lean` *with
  signatures frozen*. The witness pattern produces declarations with
  the correct signatures; their bodies route through
  `Nonempty (JacobianWitness C)`, which is a single named existence
  sorry. This is the cleanest possible exit consistent with the
  protected signatures. The end-state framing's plain-language
  disclosure ("ships a Jacobian *framework*, conditional on the
  witness — does NOT autonomously construct the Jacobian") is
  exemplary in honest accounting.
- **Mathematical soundness**: PASS — `nonempty_jacobianWitness` is a
  well-typed `Type → Prop`-style existence; the soundness rule
  (no universally-false helper) is observed. The strategy correctly
  rejected the earlier 10–15-iter / ~1500-LOC estimate as wildly
  under-counted for either FGA-Hilbert or `Sym^g/S_g`.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none. The strategy explicitly disclaims
  Mathlib's absence of Hilbert/Quot schemes and finite-group scheme
  quotients.
- **Effort honesty**: deferral cost is zero by construction; honest.
- **Verdict**: SOUND. This is the right move and the right framing.

### Route: 7+1 named-gap roster (end-state disclosure)

- **Goal-alignment**: PASS — the 7 named Mathlib-gap sorries + 1
  budget-deferred sorry roster is the honest end-state surface.
  `lean_verify` on the framework-conditional layers will surface
  `sorryAx` chains rooted at exactly these positions, matching the
  documented "what's unconditional vs framework-conditional" split.
- **Mathematical soundness**: PASS for every individual entry.
  Specifically:
  1. `instIsMonoidal_W` (varying-ring `stalk_tensorObj`) — load-bearing
     post-C1, correctly disclosed.
  2. `cotangentExactSeq_structure.h_exact` (sheaf-modules exactness
     criterion) — Mathlib gap, parallel to (1).
  3. `nonempty_jacobianWitness` — Hilbert/Quot + finite-group gaps,
     C3 exit.
  4. `PicardFunctor.representable` — gated on (3); valid only if (3)
     resolves.
  5. + 6. `SheafOfModules.pullback_tensorObj` / `pullback_oneIso` —
     single underlying monoidal-pullback gap, split into μ-iso and
     ε-iso witnesses; the strategy explicitly notes they "collapse
     simultaneously" when Mathlib lands the monoidal instance. This
     two-row accounting is *honest* (Lean really has two sorries at
     L82 and L96) and a fresh reader is not misled.
  7. `serre_duality_genus` — iter-110 reclassification per
     `serre-duality.md`; the rationale file's exhaustive Mathlib
     verification (no `SerreDuality`, no `DualizingSheaf`, no trace
     morphism for proper morphisms, no Zariski coherent cohomology
     for QC sheaves, no Riemann–Roch) is convincing.
  + Budget-deferred L1846 `h_loc_exact` — explicitly labelled "NOT a
    Mathlib gap" with the mechanizability claim documented; correct
    soundness-rule application (a budget-deferred sorry is a different
    category from a Mathlib-gap sorry).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none. Every claimed Mathlib gap has a
  documented audit (in the strategy itself, or in the persistent
  rationale files).
- **Effort honesty**: each entry's scope is honestly stated. The
  serre-duality "~3000–8000 LOC from first principles" matches the
  rationale file's breakdown (trace map + duality pairing +
  perfect-pairing + bridge to rank equality).
- **Verdict**: SOUND. The roster is the right disclosure surface.

## Alternative routes (suggested)

### Alternative: explicit named-gap surface as a `protected` type instead of inline sorries

- **What it looks like**: package each of the 7 named Mathlib gaps as
  a `class` or `structure` (`AlgebraicGeometry.MathlibGap_*`) whose
  instances are the only way to discharge them, with one
  `theorem … := sorry` inside each. Downstream lemmas then take
  `[MathlibGap_SerreDuality]` (etc.) as an explicit typeclass
  argument rather than inheriting a transitive `sorryAx`.
- **Why it might be cheaper or sounder**: makes the
  framework-conditional layers' dependency on each gap *visible at the
  type level*, so `lean_verify` becomes redundant for surfacing the
  conditioning (the type signature already says it). The
  `JacobianWitness` exit policy already does this for gap (3); the
  same pattern could be applied uniformly.
- **What the current strategy may have rejected**: I suspect the
  protected signatures freeze prevents adding `[MathlibGap_*]`
  typeclass arguments to e.g. `Jacobian C`, so the typeclass route
  cannot be applied uniformly without breaking the signature freeze.
  The witness route works specifically because it routes *through
  the body* of a frozen-signature decl, not its arguments. Strategy
  may have rejected the alternative for exactly this reason.
- **Severity of the omission**: minor — the strategy's chosen
  framework-conditional disclosure is already honest; the alternative
  would be more uniform but is gated by the signature freeze.

### Alternative: Picard-via-divisor-class-image Pic⁰

- **What it looks like**: instead of constructing the Jacobian via a
  representability witness or `Sym^g/S_g`, bypass scheme-level Pic⁰
  altogether by working with degree-0 divisor classes (Weil divisors
  modulo principal) and equip them with a *group* structure rather
  than a scheme structure. The protected signature `Jacobian C : Over
  (Spec k)` rules this out directly (the result must be a scheme over
  `k`), but a *witness-only* construction (Spec of the group ring of
  divisor classes, or similar) might give an over-scheme that
  satisfies the signature without constructing Hilbert/Quot.
- **Why it might be cheaper or sounder**: if such a Spec-construction
  produces a scheme over `k` with the required typeclass instances
  (modulo Mathlib gaps already named), it could obviate the
  `nonempty_jacobianWitness` sorry, reducing the named-gap count
  from 7 to 6.
- **What the current strategy may have rejected**: the strategy
  mentions this as "documented as a future-work option" under the
  C3 exit policy. Plausible reason: the Spec-of-group-ring object
  is not naturally smooth or even finite-type, so the required
  instances (`SmoothOfRelativeDimension`, `IsProper`, `GrpObj`,
  `GeometricallyIrreducible`) would themselves require nontrivial
  bridging that recapitulates the Hilbert/Quot effort.
- **Severity of the omission**: minor — already acknowledged
  by the strategy as future work; not actionable in the autonomous
  loop's remaining budget.

## Sunk-cost flags

None detected. The strategy aggressively *rejects* sunk cost
(progress-critic-iter106/107/108 STUCK led to L1120 PAUSE; two
consecutive PARTIAL on L1846 fired Option (i); iter-105 REJECT on
the C3 estimate led to the JacobianWitness exit). This is the
opposite of sunk-cost reasoning — the strategy is comfortable
abandoning routes when the evidence says they're not landing.

## Prerequisite verification

- `IsLocalizedModule.Away` / `IsLocalizedModule.pi` /
  `IsLocalizedModule.prodMap`: VERIFIED (strategy cites iter-108
  audit; persistent rationale in
  `analogies/finite-product-localisation-and-cech-r-linearity.md`).
- `CategoryTheory.Skeleton.instCommMonoid` (Picard idiom):
  VERIFIED via `lean_leansearch` (`Mathlib.CategoryTheory.Monoidal.Skeleton`,
  requires `[BraidedCategory C]`, returns `CommMonoid (Skeleton C)`).
- `CommRing.Pic` precedent: VERIFIED (strategy cites
  `Mathlib.RingTheory.PicardGroup:407-408` via `c1-route.md`).
- `(SheafOfModules.pullback _).Monoidal`: MISSING — strategy
  correctly classifies as Mathlib gap (5+6).
- `SerreDuality` / `DualizingSheaf` / trace morphism / coherent
  cohomology of QC sheaves / Riemann–Roch: MISSING — strategy
  correctly classifies as Mathlib gap (7); persistent rationale
  in `analogies/serre-duality.md` provides exhaustive evidence.
- Hilbert / Quot schemes / finite-group quotients: MISSING —
  strategy correctly classifies as Mathlib gap (3); deferred via
  C3 exit policy.

## Must-fix-this-iter

- Route Phase A residual: CHALLENGE — the phase-table cell
  "~2–4 iters / ~30–80 LOC" implies near-term scheduled work, but
  the body text says Phase A is closed-out modulo gated substeps and
  the "Path from today to end-state" section does not schedule any
  Phase A work. Reconcile by either (a) re-casting the table cell to
  `DEFERRED (gated)` with the LOC figure parenthesized as
  conditional, or (b) explicitly footnoting that the estimate is
  per-substep-conditional and *not* on the iter-111+ path.
- Route Phase B 3-sorry scope: minor framing ask — note explicitly
  that L718 (`smooth_iff_locally_free_omega`, Hartshorne II 8.15) is
  the heaviest of the three so the prover loop does not dispatch
  three lanes at equal expected cost. The "prover-viable in parallel"
  language as-is invites uniform-priority scheduling.

No REJECT verdicts. No phantom prerequisites.

## Overall verdict

A fresh mathematician would **approve this strategy as-is**, modulo
two minor framing precision asks. The 7+1 named-gap roster is honestly
disclosed and each entry has a documented Mathlib audit. The
"framework-conditional" enumeration introduced iter-109/110 gives the
fresh reader exactly the right mental model: an unconditional core
(Rigidity, Genus def, Čech infra, FunctorAb wrapping) plus three
conditional layers (witness-conditional Jacobian arc;
`instIsMonoidal_W`-and-pair-conditional Picard arc; future-conditional
Serre-duality bridge). The C3 JacobianWitness exit policy is the right
soundness-rule-compliant move and was correctly extended to
`instIsMonoidal_W` (load-bearing post-C1) and `serre_duality_genus`
(iter-110 reclassification). The strategy is materially more honest
than typical formalization-project end-states; the only criticisms I
have are presentational (Phase A table cell vs body text;
L718-as-heaviest framing). The path forward — iter-111+ Phase B
opening on L122, then L735 / L718, then C2 verification, then ship —
is reasonable and tight.

## Return value

iter111: SOUND-with-CHALLENGE — 6 routes audited, 2 CHALLENGE verdicts (Phase A table-presentation precision; Phase B L718-as-heaviest framing). Report at /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/task_results/strategy-critic-iter111.md

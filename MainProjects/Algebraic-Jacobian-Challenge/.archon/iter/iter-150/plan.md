# Iter-150 plan-agent run

## Headline outcome

Iter-150 is a **HYBRID-pivot iter**: the iter-149 escalation hook fired
(progress-critic CHURNING + iter-149 commitment); the mathlib-analogist
cross-domain consult discarded the directive's H1Cotangent-vanishing
pivot as mathematically incoherent (André-Quillen H¹ ≠ structure-sheaf
H⁰; naming collision) but surfaced **three productive analogues** under
a HYBRID heading. Iter-150 commits the safe two-thirds of the HYBRID
to a small two-lane prover dispatch, and surfaces the third (gated)
piece to the user via the iter sidecar for review-agent absorption to
TO_USER.md.

User-hint absorption (per `USER_HINTS.md`):

1. **Fabricated `references/literature-crosscheck-iter149.md`** — removed
   prior to this iter (file absent + summary.md clean confirmed at plan
   start). `reference-retriever` dispatched (slug
   `stacks-and-classical-ag-iter150`) and returned PARTIAL: 11 reference
   files written, **4 Stacks Tag numbers in the prior strategy/blueprint
   were typos** (0334 → 035U/030V; 0BJF → 0BUG part (4); 05DH → 09HD +
   030K; 07F4 → 00T7). Classical textbooks (Hartshorne, Eisenbud,
   Matsumura) are Springer/CUP paywalled; honest TOC-only stubs written
   with explicit "do not cite specific statements" warnings.

2. **Blueprint rendering failures** — confirmed via direct grep at plan
   start; remediated this iter via `blueprint-writer-render-fix-iter150`.
   Six new macros added to `common.tex`
   (`\Abelian`, `\HasCechToHModuleIso`, `\IsAffineHModuleVanishing`,
   `\HasAffineCechAcyclicCover`, `\app`, `\pr`, `\presheaf`, plus
   `\providecommand{\hom}` and `\providecommand{\cref}/\Cref`).
   `Cohomology_MayerVietoris.tex:66–69` `tikzcd` converted to a
   KaTeX-renderable 4-node array. Three `$\thm{...}$` invocations in
   `RigidityKbar.tex` (lines 10, 2319, 2322) replaced by `\cref{...}`.
   Four Stacks Tag typos corrected inline with `% NOTE:` traceability
   pointers to `references/stacks-*.md`. **Unexpected finding**: the
   user's reported `??` placeholders were not source-level placeholders
   but plastex `\cref` fallback misses; the new `\providecommand{\cref}`
   fixes every project-wide `??` rendering artifact in one line.
   `leanblueprint web` builds CLEAN post-writer.

3. **Reference integration (every blueprint declaration cites source)**
   — light pass landed this iter via the same writer round:
   `% NOTE: see references/...` pointers added above the main theorem
   `thm:rigidity_over_kbar` (RigidityKbar.tex) and `def:genus`
   (Genus.tex) + the Mayer–Vietoris exactness + cover-totality bridge
   declarations (Cohomology_MayerVietoris.tex). Substantive content-
   excerpt backfill is iter-151+ per-chapter writer work (scope-bounded
   to ~5 declarations per chapter to avoid the iter-149 fabrication
   anti-pattern).

## Wave 1 (parallel) — 4 dispatches

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| `blueprint-reviewer` | iter150 | **HARD GATE technically blocks** `RigidityKbar.tex` (`correct: partial` on rendering grounds); pragmatic disposition recommends ~5-min writer fix this iter + green-light prover lanes. 12 chapters audited, 8 clean, 4 `correct: partial` (all reducing to the same macro/render fix). No `??` source placeholders found. All 9 chart-algebra (ii) `\lean{...}` hints verified. | Pragmatic disposition accepted: writer dispatched Wave 2; iter-150 prover dispatch proceeds with HYBRID-trimmed scope. |
| `progress-critic` | iter150 | **CHURNING on Route C** — 4 consecutive PARTIAL iters with recurring "Mathlib gap" blocker in shifting verbal dress. Primary corrective: fire `mathlib-analogist` cross-domain consult **before** re-dispatching prover lanes. Hook commitment (route-pivot user conversation) must also fire. | Accepted: mathlib-analogist dispatched Wave 2; user escalation surfaced via this sidecar for review-agent TO_USER absorption. The substantive iter-149 scaffolding does NOT relax the hook (the hook is metric-bound to body closure; 0/4 met). |
| `strategy-critic` | iter150 | **CHALLENGE + DRIFTED** — 4 CHALLENGEs: (1) Route C's "Honesty note" cites deleted fabricated source; (2) "5–9 iters left" optimistic at the low end vs "380–800 LOC remaining"; (3) over-$\bar k$ alternative's 1200-LOC trigger is unfalsifiable without a counter-bid; (4) H1Cotangent alternative is a major omission requiring feasibility consult. Format DRIFTED: 5 iter-NNN leaks + 2.4 KB byte overage. | All 4 absorbed in STRATEGY.md edits (no rebuttal): (1) "Honesty note" re-grounded against `references/stacks-02KH.md` + `references/stacks-0BUG.md`; (2) iters-left widened 5–9 → 6–10; (3) over-$\bar k$ alternative recast as decorative until LOC-bid lands; (4) HYBRID alternative section added consuming the analogist's verdict. DRIFTED leaks excised structurally (no iter-NNN references in STRATEGY.md anymore). New LOC: 248 / 14.4 KB (within 250-line bound; marginally over ~12 KB byte budget, deliberate given the HYBRID section's necessity). |
| `reference-retriever` | stacks-and-classical-ag-iter150 | **PARTIAL** — 11 reference files written (7 Stacks tags + Hartshorne/Eisenbud/Matsumura TOC stubs + Kleiman/Nitsure FGA arXiv summaries); 4 directive tag numbers corrected; 3 print books stubbed honestly (no statements quoted). | Stacks Tag corrections propagated to blueprint via Wave 2 writer; (S3.*) sub-claim Lean signatures + inline `% NOTE:` pointers landed; iter-151+ writers should ground future citations against the new `references/stacks-*.md` files, not against memory. |

## Wave 2 (parallel) — 2 dispatches conditional on Wave 1

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| `blueprint-writer` | render-fix-iter150 | **COMPLETE** in ~10 min. 4 chapters + `common.tex` edited. 6 new macros + `\hom` provide + `\cref/\Cref` fallback added. One `tikzcd` block converted to array. Three `$\thm{...}$` → `\cref{...}` rewrites. Four Stacks Tag typos corrected inline. Light citation NOTE pass on 3 declarations. `leanblueprint web` builds CLEAN. **Unexpected finding**: `\providecommand{\cref}` fixes every project-wide `??` rendering artifact in one line; the user's `??` complaint was a plastex `\cref` miss, not a source-level placeholder. | Accepted in full. One follow-up flagged: `chap-AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` carries the same 3 wrong Stacks Tags at lines 42, 46, 51 (out of this writer's write-domain); iter-151+ cleanup dispatch noted in `task_pending.md` operational debt. |
| `mathlib-analogist` | h1cotangent-iter150 (cross-domain-inspiration) | **HYBRID pivot recommended** — 3 ANALOGUE_FOUND, 1 PARTIAL_ANALOGUE, 1 NO_USEFUL_ANALOGUE. The directive's H1Cotangent-vanishing pivot is mathematically incoherent (André-Quillen H¹ ≠ Γ ≅ k; naming collision). Hybrid: (A) consumer reformulation over `\bar k` via `IsAlgClosed.algebraMap_bijective_of_isIntegral` (~15 LOC, **GATED** on user input — reverses iter-127 over-k commitment); (B) CharZero collapse of (S3.sep.*) via `PerfectField.ofCharZero` + `Algebra.IsAlgebraic.isSeparable_of_perfectField` (~10–15 LOC each); (C) KDM (BR.5) joint-kernel via `MvPolynomial.mkDerivation` + `pderiv` monomial expansion (~60–80 LOC). Net M2.a critical-path closure under (A)+(B)+(C): ~120–170 LOC vs ~310–550 LOC for path (b) full. **~50–60% savings**. | Accepted in part: (B) and (C) commit to iter-150 prover dispatch (low-risk, ~90–95 LOC aggregate). (A) is GATED on user input — `[IsAlgClosed kbar]` on `rigidity_over_kbar`'s signature reverses the iter-127 over-k commitment, which is a strategy-level reversal warranting user sign-off. Surfaced via this sidecar for review-agent TO_USER. `analogies/h1cotangent-vanishing-iter150.md` carries the full analogue list including the 2 discarded candidates (Hopf-algebra augmentation-ideal; locally-constant-on-preconnected). |

## STRATEGY.md edits (this iter)

- Row 1 of `## Phases & estimations`: iters left 5–9 → **6–10** (strategy-critic absorption).
- Route C "Remaining" section: KDM bullet rewritten around HYBRID part (C); substep 3 bullet adds path (c) HYBRID. Path (a) BUILD and path (b) SMART PROOF retained as fallbacks.
- Route A section: trimmed; literature pointer to `references/fga-picard.md`.
- Over-$\bar k$ alternative: recast as decorative until LOC-bid lands.
- HYBRID alternative section added (lines ~125–155) consuming the analogist verdict; the 3 parts (A)/(B)/(C) catalogued, (A) flagged as user-gated.
- `## Open strategic questions` rewritten: replace generic "path (b) commitment" question with the specific user-input question on `[IsAlgClosed kbar]`.
- All 5 iter-NNN narrative leaks (lines 70, 107, 154, 166, 213 of prior STRATEGY.md) excised.
- `## Mathlib gaps & new material`: substep 3 entry rewritten with the corrected Stacks Tag numbers (035U, 030V, 0BUG, 02KH, 030K, 09HD, 00T7) verified against `references/stacks-*.md`.
- New LOC: 248 / 14.4 KB. Within 250-line bound. Byte budget slightly overshot but deliberate given the new HYBRID section's necessity.

## Decisions for iter-150 prover dispatch

**Two-lane HYBRID-trimmed prover dispatch.** Per progress-critic + analogist:

- **Lane 1** — `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`. Close
  (S3.sep.1) + (S3.sep.2) via the analogist's HYBRID part (B): `[CharZero k]`
  (already in iter-149 signatures) ⇒ `PerfectField.ofCharZero` ⇒
  `Algebra.IsAlgebraic.isSeparable_of_perfectField`. Leave (S3.pi.1)
  and (S3.pi.2) bodies as the existing structured `sorry` scaffolds —
  they are now deferred indefinitely (post-HYBRID) as upstream-Mathlib-PR
  work, NOT iter-150+ critical-path. ~30 LOC total.

- **Lane 2** — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`. Close
  KDM (BR.5) joint-kernel collapse via analogist's HYBRID part (C):
  `MvPolynomial.mkDerivation` + `pderiv` monomial-expansion + standard-
  smooth surjection transfer. Body refines the iter-149 (BR.2)–(BR.4)
  scaffold (which builds the basis + coordinate-derivation extraction).
  ~60–80 LOC. The hPI branch of `constants_integral_over_base_field`
  is NOT touched this iter (it consumes (S3.pi.*), which are deferred
  pending user input on the HYBRID part (A)).

**Aggregate scope**: ~90–110 LOC across 2 lanes. **Materially smaller**
than the iter-149 estimate of 330–680 LOC, by design: the HYBRID pivot's
50–60% savings absorb the prior over-scoping.

**Not dispatched this iter**: (S3.pi.1), (S3.pi.2), hPI branch closure
(all gated on user input on HYBRID part (A); see TO_USER surface
below).

## TO_USER surface (for review agent)

The user is asked to decide:

> **Should `rigidity_over_kbar`'s signature in
> `AlgebraicJacobian/RigidityKbar.lean` be amended to add
> `[IsAlgClosed kbar]`?**
>
> Context: the iter-127 over-k commitment (recorded in
> `RigidityKbar.tex` § "Iter-127 over-k commitment") chose `[Field kbar]`
> without algebraic closure to bypass fpqc descent of morphisms. The
> mathlib-analogist iter-150 consult identifies a HYBRID pivot whose
> part (A) — consumer reformulation over `\bar k` via
> `IsAlgClosed.algebraMap_bijective_of_isIntegral` — closes
> `constants_integral_over_base_field` in ~15 LOC under
> `[IsAlgClosed kbar]`, **descoping (S3.pi.1) and (S3.pi.2) entirely**
> from the M2.a critical path. The (S3.pi.1) sub-claim is the
> load-bearing ~150–250 LOC blocker (flat base change of Γ for proper
> schemes; Stacks Tag 02KH at H⁰; the Mathlib gap that has driven 4
> consecutive PARTIAL iters).
>
> Trade-off:
> - **Yes (add `[IsAlgClosed kbar]`)**: ~150–250 LOC saved on (S3.pi.1).
>   But the downstream consumer somewhere on the chain to
>   `nonempty_jacobianWitness` (probably `genusZeroWitness`) must
>   base-change to `\bar k`, costing the fpqc-descent-of-morphisms
>   infrastructure the iter-127 commitment originally dropped (~300–500
>   LOC per prior strategy estimates). Net: the LOC may shift, not
>   shrink — but the Mathlib gap is RING-side (`fpqc descent of
>   morphisms is a more concrete Mathlib gap than `flat base change of
>   Γ for proper schemes`) and may be more tractable.
> - **No (keep iter-127 over-k)**: project continues building (S3.pi.1)
>   in path (b) — ~150–250 LOC of scheme-cohomology Mathlib-PR-grade
>   work. The (S3.pi.2) sub-claim — `IsPurelyInseparable` from a
>   unique-min-prime hypothesis — also remains on the M2.a critical
>   path at ~50–100 LOC.
>
> The HYBRID parts (B) and (C) are LOW-RISK and committed to iter-150
> prover dispatch regardless of this decision.

The review agent picks this up from this sidecar and writes the
question to `TO_USER.md` for the user's next visit.

## Subagent skips

(none this iter; all 3 mandatory critics dispatched in Wave 1.)

## Fallback if no user response

If `USER_HINTS.md` is empty at iter-151 entry (no user response to
the `[IsAlgClosed kbar]` question), default to **NO** (keep iter-127
over-k commitment). Rationale: the iter-127 commitment was made after
the iter-126 mathlib-analogist consult (`analogies/cotangent-vanishing-pile-over-k.md`)
that verified the over-k path is feasible without descent; reverting
without strong evidence would discard that consult's work. Iter-151
prover lane under the fallback: continue (S3.pi.1) + (S3.pi.2) closure
via path (b), with the iter-150 progress-critic CHURNING signal
upgraded to STUCK if iter-151 lands 0 of 2 (S3.pi.*) closures.

## Decisions for iter-151

- Re-dispatch `blueprint-reviewer` to confirm HARD GATE clears
  post-render-fix.
- Re-dispatch `progress-critic` to confirm CHURNING → CONVERGING under
  HYBRID parts (B)+(C) closure.
- Re-dispatch `strategy-critic` to verify HYBRID absorption format is
  not DRIFTED.
- If user replies on `[IsAlgClosed kbar]` question: re-plan the M2.a
  critical-path closure schedule per the user's decision.
- If `ChartAlgebraS3.lean` (S3.sep.*) closures land iter-150: migrate
  the closed declarations to `task_done.md`.
- iter-151+ writer round: blueprint-writer-style citation backfill on
  RigidityKbar.tex / Jacobian.tex / Differentials.tex (one chapter per
  iter, write-domain widened to `references/**` for child
  reference-retriever dispatches if needed).

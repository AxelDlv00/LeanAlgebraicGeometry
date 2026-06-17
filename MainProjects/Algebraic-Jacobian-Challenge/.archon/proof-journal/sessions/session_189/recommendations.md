# Iter-189 Review — Recommendations for iter-190

## CRITICAL — Plan-phase actions iter-190

### Pin 2 corrective decision (Lane I — `RationalCurveIso.lean`)

Iter-189 prover surfaced a STRUCTURAL UNPROVABILITY DIAGNOSIS on
`Hom.poleDivisor_degree_eq_finrank`: the iter-187 body of
`Hom.poleDivisor φ` is a principal divisor (`Scheme.WeilDivisor.principal
(algebraMap _ _ (localParameterAtInfty kbar).val) halg`), so its degree
is 0 by `principal_degree_zero`; the RHS `Module.finrank K(P^1) K(C) > 0`
for any non-constant φ. **As stated, the theorem is false.**

Plan-phase iter-190 must pick a corrective:

- **(a)** Refactor `Hom.poleDivisor` body to be the positive part
  `(div(φ^* t_∞))_0 = φ^*[∞]`. Requires new project-bespoke
  `Scheme.WeilDivisor.positivePart` infrastructure (~50-100 LOC) — a
  standalone divisor-decomposition substrate, reusable across the RR.4
  branch.
- **(b)** Rename the theorem to operate on `positivePart
  (Hom.poleDivisor φ)`. Cheaper short-term but defers the substrate.

Either route requires coordinated edits to (i) `Hom.poleDivisor` body in
`RationalCurveIso.lean`, (ii) `Picard_LineBundlePullback`/`RR_RationalCurveIso`
blueprint pins (`lem:degree_via_pole_divisor`), and (iii) callers.
**This is the primary blocker for Lane I closure.** Without the decision,
Pin 2 stays sorry'd indefinitely. The iter-189 review already added a
`% NOTE (iter-189 review):` annotation to `RiemannRoch_RationalCurveIso.tex`
flagging the issue.

### Lane A.3.i ESCALATION TRIGGER (`IdentityComponent.lean`)

Per progress-critic `route189` CHURNING verdict + iter-188 HARD SCOPE
CAP escalation rule, the iter-189 prover dispatch was the **last chance
window**: with 0 axiom-clean closes against a target of ≥2, the route
transitions **STUCK iter-190 → structural refactor required**.

The 8 remaining sorries cannot be closed via further scaffolding within
the CHURNING-detection envelope; the planner must intervene with a
structural decision. Concrete options:

1. **Cross-domain-inspiration analogist consult** on
   group-scheme-identity-component substrate. Key questions:
   - Does Mathlib's `Subgroup.connectedComponentOfOne`
     (`Topology.Algebra.Group`) have a Scheme-valued analog?
   - Is there an `OpenSubScheme.GrpObj` pattern that automatically
     equips an open subscheme containing the identity with a `GrpObj`
     structure inherited from the ambient `GrpObj`?
2. **Unbundle baseChangeIso** into 3 separately-pinned typed sorries
   (parallel to Lane F unbundle strategy iter-189): GrpObj-on-G_K
   (closable axiom-clean via `Scheme.GrpObjAsOverPullback` + ~10-30
   LOC OverClass/asOver bridging); LFT-on-G_K (closable axiom-clean
   via `MorphismProperty.pullback_snd`); the substantive iso (Kleiman
   §5).
3. **Project-side substrate**:
   `Scheme.isConnected_pullback_of_isGeometricallyConnected` ~80-150
   LOC bridges identityComponent → isSubgroupHomomorphism →
   isFiniteTypeGeometricallyIrreducible. This is the EGA IV₂ 4.5.8 +
   4.5.14 gap, both confirmed absent from Mathlib b80f227.
4. **Decouple `Pic0Scheme` def body**: once
   `[LocallyOfFiniteType (PicScheme C).hom]` instance lands (post FGAPic
   representability iter-200+), `Pic0Scheme` body becomes
   `GroupScheme.IdentityComponent (PicScheme C)` (axiom-clean modulo
   transitive sorry). This unblocks `finrank_eq_genus` and
   `kPoints_iff_kerDegree` for direct work.

Recommend dispatching options (1) + (2) iter-190; defer (3) and (4) to
iter-191+ contingent on (1)'s verdict.

### Lane F unbundle continuation (`QuotScheme.lean`)

iter-189 landed the analogist-licensed unbundle (3 named pins, residual
is PURE compositional bookkeeping). iter-190 prover should target the
EASIEST pin per the analogist verdict: **`pullback_of_openImmersion_iso_restrict`**
(~30-50 LOC). With Step 3 closed, the `_sectionLinearEquiv` body residual
reduces to Steps 1+2 + compositional glue.

iter-190 plan-phase: add 2 new chapter pins to `Picard_QuotScheme.tex`
(`def:tildeIso_of_isQuasicoherent_isAffineOpen` +
`def:pullback_of_openImmersion_iso_restrict`).

### Mathlib-gap chapter pin (Lane G2 — `AuslanderBuchsbaum.lean`)

iter-189 prover narrowed the substrate to `isDomain_of_regularLocal`
(pure Stacks 00NQ; Mathlib gap confirmed). iter-190 plan-phase should
add the corresponding pin to `Albanese_AuslanderBuchsbaum.tex`:

```latex
\begin{lemma}[Regular local rings are integral domains]
  \label{lem:isDomain_of_regularLocal}
  \lean{RingTheory.CohenMacaulay.isDomain_of_regularLocal}
  \textit{Source: [Stacks Project], tag 00NQ (lemma-regular-ring-CM).}
  Let $(R, \mathfrak{m})$ be a regular Noetherian local ring. Then $R$
  is an integral domain.
\end{lemma}
```

(Do NOT add `\leanok` — body is typed sorry; only the `\lean{...}` pin
so blueprint cross-reference resolves.)

Iter-190+ prover dispatch on `isDomain_of_regularLocal` requires one of:
(a) project-side ~300 LOC via Krull PIT (Mathlib ✓) + Krull intersection
(Mathlib ✓ via `Mathlib.RingTheory.AdicCompletion.Noetherian.IsHausdorff
(maximalIdeal R)`) + prime avoidance (Mathlib ✓) + minimal primes finite
(Mathlib ✓); (b) Mathlib upstream PR ~50-100 LOC; (c) Koszul-homology
bypass via depth/Koszul complex API. **Recommend (a)** as the highest-
leverage option (closes the substrate without depending on upstream
PR latency).

## HIGH — Closest-to-completion targets iter-190

### Lane B — Substrate 2 (`Cross01Substrate.lean`)

Now that Substrate 1 (`IsClosedImmersion.lift_iff_range_subset`) is
axiom-clean, dispatch the iter-190 prover on Substrate 2:
`gmRing_tensor_homogeneousAway_isDomain` (~50-80 LOC per
`analogies/lane-b-substrate.md` §2 — localization-polynomial iso chain).
The blueprint chapter `Genus0BaseObjects_Cross01Substrate.tex` already
pins both substrates; chapter is complete-vs-itself.

iter-191-193 consumer closures in `GmScaling.lean`:
`gmScalingP1_chart_agreement_cross01` cocycle body + `gm_geomIrred` +
`projGm_isReduced` (~65-105 LOC total).

### Lane I — Pin 3 Step 2 (`RationalCurveIso.lean`)

Iter-189 closed Step 1 axiom-clean inline; Step 2 (scheme-level lift)
remains as a single typed sorry with 4-sub-obligation continuation doc.
~80-150 LOC per `analogies/ratcurveiso-pin3.md`. Lane I is CONVERGING
per progress-critic verdict; if Pin 2 corrective is also picked iter-190,
Lane I can close fully iter-191-192.

Mathlib-analogist consults blocked on:
- "smooth proper dim-1 morphism + non-constant ⟹ finite" (Step 2 (a)).
- "`fromNormalization` is iso when target is normal and degree = 1"
  (Step 2 (c)).

### Lane A — OCofP downstream sorries

3 remaining sorries (L1154/L1191/L1249: `h1_vanishing_genusZero` /
`dim_eq_two_of_genusZero` / `exists_nonconstant_genusZero`) all gated
on the **RR.2.H¹ skyscraper-flasque vanishing sub-phase** (per iter-188
STRATEGY revision). iter-190 plan-phase should:

1. Dispatch `blueprint-writer` for `RiemannRoch_H1Vanishing.tex` chapter
   (per iter-189 blueprint-reviewer's unstarted-phase proposal). This
   also closes blueprint-doctor's `\cref{chap:RR_H1Vanishing}` broken
   reference (see "Blueprint hygiene" below).
2. Defer prover dispatch on RR.2.H¹ until iter-191 (per HARD GATE rule
   — new chapter needs blueprint-reviewer re-confirmation).

## MEDIUM — Blueprint hygiene

### Blueprint-doctor finding (iter-189)

Broken cross-reference flagged: `\cref{chap:RR_H1Vanishing}` in
`RiemannRoch_RRFormula.tex` — no matching `\label`. The RR.2.H¹
chapter is unstarted. Fix one of two ways iter-190:

- **(preferred)** Land the H1Vanishing chapter via blueprint-writer
  (also serves Lane A downstream + RR.2 phase).
- **(deferral)** Temporarily comment out the broken `\cref{...}` in
  RRFormula.tex with a `% NOTE: pending H1Vanishing chapter` marker.

### iter-189 blueprint-reviewer follow-ups

3 unstarted-phase blueprint chapters proposed and awaiting writer
dispatch iter-190 (per `task_results/blueprint-reviewer-iter189.md`):

1. **`Picard_Pic0AbelianVariety.tex`** — covers A.3.ii (`Pic⁰_{C/k}`
   def) through A.3.vi (geom-irreducibility). New chapter, ~150-400
   LOC blueprint per sub-phase × 5 sub-phases.
2. **`RiemannRoch_H1Vanishing.tex`** — covers RR.2.H¹ skyscraper-flasque
   vanishing. New chapter ~200-400 LOC blueprint.
3. **`Albanese_AlbaneseUP.tex`** — REWRITE per iter-188 strategy
   decision (Sym^g symmetric-power UP → divisor-map Albanese UP). The
   chapter exists but its content must be replaced.

Stale prose flag (minor): `AbelianVarietyRigidity.tex` proof blocks for
`lem:rigidity_eqOn_dense_open` chain contain "single genuinely-deep
residual sorry" wording that is stale (declarations closed axiom-clean
iter-162). Plan-agent task for iter-190 prose refresh; not blocking
any prover lane.

## LOW — Project bookkeeping

- iter-189 plan-phase **re-invocation** correctly landed Cross01Substrate
  chapter for the new prover-target file — HARD GATE complied retroactively.
  The pattern was: dispatch plan agent, agent dispatches all subagents but
  exits without signalling done; loop re-invokes; agent self-audits, finds
  one outstanding gate violation, lands the new chapter. This is a healthy
  recovery — the gate violation was caught before the prover phase started.
  No process change needed; document the pattern in the knowledge base.
- Strategy-critic + blueprint-writer for AlbaneseUP rewrite were **KILLED
  during iter-189 plan-phase** to bound budget (already 8 subagents in
  flight, semaphore was at `loop.max_parallel`). Both deferred to
  iter-190 plan-phase. iter-190 should re-dispatch with the same slugs
  on fresh invocations.

## Blocked targets — do NOT re-assign without structural change

- **`Hom.poleDivisor_degree_eq_finrank`** (Lane I Pin 2): blocked on
  Pin 2 corrective decision (a)/(b) above. Do NOT retry without the
  refactor.
- **`isSubgroupHomomorphism`** (Lane A.3.i): blocked on EGA IV₂ 4.5.8
  Mathlib gap. Do NOT retry inside HARD SCOPE CAP — needs option (1)
  cross-domain analogist consult or option (3) project-side substrate
  (~80-150 LOC).
- **`Pic0Scheme.finrank_eq_genus`** + **`Pic0Scheme.kPoints_iff_kerDegree`**
  (Lane A.3.i): cascading sorries; gated on PicScheme.lean body work
  iter-200+. Do NOT prover-dispatch.
- **`isDomain_of_regularLocal`** (Lane G2): blocked on Mathlib gap
  Stacks 00NQ. Do NOT retry "direct close"; only options (a)/(b)/(c)
  above advance.

## Reusable proof patterns discovered iter-189

- **Direct irreducibility-based sheaf gluing** for ModuleCat-valued
  carrier presheaves (OCofP Case B): bypass `Subfunctor.isSheaf_iff`
  when the carrier is ModuleCat (not Type) — direct argument via
  `nonempty_preirreducible_inter` (`@`-form to bridge `↥X` vs `↑X.toTopCat`
  instance friction) + value-uniformity helper extracted via
  `congr_arg Subtype.val` on compatibility hypothesis is cleaner.
- **Inline ring-kernel-radicality from reduced codomain** (Lane B
  Substrate 1): 5-LOC `have ker_isRadical` via `obtain ⟨n, hxn⟩` →
  `map_pow` → `eq_zero_of_pow_eq_zero` — no need to invoke the surjective
  variant `RingHom.ker_isRadical_iff_reduced_of_surjective` for the easy
  direction.
- **`letI`-driven Γ-module structure on pullback sections** (Lane F):
  `letI : Algebra Γ(Y, U) Γ((Spec Γ(Y, U)), ⊤) := (Scheme.ΓSpecIso _).inv.hom.toAlgebra`
  + `letI : Module Γ(Y, U) ... := Module.compHom _ (Scheme.ΓSpecIso _).inv.hom`
  installs the typeclass infrastructure for section-level LinearEquiv
  signatures involving `(pullback hU.fromSpec).obj N` at `⊤`.
- **`Subalgebra.bot_eq_top_of_finrank_eq_one`** (Lane I Step 1): one-line
  bridge from `Module.finrank = 1` to `⊥ = ⊤` in the algebra-subalgebra
  lattice, enabling `Algebra.surjective_algebraMap_iff` directly.
- **Closed-immersion ⇒ QuasiCompact** auto-instance chain (Lane B): no
  need to assume `[QuasiCompact i]` on a `[IsClosedImmersion i]` argument
  — `IsClosedImmersion → IsAffineHom → QuasiCompact` low-prio instances
  fire.
- **Stacks 00NU regularity-propagation via iter-188 G1 cotangent
  dim-drop bridge** (Lane G2): closing the regular-quotient half of
  joint induction without Mathlib's `Stacks 00NU` directly — chain
  `finrank_cotangentSpace_quot_span_singleton_succ` +
  `IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace` +
  `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim` +
  `IsRegularLocalRing.of_spanFinrank_maximalIdeal_le`. Conditional on
  `[IsSMulRegular R x]`, which is itself fed by Stacks 00NQ (the lone
  remaining substrate sorry).
- **Subagent-licensed structural unbundle** (Lane F): when an analogist
  returns "Structural OK with corrective: separate the bundled gaps into
  named pins", landing 2+ named typed sorries that explicitly enumerate
  the Mathlib gaps in independent declarations is preferable to
  attempting full closure in one session — even though file sorry count
  increases (+1 or +2 net). The independent-targeting payoff iter-190+
  is real.

## Off-limits routes (unchanged from iter-188)

- **Lane J** `RiemannRoch/OcOfD.lean` — structurally blocked
  (`sheafOf := if D = 0 then ... else sorry` propagates sorry
  through every closure tactic that unfolds sheafOf). DO NOT RETRY
  without `Decidable (D = 0)` (computational, doesn't exist) or
  off-target ~100-200 LOC Hartshorne II.6 body work.
- **Lane M↓** `Albanese/CodimOneExtension.lean` — DECLARED
  complete-except-upstream-gap (`isRegularLocalRing_stalk_of_smooth`
  permanent Mathlib b80f227 gap, Option (c) committed iter-188). DO
  NOT dispatch provers.

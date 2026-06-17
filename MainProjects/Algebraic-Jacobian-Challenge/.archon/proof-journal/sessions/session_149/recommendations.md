# Recommendations for the next plan iteration (iter-150)

## CRITICAL — iter-150 escalation hook FIRES

Per the iter-149 plan agent's Decision 3 escalation hook:

> If iter-149 lane closes ≤1 of the four (S3.\*) sub-claims AND
> the KDM (p2) bridge body remains a structured `sorry`, iter-150
> MUST escalate via mid-iter mathlib-analogist in
> `cross-domain-inspiration` mode for the H1Cotangent-vanishing
> reformulation. The route-pivot conversation becomes mandatory.

**Trigger conditions met**: iter-149 closed 0 of 4 (S3.\*) bodies
(all four are PARTIAL scaffolding); KDM (p2) bridge body L194 is
still a structured `sorry` (BR.5 joint-kernel collapse).

**Iter-150 plan agent action items** (must, not should):

1. **Dispatch `mathlib-analogist` in `cross-domain-inspiration`
   mode** with the H1Cotangent-vanishing alternative as the
   structural problem. The hSep branch of substep 3 is now closed
   in-tree (modulo Lane 1 (S3.sep.\*) bodies); only the hPI branch
   and KDM (BR.5) remain as iter-150 entry points on path (b).
   The H1Cotangent-vanishing alternative would replace the hPI
   strand entirely with `Subsingleton (Algebra.H1Cotangent A B)`
   in `rigidity_over_kbar`'s body.
2. **Route-pivot conversation is mandatory**: the iter-150 plan
   phase MUST explicitly commit to either continuing path (b) (now
   with concrete decomposed sub-claims) or pivoting to H1Cotangent
   vanishing. Silently scheduling another path (b) prover round
   without the cross-domain consult is a missed escalation that
   the next iter's progress-critic will flag.

If the cross-domain consult returns "stay on path (b)", a
prover round on the tractable closers ((S3.sep.2) + (S3.pi.2);
each ~50–80 LOC) is the lowest-risk closure-target for
iter-150.

## HIGH PRIORITY (priority-ordered)

### Path (b) closer-targets (tractable iter-150 prover candidates)

1. **(S3.sep.2)** `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`
   (`ChartAlgebraS3.lean:199`). Mathlib bridges identified:
   `Field.finSepDegree_eq_finrank_iff`,
   `IsArtinianRing.isSemisimpleRing_of_isReduced`,
   `IsArtinianRing.isField_of_isReduced_of_isLocalRing`,
   `Module.Finite.base_change`. **~30–50 LOC chase** via the
   Artinian-product decomposition. Stacks Tag **0BJF**.

2. **(S3.pi.2)** `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`
   (`ChartAlgebraS3.lean:269`). Mathlib bridge:
   `isPurelyInseparable_of_finSepDegree_eq_one`,
   `IsArtinianRing.isPrime_iff_isMaximal`, `Module.Finite.base_change`,
   `Field.Emb.cardinal_eq`. **~50–100 LOC chase** via the
   embedding-count bijection. Stacks Tag **05DH**.

Closing either (S3.sep.2) or (S3.pi.2) clears the easier sub-side
of path (b) and lets the iter-150 review confirm the hSep branch
closure end-to-end (since Lane 1 sorries propagate up through the
hSep branch).

### KDM (BR.5) joint-kernel collapse

`ChartAlgebra.lean:194` — joint-kernel collapse of coordinate
derivations on the standard-smooth presentation
`B ≅ k[x_1, …, x_n, y_1, …, y_m] / (f_1, …, f_m)` with invertible
Jacobian. **Suggested target name**:
`KaehlerDifferential.coordinateDeriv_jointKernel_collapse_of_charZero`.
~40–80 LOC. Stacks Tag **07F4**.

This is the load-bearing residual of the (p2) char-0 KDM path. The
iter-149 (BR.2)–(BR.4) scaffolding lands the basis + coordinate
derivation extraction; the (BR.5) gap is a genuine project lemma
(Mathlib's `Differential.ContainConstants` covers the
single-derivation case but not the joint-kernel collapse).

## MEDIUM PRIORITY

### (S3.sep.1) closure — depends on Mathlib bridge OR short-circuit

`ChartAlgebraS3.lean:124` — `Smooth ⇒ GeometricallyReduced` scheme
morphism class bridge is a Mathlib b80f227 gap. Two iter-150+
paths:

- **Path A**: build the morphism-class bridge in-tree
  (~80–150 LOC). Mathlib-PR-grade.
- **Path B**: short-circuit by proving
  `Algebra.IsGeometricallyReduced k Γ` directly via the
  (S3.pi.1)-produced `Γ ⊗_k K ≅ Γ(X_K)` chain. Saves the
  morphism-class infrastructure but pre-requires (S3.pi.1).

Recommend Path B if (S3.pi.1) lands first (or in parallel); Path A
otherwise.

### (S3.pi.1) deep closure

`ChartAlgebraS3.lean:227` — Stacks 02KH H^0 = Γ row. **~150–250
LOC** Čech-equaliser + flat-tensor exchange chase. Iter-149 plan
agent's Decision 2 names the H1Cotangent-vanishing reformulation
as the escape route if (S3.pi.1) proves too expensive.

### hPI branch closure (iter-151+ if H1Cotangent pivot doesn't fire)

`ChartAlgebra.lean:423` — depends on (S3.pi.1) + (S3.pi.2) +
the `Smooth ⇒ IsReduced X_{\\bar k}` base-change-stability bridge.
The iter-149 hSep precedent's `FiniteDimensional k Γ` bridge is
directly reusable.

## LOW PRIORITY / informational

### Lane 2 hSep branch is project-internally CLOSED

After iter-149, `ChartAlgebra.lean:425` (the hSep branch) is
sorry-free in `ChartAlgebra.lean` itself — the residual sorries
propagate from `ChartAlgebraS3.lean`'s (S3.sep.1) and (S3.sep.2)
bodies. Once Lane 1's (S3.sep.\*) bodies close, the hSep branch
inherits the closure automatically.

### Path (b) versus H1Cotangent vanishing

Per iter-149 plan Decision 2 + the open strategic question added
to `STRATEGY.md` (line 217 region):

> Alternative reformulation — H1Cotangent vanishing instead of `Γ ≅ k`

This is the strategic-question backstop. The iter-149 plan agent
deferred the investigation to iter-150 strategy-critic dispatch.
With the escalation hook now firing, iter-150 plan agent should
attend to this question with the `mathlib-analogist`
cross-domain consult result.

## Blocked / do-not-retry

### KDM (p2) char-0 path on the OLD signature `[Field k] [CommRing B] [Algebra k B] [Algebra.FiniteType k B]`

The signature was retroactively rejected as the "honest-wrong-signature" anti-pattern (iter-148
review documented). Iter-149 closed this retirement: KDM now ships
with `[CharZero k]` + `[Algebra.IsStandardSmoothOfRelativeDimension n k B]`.
**Do NOT retry** any attempt to prove the original FiniteType-only
form; the counter-example `B = k[X], b = X^p` (char p) makes it
literally false.

### Mathlib b80f227 `Smooth ⇒ IsGeometricallyReduced` (scheme morphism class) and `Smooth ⇒ IsReduced` for general base field

Both confirmed absent via iter-148 + iter-149 prover lane full
greps. **Do NOT re-dispatch `mathlib-analogist` on these specific
questions** — the gaps are well-characterised. Either an in-tree
wrapper or a Mathlib PR is required.

### Direct retrying of the path (b) consolidated sorry without first-class decomposition

The iter-149 first-class (S3.\*) decomposition is now the canonical
shape. Do NOT collapse back to a single conjunction sorry — the
named decomposition is the structural advance the iter-148/149
reviews and the iter-149 progress-critic asked for.

## Proof patterns added to PROJECT_STATUS.md Knowledge Base

- **FiniteDimensional bridge via `Iso.commRingCatIsoToRingEquiv` +
  `RingEquiv.finite` + `RingHom.Finite.comp` + `RingHom.finite_algebraMap`**
  for "appTop.hom finite ⇒ Γ finite-dim over k" propagation.
- **First-class sub-claim decomposition strategy unit** (one
  consolidated sorry → multiple first-class named sub-claims with
  documented Mathlib bridges) as a planner-deliberate sorry-count
  trade-off.
- **`Algebra.IsStandardSmoothOfRelativeDimension n k B` is a `Prop`,
  not registered as an instance**; must dispatch through the named
  theorem `.isStandardSmooth n` to extract `Algebra.IsStandardSmooth k B`.

(See PROJECT_STATUS.md Knowledge Base updates.)

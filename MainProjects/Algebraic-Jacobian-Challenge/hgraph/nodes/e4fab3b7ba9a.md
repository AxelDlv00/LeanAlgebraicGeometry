---
author: sync
content_type: instance
created: '2026-07-28T05:48:19'
decl: anyone
file: scripts/axiom-frontier.lean
generated: lean
lean_status: sorry
title: anyone
type: lean
updated: '2026-07-28T14:28:37'
---
instance anyone would use, `¬H`. The theorem is true, axiom-clean, non-vacuous by every probe
in this file, and empty.

Measured instance (2026-07-28, `RiemannRoch/Adelic/LedgerClosure.lean`): `chi_eq_of_bump`
takes `hbump : ∀ P E, χ(1·P + E) = χ(E) + residueDeg P`. Iterating it down the anti-effective
cone forces `χ(-m·P) = χ(0) - m·[κ(P):k]`, and since `χ = ℓ - h¹` with `ℓ ≥ 0`, `h¹` must grow
linearly there. So `hbump` is FALSE on every cover whose `h¹` is bounded — and outright false
at the degenerate cover `U₀ = U₁ = ⊤`, where the Čech `H¹` vanishes identically, as soon as a
single prime divisor exists. That refutation needs no exactness data at all.

THE OFF-CHART REFUTATION, and the two-step history of this paragraph is the most instructive
part of the entry, because the trap caught the audit and then caught the retraction.

Round 1 (the audit, `I-0449`): a second refutation "at each prime outside the overlap", on the
grounds that `A(1·P + E) = A(E)` there makes the local step a subsingleton, so
`ChiLedger.chi_add` gives a χ-jump of `0` against `hbump`'s `residueDeg P ≥ 1`.

Round 2 (my retraction, and it was WRONG): I withdrew that on the grounds that the derivation
runs through `chi_add`, so it measures `chi_add`'s exactness hypotheses rather than `hbump` —
citing `Adelic.bump_iff_chartStep_of_notMem_left`, which makes `hbump` at such a `P` equivalent
to the surviving one-chart step being `[κ(P):k]`, and concluding `hbump` is merely weaker there
rather than false.

Round 3 (`I-0467`, machine-checked, and it reinstates round 1): the one-chart step cannot be
`[κ(P):k]` repeatedly, because the overlap term `A` is FROZEN along the tower `n·P`
(`sectionSub_add_pointDivisor_of_notMem`, iterated) and the coboundary term is trapped beneath
it (`S₁(D) ≤ A(D)`). So in `χ = dim S₀ + dim S₁ − dim A` all three terms are bounded along the
tower while `hbump` forces linear growth. Hence `¬hbump` off the chart, from this file's own
theorems and its own finiteness binders, with **no** `chi_add` and no exactness hypothesis
anywhere. The equivalence I cited is true and does not say what I used it for: its right-hand
side is itself false for large `n`. `Adelic.not_bump_of_notMem_left` and
`Adelic.ledger_refuted_of_notMem_left` are the landed forms (§6f), and `P.point ∉ U₀` is far
weaker than `P.point ∉ U₀ ⊓ U₁`, so the refutation reaches MORE primes than the audit claimed.

Honest status of `hbump`: consistent (`bump_of_isEmpty_primeDivisor`); refutable at
`U₀ = U₁ = ⊤` given one prime divisor; refutable on every bounded-`h¹` cover; refutable
whenever any prime divisor lies off one chart; satisfiable only where `h¹` is unbounded on the
anti-effective cone. The closed ledger itself is refuted on the same covers. None of that
contradicts the vanishing lane, whose results are high-degree only — which is why nobody
noticed.

The generalisable lesson, and note that it cuts BOTH ways, which is what round 2 missed. When a
hypothesis `H` and a lemma `L` are inconsistent together, that does not tell you which is at
fault: establishing that `H` is refutable requires deriving `¬H` from things THEMSELVES
satisfiable. That is why round 1's argument was not yet conclusive. But it equally does not
license concluding `H` is *fine* — round 2 inferred "not refutable" from "not refutable by this
route", which is the same error with the sign flipped, and an ungated derivation existed the
whole time. The correct response to "your refutation measured the wrong thing" is to look for an
ungated derivation, not to withdraw the conclusion. Recorded as I-0449/I-0454/I-0467, with the
durable lessons at I-0451 and I-0468.

What defeats each check, in order: `#print axioms` sees a clean line; a consistency witness
exists (`bump_of_isEmpty_primeDivisor`, on a scheme with no prime divisors); an elaboration
probe synthesises every binder; and non-vacuity in the trap-(c) sense holds, because the
hypothesis is not contradictory — it is merely refutable where it is wanted. The only check
that finds it is reading the PRODUCER's side conditions and asking whether the family the
hypothesis quantifies over contains members where the tree proves the negation.

So the discipline this adds to the other six: for a hypothesis quantified over a family, do
not stop at "is it satisfiable". Ask where the project can derive its negation. Recorded as
I-0449/I-0454 with the machine-checked steps, and as the durable lesson I-0451.

§2c The EIGHTH, found in the same audit and cheaper to check than any of the others: a
hypothesis EQUIVALENT to the conclusion it is supposed to buy.

`chi_eq_of_bump` proves `hbump → closed χ-ledger`. The converse is three lines —
`rw [hledger (pointDivisor P + E), hledger E, degK_add, degK_pointDivisor]; ring` — because
`degK` is an `AddMonoidHom` and the bump adds exactly one point. A theorem `A → B` whose
converse is trivial transports no information: it is a restatement, and "is `A` satisfiable"
is literally the question "is `B` satisfiable". The theorem is true, axiom-clean,
instantiable, non-vacuous, and not a reduction.

This is the re-indexing failure mode one level out, and it is the one to check FIRST, because
it costs a single `rw` attempt: before believing that `H → C` reduces `C` to `H`, try to prove
`C → H`. If that succeeds, no amount of axiom-probing will tell you the result is empty.
Lesson recorded as I-0456.

§6b Cluster-P extensions (task ajc-rr).  Independent re-verification, in the
rooted environment, of the axiom claims made in I-0383 and I-0403.

CAUTION, and this is the section to read before quoting any line below as a
completeness claim: several of these are axiom-clean and still NOT unconditional
mathematics, because they take the closed χ-ledger and/or a peel-surjectivity
datum as *named hypotheses* — invisible to `#print axioms`.  What each one is
open in, as of 2026-07-27:

| declaration                          | open named hypotheses                    |
|--------------------------------------|------------------------------------------|
| `chi_eq_of_linearEquivalence`        | none (unconditional)                     |
| `degK`                               | none (a definition)                      |
| `degK_principal_eq_zero`             | none (unconditional)                     |
| `ell_eq_zero_of_degK_neg`            | closed χ-ledger                          |
| `chi_divisorOfList_eq_degK`          | closed χ-ledger                          |
| `coneVanishing_iff_base_and_peel`    | none (unconditional; an equivalence)     |
| `exists_bound_subsingleton_h1Mod`    | base vanishing at one divisor + peel     |
| `exists_bound_subsingleton_h1Mod_of_pointPeel` | base vanishing + point-peel    |
| `exists_bound_h1dim_eq_zero`         | the above, plus the closed χ-ledger      |

The honest one-line summary of the vanishing lane, in ajc-rr's own sharpened
words: single-field bounded `H¹` vanishing is assembled and kernel-checked, and
its hypothesis pair (base vanishing at one divisor plus peel-surjectivity) is
*equivalent* to vanishing on the whole cone `{D' ≥ D₀}` — that equivalence is
proved (`coneVanishing_iff_base_and_peel`).  So the content is "pointwise cone
vanishing plus closed ledger ⟹ numerical-degree vanishing", a real reduction,
since a divisor of large weighted degree need not dominate `D₀`.  It is NOT "one
vanishing implies all vanishing".  Extension-uniformity and global generation are
proved nowhere in AJC, and extension-uniformity is not currently even statable:
the invariants are pinned to a chosen 2-affine cover and `CurveBaseChange.lean`
does not transport it.

One further caveat that no axiom line shows.  "`Subsingleton` rather than
`h¹ = 0`, so no finiteness instance is needed" holds only for the
vanishing-criterion and peel machinery.  Any theorem taking the closed χ-ledger
carries finiteness content with no `Module.Finite` binder visible, because
`Module.finrank` of an infinite-dimensional space is `0`. -/
#print axioms AlgebraicGeometry.Adelic.chi_eq_of_linearEquivalence
#print axioms AlgebraicGeometry.Adelic.degK
#print axioms AlgebraicGeometry.Adelic.degK_principal_eq_zero
#print axioms AlgebraicGeometry.Adelic.ell_eq_zero_of_degK_neg
#print axioms AlgebraicGeometry.Adelic.exists_bound_h1dim_eq_zero
#print axioms AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod
#print axioms AlgebraicGeometry.Adelic.coneVanishing_iff_base_and_peel
#print axioms AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod_of_pointPeel
#print axioms AlgebraicGeometry.Adelic.chi_divisorOfList_eq_degK

/-! §6d The global-generation and ledger-closure lane (task ajc-rr, requested in I-0410).

Same caution as §6b, and ajc-rr asked for it to be kept: everything in the generation
lane takes the closed χ-ledger `hledger` as an explicit hypothesis, so a clean axiom line
on `exists_bound_generatedAt` says nothing about the ledger being available.  Measured
open named hypotheses, read off the signatures rather than asserted:

| declaration                                    | open named hypotheses                   |
|------------------------------------------------|-----------------------------------------|
| `evalMap_injective`                            | none (unconditional)                    |
| `mem_orderGe_one_iff_mem_maximalIdeal`         | none (unconditional)                    |
| `residueDeg_eq_one_iff_hasRationalResidues`    | none (unconditional; an equivalence)    |
| `hasRationalResidues_of_isAlgClosed`           | no *named* hypothesis, but three
                                                   un-instantiable instance binders —
                                                   see §6e, this is trap (d)              |
| `residueDeg_eq_one_of_hasRationalResidues`     | rational residues at every point        |
| `degK_eq_degree_of_hasRationalResidues`        | rational residues at every point        |
| `ell_sub_ell_sub_pointDivisor_eq`              | ledger + vanishing at `D` and `D − P`   |
| `evalMap_surjective`                           | ledger + the same two vanishings        |
| `generatedAt_of_evalMap_surjective`            | surjectivity of `evalMap` itself        |
| `generatedAt_of_vanishing`                     | ledger + the same two vanishings        |
| `exists_bound_generatedAt`                     | ledger + base vanishing + peel          |
| `exists_bound_forall_generatedAt`              | the above, plus a uniform residue bound |
| `exists_bound_forall_generatedAt_of_hasRationalResidues` | ledger + base vanishing + peel |
| `degree_principal_eq_zero_of_hasRationalResidues` | ledger + rational residues          |
| `chi_eq_of_bump_of_nonneg`                     | the one-point bump                      |
| `chi_eq_iff_step_of_bump`                      | the one-point bump (an equivalence)     |

§6e The fourth trap, and why the apparent exception in the table above is not one.

`hasRationalResidues_of_isAlgClosed` looks like the one unconditional statement of the
lane: no ledger, no vanishing, no bump, and it measures clean.  It is not, and the reason
is a way of overstating a result that the other three traps do not cover.

Its obligations are in *instance* position, not in named-hypothesis position:
`[Algebra k (X.presheaf.stalk P.point)]`,
`[IsScalarTower k (X.presheaf.stalk P.point) X.functionField]` and
`[Module.Finite k (IsLocalRing.ResidueField (X.presheaf.stalk P.point))]`.  Nothing in
this project constructs any of the last two for the ambient object the Adelic lane runs
on — a bare `Scheme X` — and the first exists only for `Over (Spec k)` objects.  The
`Module.Finite` binder is on the stalk residue field, which the lane has no identification
with its own `localStepTgt` keystone, so it is a new obligation rather than a reused one.

So the fourth trap, in the same form as the other three:

  (d) a theorem whose INSTANCE BINDERS are never instantiable for the object actually
      used reports `[propext, Classical.choice, Quot.sound]` and always will, because the
      binders are hypotheses.  The axiom output cannot see this at all; the check is
      whether each binder has a constructing instance for the ambient object.

The statement is still a real reduction — `[κ(P) : k] = 1` is traded for standard stalk
commutative algebra — but it is a relocation of the obligation, not a discharge, and the
two `_of_hasRationalResidues` results are therefore not unconditional over an
algebraically closed field either.

RESOLVED, and the resolution is what makes trap (d) worth stating rather than merely
embarrassing.  `RiemannRoch/Adelic/ResidueField.lean` supplies the `_curve` forms below,
which take no stalk binders at all: only the curve's own geometric instances, with the
stalk algebra and tower *built* (`algebraMap_stalk_functionField`,
`isScalarTower_stalk_functionField`) and the residue-field finiteness routed around
entirely through mathlib's `residueFieldIsoBase`, which gets integrality of `κ(x)` over `k`
from `LocallyOfFiniteType` by the Jacobson-space criterion.  So the same mathematics that
was a relocation in the `_of_hasRationalResidues` form is a discharge in the `_curve` form,
and the difference is invisible to `#print axioms`: both report clean.  That is trap (d)
stated positively — the axiom line was never the thing that distinguished them.

`degK_eq_degree_of_isAlgClosed_curve` is the one to look at: geometric degree equals the
residue-weighted degree on an AJC curve over an algebraically closed field, with no open
input at all.  `degree_principal_eq_zero_of_isAlgClosed_curve` then rests on the closed
ledger alone, where its `_of_hasRationalResidues` predecessor needed the ledger *and* the
approximation statement.

ONE QUALIFICATION, established by elaborating a consumer rather than by reading signatures,
because that is the discipline trap (d) demands.  These take an `Adelic.IsConstantField k
C.left` binder whose producer (`Scheme.instIsConstantField`, `Adelic/GateInstances.lean`) is
a `scoped` instance.  A consumer must therefore `open scoped AlgebraicGeometry.Scheme`; a
`degK_eq_degree_of_isAlgClosed_curve` applied without it fails to synthesize, and the
failure looks exactly like trap (d) even though the instance exists.  Instantiability is
`open`-sensitive, which is a fifth thing no axiom line shows and the reason to test the
consumer instead of the signature. -/
#print axioms AlgebraicGeometry.Adelic.evalMap_injective
#print axioms AlgebraicGeometry.Adelic.mem_orderGe_one_iff_mem_maximalIdeal
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_iff_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.hasRationalResidues_of_isAlgClosed
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.degK_eq_degree_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.ell_sub_ell_sub_pointDivisor_eq
#print axioms AlgebraicGeometry.Adelic.evalMap_surjective
#print axioms AlgebraicGeometry.Adelic.generatedAt_of_evalMap_surjective
#print axioms AlgebraicGeometry.Adelic.generatedAt_of_vanishing
#print axioms AlgebraicGeometry.Adelic.exists_bound_generatedAt
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.degree_principal_eq_zero_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.chi_eq_of_bump_of_nonneg
#print axioms AlgebraicGeometry.Adelic.chi_eq_iff_step_of_bump

-- The `_curve` forms of §6e: same clean axiom lines as their `_of_hasRationalResidues`
-- predecessors, and unlike them, instantiable at the curve's own hypotheses.
#print axioms AlgebraicGeometry.Adelic.algebraMap_stalk_functionField
#print axioms AlgebraicGeometry.Adelic.isScalarTower_stalk_functionField
#print axioms AlgebraicGeometry.Adelic.hasRationalResidues_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.degK_eq_degree_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.degree_principal_eq_zero_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt_of_isAlgClosed_curve

/-! §6f The unconditional-χ lane, measured THROUGH THE ROOT PATH (requested by ajc-rr in
I-0463).

ajc-rr measured twelve declarations in their own session and reported zero `sorryAx`, but
flagged the measurement themselves: they probed through a scratch file that imported
`AlgebraicJacobian` *plus* the two new modules directly, because at that moment
`ChiUnconditional` and `UniformChartVanishing` were committed and **not** in the root
roll-up. The two imports have since landed (`AlgebraicJacobian.lean`), so the lines below
are measured on the root path — the measurement that may be quoted. All clean, agreeing with
theirs.

Ten of the twelve, not twelve: `degK_principal_eq_zero_of_chartCounts` and
`chartCountsDegree_iff_ledger` no longer exist. ajc-rr deleted them (audit `I-0467`) on their
own initiative, for two reasons worth recording because both are the reasons a probe line
would have been misleading. The predicate was `Iff.rfl` to the closed ledger and
`SectionBounds.degK_principal_eq_zero` already took that hypothesis verbatim, so the theorem
was the old one with a renamed binder; and it was *vacuous on the covers the module is about*,
since the ledger is outright FALSE whenever a prime divisor lies off one chart. Two clean
axiom lines would have sat on a duplicate of a vacuous statement — which is trap (c) and trap
(h) at once, and no axiom output distinguishes either. `ledger_refuted_of_notMem_left` below
is what replaced them, and it is a constraint on the route rather than a theorem about it.

This is also why a probe file must be re-elaborated and not merely re-read after a sibling
team lands: naming a deleted declaration is a hard error, so the file itself fails rather than
silently reporting a stale set. That is the desired failure mode, and it fired here.

Why the distinction is not pedantry. An unrooted module is invisible to `import
AlgebraicJacobian`, so its axioms cannot be probed here at all; and a scratch import can
differ from the root path in instance *scope*, which §6e's final qualification shows is
exactly the kind of difference an axiom line does not display. The honest procedure when a
sibling team lands a module is: root it, rebuild, then re-measure — not carry the scratch
number forward.

What the clean lines do and do not say. Same caution as §6b and §6d: the χ identity
`chi_eq_charts_sub_overlap` is genuinely unconditional (inclusion–exclusion for a two-set
cover, no exact sequence and no exactness binders), whereas the two vanishing statements carry
chart-count hypotheses proved at no curve. `uniformlyBoundedVanishing_of_uniformChartCount`
takes `UniformChartCount`, which is strictly stronger than the single-field count. And the two
refutations are the sharpest lines here precisely because they are *negative*: they say the
bump hypothesis and the closed ledger are FALSE on any cover having a prime divisor off one
chart, so a clean axiom line on anything downstream of either is clean about a vacuous
premise (trap (h)). -/
#print axioms AlgebraicGeometry.Adelic.chi_eq_charts_sub_overlap
#print axioms AlgebraicGeometry.Adelic.chi_sub_chi_eq_charts_sub_overlap
#print axioms AlgebraicGeometry.Adelic.sectionSub_top_eq_inf
#print axioms AlgebraicGeometry.Adelic.sectionSub_add_pointDivisor_of_notMem
#print axioms AlgebraicGeometry.Adelic.chi_add_pointDivisor_of_notMem_left
#print axioms AlgebraicGeometry.Adelic.bump_iff_chartStep_of_notMem_left
#print axioms AlgebraicGeometry.Adelic.charts_sub_overlap_le_ell
#print axioms AlgebraicGeometry.Adelic.h1dim_eq_zero_iff_charts
#print axioms AlgebraicGeometry.Adelic.exists_bound_h1dim_eq_zero_of_charts
#print axioms AlgebraicGeometry.Adelic.uniformlyBoundedVanishing_of_uniformChartCount

-- The two refutations that replaced the deleted `ChartCountsDegree` pair.  Both are
-- unconditional negative results on a cover with a prime divisor off one chart.
#print axioms AlgebraicGeometry.Adelic.not_bump_of_notMem_left
#print axioms AlgebraicGeometry.Adelic.ledger_refuted_of_notMem_left

-- §6c The rigid-pushforward gate (task ajc-gate).  THE GATE IS NOW INSTANTIATED AND THE
-- INSTANCE IS AXIOM-CLEAN — `instHasRigidPushforwardOfCurve`
-- (`Picard/RigidPushforwardGammaBaseChange.lean`), for every AJC curve, with no hypothesis
-- beyond the curve's own.  This is the one case in this file where a global instance is
-- *good* news, and it is exactly the case where the measurement matters most: the whole
-- point of §8 below is that a `sorry`-bodied instance poisons every synthesis site, so an
-- instance that measures clean has to be checked, not assumed.  The three extraction
-- theorems of `Picard/RigidPushforward.lean` now synthesize their gate rather than
-- assuming it, and §6c-headlines below measures them at that synthesis site.
--
-- `hasRigidPushforward_of_leaves` is a four-leaf FACTORIZATION, of historical interest
-- only now that the gate is a theorem; it was never the frontier once two of its leaves
-- were proved.
--
-- THIRD TRAP, worse than the first two, demonstrated in this very cone (I-0395): a
-- theorem whose named hypothesis is FALSE is vacuously true, and reports clean axioms
-- like any other.  `hrank`, one of the gate's extracted leaves, quantifies over every
-- finitely presented module with no flatness or fibrewise-vanishing hypothesis, and is
-- refuted by `𝒪_{ℙ¹_A}/x` (rank 0 against fibre `h⁰ = 1`).  So the assembly theorems
-- above it are clean, true, and empty.  `#print axioms` sees none of this.  It answers
-- exactly one question — "is a `sorry` reachable from this proof term" — and four
-- separate things it cannot see have now been measured here:
--   (a) a sorry-bodied INSTANCE reached only at a synthesis site (§8);
--   (b) a named hypothesis in the STATEMENT that is unproved (§6b);
--   (c) a named hypothesis in the statement that is FALSE (§6c);
--   (d) an INSTANCE BINDER that nothing can instantiate for the ambient object (§6e).
-- A fifth, outside this file: an unrooted module cannot be probed at all, because
-- `import AlgebraicJacobian` does not reach it (companion measurement 2 in the header).
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_of_leaves

-- The gate's state after `Picard/RigidPushforwardInstance.lean`.  Two of the three
-- statements the frontier file listed are now theorems and this is where that is
-- measured rather than taken on report: `instIsIntegralP1OverLeft` (from the chart-ring
-- identification `Γ(ℙ¹_k, D₊(Xᵢ)) ≃ₐ[k] k[T]` plus the two-chart irreducibility
-- argument) and `p1RankIdentity_proved` carry no named hypotheses at all, so a clean
-- line on them is an unconditional discharge in the §6d sense.  The two consequences
-- are clean and conditional in the *other* direction: they quantify over the curve's
-- own instances only, which for an AJC curve are synthesized.
--
-- `hasRigidPushforward_of_gammaBaseChange` was the honest residue when the gate's cost was
-- one statement; `rigidPushforwardGammaBaseChange_proved` now supplies that statement, so
-- the reduction closed rather than merely narrowing.  Both are measured, along with the
-- resulting instance and the three extraction theorems AT THEIR SYNTHESIS SITE — which is
-- the only measurement that distinguishes a real discharge from trap (a).
#print axioms AlgebraicGeometry.Adelic.instIsIntegralP1OverLeft
#print axioms AlgebraicGeometry.Adelic.p1RankIdentity_proved
#print axioms AlgebraicGeometry.Adelic.p1RigidPushforwardStatement_proved
#print axioms AlgebraicGeometry.Adelic.rigidPushforwardLocallyFree_proved
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_of_gammaBaseChange
#print axioms AlgebraicGeometry.Adelic.p1ChartSectionsAlgEquivX
#print axioms AlgebraicGeometry.Adelic.isIntegral_p1_of_isDomain_charts

-- The statement that closed the reduction, the instance it produces, and the three
-- extraction theorems restated without the gate binder — so they are measured where the
-- gate is SYNTHESIZED, not where it is assumed.  Compare §8: the same measurement on
-- `HasPicScheme` is what exposes `instHasPicScheme`, and these come out the other way.
#print axioms AlgebraicGeometry.Adelic.rigidPushforwardGammaBaseChange_proved
#print axioms AlgebraicGeometry.Adelic.instHasRigidPushforwardOfCurve
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_locallyFree
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_baseChange
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_isLocallyTrivial

-- NON-VACUITY of that instance, which trap (c) says is a separate question from cleanliness:
-- a theorem quantified over three hypotheses is worth nothing if the tree contains nothing
-- satisfying them, and a vacuous theorem reports clean axioms like any other.  `ℙ¹` over an
-- arbitrary field satisfies all three and the gate fires at it, so the discharge above is
-- not empty.  This is the measurement that `hrank` (the false-hypothesis case) would fail.
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_p1Over
#print axioms AlgebraicGeometry.Adelic.instSmoothOfRelativeDimensionOneP1Over
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_baseChange_p1Over

-- The gate at the *challenge's own* hypothesis bundle, which is the form the headline would
-- consume: `GeometricallyIrreducible` where the gate's producer wants `GeometricallyIntegral`.
-- Measuring it here is not redundant with `instHasRigidPushforwardOfCurve` above, because the
-- two differ exactly by the `Smooth ⇒ GeometricallyIntegral` upgrade of
-- `Curve/GeometricallyReduced.lean` — the same upgrade the headline's
-- `geometricallyIntegral_of_curve` performs.  A clean line here says the gate is available at
-- the hypotheses of `Jacobian C` itself, not merely at a restatement of them.
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_of_geometricallyIrreducible

-- §7 Albanese cone
#print axioms AlgebraicGeometry.Pic0.bundle
#print axioms AlgebraicGeometry.Pic0.jacobianScheme
#print axioms AlgebraicGeometry.Pic0.abelJacobi
#print axioms AlgebraicGeometry.Pic0.albanese_universal_property
#print axioms AlgebraicGeometry.Pic0.descentThroughBirationalSigma
#print axioms AlgebraicGeometry.Scheme.RationalMap.extend_to_av

/-! §8 The synthesis leak, measured rather than assumed.

A `#print axioms` on a declaration that *quantifies over* `[HasPicScheme C]`
reports the axioms of the declaration only, because the hypothesis is discharged
by the caller.  The leak the audit is about happens one step later: at a call
site where Lean must **synthesise** the instance, and the only producer is the
`sorry`-bodied `instHasPicScheme`.  The two `example`s below force exactly that
synthesis, so their axiom sets measure what a consumer of the theorem actually
gets.  `Flat` likewise has honest producers, so the flat-pullback probe is
stated at an identity morphism, whose flatness is proved. -/

namespace AlgebraicGeometry

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Scheme

universe u

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
/-
Axiom-frontier probe.  Not part of the library: run it with

    lake env lean scripts/axiom-frontier.lean

from the project root.  Every `#print axioms` line below reports the axioms a
declaration actually depends on, `sorryAx` included, so a declaration that is
locally `sorry`-free but consumes a `sorry`-bodied *instance* through typeclass
synthesis is exposed here and nowhere else.

What this probe does NOT establish is at least as important as what it does, so read
§6b, §6c and §8 before quoting any "clean" line as a completeness claim.  A clean axiom
set means one thing only: no `sorry` is reachable from that proof term.  It says nothing
about unproved or even false hypotheses carried in the statement.

Companion measurement — reachability of the headline.  `#print axioms` says what
the headline depends on; the import graph says what it *could* depend on.  A
headline importing only `Genus.lean` cannot rest on the Picard, cohomology or
Riemann-Roch work no matter what its docstring claims, so the size of its
transitive project-import closure is the honest check that the infrastructure is
wired to the stated theorem:

    python3 - <<'PY'
    import os, re
    def imports(m):
        p = m.replace('.', '/') + '.lean'
        return re.findall(r'^import\s+(AlgebraicJacobian[\w.]*)', open(p).read(), re.M) \
               if os.path.exists(p) else []
    seen, stack = set(), ['AlgebraicJacobian.Jacobian']
    while stack:
        m = stack.pop()
        if m not in seen:
            seen.add(m); stack += imports(m)
    total = sum(1 for _, _, fs in os.walk('AlgebraicJacobian') for f in fs
                if f.endswith('.lean'))
    print(f'{len(seen)} of {total} project modules reachable from the headline')
    PY

At the time this probe was last re-measured that reports 97 reachable modules, up from
8 before `picardJacobianWitness` was wired to `Scheme.Pic0Scheme` (the 97th is
`Curve/GeometricallyReduced.lean`, which discharges the curve's geometric integrality).
The denominator moves as modules land, so read the reachable count, not the ratio — and
note that the reachable count does *not* move when a module lands beside the headline
cone rather than under it, which is the normal case for the rigid-pushforward and
Riemann–Roch lanes.

How to read the output.  Every line is one declaration; the only token that matters is
`sorryAx`.  The clean/leaking split is worth summarising rather than eyeballing:

    lake env lean scripts/axiom-frontier.lean > /tmp/ax.txt
    python3 - <<'PY'
    import re
    entries = [e for e in re.split(r"\n(?=')", open('/tmp/ax.txt').read().strip())
               if e.startswith("'")]
    bad = [e.split("'")[1] for e in entries if 'sorryAx' in e]
    print(f'{len(entries)} probed, {len(entries) - len(bad)} clean, {len(bad)} carry sorryAx')
    for n in bad: print('  ', n)
    PY

Note the `re.split` rather than a plain line filter: Lean wraps a long axiom list over
several lines, so a per-line scan misclassifies exactly the declarations whose axiom
list is longest.  Measured 2026-07-27 on the rooted tree: 89 probed, 54 clean, 35
carrying `sorryAx`.

Companion measurement 2 — is every module on disk rooted?  A module that nothing
imports compiles green, is invisible to the root build, and is therefore invisible to
this probe as well: `import AlgebraicJacobian` does not reach it, so `#print axioms` on
its declarations cannot even be written here.  Replace the `stack` seed above with
`['AlgebraicJacobian']` and compare against the on-disk module list; the difference is
the set of modules whose axioms nobody is measuring.  It should be empty.
-/
import AlgebraicJacobian

open AlgebraicGeometry AlgebraicGeometry.Scheme

-- §0 The three open leaves of the headline witness, plus the two `sorry`-bodied
-- upstream theorems the assembly invokes (`Pic0.smooth`, `Pic0.proper`, §4).
-- Together these five are the whole mathematical distance between the tree and the
-- theorem; everything in §1 is `sorryAx` because of them and nothing else.
#print axioms AlgebraicGeometry.hasRationalPoint_of_curve
#print axioms AlgebraicGeometry.smoothOfRelativeDimension_genus_pic0
#print axioms AlgebraicGeometry.isAlbanese_pic0

-- The half of the former combined leaf `hasRationalPoint_and_geometricallyIntegral`
-- that turned out to be a theorem rather than a decision: geometric integrality of the
-- curve follows from the challenge hypotheses via `Smooth.geometricallyReduced`
-- (`Curve/GeometricallyReduced.lean`).  Clean here means it really is discharged, not
-- that a hypothesis was moved.
#print axioms AlgebraicGeometry.geometricallyIntegral_of_curve

-- §1 The headline (AlgebraicJacobian/Jacobian.lean, AbelJacobi.lean)
#print axioms AlgebraicGeometry.picardJacobianWitness
#print axioms AlgebraicGeometry.nonempty_jacobianWitness
#print axioms AlgebraicGeometry.jacobianWitness
#print axioms AlgebraicGeometry.Jacobian
#print axioms AlgebraicGeometry.Jacobian.instGrpObj
#print axioms AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus
#print axioms AlgebraicGeometry.Jacobian.instIsProper
#print axioms AlgebraicGeometry.Jacobian.instGeometricallyIrreducible
#print axioms AlgebraicGeometry.IsAlbanese
#print axioms AlgebraicGeometry.IsAlbanese.unique
#print axioms AlgebraicGeometry.Jacobian.ofCurve
#print axioms AlgebraicGeometry.Jacobian.comp_ofCurve
#print axioms AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp
#print axioms AlgebraicGeometry.genus

-- §2 The two sorry-bodied instances
#print axioms AlgebraicGeometry.Scheme.instHasPicScheme
#print axioms AlgebraicGeometry.pullback_preservesFiniteLimits

-- §3 Picard cone keystones
#print axioms AlgebraicGeometry.Scheme.PicScheme
#print axioms AlgebraicGeometry.Scheme.PicScheme.representable
#print axioms AlgebraicGeometry.Scheme.PicScheme.picSharp
#print axioms AlgebraicGeometry.Scheme.Pic0Scheme

-- §4 Pic⁰-is-an-abelian-variety cone
#print axioms AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso
#print axioms AlgebraicGeometry.Scheme.Pic0.smooth
#print axioms AlgebraicGeometry.Scheme.Pic0.proper
#print axioms AlgebraicGeometry.Scheme.Pic0.geometricallyIrreducible
#print axioms AlgebraicGeometry.Scheme.Pic0.grpObj
#print axioms AlgebraicGeometry.Scheme.Pic0.isAbelianVariety
#print axioms AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety
#print axioms AlgebraicGeometry.Scheme.Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne
#print axioms AlgebraicGeometry.Scheme.Pic0.pointedDualNumberPoints_equiv_relPicKernel
#print axioms AlgebraicGeometry.Scheme.Pic0.isSeparated
#print axioms AlgebraicGeometry.Scheme.Pic0.locallyOfFiniteType

-- §5 Cohomology cone: the Čech engine and the flat-base-change frontier
#print axioms AlgebraicGeometry.cech_computes_higherDirectImage
#print axioms AlgebraicGeometry.pullback_preservesFiniteColimits
#print axioms AlgebraicGeometry.pullback_preservesHomology
#print axioms AlgebraicGeometry.Scheme.subsingleton_hModule'_one_toModuleKSheaf_of_isAffineOpen

-- §6 Riemann–Roch / genus cone
#print axioms AlgebraicGeometry.Adelic.instModuleFiniteHModuleOne
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.hModuleOneEquivH1Cok_curve
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.chi_unit_eq_one_sub_genus
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.h1_unit_eq_genus

/-! §6b Cluster-P extensions (task ajc-rr).  Independent re-verification, in the
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
| `hasRationalResidues_of_isAlgClosed`           | none — see below, this is the exception |
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

The one genuine discharge, and the reason it is worth naming separately:
`hasRationalResidues_of_isAlgClosed` takes no ledger, no vanishing and no bump — only
`IsAlgClosed k`, an `Algebra`/`IsScalarTower` on the stalk and `Module.Finite` on its
residue field.  A clean axiom line there really does mean an unconditional theorem, and it
is what turns the two `_of_hasRationalResidues` results into unconditional statements over
an algebraically closed field. -/
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

-- §6c The rigid-pushforward gate (task ajc-gate).  Per I-0377 the gate is NOT
-- instantiated: `hasRigidPushforward_of_leaves` derives it from four named leaves,
-- none proved.  Probed here so the frontier records that accurately.
--
-- THIRD TRAP, worse than the other two, demonstrated in this very cone (I-0395): a
-- theorem whose named hypothesis is FALSE is vacuously true, and reports clean axioms
-- like any other.  `hrank`, one of the gate's extracted leaves, quantifies over every
-- finitely presented module with no flatness or fibrewise-vanishing hypothesis, and is
-- refuted by `𝒪_{ℙ¹_A}/x` (rank 0 against fibre `h⁰ = 1`).  So the assembly theorems
-- above it are clean, true, and empty.  `#print axioms` sees none of this.  It answers
-- exactly one question — "is a `sorry` reachable from this proof term" — and three
-- separate things it cannot see have now been measured here:
--   (a) a sorry-bodied INSTANCE reached only at a synthesis site (§8);
--   (b) a named hypothesis in the STATEMENT that is unproved (§6b);
--   (c) a named hypothesis in the statement that is FALSE (§6c).
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
-- `hasRigidPushforward_of_gammaBaseChange` is the honest residue: the gate still has NO
-- instance, and its whole remaining cost is `RigidPushforwardGammaBaseChange` at every
-- finitely generated `k`-algebra — one statement rather than the former four leaves.
-- Being an assembly theorem it reports clean axioms automatically (trap (a) again), so
-- the line below is a record of the reduction, not of a discharge.
#print axioms AlgebraicGeometry.Adelic.instIsIntegralP1OverLeft
#print axioms AlgebraicGeometry.Adelic.p1RankIdentity_proved
#print axioms AlgebraicGeometry.Adelic.p1RigidPushforwardStatement_proved
#print axioms AlgebraicGeometry.Adelic.rigidPushforwardLocallyFree_proved
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_of_gammaBaseChange
#print axioms AlgebraicGeometry.Adelic.p1ChartSectionsAlgEquivX
#print axioms AlgebraicGeometry.Adelic.isIntegral_p1_of_isDomain_charts

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

/-- Instantiated at a curve with a rational point, `Pic0.geometricallyIrreducible`
has to synthesise `HasPicScheme C`, whose sole producer is `sorry`-bodied. -/
theorem leakProbe_pic0_geometricallyIrreducible [HasRationalPoint C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    GeometricallyIrreducible (Pic0Scheme C).hom :=
  Pic0.geometricallyIrreducible C

/-- The same measurement for the separatedness carrier. -/
theorem leakProbe_pic0_isSeparated [HasRationalPoint C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    IsSeparated (Pic0Scheme C).hom :=
  Pic0.isSeparated C

/-- Same measurement for the local-finiteness carrier. -/
theorem leakProbe_pic0_locallyOfFiniteType [HasRationalPoint C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    LocallyOfFiniteType (Pic0Scheme C).hom :=
  Pic0.locallyOfFiniteType C

/-- The control that isolates the leak to synthesis and nothing else: identical
conclusion and proof term, but with `HasPicScheme` taken as a hypothesis rather
than synthesised.  This one is clean, which is exactly the point. -/
theorem leakControl_pic0_locallyOfFiniteType [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    LocallyOfFiniteType (Pic0Scheme C).hom :=
  Pic0.locallyOfFiniteType C

/-- The two *chapter keystones* at a synthesis site, which is what decides whether
a blueprint `\leanok` on them would be honest.  `PicScheme.representable` is
`Classical.choice` over the gate, and `Pic0.isAbelianVariety` bundles the
`sorry`-bodied `smooth` and `proper` conjuncts, so both pick up `sorryAx` here even
though each reports clean as stated. -/
noncomputable def leakProbe_picScheme_representable [HasRationalPoint C] :
    (PicScheme.picSharp C).RepresentableBy (PicScheme C) :=
  PicScheme.representable C

/-- Companion measurement for the abelian-variety assembly. -/
theorem leakProbe_pic0_isAbelianVariety [HasRationalPoint C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    IsProper (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧
      GeometricallyIrreducible (Pic0Scheme C).hom ∧
      Nonempty (GrpObj (Pic0Scheme C)) :=
  Pic0.isAbelianVariety C

#print axioms leakProbe_pic0_geometricallyIrreducible
#print axioms leakProbe_pic0_isSeparated
#print axioms leakProbe_pic0_locallyOfFiniteType
#print axioms leakControl_pic0_locallyOfFiniteType
#print axioms leakProbe_picScheme_representable
#print axioms leakProbe_pic0_isAbelianVariety

/-- Flat pullback along the identity: `Flat` is synthesised from a proved
instance, but `PreservesFiniteLimits` still routes through the `sorry`-bodied
`pullback_preservesFiniteLimits`. -/
theorem leakProbe_pullback_finiteLimits (S : Scheme.{u}) :
    PreservesFiniteLimits (Scheme.Modules.pullback (𝟙 S)) :=
  inferInstance

#print axioms leakProbe_pullback_finiteLimits

end AlgebraicGeometry

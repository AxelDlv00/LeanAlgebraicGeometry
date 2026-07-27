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
The denominator moves as modules land, so read the reachable count, not the ratio.

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

-- §6b Cluster-P extensions (task ajc-rr).  Independent re-verification, in the
-- rooted environment, of the axiom claims made in I-0383.  CAUTION: several of
-- these are axiom-clean and still NOT unconditional mathematics — they take the
-- closed χ-ledger and/or a peel-surjectivity datum as *named hypotheses*, which
-- `#print axioms` cannot see.  Read this section as "no hidden sorry", not as
-- "theorem available".
#print axioms AlgebraicGeometry.Adelic.chi_eq_of_linearEquivalence
#print axioms AlgebraicGeometry.Adelic.degK
#print axioms AlgebraicGeometry.Adelic.degK_principal_eq_zero
#print axioms AlgebraicGeometry.Adelic.ell_eq_zero_of_degK_neg
#print axioms AlgebraicGeometry.Adelic.exists_bound_h1dim_eq_zero
#print axioms AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod

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

#print axioms leakProbe_pic0_geometricallyIrreducible
#print axioms leakProbe_pic0_isSeparated
#print axioms leakProbe_pic0_locallyOfFiniteType
#print axioms leakControl_pic0_locallyOfFiniteType

/-- Flat pullback along the identity: `Flat` is synthesised from a proved
instance, but `PreservesFiniteLimits` still routes through the `sorry`-bodied
`pullback_preservesFiniteLimits`. -/
theorem leakProbe_pullback_finiteLimits (S : Scheme.{u}) :
    PreservesFiniteLimits (Scheme.Modules.pullback (𝟙 S)) :=
  inferInstance

#print axioms leakProbe_pullback_finiteLimits

end AlgebraicGeometry

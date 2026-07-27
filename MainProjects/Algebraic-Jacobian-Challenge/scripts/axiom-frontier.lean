/-
Axiom-frontier probe.  Not part of the library: run it with

    lake env lean scripts/axiom-frontier.lean

from the project root.  Every `#print axioms` line below reports the axioms a
declaration actually depends on, `sorryAx` included, so a declaration that is
locally `sorry`-free but consumes a `sorry`-bodied *instance* through typeclass
synthesis is exposed here and nowhere else.
-/
import AlgebraicJacobian

open AlgebraicGeometry AlgebraicGeometry.Scheme

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

#print axioms leakProbe_pic0_geometricallyIrreducible
#print axioms leakProbe_pic0_isSeparated

/-- Flat pullback along the identity: `Flat` is synthesised from a proved
instance, but `PreservesFiniteLimits` still routes through the `sorry`-bodied
`pullback_preservesFiniteLimits`. -/
theorem leakProbe_pullback_finiteLimits (S : Scheme.{u}) :
    PreservesFiniteLimits (Scheme.Modules.pullback (𝟙 S)) :=
  inferInstance

#print axioms leakProbe_pullback_finiteLimits

end AlgebraicGeometry

import AlgebraicJacobian.Cohomology.FlatBaseChange
import AlgebraicJacobian.Cohomology.FlatBaseChangeGlobal
import AlgebraicJacobian.Cohomology.RegroupHelper
import AlgebraicJacobian.Cohomology.SheafCompose
import AlgebraicJacobian.Cohomology.StructureSheafAb
import AlgebraicJacobian.Cohomology.StructureSheafModuleK
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.SectionsBridge
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.AffineDegreeOneVanishing
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.QuasicoherentDegreeOneVanishing
import AlgebraicJacobian.Cohomology.MayerVietorisCore
import AlgebraicJacobian.Cohomology.MayerVietorisCover
-- Čech-cohomology development merged from the Cech-Cohomology subproject
-- (enrich merge, 2026-06-18). Closes the formerly-orphaned CechNerve / Rⁱf_*
-- Čech lane: pushPullFunctor + pushPullMap_comp + cech_computes_higherDirectImage.
import AlgebraicJacobian.Cohomology.HigherDirectImage
import AlgebraicJacobian.Cohomology.HigherDirectImagePresheaf
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.CechAcyclic
import AlgebraicJacobian.Cohomology.CechCoboundarySplitting
import AlgebraicJacobian.Cohomology.AcyclicResolution
import AlgebraicJacobian.Cohomology.PresheafCech
import AlgebraicJacobian.Cohomology.FreePresheafComplex
import AlgebraicJacobian.Cohomology.CechBridge
import AlgebraicJacobian.Cohomology.AbsoluteCohomology
import AlgebraicJacobian.Cohomology.CechToCohomology
import AlgebraicJacobian.Cohomology.TildeExactness
import AlgebraicJacobian.Cohomology.AffineSerreVanishing
import AlgebraicJacobian.Cohomology.QcohRestrictBasicOpen
import AlgebraicJacobian.Cohomology.QcohTildeSections
import AlgebraicJacobian.Cohomology.CechSectionComplex
import AlgebraicJacobian.Cohomology.CechSectionIdentificationBase
import AlgebraicJacobian.Cohomology.CechSectionIdentificationLeg
import AlgebraicJacobian.Cohomology.CechSectionIdentificationLegMid1
import AlgebraicJacobian.Cohomology.CechSectionIdentificationLegMid2
import AlgebraicJacobian.Cohomology.CechSectionIdentificationLegTop
import AlgebraicJacobian.Cohomology.CechSectionIdentificationLegAux
import AlgebraicJacobian.Cohomology.CechSectionAugmentationComparison
import AlgebraicJacobian.Cohomology.CechSectionIdentification
import AlgebraicJacobian.Cohomology.CechSectionContractibility
import AlgebraicJacobian.Cohomology.CechAugmentedResolution
import AlgebraicJacobian.Cohomology.OpenImmersionPushforward
import AlgebraicJacobian.Cohomology.CechTermAcyclic
import AlgebraicJacobian.Cohomology.CechToHigherDirectImage
import AlgebraicJacobian.Cohomology.ModulesCoverConservativity
-- Affine essential-image heart of the open-immersion Beck–Chevalley (Stacks 02KG)
import AlgebraicJacobian.Cohomology.AffinePushPullEssImage
-- Pullback of quasi-coherent modules along an arbitrary morphism (Stacks 01BG)
import AlgebraicJacobian.Cohomology.PullbackQuasicoherent
-- Target-local roadmap nodes preserved across the merge (unconditional Rⁱf_*
-- packaging + Čech flat base change, Stacks 02KH) — see file header.
import AlgebraicJacobian.Cohomology.CechHigherDirectImageUnconditional
import AlgebraicJacobian.Genus
import AlgebraicJacobian.RigidityLemma
import AlgebraicJacobian.Jacobian
import AlgebraicJacobian.AbelJacobi
import AlgebraicJacobian.Picard.RelativeSpec
import AlgebraicJacobian.Picard.SectionRingUniversal
import AlgebraicJacobian.Picard.StructureSheafPushforward
import AlgebraicJacobian.Picard.RigidPushforward
import AlgebraicJacobian.Picard.RigidPushforwardTransfer
import AlgebraicJacobian.Picard.RigidPushforwardP1Engine
-- Rigid-pushforward gate cone (run 0053, task ajc-gate). RigidPushforwardGate is
-- the single entry point; it transitively pulls RigidPushforwardP1Constants,
-- RigidPushforwardFiberChart and RigidPushforwardP1Sheaf. The gate itself is NOT
-- instantiated: hasRigidPushforward_of_leaves derives HasRigidPushforward from
-- four named leaves, none of them proved. FiberChart and P1Sheaf are NOT below
-- the gate (P1Sheaf imports it, FiberChart sits beside it), so they need their
-- own entries or they stay invisible to the root build.
import AlgebraicJacobian.Picard.RigidPushforwardGate
import AlgebraicJacobian.Picard.RigidPushforwardFiberChart
import AlgebraicJacobian.Picard.RigidPushforwardP1Sheaf
import AlgebraicJacobian.Picard.P1SectionsFinite
import AlgebraicJacobian.Picard.TwoTermFiniteFree
import AlgebraicJacobian.Picard.SemicontinuityH0
import AlgebraicJacobian.Picard.DivDegree
import AlgebraicJacobian.Picard.FinitePresentationFunctor
import AlgebraicJacobian.Picard.FiniteGaloisQuotient
import AlgebraicJacobian.Picard.FiniteGaloisQuotientAffine
import AlgebraicJacobian.Picard.StableAffineCover
import AlgebraicJacobian.Picard.GaloisQuotientGlue
import AlgebraicJacobian.Picard.LineBundlePullback
import AlgebraicJacobian.Picard.TensorObjSubstrate
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse
-- Comparison-iso substrate merged from the Line-Bundle-Comparison-Iso
-- subproject (T1 merge, 2026-07-02). Headline: exists_tensorObj_inverse
-- (the L ⊗ L⁻¹ ≅ O_C keystone) proved sorry-free in TensorObjInverse,
-- via the DUAL/D3′ route (PresheafDualPullback* + PullbackTensorMapIso +
-- TrivialisationRestrict). PullbackTensorComp.lean was retired in the
-- merge: its D3′ lemma set was absorbed into TensorObjSubstrate.lean
-- (proved), and its remaining helpers had no consumers.
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse.PresheafDualPullback
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse.PresheafDualUnitPullback
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse.PresheafDualPullbackNatural
import AlgebraicJacobian.Picard.TensorObjSubstrate.PullbackTensorMapIso
import AlgebraicJacobian.Picard.TensorObjSubstrate.PullbackTensorIso
import AlgebraicJacobian.Picard.TensorObjSubstrate.TrivialisationRestrict
import AlgebraicJacobian.Picard.TensorObjInverse
import AlgebraicJacobian.Picard.RelPicFunctor
import AlgebraicJacobian.Picard.GeometricallyConnectedSection
import AlgebraicJacobian.Picard.FGAPicRepresentability
import AlgebraicJacobian.Picard.RigidifiedPic
import AlgebraicJacobian.Picard.IdentityComponent
import AlgebraicJacobian.Picard.TangentSpaceDualNumbers
import AlgebraicJacobian.Picard.TangentSpaceSchemePoints
import AlgebraicJacobian.Picard.TangentSpaceStalkAlgebra
import AlgebraicJacobian.Picard.TangentSpaceIdentitySection
import AlgebraicJacobian.Picard.DualNumberUnits
import AlgebraicJacobian.Picard.Pic0AbelianVariety
import AlgebraicJacobian.Picard.FlatteningStratification
import AlgebraicJacobian.Picard.EntryIdeal
import AlgebraicJacobian.Picard.EntryIdealStratum
import AlgebraicJacobian.Picard.FlatteningStratificationUniversal
import AlgebraicJacobian.Picard.GenericFlatnessGeometric
import AlgebraicJacobian.Picard.HilbertPolynomial
import AlgebraicJacobian.Picard.QuotScheme
-- Grassmannian/Quot representability development merged from the
-- GR-quot_closure subproject (union merge, 2026-06-22). Headline:
-- AlgebraicGeometry.Grassmannian.represents (rank-d quotient functor
-- representability) + the section graded ring/module lane, all sorry-free.
import AlgebraicJacobian.Picard.GradedHilbertSerre
import AlgebraicJacobian.Picard.SectionGradedRing
import AlgebraicJacobian.Picard.GrassmannianCells
import AlgebraicJacobian.Picard.GlueDescent
import AlgebraicJacobian.Picard.GrassmannianQuot
import AlgebraicJacobian.Picard.ScalarEndFaithful
import AlgebraicJacobian.Picard.QuotFunctorDef
-- T14 ampleness / projective-morphism / Serre-finiteness foundation:
-- relative projective space, Serre twist O(m), projective-with-L predicate.
import AlgebraicJacobian.Picard.ProjectiveSpace
import AlgebraicJacobian.Picard.SerreTwist
-- Option-B Phase 0 (Serre-finiteness lane): the glued-sheaf Γ-section API —
-- Γ(glue D M g, ⊤) ≅ compatible families, instantiated at O(m).
import AlgebraicJacobian.Picard.SerreTwistSections
import AlgebraicJacobian.Picard.InvertibleGrBridge
import AlgebraicJacobian.Picard.GradedPiecesFinite
import AlgebraicJacobian.Picard.ChartSectionsFinite
import AlgebraicJacobian.Picard.ProjectiveMorphism
import AlgebraicJacobian.Picard.SerreFiniteness
import AlgebraicJacobian.Picard.ZariskiDescentRepresentability
import AlgebraicJacobian.Picard.GrassmannianZariskiSheaf
import AlgebraicJacobian.Picard.GrassmannianRepresentability
-- I-0118 honest restatement of thm:quot_representable (projective π with
-- very ample L via IsProjectiveWith, coherent E), split out of QuotFunctorDef.
import AlgebraicJacobian.Picard.QuotRepresentability
-- Wave-2 leaf bricks (2026-07-07): schematic-support / annihilator lane for
-- gammaFiber, and the tensor section-comparison lane for pullbackTensorMap_isIso.
import AlgebraicJacobian.Picard.SchematicSupport
import AlgebraicJacobian.Picard.TensorSectionFormula
import AlgebraicJacobian.Picard.LineBundleCoherence
import AlgebraicJacobian.RiemannRoch.WeilDivisor
-- Adelic Riemann-Roch lane (2026-07-07): Weil repartitions as the concrete
-- 2-affine-cover cokernel; keystone = H^1(C, O_C) finiteness via a finite map
-- to P^1 (design: RiemannRoch_Adelic blueprint chapter).
import AlgebraicJacobian.RiemannRoch.Adelic.Substrate
import AlgebraicJacobian.RiemannRoch.Adelic.Cokernel
import AlgebraicJacobian.RiemannRoch.Adelic.P1BaseCase
import AlgebraicJacobian.RiemannRoch.Adelic.FinitenessP1
import AlgebraicJacobian.RiemannRoch.Adelic.FiniteMapToP1
import AlgebraicJacobian.RiemannRoch.Adelic.P1ChartData
import AlgebraicJacobian.RiemannRoch.Adelic.ChiLedger
import AlgebraicJacobian.RiemannRoch.Adelic.NonconstantToP1
import AlgebraicJacobian.RiemannRoch.Adelic.GenusFiniteness
import AlgebraicJacobian.RiemannRoch.Adelic.CechComparisonGate
import AlgebraicJacobian.RiemannRoch.Adelic.CechAcyclicInstance
import AlgebraicJacobian.RiemannRoch.Adelic.GateInstances
import AlgebraicJacobian.RiemannRoch.Adelic.GenusUnconditional
-- Cluster-P χ-ledger extensions (run 0055, task ajc-rr). Each imports the
-- previous; ClassInvariance sits over the already-rooted Adelic.ChiLedger.
-- NB several keystones here are axiom-clean but CONDITIONAL in their statements:
-- they take the closed ledger and/or a peel-surjectivity datum as named
-- hypotheses, so `#print axioms` alone overstates them.
import AlgebraicJacobian.RiemannRoch.Adelic.ClassInvariance
import AlgebraicJacobian.RiemannRoch.Adelic.SectionBounds
import AlgebraicJacobian.RiemannRoch.Adelic.BoundedVanishing
import AlgebraicJacobian.RiemannRoch.CurveBaseChange
import AlgebraicJacobian.RiemannRoch.CohomologyKit
import AlgebraicJacobian.Picard.InvertibleSectionLocalization
import AlgebraicJacobian.Picard.GaloisDescent.SemilinearModules
import AlgebraicJacobian.Picard.GaloisDescent.SemilinearAlgebras
import AlgebraicJacobian.Albanese.AlbaneseUP
import AlgebraicJacobian.Albanese.AuslanderBuchsbaum
import AlgebraicJacobian.Albanese.CodimOneExtension
import AlgebraicJacobian.Albanese.CoheightBridge
import AlgebraicJacobian.Albanese.DifferenceMap
import AlgebraicJacobian.Albanese.PolePurity
import AlgebraicJacobian.Albanese.Milne33Substeps
import AlgebraicJacobian.Albanese.RationalMapFunctionField
import AlgebraicJacobian.Albanese.RationalMapPrecomp
import AlgebraicJacobian.Albanese.RationalMapProd
import AlgebraicJacobian.Albanese.SmoothPrimeRegularity
import AlgebraicJacobian.Albanese.StandardSmoothDimension
import AlgebraicJacobian.Albanese.Thm32RationalMapExtension

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
-- Smooth ⟹ geometrically reduced (mathlib-general, upstreaming candidate). Supplies
-- `GeometricallyIntegral` for the challenge's curve hypotheses, which is what the whole
-- Picard/FGA development runs under.
import AlgebraicJacobian.Curve.GeometricallyReduced
import AlgebraicJacobian.Jacobian
import AlgebraicJacobian.AbelJacobi
import AlgebraicJacobian.Picard.RelativeSpec
import AlgebraicJacobian.Picard.SectionRingUniversal
import AlgebraicJacobian.Picard.StructureSheafPushforward
import AlgebraicJacobian.Picard.RigidPushforward
import AlgebraicJacobian.Picard.RigidPushforwardTransfer
import AlgebraicJacobian.Picard.RigidPushforwardP1Engine
-- Rigid-pushforward gate cone (run 0053, task ajc-gate). The gate is DISCHARGED (see the
-- Instance/GammaBaseChange/P1Witness entries below); `hasRigidPushforward_of_leaves` is a
-- four-leaf factorization of it, kept as a decomposition, no longer a frontier.
-- The gate is NOT the top of its own cone: RigidPushforwardP1Sheaf imports it and
-- RigidPushforwardFiberChart sits beside it (over Transfer + P1Engine), so both are
-- ABOVE the gate. RigidPushforwardFrontier imports all three and is the single entry
-- point; the other entries are kept explicit so that retiring Frontier cannot silently
-- unroot them.
import AlgebraicJacobian.Picard.RigidPushforwardGate
import AlgebraicJacobian.Picard.RigidPushforwardFiberChart
import AlgebraicJacobian.Picard.RigidPushforwardP1Sheaf
import AlgebraicJacobian.Picard.RigidPushforwardFrontier
-- Aimed at the gate's H0-finiteness leaf: the P^1 chart-ring identification over the
-- integral model. Sits over Adelic.P1ChartData, beside the cone rather than under it.
import AlgebraicJacobian.Picard.RigidPushforwardP1ChartRing
-- Second wave of the same cone (run 0053, task ajc-gate). None of these is below
-- another: AffineDescent sits over Transfer + PullbackQuasicoherent, P1Topology over
-- Adelic.FinitenessP1, P1ChartSections over P1ChartRing, and Rank over P1Sheaf +
-- FiberChart. Four separate entries, for the same reason the first wave needed them.
import AlgebraicJacobian.Picard.RigidPushforwardAffineDescent
import AlgebraicJacobian.Picard.RigidPushforwardP1Topology
import AlgebraicJacobian.Picard.RigidPushforwardP1ChartSections
import AlgebraicJacobian.Picard.RigidPushforwardRank
-- The assembly above all four: `IsIntegral ℙ¹_k` and the rank identity are theorems, so the
-- gate's `locallyFree` field is unconditional.
import AlgebraicJacobian.Picard.RigidPushforwardInstance
-- The gate's second field and its chart-level input. ChartBaseChange sits over FiberChart;
-- GammaBaseChange imports it and Instance, proves the residual Γ-level base-change statement,
-- and carries the resulting `instHasRigidPushforwardOfCurve` — a real global instance, measured
-- clean AT THE SYNTHESIS SITE together with the three extraction theorems that now synthesize
-- rather than assume it (scripts/axiom-frontier.lean §6c).
import AlgebraicJacobian.Picard.RigidPushforwardChartBaseChange
import AlgebraicJacobian.Picard.RigidPushforwardGammaBaseChange
-- Non-vacuity of that instance, which is not a formality: a theorem quantified over three
-- hypotheses is worth nothing if nothing satisfies them, and §6c trap (c) is exactly this
-- failure mode. ℙ¹ over an arbitrary field satisfies all three, and the gate fires at it.
import AlgebraicJacobian.Picard.RigidPushforwardP1Witness
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
import AlgebraicJacobian.Picard.NilpotentThickeningFree
import AlgebraicJacobian.Picard.DualNumberChartTriviality
import AlgebraicJacobian.Picard.GroupSchemeSmoothAlgClosed
import AlgebraicJacobian.Picard.Pic0AbelianVariety
-- The A.3 dimension leg and the ambient-properness refutation (run 0067 r5/r6).
-- Rooted here per inbox I-0600 / I-0659: an unrooted module is invisible to the
-- workspace axiom probe, which walks the cone of THIS file. `Pic0Dimension`
-- transitively pulls in `SchemeKrullDimStalk`.
import AlgebraicJacobian.Picard.EmbeddingDimensionBound
import AlgebraicJacobian.Picard.Pic0Dimension
import AlgebraicJacobian.Picard.AmbientPicNotProper
import AlgebraicJacobian.Picard.GroupSchemeHomogeneity
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
-- AJC.rr.principal carrier comparisons (2026-07-28): the two index sets used for
-- divisors on a curve agree (X.PrimeDivisor ≃ non-generic points, ajc-rr), lifted to
-- divisors and their degree — the first of the two mismatches costing the sibling
-- χ-ledger port. Rooted here per I-0362: a module with no importer is never elaborated.
import AlgebraicJacobian.RiemannRoch.CurveCoheight
import AlgebraicJacobian.RiemannRoch.CurveDivisorIndexBridge
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
-- Global generation and the ledger closure (run 0055, task ajc-rr). LedgerClosure
-- imports GlobalGeneration, so the second entry alone would root both; both are kept
-- explicit so retiring either cannot silently unroot the other. Same caveat as above:
-- the generation lane takes the closed χ-ledger as a named hypothesis, so a clean
-- `#print axioms` on it is not an unconditional theorem. There is NO exception here:
-- `hasRationalResidues_of_isAlgClosed` takes no ledger, but its obligations sit in three
-- instance binders that nothing constructs for a bare `Scheme`, so it is a relocation
-- rather than a discharge (scripts/axiom-frontier.lean §6e).
import AlgebraicJacobian.RiemannRoch.Adelic.GlobalGeneration
import AlgebraicJacobian.RiemannRoch.Adelic.LedgerClosure
-- Residue degree one on the curve's own hypotheses. This is the module that turned the
-- retracted "discharge" above into a real one: it routes around the stalk residue-field
-- finiteness binder via mathlib's `residueFieldIsoBase`, so the obligation is no longer
-- parked in an instance nothing constructs (scripts/axiom-frontier.lean §6e).
import AlgebraicJacobian.RiemannRoch.Adelic.ResidueField
-- The UNGATED Čech Euler characteristic and its consequences (run 0055, task ajc-rr).
-- `ChiUnconditional` is where `χ` is computed as inclusion–exclusion over the two charts with
-- no exact sequence and no exactness hypotheses, which is what makes its conclusions
-- independent of the `chi_add` machinery. That independence is the point: a refutation of a
-- hypothesis routed through `chi_add` measures `chi_add`, not the hypothesis
-- (scripts/axiom-frontier.lean §2b records a retraction of exactly that shape).
import AlgebraicJacobian.RiemannRoch.Adelic.ChiUnconditional
-- 2026-07-28 (ajc-rr, request I-0547): the chart-finiteness binder of those refutations is
-- UNSATISFIABLE on a curve — one instance at D = 0 forces K(X)/k finite — so `hbump` and the
-- closed ledger are OPEN there rather than refuted. Rooted so the refutation-of-the-refutation
-- is elaborated alongside what it corrects.
import AlgebraicJacobian.RiemannRoch.Adelic.ChartFinitenessRefuted
import AlgebraicJacobian.RiemannRoch.Adelic.UniformChartVanishing
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
-- The g-fold sum `C^g ⟶ A` into a commutative group object and its
-- permutation symmetry: Milne's "clearly this is symmetric" (III.6.1).
import AlgebraicJacobian.Albanese.GrpObjFoldSum
-- Milne I.1.4: an abelian variety is commutative. Supplies the `IsCommMonObj`
-- instance that the g-fold sum above needs at its intended target.
import AlgebraicJacobian.Albanese.AVCommutative
import AlgebraicJacobian.Albanese.AVSelfProduct
import AlgebraicJacobian.Albanese.SymPowInterface
import AlgebraicJacobian.Albanese.SymPowColimit
-- The affine symmetric-power carrier, rooted so the workspace axiom probe covers it
-- (it did not until run 0069 r5; see inbox I-0659). `SymPowInvariants` names the carrier
-- of a ring-action quotient, `SymPowInvariantsLocalization` supplies `(A_b)^G = (A^G)_b`,
-- `SymPowTensorAction` the `S_n`-action on the tensor power that makes it Milne's
-- `(A^{⊗ n})^{S_n}`, and `SymPowInvariantsUnder` restates the identification over the base.
import AlgebraicJacobian.Albanese.SymPowInvariants
import AlgebraicJacobian.Albanese.SymPowInvariantsLocalization
import AlgebraicJacobian.Albanese.SymPowTensorAction
import AlgebraicJacobian.Albanese.SymPowInvariantsUnder
-- The `G`-stable affine cover for a bare finite group action: the same proof as
-- `Picard/StableAffineCover.lean`, whose Galois binder its body never uses. Since run 0069 r6
-- it also carries the `S_n` instantiation, via `MonObj.permAutHom` in `GrpObjFoldSum`.
import AlgebraicJacobian.Albanese.StableAffineCoverGroup
-- The `n`-fold tensor power IS the `n`-ary coproduct of commutative algebras, with the
-- factor-permutation action matched to `permAlgHom`. Item 3 of the four-item glue-data bill
-- for `Sym^n C`; both halves of the universal property were already in mathlib unbundled
-- (`liftAlgHom` / `algHom_ext`) rather than absent, as two earlier sessions had recorded.
import AlgebraicJacobian.Albanese.TensorPowerCoproduct
-- …and that comparison packaged as a `Cofan`/`IsColimit` in `Under k`, which is what makes
-- item 3 consumable rather than merely proved: the affine chart's carrier is now a NAMED
-- object of `Under k` with its universal property in categorical form. Closes the last
-- categorical crossing of the bill; the one trap is that `CommRingCat.toAlgHom` is typed
-- over the rebuilt algebra instance, not the ambient one.
import AlgebraicJacobian.Albanese.TensorPowerCofan
-- Naming the affine carrier's INPUT: the n-fold product in `(Under k)ᵒᵖ` that `permDiagram`
-- is built on IS `op (mkUnder k (⨂[k] _ : Fin n, A))`, i.e. `(Spec_k A)^n = Spec_k (A^{⊗n})`,
-- with the S_n-actions matched (and the match carries `e⁻¹` — the kernel forced it). The
-- QUOTIENT carrier is still anonymous; see that file's Scope section for what separates them.
import AlgebraicJacobian.Albanese.SymPowAffineCarrier
-- …and the composition that names the QUOTIENT: the colimit of the S_n-action on (Spec_k A)^n
-- IS Spec_k ((A^{⊗n})^{S_n}) -- Milne III.3 Prop 3.1's affine half with the object identified,
-- which is what SymPowColimit §5's bold caveat asked for. Note that the accompanying HasColimit
-- is NOT a new fact (cocompleteness gives it); the deliverable is the iso, because only an
-- equation mentioning the object can name it.
import AlgebraicJacobian.Albanese.SymPowAffineQuotient
import AlgebraicJacobian.Albanese.AlbaneseFromData
import AlgebraicJacobian.Albanese.AlbaneseFromColimit
import AlgebraicJacobian.Albanese.AlbaneseJacobian
import AlgebraicJacobian.Albanese.Milne33Substeps
-- Milne Lemma 3.3 (`lem:milne_codim1_indeterminacy`) and its substep layers:
-- ported sorry-free from the sibling Rebuild tree in run 0069, closing the last
-- open obligation of the codim-one extension chapter and making Milne Theorem
-- 3.2 (`extend_to_av`) unconditional.
import AlgebraicJacobian.Albanese.Milne33CMEquidim
import AlgebraicJacobian.Albanese.Milne33KernelGen
import AlgebraicJacobian.Albanese.Milne33TransportLocal
import AlgebraicJacobian.Albanese.Milne33Rows
import AlgebraicJacobian.Albanese.Milne33Diagonal
import AlgebraicJacobian.Albanese.Milne33RowSection
import AlgebraicJacobian.Albanese.Milne33Pullback
import AlgebraicJacobian.Albanese.Milne33Transport
import AlgebraicJacobian.Albanese.Milne33
-- Descent of a morphism from a dense open into an abelian variety: the
-- extension half of Milne III.6.1's "it therefore defines a rational map
-- psi : J -> A, which (I 3.2) shows to be a regular map".
import AlgebraicJacobian.Albanese.DenseOpenDescent
import AlgebraicJacobian.Albanese.RationalMapFunctionField
import AlgebraicJacobian.Albanese.RationalMapPrecomp
import AlgebraicJacobian.Albanese.RationalMapProd
import AlgebraicJacobian.Albanese.SmoothPrimeRegularity
import AlgebraicJacobian.Albanese.StandardSmoothDimension
import AlgebraicJacobian.Albanese.Thm32RationalMapExtension

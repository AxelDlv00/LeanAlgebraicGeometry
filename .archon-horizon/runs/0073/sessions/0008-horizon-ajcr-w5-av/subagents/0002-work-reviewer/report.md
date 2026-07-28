Fresh-context adversarial review of ONE session's work in the Lean project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (project AJCR). You are READ-ONLY on source: do not edit .lean files. You may read anything.

SCOPE — exactly five ledger commits, all today (2026-07-28), lane ajcr-w5-av, run 0073 round 3:
  6555d7a6e  Tangent/TwoChartNaturality.lean          (new)
  40dc6f6ce  Tangent/DualNumberCarrier.lean           (new)
  8c3e89ea7  Tangent/DualNumberCarrierReduction.lean  (new)
  c06be818c  Tangent/DualNumberChartPic.lean          (new)
  b3dfd386b  informal/w5-t4-worksheet.md              (§6.14 only)
Read the diffs with:
  git --git-dir=/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/vcs/workspace.git show <sha>

WHAT I CLAIM, and what I want attacked. Task ajcr-w5-av is Wave 5 of "Pic^0 is an abelian variety of dimension g". Its T4 leg needed three statements per a prior fresh-context review (inbox I-0573). I claim I closed two of them and reduced the third:

 (c) REDUCTION SQUARE: Scheme.map_twoChartClassHom — for an ARBITRARY scheme morphism f and an
     arbitrary two-open family V : Bool → Y.Opens,
     CechPic.map f (twoChartClassHom V sel hmem u) = twoChartClassHom (f ⁻¹ᵁ V ·) (sel ∘ f.base) _ (pullbackOverlapUnit f u)
 (b-open) Over.dualNumberSections : Γ(C,W)[ε] ≃+* Γ(C_ε, fst⁻¹ W), plus naturality in the open
     (Over.resHom_dualNumberSections) and unit-group forms.
 (b-coeff) Over.relSectionsMap_dualNumberSections : the ε↦0 section map IS TrivSqZeroExt.fst across
     that equivalence. Uses two SCOPED instances (TruncExpCech.EpsilonReduction.epsAlgebra,
     epsIsScalarTower) because mathlib has no Algebra k[ε] k.
 (iii-c2-aff) steps 1–2: CommRing.Pic.eq_one_of_cyclic_mod_eps, CommRing.Pic.eq_one_of_mapRingEquiv,
     and Scheme.Opens.cechPicMap_ι_eq_one_of_dualNumberChart composing them with the affine dictionary.

THE SPECIFIC THINGS TO CHECK, in priority order:

1. IS EVERY DOCSTRING CLAIM TRUE? My own memory records that I once shipped three PHANTOM declaration
   names in docstrings of the very file citing that lesson. Check every "Main declarations" list and
   every cross-reference (`Over.resHom_dualNumberSections`, `Over.unitsMap_resHom_dualNumberSectionsUnits`,
   `Over.dualNumberSectionsOfIsAffineOpen`, `CommRing.Pic.eq_one_of_mapRingEquiv`, references to
   `EffectivityMoving.cechPicClass_basicOpen_eq_one_of_free`, `Opens.cechPicClass`, `relCover`,
   `Over.sectionsBaseChange_naturality`, mathlib's `Pic.mk_eq_self` / `mk_eq_one_iff_free`) actually
   EXISTS with the claimed name and says what I say it says. Report any name that does not resolve.

2. IS THE GENERALITY CLAIM HONEST? I say TwoChartNaturality.lean has "no affineness, no dual numbers,
   no curve, no Function.Surjective sel". Verify by reading the actual binders. Same for
   DualNumberChartPic.lean's claim that steps 1–2 work over an ARBITRARY commutative ring.

3. IS ANY HYPOTHESIS VACUOUS? Especially `hcyc` in Opens.cechPicMap_ι_eq_one_of_dualNumberChart. A
   hypothesis that cannot be satisfied, or that is satisfiable by a trivial witness, makes the theorem
   worthless. I probed this with r := 0 and got a leftover goal, which I read as non-vacuous — check
   my reasoning, and separately check the CONVERSE risk: is the hypothesis so strong that it already
   assumes the conclusion? (e.g. does cyclicity mod (ε) plus invertibility trivially force freeness in
   a way that makes my lemma circular with free_of_cyclic_mod_eps?)

4. THE SCOPED INSTANCES. Are epsAlgebra/epsIsScalarTower really scoped (not leaking into global
   instance search)? Does anything downstream accidentally depend on them? Is my claim that a GLOBAL
   Algebra k[ε] k would diamond with Algebra k k actually right, or is that a rationalization?

5. DOES (b-coeff) SAY WHAT A KERNEL COMPUTATION NEEDS? The standing lesson in this lane (inbox I-0571)
   is that "the groups agree" is not "the maps agree". I claim my square fixes that for the
   T2-engine/comparison composition. Read TruncExpCechH1.lean's unitsReduction and
   TwoChartCechPic.lean's twoChartClass and judge whether my two new statements actually compose them,
   or whether a THIRD gap remains that I have again priced at zero. This is the highest-value check.

6. Anything in worksheet §§6.12–6.15 that overstates what landed.

METHOD: use `/home/axel/.archon-env/bin/horizon search "<words>" --json` (indexes both projects AND
mathlib) to check name existence; grep for call sites; read files. Do NOT run lake build (another lane
holds the build mutex) — I already have: root build 9181 jobs exit 0, and `#print axioms` clean on all
eight keystones with a control that still reports sorryAx.

OUTPUT: a short list of CONFIRMED DEFECTS (each with file:line and why it is wrong), then SUSPICIONS
you could not settle, then what you verified as sound. Be adversarial; a finding that I overstated
something is worth more to me than agreement. No narration of your search process.

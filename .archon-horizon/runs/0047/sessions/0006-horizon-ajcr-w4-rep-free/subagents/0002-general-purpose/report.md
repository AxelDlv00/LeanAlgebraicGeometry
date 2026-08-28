You are scouting inside the Lean 4 project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (mathlib-based, huge). Do NOT edit any file. Report findings only. Use `grep`/`Read`, and the indexed search `/home/axel/.archon-env/bin/horizon search "<query>" --json` (covers the project AND mathlib).

CONTEXT. Read `AlgebraicJacobian/Picard/DivSchemeCertZarKerSpan.lean` and `AlgebraicJacobian/Picard/DivSchemeCertUniv.lean` first. For a `DivisorAdaptation C R pi d` with index type `A.index`, chart colengths `A.colength j = Γ(piece j)/(f_j)`, product `A.chartProd`, overlap product `A.ovlProd`, and the Čech difference `δ = A.deltaLeft - A.deltaRight : A.chartProd →ₗ[R] A.ovlProd`, the remaining certificate obligation ("away-kerspan") is

  hinj : ∀ p : PrimeSpectrum R, Function.Injective
    (((LinearMap.ker δ).liftQ δ le_rfl).rTensor p.asIdeal.ResidueField)

i.e. the injectivized Čech difference stays injective after base change to each residue field. Equivalently (per `ker_rTensor_le_range_subtype_iff_liftQ_rTensor_injective`) `ker (δ ⊗ κ(p)) ≤ range((ker δ) ⊗ κ(p) → chartProd ⊗ κ(p))`.

Investigate and report:

1. What does the project already know about the flatness of `chartProd ⧸ ker δ` (= `chartProd ⧸ gluedSubmodule`) and of `ovlProd ⧸ range δ`? Note the two clauses (c3)/(c4) of `DivisorAdaptation.IsCertified` (in `Picard/DivisorFamily.lean` around line 426) are exactly these flatness statements. Find every lemma in the project of the form "flat cokernel ⇒ base-change-exactness" or the converse, e.g. in files matching `FlatCokernel`, `SlicingFlatKernel.lean`, `CechKernelGlue.lean`, `KernelDescentUnit.lean`, `DivSchemeHighWindowSyzygy.lean`. Copy exact signatures.

2. Read `AlgebraicJacobian/Picard/DivSchemeHighWindowSyzygy.lean`: what exactly is `divUniversalHighWindowKernelSyzygySpans_iff`, and in what sense is `hinj` "equivalent to the flat-cokernel clause"? Is that an honest obstruction or just an equivalence of two statements both of which are still open?

3. Crucially: **is there a route to `hinj` that goes through finiteness/flatness of the colength modules rather than through syzygies?** Standard commutative algebra: if `A.colength j` are finite projective over R and `A.ovlColength i j` are flat over R, then `coker δ` flat would give it. Look for: lemmas about `Module.Flat` of quotients, `Module.Projective` of `ker` when coker is flat, mathlib's `Module.Flat.iff_...`, `LinearMap.rTensor` exactness lemmas (`lTensor_ker`, `rTensor_injective_of_...`), and any existing project lemma that derives `hinj`-shaped statements from projectivity of the pieces. Report what mathlib offers here (use `horizon search` and LSP-free grep of `.lake/packages/mathlib`).

4. Also check: does the project have a route where the ADAPTATION IS CHOSEN so that δ is easy? E.g. if the adaptation has exactly two pieces, one of which contains the whole divisor support and the other of which meets it in the empty set, then some colengths are 0 and δ may become injective/split. Look for lemmas about `colength` being zero/trivial when the equation is a unit (`f_j` invertible on the piece, i.e. the piece misses the support), and about `ovlColength` being the zero ring in that case. Give signatures. Is there `colength_subsingleton_of_isUnit` or similar? If not, is it easy? Also: what happens to δ, ker δ, chartProd, ovlProd when all but one colength vanish — is `hinj` then automatic?

Return a compact, precise technical report with exact copied Lean signatures and file:line refs, plus your assessment of the cheapest available route to `hinj`. Your final message IS the report.

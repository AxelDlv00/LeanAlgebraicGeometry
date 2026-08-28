You are surveying Lean files in the project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (files under AlgebraicJacobian/Picard/). READ ONLY — do not edit any file.

CONTEXT. There are two parallel layers:
 (A) the CHART-TYPED layer: `FinCoverData` (cover pieces are basic opens of two pinned P1 charts), `DivisorAdaptation`, `CertifiedDivisorFamily`, `IsLocallyCertified`, `DivFamZar`.
 (B) a NEW WIDENED layer: `AffCoverData` (pieces are arbitrary affine opens; fields m/pieces/isAffineOpen/cover), `AffAdaptation`, `CertifiedDivisorFamilyAff`, `IsLocallyCertifiedAff`, `DivFamZarAff` — in files DivisorFamilyAff*.lean.

Layer (B) currently has NO base-change / mapAlg layer. I want to build it: `AffCoverData.baseChange R'` (pieces := relCurveMap C R R' ⁻¹ᵁ pieces j), `AffAdaptation.pullback`, `isCertified_pullback`, `CertifiedDivisorFamilyAff.mapAlg`, `IsLocallyCertifiedAff.pullback`, `DivFamZarAff.mapAlg` and its laws, and `DivFamZarAff.eq_of_away_eq`.

YOUR TASK: report exactly how much of the existing chart-typed base-change apparatus is generic (works for an arbitrary affine open / arbitrary cover shape) versus genuinely chart-specific, so I can tell what must be re-proved for arbitrary affine opens. Files to read: DivisorFamilyPullback.lean, DivisorFamilyPullbackCert.lean, DivisorFamilyPullbackOverlap.lean, DivisorFamilyPullbackGlued.lean, DivisorFamilyPullbackMap.lean, DivisorFamilyMapAlg.lean, DivisorFamilyZar.lean, DivisorFamilyZarMapAlg.lean, and anything they import that carries the section-level base-change keystone.

Specifically answer, with file:line for each:
 1. What is the CORE section-level base-change keystone? i.e. the lemma/def giving `R' ⊗[R] Γ(relCurve C R, V) ≃ Γ(relCurve C R', preimage V)` (or the FinCoverData-specific spellings `piecesMap`, `pieceQuotBaseChange`, `ovlMap`, `ovlQuotBaseChange`). For each: does its proof use that the open is a BASIC OPEN of a pinned chart / use partition-of-unity or freeness of chart sections, or is it stated for an arbitrary affine open? Quote the actual hypotheses.
 2. Is there already a version of that keystone for an ARBITRARY affine open of relCurve C R (maybe in a Cohomology/ or RelativeSections file)? Search with `"$HORIZON_BIN" search "<query>" --json` (the CLI at $HORIZON_BIN indexes this project AND mathlib) as well as reading files. Report the exact names if they exist.
 3. `DivisorAdaptation.germ_pullbackEqn_mem_nonZeroDivisors` — where is it, what does it need (does it consume projectivity of colengths, chart structure, or only regularity of equations)? Would the same proof work verbatim for `AffAdaptation`?
 4. `flat_pulledCokerIncl` / `flat_pulledCokerDiff` / the glued-module transport in DivisorFamilyPullbackGlued.lean: are these proved from an abstract FlatCokernel base-change keystone applied to the delta arrows (hence index-shape agnostic), or do they use chart specifics? Name the abstract keystone.
 5. Is there an instance `IsAffineHom (relCurveMap C R R')` or a lemma that the preimage of an affine open under relCurveMap is affine? Report exact names, or say clearly that none exists.
 6. Give me a bottom-line estimate: which of the pieces I listed (baseChange, AffAdaptation.pullback, isCertified_pullback, mapAlg, IsLocallyCertifiedAff.pullback, eq_of_away_eq) are cheap transports of existing generic lemmas, and which need genuinely new mathematics.

Be concrete and quote signatures. Your final message is the report; no preamble.

All checks pass. Final report:

## Status: COMPLETE

Created `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalDivisorDescent.lean` — kernel-clean, zero sorries, zero warnings. (File is written but not committed; commit left to the caller.)

## Declarations proved (all in namespace `AlgebraicGeometry`)

1. `RankOneDivisorUniqueness` — the named-Prop uniqueness interface, exactly as specified.
2. `existsUnique_abel_divFamZarAff_of_etale_witness` — the descent kernel. The tensor-square cocycle is manufactured, not assumed: `ψ := (includeLeft.restrictScalars k).comp ((ofId A E.Carrier).restrictScalars k)`; `lam_sq := (picDegLayerFunctor C (genus C : ℤ)).map (Over.overSpecMap ψ).op lam` with membership via `picRankOneOpen_map_mem` and Abel comparison via `picEtAffineEquiv_naturality`; both coprojection pullbacks of `F'` shown Abel-equal to `picEtAffineEquiv _ lam_sq.1` via `abelDivAffPlus_mapAlgHom` + `PicEtAff.mapAlg_comp`; `hu` at the tensor square yields the hypothesis of `DivFamZarAff.exists_descent_of_tensor_eq`; the descended class's Abel value is pinned by `PicEtAff.map_injective_of_etaleCover` after aligning through `PicEtAff.mapAlg_eq_map_of_toRingHom_eq_algebraMap`; the ∃! uniqueness clause is `hu` at `A`.
3. `existsUnique_abel_divFamZarAff_of_localPresentation` — consumes `P.exists_glued_rankOne_away_divisor_with_abel_evaluation`; its Abel conjunct (8th of the 11-component existential) matched (2)'s `habel` verbatim with `E := P.cover`, `F' := F0`.
4. `canonicalRankOneDivisorOfPresentation` (noncomputable def, `.choose` of 3) with accessors `canonicalRankOneDivisorOfPresentation_abel` and `canonicalRankOneDivisorOfPresentation_unique`.

## Axiom audit (lean_verify, all 6 declarations)

Every declaration depends on exactly `[propext, Classical.choice, Quot.sound]` — as the spec expected. Source scan: no warnings (no sorry/admit/native_decide/local axioms).

## Verification output

- `lake env lean AlgebraicJacobian/Picard/Pic0RankOneCanonicalDivisorDescent.lean` → exit 0, no output ("KERNEL CLEAN").
- LSP diagnostics: empty (success), no lint warnings.
- Prerequisite `lake build` of the imports completed from cache (one pre-existing `show`-linter warning in `DivRepAffFaithfullyFlatDescent.lean:192`, not introduced by this work).

## Deviations from spec, with reasons

1. **Added a 4th import** `AlgebraicJacobian.Picard.Pic0RankOneLocus`: `PicRankOneOpen` and `picRankOneOpen_map_mem` are not in the closure of the three listed imports (spec's "plus whatever those need re-exported" clause covers this).
2. **Key coprojection fact proved via `AlgHom.commutes`, not `AlgHom.ext fun _ => rfl`**: `includeLeft (algebraMap A E a) = x ⊗ₜ 1` vs `includeRight … = 1 ⊗ₜ x` are not syntactically rfl; used `(includeLeft.commutes a).trans (includeRight.commutes a).symm` — the "minor variant" the spec anticipated. Also stated it as `φR.comp φ0 = ψ` (the direction actually consumed by the rewrite).
3. **`picEtAffineEquiv_naturality` takes `C` explicitly** — called as `picEtAffineEquiv_naturality C ψ lam.1` (name and direction were as spec predicted).
4. **The mapAlg/map alignment** used the existing bridge lemma `PicEtAff.mapAlg_eq_map_of_toRingHom_eq_algebraMap … rfl` (already in the import closure, same pattern as `Pic0AffineEtaleDescent.lean`) instead of a bespoke `AlgHom.ext`/congrArg construction — strictly less new code, same effect.
5. The unused uniqueness clause of `exists_descent_of_tensor_eq` is discarded (`-` in the obtain pattern); the ∃!'s uniqueness comes from `hu` per spec step 5.

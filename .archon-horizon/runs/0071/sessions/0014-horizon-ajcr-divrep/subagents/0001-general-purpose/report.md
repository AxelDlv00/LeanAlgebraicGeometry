Review complete. Six findings filed as I-0778 through I-0783. No source files edited; three kernel-verified probes kept at `/tmp/ajcr_probe8.lean`, `/tmp/ajcr_probe9.lean`, `/tmp/ajcr_probe13.lean`.

## The file itself is sound

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffTheta.lean` — 705 lines, `lake env lean` EXIT=0 with zero diagnostics (verified independently), no `sorry`/`admit`/`native_decide`, rooted at `AlgebraicJacobian.lean:345`. The import diff is a single inserted line; nothing swept (I-0153 clean), worktree clean vs HEAD. No dead declarations inside the file, though nothing outside it consumes anything either — it is currently an island.

## What survived

Claim 1's three absence measurements are all true as stated: no theta arrow existed on `AffAdaptation` (24 files name it; the 5 with "heta" hits are all `ThetaGeneratorSeed` or prose), `IsChartClause` really is typed on `DivFamZar` with only the forward `DivFamZar.toAff` crossing, and `divFamEps_eq_of_le` really does route through `windowQuotEquiv`.

Claim 2's term identity holds character-for-character. Claim 3's scope disclaimers are honest — no surjectivity, no eps-value identity, no smuggled pairing — and `IsThetaPaired` is neither vacuous nor false: I proved it outright for any one-sided typing.

## What did not

The headline is not established, and the reason is inhabitation rather than mathematics. Every declaration in the file is indexed by a `ChartTyping`, and I proved that a cover with any straddling piece admits **none** — `IsEmpty (ChartTyping C R π D)`, three lines. cert-r2's producer puts the whole support inside one piece `W`, and the straddling hypotheses say that support has points outside both `V₀` and `V₁`; both land in `W`. So the layer is empty exactly on the divisors R2 exists for. Compounding it, the tree's only `ChartTyping` producer is `FinCoverData.toChartTyping`, the migration from the old chart-typed carrier. The clause-3 argument in the docstring is about what is *permitted*, not what is *inhabited*.

Claim 4's retraction went the wrong way. `thetaSectionSide A τ a b` is just `thetaEval` of the already-landed global section, so `thetaSectionSide_mem` follows from `thetaEval_mem` in the same file — about 15 lines, kernel-green, no four-case split and no cocycle identity. The "genuine content" 91f702164 measured was a property of the existing chart-typed proof, not of the widened obligation. Both commits also mis-locate where the pinned pair enters: it is the `τ` binder in every signature, not any proof body.

Two smaller notes: "hence `divisorWindow` is the same submodule on both carriers" is empty, since `divisorWindow` never mentioned a carrier; and no widened analogue of `ker_windowCarve` is stated, so nothing yet connects the new theorem to `divisorWindow`.

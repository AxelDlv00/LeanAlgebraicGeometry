# Lean Auditor Directive

## Slug
iter185

## Scope (files)
all

## Focus areas (optional)
Files touched by iter-185 prover phase carry the heaviest edit weight; pay extra attention but do NOT skip the rest of the project:

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — Lane E sub-task (f) privacy-bridge workaround landed (+155 / −10 LOC). Look at the `change` + iso-chain reconstruction trick around L238/L382.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` — Lane G PIVOT to `exists_isRegular_of_regularLocal`; 1 new typed-sorry helper `exists_isSMulRegular_quotient_isRegularLocal_succ` at L965, and `regularLocal_inductive_step` body rewritten with an inline technical-bridge sorry at L1008.
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` — Lane B Recipe 2/3 attempt; structural advance only, no decrement (4 → 4).
- `AlgebraicJacobian/Picard/IdentityComponent.lean` — NEW file from Lane "NEW"; 5 `sorry`-bodied declarations matching chapter `\lean{...}` pins.
- `AlgebraicJacobian/Picard/QuotScheme.lean` — Lane F first body substance for Tilde-isoTop route; 2 new private helpers (`pullback_app_isoTensor_unitAtV` axiom-clean, `pullback_app_isoTensor_isBaseChange` typed-sorry).
- `AlgebraicJacobian/Picard/RelativeSpec.lean` — Lane D HARD-BAR SUCCESS; both Tier-3 helpers landed Tier-1 axiom-clean (2 → 0 sorries).
- `AlgebraicJacobian/RiemannRoch/OcOfD.lean` — Lane K landed `sheafOf_zero` axiom-clean **via a structural change to `sheafOf` body**: it now reads `if D = 0 then Scheme.toModuleKSheaf C else sorry` (Classical). Look critically at this pinning choice — the descriptor expects you to flag whether this is honest mathematics or a value-pinning trick that quietly weakens the def. The task author claims it is the genuine Hartshorne identification `ℒ(0) = 𝒪_C`.
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean` — Lane H SUCCESS + PARTIAL; `finrank_H0_toModuleKSheaf_eq_one` axiom-clean closure (~50 LOC); 1 new named typed-sorry helper `eulerCharacteristic_of_shortExact_skyscraper` at L329.

## Known issues
- iter-184 lean-auditor `iter184` (SOUND verdict) flagged minor stylistic issues; no must-fix-this-iter remained. Don't re-report iter-184 findings already addressed.
- `MayerVietorisCover.lean` L504-505 contains the word "axiom" inside a comment; this is not a project axiom (verified — there are zero `^axiom ` declarations in the project tree).
- `archon-protected.yaml` protects signatures; flag any rename/re-type but not flagged body work.
- `sheafOf` `else`-branch sorry propagation in `OcOfD.lean` causes `sheafOf_zero` lemma to emit a `declaration uses 'sorry'` warning even though its body is closed; this is propagation through the def, not laundering. Verify but don't double-flag.

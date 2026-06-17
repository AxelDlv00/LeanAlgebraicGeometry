# Lean ↔ Blueprint Checker Directive

## Slug
iter185-relativespec

## Lean file
AlgebraicJacobian/Picard/RelativeSpec.lean

## Blueprint chapter
blueprint/src/chapters/Picard_RelativeSpec.tex

## Known issues
- iter-185 Lane D SUCCESS: both Tier-3 helpers at L494 (`pullback_cocone` naturality) and L583 (`pullback_iso_desc_isIso` per-piece) closed Tier-1 axiom-clean (sorries 2 → 0).
- iter-173 review NOTEs inline in the chapter at L62/L162/L253/L302/L338/L380 flagging signature drift between Lean and prose for `RelativeSpec` / `structureMorphism` / `base_change`. The L338 NOTE remains valid per the prover task result (Lean type is weaker existential, not canonical iso with a named pullback `g^* 𝒜`); iter-186+ refinement still pending.
- The L62/L162/L253/L302/L380 NOTEs about "Mathlib value" bodies for `RelativeSpec` / `structureMorphism` were marked obsolete by the prover task — verify whether the chapter NOTEs should be removed now that body work is end-to-end.
- Iter-184 was NOT_DISPATCHED (rate-limit); the iter-183 5-helper structured proof is what landed prior to iter-185's HARD-BAR closures.

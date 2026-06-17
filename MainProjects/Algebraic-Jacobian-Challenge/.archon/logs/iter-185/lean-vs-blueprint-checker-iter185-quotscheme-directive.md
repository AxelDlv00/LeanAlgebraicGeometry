# Lean ↔ Blueprint Checker Directive

## Slug
iter185-quotscheme

## Lean file
AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Known issues
- iter-185 Lane F: first body substance for the Tilde-isoTop route. Two new private helpers landed:
  - `pullback_app_isoTensor_unitAtV` (axiom-clean) — underlying `Γ(X, V)`-linear map from the `pullback ⊣ pushforward` adjunction unit.
  - `pullback_app_isoTensor_isBaseChange` (typed sorry, with 4-step structured comment) — the substantive bijectivity claim, body documents Steps 2-4 of the Tilde-isoTop plan.
- Consumer-facing `pullback_app_isoTensor` (L480 area) body now reads `exact (pullback_app_isoTensor_isBaseChange g N hU hV e).some` — sorry-free assembly mod the named helper.
- 9 sorries entering, 9 exiting (net 0; one unnamed body sorry replaced by one named typed-sorry helper).
- The downstream consumer `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase` (L587 post-edit) still carries its Beck-Chevalley sorry — rfl-bridge closure deferred to iter-186+.
- Chapter `Picard_QuotScheme.tex` is UNCHANGED this iter; §5 "Project-side typed-sorry" subsection (L851-856) already pins `Scheme.Modules.pullback_app_isoTensor`.
- The 2 new helpers are NOT chapter-pinned — verify if they should grow chapter blocks or remain project-internal.
- Iter-184 was NOT_DISPATCHED.

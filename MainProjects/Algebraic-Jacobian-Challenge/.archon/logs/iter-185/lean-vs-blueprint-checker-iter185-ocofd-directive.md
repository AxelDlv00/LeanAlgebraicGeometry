# Lean ↔ Blueprint Checker Directive

## Slug
iter185-ocofd

## Lean file
AlgebraicJacobian/RiemannRoch/OcOfD.lean

## Blueprint chapter
blueprint/src/chapters/RiemannRoch_OcOfD.tex

## Known issues
- iter-185 Lane K closed `sheafOf_zero` (L167) by **structurally pinning `sheafOf` body** at L137 to read `open Classical in if D = 0 then Scheme.toModuleKSheaf C else sorry`. The closure proof is `unfold sheafOf; exact if_pos rfl`. The prover claims this is the genuine Hartshorne identification `ℒ(0) = 𝒪_C`, not a value-pinning trick.
  
  **Audit critically**: does this pinning faithfully realize the chapter's `\begin{lemma}\label{lem:sheafOf_zero}` claim, or does it weaken the def in a way that quietly diverges from the chapter's `def:sheafOf` semantic? The chapter §"Sheaf-property correctness" describes the general construction; verify the `D = 0` value-pinning is consistent.
- `#print axioms sheafOf_zero` reports `[propext, sorryAx, Classical.choice, Quot.sound]`. The `sorryAx` is propagated through `sheafOf`'s `else`-branch, not from the lemma body. Treat that as honest propagation, not laundering — but confirm.
- `sheafOf_singlePoint` (L189) and `sheafOf_ses_single_add` (L232) untouched (explicit off-target per iter-185 directive).
- Iter-183 chapter prose at L138 carries `\leanok` on the `def:sheafOf` block — verify this is still correct under the new partial body (sync_leanok manages \leanok, but check the marker semantics still apply).
- Lane K and Lane H (RRFormula) share the `sheafOf_ses_single_add` interface; downstream `Scheme.eulerCharacteristic_sheafOf_succ` consumes it. The iter-184 `lean-vs-blueprint-checker iter184-ocofd` produced a clean report; flag only NEW deltas.
